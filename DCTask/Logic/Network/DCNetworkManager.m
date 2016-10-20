//
//  DCNetworkManager.m
//  DCTask
//
//  Created by 青秀斌 on 2016/9/24.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCNetworkManager.h"

static NSErrorDomain errorDomain = @"DCNetwordDomain";

@interface DCNetworkManager ()<SRWebSocketDelegate>
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) SRWebSocket *webSocket;
@property (nonatomic, strong) NSMutableArray<DCNetworkReqeust *> *reqeusts;
@end

@implementation DCNetworkManager

- (instancetype)initWithUserNumber:(NSString *)number {
    self = [super init];
    if (self) {
        NSString *urlString = [URL_WEB_SERVICE stringByAppendingFormat:@"/%@/%@", @"tongren", number];
        self.url = [NSURL URLWithString:urlString];
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
    DCNetworkResponse *response = [DCNetworkResponse responseWithId:Id payload:payload];
    if (self.didReceiveData) {
        self.didReceiveData(response);
    }
    
    //发送确认数据
    if (self.webSocket && self.webSocket.readyState==SR_OPEN) {
        [self.webSocket send:[response ask]];
    }
}

//{"id":"62112"}
- (void)handleAsk:(NSDictionary *)dic {
    NSString *Id = dic[@"id"];
    [self.reqeusts enumerateObjectsUsingBlock:^(DCNetworkReqeust * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.Id isEqualToString:Id]) {
            obj.status = DCReqeustStatusFilished;
            if (self.didSendData) {
                self.didSendData(obj);
            }
            [self.reqeusts removeObject:obj];
            *stop = YES;
        }
    }];
    if (self.reqeusts.count==0 && self.didSendAllData) {
        self.didSendAllData();
    }
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

//发送数据
- (DCNetworkReqeust *)sendData:(NSDictionary *)data {
    NSParameterAssert(data);
    if (!self.reqeusts) {
        self.reqeusts = [NSMutableArray array];
    }
    
    DCNetworkReqeust *reqeust = [DCNetworkReqeust reqeustWithPayload:data];
    [self.reqeusts addObject:reqeust];
    if (self.webSocket && self.webSocket.readyState==SR_OPEN) {
        reqeust.status = DCReqeustStatusRuning;
        [self.webSocket send:[reqeust data]];
    }
    return reqeust;
}

/**********************************************************************/
#pragma mark - SRWebSocketDelegate
/**********************************************************************/

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
    
    //执行挂起的请求
    [self.reqeusts enumerateObjectsUsingBlock:^(DCNetworkReqeust * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.status==DCReqeustStatusSuspend) {
            obj.status = DCReqeustStatusRuning;
            [webSocket send:[obj data]];
        }
    }];
    
//    //测试数据
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"plan" withExtension:@"json"];
//    NSString *jsonString = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
//    [self.webSocket send:jsonString];
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
    } else {
        DDLogError(@"不能解析的数据类型：%@", jsonObject);
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    DDLogDebug(@"%s %@", __PRETTY_FUNCTION__, error);
    
    //挂起请求
    [self.reqeusts enumerateObjectsUsingBlock:^(DCNetworkReqeust * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
