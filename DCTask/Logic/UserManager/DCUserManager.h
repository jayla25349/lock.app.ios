//
//  DCUserManager.h
//  DCTask
//
//  Created by 青秀斌 on 16/9/14.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User+CoreDataClass.h"

@interface DCUserManager : NSObject<UIApplicationDelegate>
@property (nonatomic, readonly) User *user;


/**
 用户注册
 
 @param number   工号
 @param name     名称
 @param password 密码
 @param gesture  手势
 @param success  成功回调
 @param failure  失败回调
 */
- (void)registerWithNumber:(NSString *)number
                      name:(NSString *)name
                  password:(NSString *)password
                   gesture:(NSString *)gesture
                   success:(void (^)(User *user))success
                   failure:(void (^)(NSError *error))failure;


/**
 用户登录

 @param number  工号
 @param gesture 手势
 @param success  成功回调
 @param failure  失败回调
 */
- (void)loginWithNumber:(NSString *)number
                gesture:(NSString *)gesture
                success:(void (^)(User *user))success
                failure:(void (^)(NSError *error))failure;

@end