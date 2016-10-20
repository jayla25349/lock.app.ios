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
@property (nonatomic, strong) NetworkManager *httpManager;
@property (nonatomic, assign) BOOL isSyncing;
@end

@implementation DCDataManager

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

//批量上传图片
- (void)uploadPictures:(NSMutableArray<Picture *> *)pics complete:(void (^)(void))block {
    Picture *pic = [pics popFirstObject];
    if (pic) {
        [[DCAppEngine shareEngine].networkManager HTTP_POST:URL_SERVER api:@"/docs/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSString *path = [DCUtil imagePathWithName:pic.name];
            NSURL *url = [NSURL fileURLWithPath:path];
            
            NSError *error = nil;
            if (![formData appendPartWithFileURL:url name:@"file" error:&error]) {
                DDLogError(@"%@", error);
            }
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSString *id = responseObject[@"id"];
                NSString *href = responseObject[@"href"];
                if (id.length>0) {
                    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                        Picture *picture = [pic MR_inContext:localContext];
                        picture.id = id;
                        picture.href = href;
                    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
                        [self uploadPictures:pics complete:block];
                    }];
                }
            }
        } failure:nil];
    } else {
        if (block) {
            block();
        }
    }
}

/**********************************************************************/
#pragma mark - Public
/**********************************************************************/

//同步数据
- (void)syncData {
    if (self.isSyncing) {
        return;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type=0"];
    Queue *queue = [Queue MR_findFirstWithPredicate:predicate sortedBy:@"createDate" ascending:NO];
    if (queue) {
        
        //需要上传的图片
        NSMutableArray<Picture *> *tempArray = [NSMutableArray array];
        [queue.plan.items enumerateObjectsUsingBlock:^(PlanItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj.pics enumerateObjectsUsingBlock:^(Picture * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.id.length==0) {//未上传图片
                    [tempArray addObject:obj];
                }
            }];
        }];
        
        //上传图片
        if (tempArray.count>0) {
            @weakify(self)
            self.isSyncing = YES;
            [self uploadPictures:tempArray complete:^{
                @strongify(self)
                [self.networkManager sendData:[queue toJSONObject]];
            }];
        }
    }
}

/**********************************************************************/
#pragma mark - Action
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
                NSNumber *plan_data = response.payload[@"plan_date"];
                User *user = [[DCAppEngine shareEngine].userManager.user MR_inContext:localContext];
                Plan *plan = [Plan MR_findFirstOrCreateByAttribute:@"plan_id"
                                                         withValue:response.payload[@"plan_id"]
                                                         inContext:localContext];
                plan.createDate = plan.createDate?:[NSDate date];
                plan.plan_name = response.payload[@"plan_name"];
                plan.dispatch_man = response.payload[@"dispatch_man"];
                plan.plan_date = plan_data?[NSDate dateWithTimeIntervalSince1970:plan_data.floatValue]:nil;
                plan.room_name = response.payload[@"room_name"];
                plan.lock_mac = response.payload[@"lock_mac"];
                plan.user = user;
                
                NSArray<NSDictionary *> * itemDics = response.payload[@"items"];
                [itemDics enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    PlanItem *planItem = [PlanItem MR_findFirstOrCreateByAttribute:@"item_id"
                                                                         withValue:obj[@"item_id"]
                                                                         inContext:localContext];
                    planItem.item_cate_name = obj[@"item_cate_name"];
                    planItem.equipment_name = obj[@"equipment_name"];
                    planItem.cabinet_name = obj[@"cabinet_name"];
                    planItem.cabinet_lock_mac = obj[@"cabinet_lock_mac"];
                    planItem.item_name = obj[@"item_name"];
                    planItem.item_flag = obj[@"item_flag"];
                    planItem.plan = plan;
                }];
            }];
        } else if ([business isEqualToString:@"RESULT_RETURN"]) {//提交回复
            
        } else if ([business isEqualToString:@"LOCKS_AUTH"]) {//可开锁的蓝牙列表
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                User *user = [[DCAppEngine shareEngine].userManager.user MR_inContext:localContext];
                NSArray<NSDictionary *> * lockDics = response.payload[@"locks"];
                [lockDics enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    Lock *lock = [Lock MR_findFirstOrCreateByAttribute:@"lock_mac"
                                                             withValue:obj[@"lock_mac"]
                                                             inContext:localContext];
                    lock.createDate = lock.createDate?:[NSDate date];
                    lock.updateDate = [NSDate date];
                    lock.lock_name = obj[@"lock_name"];
                    lock.user = user;
                }];
            }];
        } else if ([business isEqualToString:@"HUMITURE"]) {//机房温湿度
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                User *user = [[DCAppEngine shareEngine].userManager.user MR_inContext:localContext];
                Humiture *humiture = [Humiture MR_findFirstOrCreateByAttribute:@"room_name"
                                                                     withValue:response.payload[@"room_name"]
                                                                     inContext:localContext];
                humiture.createDate = humiture.createDate?:[NSDate date];
                humiture.updateDate = [NSDate date];
                humiture.temperature = @([response.payload[@"temperature"] floatValue]);
                humiture.humidity = @([response.payload[@"humidity"] floatValue]);
                humiture.user = user;
            }];
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
        [self syncData];
    }];
    
    //连接服务器
    [self.networkManager connect];
}

- (void)userLogout {
    if (!self.networkManager) {
        return;
    }
    [self.networkManager close];
    self.networkManager = nil;
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
