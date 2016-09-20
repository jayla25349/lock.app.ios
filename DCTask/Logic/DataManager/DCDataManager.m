//
//  DCDataManager.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/10.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCDataManager.h"

@interface DCDataManager ()<SRWebSocketDelegate>
@property (nonatomic, strong) SRWebSocket *webSocket;
@end

@implementation DCDataManager

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

//处理消息
- (void)handleMessage:(NSDictionary *)dic {
    NSString *business = dic[@"business"];
    if (!business) {
        return;
    }
    
    if ([business isEqualToString:@"PLAN"]) {//巡检任务
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            
            
            NSString *plan_id = dic[@"plan_id"];
            NSString *plan_data = dic[@"plan_date"];
            User *user = [[DCAppEngine shareEngine].userManager.user MR_inContext:localContext];
            Plan *plan = [Plan MR_findFirstOrCreateByAttribute:@"plan_id" withValue:plan_id inContext:localContext];
            plan.createDate = plan.createDate?:[NSDate date];
            plan.plan_name = dic[@"plan_name"];
            plan.dispatch_man = dic[@"dispatch_man"];
            plan.plan_date = plan_data?[NSDate dateWithString:plan_data format:@"yyyy-MM-dd HH:mm"]:nil;
            plan.room_name = dic[@"room_name"];
            plan.lock_mac = dic[@"lock_mac"];
            plan.user = user;
            
            NSArray<NSDictionary *> * itemDics = dic[@"items"];
            [itemDics enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *item_id = obj[@"item_id"];
                PlanItem *planItem = [PlanItem MR_findFirstOrCreateByAttribute:@"item_id" withValue:item_id inContext:localContext];
                planItem.item_cate_name = obj[@"item_cate_name"];
                planItem.equipment_name = obj[@"equipment_name"];
                planItem.cabinet_name = obj[@"cabinet_name"];
                planItem.cabinet_lock_mac = obj[@"cabinet_lock_mac"];
                planItem.item_name = obj[@"item_name"];
                [plan addItemsObject:planItem];
            }];
        }];
    } else if ([business isEqualToString:@"RESULT_RETURN"]) {//提交回复
        
    } else {
        DDLogError(@"响应数据类型无法处理：%@", dic);
    }
}

/**********************************************************************/
#pragma mark - Public
/**********************************************************************/

//同步数据
- (void)syncData {
    
}

- (void)test {
    NSURL *jsonUrl = [[NSBundle mainBundle] URLForResource:@"plan" withExtension:@"json"];
    NSString *jsonString = [NSString stringWithContentsOfURL:jsonUrl encoding:NSUTF8StringEncoding error:nil];
    [self.webSocket send:jsonString];
}


/**********************************************************************/
#pragma mark - UIApplicationDelegate
/**********************************************************************/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:URL_WEB_SERVICE]];
    self.webSocket.delegate = self;
    [self.webSocket open];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
    } completion:^(BOOL success, NSError *error) {
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
}

/**********************************************************************/
#pragma mark - SRWebSocketDelegate
/**********************************************************************/

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
    
    [self test];
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
    
    //数据处理
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        [self handleMessage:jsonObject];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    DDLogDebug(@"%s %@", __PRETTY_FUNCTION__, error);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    DDLogDebug(@"%s %ld %@ %d", __PRETTY_FUNCTION__, code, reason, wasClean);
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    DDLogDebug(@"%s %@", __PRETTY_FUNCTION__, pongPayload);
}

@end
