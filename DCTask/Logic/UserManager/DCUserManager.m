//
//  DCUserManager.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/14.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCUserManager.h"
#import "DCWebSocketManager.h"

NSNotificationName const DCUserLoginNotification = @"DCUserLoginNotification";
NSNotificationName const DCUserLogoutNotification = @"DCUserLogoutNotification";
NSNotificationName const DCUserOfflineNotification = @"DCUserOfflineNotification";

@interface DCUserManager ()<DCWebSocketManagerDelegate>
@property (nonatomic, strong) DCWebSocketManager *socketManager;
@property (nonatomic, copy) void (^loginSuccessBlock)(User *user);
@property (nonatomic, copy) void (^loginFailureBlock)(NSError *error);
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) User *user;
@end

@implementation DCUserManager

/**********************************************************************/
#pragma mark - Public
/**********************************************************************/

/**
 用户注册

 @param number   工号
 @param name     名称
 @param password 密码
 @param gesture  手势
 @param success  成功回调
 */
- (void)registerWithNumber:(NSString *)number
                      name:(NSString *)name
                  password:(NSString *)password
                   gesture:(NSString *)gesture
                   success:(void (^)(User *user))success
                   failure:(void (^)(NSError *error))failure{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        User *user = [User MR_createEntityInContext:localContext];
        user.createDate = [NSDate date];
        user.loginDate = [NSDate date];
        user.number = number;
        user.name = name;
        user.password = password;
        user.gesture = gesture;
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        self.user = [User MR_findFirstOrderedByAttribute:@"loginDate" ascending:NO];
        if (!error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:DCUserLoginNotification object:self];
            if (success) {
                success(self.user);
            }
        } else {
            if (failure) {
                failure(error);
            }
        }
    }];
}

/**
 用户登录
 
 @param gesture 手势
 @param success  成功回调
 @param failure  失败回调
 */
- (void)loginWithGesture:(NSString *)gesture
                 success:(void (^)(User *user))success
                 failure:(void (^)(NSError *error))failure {
    if (self.user && [self.user.gesture isEqualToString:gesture]) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            User *user = [self.user MR_inContext:localContext];
            user.loginDate = [NSDate date];
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:DCUserLoginNotification object:self];
            if (success) {
                success(self.user);
            } else {
                if (failure) {
                    failure(error);
                }
            }
        }];
    } else {
        if (failure) {
            failure(nil);
        }
    }
}

/**
 用户登录
 
 @param number   工号
 @param password 密码
 @param success  成功回调
 @param failure  失败回调
 */
- (void)loginWithNumber:(NSString *)number password:(NSString *)password
                success:(void (^)(User *user))success
                failure:(void (^)(NSError *error))failure {
    NSParameterAssert(number);
    NSParameterAssert(password);
    
    self.loginSuccessBlock = success;
    self.loginFailureBlock = failure;
    self.password = password;
    
    NSDictionary *loginInfoDic = @{@"business":@"LOGIN", @"user_job_number": number, @"lock_password": [password md5String]};
    DCWebSocketRequest *reqeust = [DCWebSocketRequest reqeustWithId:[[NSUUID UUID] UUIDString] payload:loginInfoDic];
    [self.socketManager sendRequest:reqeust];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginTimeoutAction) object:nil];
    [self performSelector:@selector(loginTimeoutAction) withObject:nil afterDelay:30];
}

/**
 更新密码
 
 @param password 密码
 @param success  成功回调
 @param failure  失败回调
 */
- (void)updatePassword:(NSString *)password
               success:(void (^)(User *user))success
               failure:(void (^)(NSError *error))failure {
    if (self.user) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            User *user = [self.user MR_inContext:localContext];
            user.password = password;
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:DCUserLoginNotification object:self];
            if (success) {
                success(self.user);
            } else {
                if (failure) {
                    failure(error);
                }
            }
        }];
    } else {
        if (failure) {
            failure(nil);
        }
    }
}

/**
 用户登出
 */
- (void)logout {
    self.user = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:DCUserLogoutNotification object:self];
}

/**
 用户离线
 */
- (void)offline {
    self.user = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:DCUserOfflineNotification object:self];
}

/**********************************************************************/
#pragma mark - Action
/**********************************************************************/

- (void)userLoginAction {
    if (!self.socketManager) {
        return;
    }
    [self.socketManager close];
    self.socketManager = nil;
}

- (void)userLogoutAction {
    if (self.socketManager) {
        return;
    }
    NSString *urlString = [URL_WEB_SERVICE stringByAppendingFormat:@"/%@", [[NSUUID UUID] UUIDString]];
    NSURL *url = [NSURL URLWithString:urlString];
    self.socketManager = [[DCWebSocketManager alloc] initWithURL:url];
    self.socketManager.delegate = self;
    [self.socketManager connect];
}

- (void)loginTimeoutAction {
    if (self.loginFailureBlock) {
        NSError *error = [NSError bussinessError:-1 message:@"登录超时"];
        self.loginFailureBlock(error);
    }
    self.loginSuccessBlock = nil;
    self.loginFailureBlock = nil;
    self.password = nil;
}

/**********************************************************************/
#pragma mark - UIApplicationDelegate
/**********************************************************************/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self userLogoutAction];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userLoginAction)
                                                 name:DCUserLoginNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userLogoutAction)
                                                 name:DCUserLogoutNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userLogoutAction)
                                                 name:DCUserOfflineNotification
                                               object:nil];
    return YES;
}

/**********************************************************************/
#pragma mark - DCWebSocketManagerDelegate
/**********************************************************************/

- (void)webSocketManager:(DCWebSocketManager *)manager didReceiveData:(DCWebSocketResponse *)response {
    NSString *business = response.payload[@"business"];
    if ([business isEqualToString:@"LOGIN_RETURN"]) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginTimeoutAction) object:nil];
        NSString *status = response.payload[@"state"];
        NSString *number = response.payload[@"user_job_number"];
        if (status.integerValue == 1) {
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                User *user = [User MR_findFirstOrCreateByAttribute:@"number" withValue:number inContext:localContext];
                user.createDate = user.createDate?:[NSDate date];
                user.loginDate = [NSDate date];
                user.password = self.password;
            } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
                self.user = [User MR_findFirstOrderedByAttribute:@"loginDate" ascending:NO];
                if (!error) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:DCUserLoginNotification object:self];
                    if (self.loginSuccessBlock) {
                        self.loginSuccessBlock(nil);
                    }
                } else {
                    if (self.loginFailureBlock) {
                        NSError *error = [NSError bussinessError:-4 message:@"登录失败"];
                        self.loginFailureBlock(error);
                    }
                }
                self.loginSuccessBlock = nil;
                self.loginFailureBlock = nil;
                self.password = nil;
            }];
        } else {
            if (self.loginFailureBlock) {
                NSError *error = [NSError bussinessError:-3 message:@"工号或开锁密码错误"];
                self.loginFailureBlock(error);
            }
            self.loginSuccessBlock = nil;
            self.loginFailureBlock = nil;
            self.password = nil;
        }
    } else {
        DDLogError(@"响应数据类型无法处理：%@", response.payload);
    }
    
    //响应请求
    [manager sendResponse:response];
}

- (void)webSocketManager:(DCWebSocketManager *)manager didReceiveAsk:(DCWebSocketRequest *)request {
    NSString *business = request.payload[@"business"];
    if ([business isEqualToString:@"LOGIN"]) {
        
    } else {
        DDLogError(@"响应数据类型无法处理：%@", request.payload);
    }
}

- (void)webSocketManagerDidOffline:(DCWebSocketManager *)manager {
    [self userLogoutAction];
}

@end
