//
//  AppEngine.h
//  LZSoccer
//
//  Created by 青秀斌 on 16/9/3.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"
#import "PushManager.h"

@interface AppEngine : NSObject<UIApplicationDelegate>
@property (nonatomic, readonly) NetworkManager *networkManager;
@property (nonatomic, readonly) PushManager *pushManager;

+ (BOOL)registerManager:(id<UIApplicationDelegate>)manager;
+ (BOOL)unRegisterManager:(id<UIApplicationDelegate>)manager;

@end
