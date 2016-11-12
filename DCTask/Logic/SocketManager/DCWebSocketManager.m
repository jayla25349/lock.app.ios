//
//  DCWebSocketManager.m
//  DCTask
//
//  Created by 青秀斌 on 2016/9/24.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCWebSocketManager.h"

static NSErrorDomain errorDomain = @"DCNetwordDomain";

@interface DCWebSocketManager ()<SRWebSocketDelegate>
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) SRWebSocket *webSocket;
@property (nonatomic, strong) NSMutableArray<DCWebSocketRequest *> *reqeusts;
@end

@implementation DCWebSocketManager

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

//{"id":"62112","source":"admin","payload":"双方约定的数据"}
- (void)handleData:(NSDictionary *)dic {
    NSString *Id = dic[@"id"];
    NSString *payload = dic[@"payload"];
    DCWebSocketResponse *response = [DCWebSocketResponse responseWithId:Id payload:payload];
    if ([self.delegate respondsToSelector:@selector(webSocketManager:didReceiveData:)]) {
        [self.delegate webSocketManager:self didReceiveData:response];
    }
}

//{"id":"62112"}
- (void)handleAsk:(NSDictionary *)dic {
    NSString *Id = dic[@"id"];
    [self.reqeusts enumerateObjectsUsingBlock:^(DCWebSocketRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.Id isEqualToString:Id]) {
            obj.status = DCReqeustStatusFilished;
            [self.reqeusts removeObject:obj];
            *stop = YES;
            
            if ([self.delegate respondsToSelector:@selector(webSocketManager:didReceiveAsk:)]) {
                [self.delegate webSocketManager:self didReceiveAsk:obj];
            }
        } else {
            DDLogWarn(@"未处理响应：%@", dic);
        }
    }];
    if (self.reqeusts.count==0) {
        if ([self.delegate respondsToSelector:@selector(webSocketManagerDidFilishSend:)]) {
            [self.delegate webSocketManagerDidFilishSend:self];
        }
    }
}

//{"id":""}
- (void)handleBye:(NSDictionary *)dic {
    [self close];
    if ([self.delegate respondsToSelector:@selector(webSocketManagerDidOffline:)]) {
        [self.delegate webSocketManagerDidOffline:self];
    }
}

//{ "id":""}
- (void)handlePing:(NSDictionary *)dic {
    
}

/**********************************************************************/
#pragma mark - Public
/**********************************************************************/

//连接
- (void)connect {
    if (!self.webSocket || self.webSocket.readyState==SR_CLOSED) {
        self.webSocket = [[SRWebSocket alloc] initWithURL:self.url];
        self.webSocket.delegate = self;
        [self.webSocket open];
    }
}

//关闭
- (void)close {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connect) object:nil];
    if (self.webSocket && (self.webSocket.readyState==SR_CONNECTING || self.webSocket.readyState==SR_OPEN)) {
        [self.webSocket close];
    }
}

//发送请求数据
- (void)sendRequest:(DCWebSocketRequest *)request {
    NSParameterAssert(request);
    if (!self.webSocket || self.webSocket.readyState!=SR_OPEN) {
        return;
    }
    if (!self.reqeusts) {
        self.reqeusts = [NSMutableArray array];
    }
    
    request.status = DCReqeustStatusRuning;
    [self.reqeusts addObject:request];
    
    NSString *dataString = [request data];
    [self.webSocket send:dataString];
    DDLogDebug(@"%s %@",__PRETTY_FUNCTION__, dataString);
}

//发送响应数据
- (void)sendResponse:(DCWebSocketResponse *)response {
    NSParameterAssert(response);
    if (!self.webSocket || self.webSocket.readyState!=SR_OPEN) {
        return;
    }
    
    NSString *dataString = [response ask];
    [self.webSocket send:dataString];
    DDLogDebug(@"%s %@",__PRETTY_FUNCTION__, dataString);
}

/**********************************************************************/
#pragma mark - SRWebSocketDelegate
/**********************************************************************/

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
    
    //执行挂起的请求
    [self.reqeusts enumerateObjectsUsingBlock:^(DCWebSocketRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.status==DCReqeustStatusSuspend) {
            obj.status = DCReqeustStatusRuning;
            [webSocket send:[obj data]];
        }
    }];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    DDLogDebug(@"%s %@", __PRETTY_FUNCTION__, message);
    
    //类型转换
    NSData *jsonData = nil;
    if ([message isKindOfClass:[NSString class]]) {
        jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([message isKindOfClass:[NSData class]]) {
        jsonData = message;
    } else {
        DDLogError(@"数据类型错误：%@", NSStringFromClass([message class]));
        return;
    }
    
    //反序列化
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error) {
        DDLogError(@"解析JSON失败：%@", error);
        return;
    }
    
    //类型判断
    if (!jsonObject || ![jsonObject isKindOfClass:[NSDictionary class]]) {
        DDLogError(@"数据类型错误：%@", NSStringFromClass([jsonObject class]));
        return;
    }
    NSString *directive = jsonObject[@"directive"];
    if (!directive || ![directive isKindOfClass:[NSString class]]) {
        DDLogError(@"数据类型错误：%@", NSStringFromClass([directive class]));
        return;
    }
    NSDictionary *data = jsonObject[@"data"];
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        DDLogError(@"数据类型错误：%@", NSStringFromClass([directive class]));
        return;
    }
    
    //处理数据
    if ([directive isEqualToString:@"data"]) {
        [self handleData:data];
    } else if ([directive isEqualToString:@"ask"]) {
        [self handleAsk:data];
    } else if ([directive isEqualToString:@"bye"]) {
        [self handleBye:data];
    } else if ([directive isEqualToString:@"ping"]) {
        [self handlePing:data];
    } else {
        DDLogError(@"不能解析的数据类型：%@", jsonObject);
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    DDLogDebug(@"%s %@", __PRETTY_FUNCTION__, error);
    
    //挂起请求
    [self.reqeusts enumerateObjectsUsingBlock:^(DCWebSocketRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.status == DCReqeustStatusRuning) {
            obj.status = DCReqeustStatusSuspend;
        }
    }];
    
    //定时重试
    [self performSelector:@selector(connect) withObject:nil afterDelay:3.0f];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    DDLogDebug(@"%s %ld %@ %d", __PRETTY_FUNCTION__, code, reason, wasClean);
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    DDLogDebug(@"%s %@", __PRETTY_FUNCTION__, pongPayload);
}

@end
