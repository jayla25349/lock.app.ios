//
//  DCDataManager.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/10.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCDataManager.h"
#import "DCWebSocketManager.h"

@interface DCDataManager ()<DCWebSocketManagerDelegate>
@property (nonatomic, strong) NetworkManager *httpManager;
@property (nonatomic, strong) DCWebSocketManager *socketManager;
@property (nonatomic, assign) BOOL isSyncing;
@end

@implementation DCDataManager

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

//批量上传图片
- (void)uploadPictures:(NSMutableArray<Picture *> *)pics complete:(void (^)(BOOL filished))block {
    Picture *pic = [pics popFirstObject];
    if (pic) {
        [[DCAppEngine shareEngine].networkManager HTTP_POST:URL_SERVER api:@"/docs/upload" parameters:^(id<ParameterDic>  _Nonnull parameter) {
            [parameter setObject:pic.name forField:@"aliases"];
        } constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSString *path = [DCUtil imagePathWithName:pic.name];
            NSURL *url = [NSURL fileURLWithPath:path];
            
            NSError *error = nil;
            if (![formData appendPartWithFileURL:url name:@"file" error:&error]) {
                DDLogError(@"%@", error);
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            DDLogInfo(@"上传进度%@", uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
        } failure:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject, NSError * _Nonnull error) {
            if (block) {
                block(NO);
            }
        }];
    } else {
        if (block) {
            block(YES);
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status=0"];
    Queue *queue = [Queue MR_findFirstWithPredicate:predicate sortedBy:@"createDate" ascending:NO];
    if (queue) {
        DCWebSocketRequest *reqeust = [DCWebSocketRequest reqeustWithId:queue.id payload:[queue toJSONObject]];
        
        switch (queue.type.integerValue) {
            case 0:{//状态队列
                [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
                    queue.status = @1;//正在同步
                    [self.socketManager sendRequest:reqeust];
                }];
            }break;
            case 1:{//巡检队列
                
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
                    [self uploadPictures:tempArray complete:^(BOOL filished) {
                        @strongify(self)
                        if (filished) {
                            [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
                                queue.status = @1;//正在同步
                                [self.socketManager sendRequest:reqeust];
                            }];
                        } else {
                            self.isSyncing = NO;
                        }
                    }];
                } else {
                    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
                        queue.status = @1;//正在同步
                        [self.socketManager sendRequest:reqeust];
                    }];
                }
            }break;
        }
    }
}

/**********************************************************************/
#pragma mark - Action
/**********************************************************************/

- (void)userLogin {
    if (self.socketManager) {
        return;
    }
    NSString *number = [DCAppEngine shareEngine].userManager.user.number;
    NSString *urlString = [URL_WEB_SERVICE stringByAppendingFormat:@"/%@/%@", @"tongren", number];
    NSURL *url = [NSURL URLWithString:urlString];
    self.socketManager = [[DCWebSocketManager alloc] initWithURL:url];
    self.socketManager.delegate = self;
    [self.socketManager connect];
    
    //测试数据
    NSURL *jsonUrl = [[NSBundle mainBundle] URLForResource:@"plan" withExtension:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonUrl];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    DCWebSocketResponse *response = [DCWebSocketResponse responseWithId:@"123" payload:jsonString];
    [self webSocketManager:self.socketManager didReceiveData:response];
}

- (void)userLogout {
    if (!self.socketManager) {
        return;
    }
    [self.socketManager close];
    self.socketManager = nil;
}

/**********************************************************************/
#pragma mark - DCWebSocketManagerDelegate
/**********************************************************************/

- (void)webSocketManager:(DCWebSocketManager *)manager didReceiveData:(DCWebSocketResponse *)response {
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
    
    //响应请求
    [manager sendResponse:response];
}

- (void)webSocketManager:(DCWebSocketManager *)manager didReceiveAsk:(DCWebSocketRequest *)request {
    NSString *business = request.payload[@"business"];
    if ([business isEqualToString:@"PLAN_RETURN"]) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id=%@", request.Id];
            Queue *queue = [Queue MR_findFirstWithPredicate:predicate inContext:localContext];
            if (queue) {
                [localContext deleteObject:queue];
            }
        }];
    } else if ([business isEqualToString:@"RESULT"]) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id=%@", request.Id];
            Queue *queue = [Queue MR_findFirstWithPredicate:predicate inContext:localContext];
            if (queue) {
                
                //删除本地图片资源
                [queue.plan.items enumerateObjectsUsingBlock:^(PlanItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj.pics enumerateObjectsUsingBlock:^(Picture * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSError *error = nil;
                        
                        NSString *thumbnailPath = [DCUtil thumbnailPathWithName:obj.name];
                        if ([[NSFileManager defaultManager] fileExistsAtPath:thumbnailPath]) {
                            if (![[NSFileManager defaultManager] removeItemAtPath:thumbnailPath error:&error]) {
                                DDLogError(@"删除缩略图片资源失败：%@", error);
                            }
                        }
                        
                        NSString *imagePath = [DCUtil imagePathWithName:obj.name];
                        if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
                            if (![[NSFileManager defaultManager] removeItemAtPath:imagePath error:&error]) {
                                DDLogError(@"删除图片资源失败：%@", error);
                            }
                        }
                    }];
                }];
                
                //删除数据库对象（级联删除）
                [localContext deleteObject:queue.plan];
            }
        }];
    }
}

- (void)webSocketManagerDidFilishSend:(DCWebSocketManager *)manager {
    self.isSyncing = NO;
    [self syncData];
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
