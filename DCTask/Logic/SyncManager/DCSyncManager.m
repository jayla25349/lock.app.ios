//
//  DCSyncManager.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/10.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCSyncManager.h"

@interface DCSyncManager ()<SRWebSocketDelegate>
@property (nonatomic, strong) SRWebSocket *webSocket;
@end

@implementation DCSyncManager

/**********************************************************************/
#pragma mark - UIApplicationDelegate
/**********************************************************************/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelWarn];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"DCTaskModel"];
    
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
        [localContext MR_saveToPersistentStoreAndWait];
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
    
    NSURL *jsonUrl = [[NSBundle mainBundle] URLForResource:@"plan" withExtension:@"json"];
    NSString *jsonString = [NSString stringWithContentsOfURL:jsonUrl encoding:NSUTF8StringEncoding error:nil];
    [webSocket send:jsonString];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    DDLogDebug(@"%s %@", __PRETTY_FUNCTION__, message);
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        Plan *plan = [Plan MR_createEntityInContext:localContext];
        plan.plan_id = @"1";
        plan.plan_name = @"ups监视输出电压,ups监视输出电压,ups监视输出电压";
        plan.dispatch_man = @"刘经理";
        plan.plan_date = [NSDate date];
        plan.room_name = @"大门1";
        plan.lock_mac = @"21:43:43:12:56";
    }];
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
