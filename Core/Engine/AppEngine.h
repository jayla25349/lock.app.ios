//
//  AppEngine.h
//  LZSoccer
//
//  Created by 青秀斌 on 16/9/3.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"

@interface AppEngine : NSObject<UIApplicationDelegate>
@property (nonatomic, readonly) NetworkManager *networkManager;

+ (BOOL)registerManager:(id<UIApplicationDelegate>)manager;
+ (BOOL)unRegisterManager:(id<UIApplicationDelegate>)manager;

@end
