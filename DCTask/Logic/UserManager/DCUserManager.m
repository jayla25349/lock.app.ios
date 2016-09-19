//
//  DCUserManager.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/14.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCUserManager.h"

@interface DCUserManager ()
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
        self.user = [User MR_createEntityInContext:localContext];
        self.user.number = number;
        self.user.name = name;
        self.user.password = password;
        self.user.gesture = gesture;
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (!error) {
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
        if (success) {
            success(self.user);
        }
    } else {
        if (failure) {
            failure(nil);
        }
    }
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
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        User *user = [self.user MR_inContext:localContext];
        user.password = password;
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (!error) {
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

/**********************************************************************/
#pragma mark - UIApplicationDelegate
/**********************************************************************/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.user = [User MR_findFirstOrderedByAttribute:@"loginDate" ascending:NO];
    return YES;
}

@end
