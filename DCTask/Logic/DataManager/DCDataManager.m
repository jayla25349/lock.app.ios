//
//  DCDataManager.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/10.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCDataManager.h"
#import "DCNetworkManager.h"

@interface DCDataManager ()
@property (nonatomic, strong) DCNetworkManager *networkManager;
@property (nonatomic, assign) BOOL isSyncing;
@end

@implementation DCDataManager

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

- (void)userLogin {
    if (self.networkManager) {
        return;
    }
    NSString *number = [DCAppEngine shareEngine].userManager.user.number;
    self.networkManager = [[DCNetworkManager alloc] initWithUserNumber:number];
    
    //已接收数据
    [self.networkManager setDidReceiveData:^(DCNetworkResponse * _Nonnull response) {
        NSString *business = response.payload[@"business"];
        if ([business isEqualToString:@"PLAN"]) {//巡检任务
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                
                NSString *plan_id = response.payload[@"plan_id"];
                NSNumber *plan_data = response.payload[@"plan_date"];
                User *user = [[DCAppEngine shareEngine].userManager.user MR_inContext:localContext];
                Plan *plan = [Plan MR_findFirstOrCreateByAttribute:@"plan_id" withValue:plan_id inContext:localContext];
                plan.createDate = plan.createDate?:[NSDate date];
                plan.plan_name = response.payload[@"plan_name"];
                plan.dispatch_man = response.payload[@"dispatch_man"];
                plan.plan_date = plan_data?[NSDate dateWithTimeIntervalSince1970:plan_data.floatValue]:nil;
                plan.room_name = response.payload[@"room_name"];
                plan.lock_mac = response.payload[@"lock_mac"];
                plan.user = user;
                
                NSArray<NSDictionary *> * itemDics = response.payload[@"items"];
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
            /*
             {
             "business": "RESULT_RETURN",
             "plan_id": "巡检计划id",
             "state": "巡检状态（2-处理中、3-已完成）",
             "items": [
             {
             "item_id": "计划数据项id1",
             "state": "数据项状态（1-成功，0-失败）"
             },
             {
             "item_id": "计划数据项id2",
             "state": "数据项状态（1-成功，0-失败）"
             }
             ]
             }
             */
        } else {
            DDLogError(@"响应数据类型无法处理：%@", response.payload);
        }
    }];
    
    //已接发送数据
    [self.networkManager setDidSendData:^(DCNetworkReqeust * _Nonnull request) {
 
    }];
    
    //发送数据完成
    @weakify(self)
    [self.networkManager setDidSendAllData:^{
        @strongify(self)
        self.isSyncing = NO;
    }];
    
    [self.networkManager connect];
}

- (void)userLogout {
    if (!self.networkManager) {
        return;
    }
    [self.networkManager close];
    self.networkManager = nil;
}

- (void)uploadPicture:(Picture *)pic complete:(void (^)(void))block{
//    [[DCAppEngine shareEngine].networkManager HTTP_POST:nil api:nil parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject, NSError * _Nonnull error) {
//        
//    }];
}

/**********************************************************************/
#pragma mark - Public
/**********************************************************************/

//同步数据
- (void)syncData {
    if (self.isSyncing) {
        return;
    }
    self.isSyncing = YES;
    
    Queue *queue = [Queue MR_findFirstOrderedByAttribute:@"createDate" ascending:NO];
    if (queue) {
        [self.networkManager sendData:[queue toJSONObject]];
    }
}

/**********************************************************************/
#pragma mark - UIApplicationDelegate
/**********************************************************************/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelWarn];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"DCTaskModel"];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userLogin)
                                                 name:DCUserLoginNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userLogout)
                                                 name:DCUserLogoutNotification
                                               object:nil];
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

@end
