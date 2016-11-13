//
//  DCAppEngine.h
//  DCTask
//
//  Created by 青秀斌 on 16/9/11.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "AppEngine.h"
#import "DCDataManager.h"
#import "DCUserManager.h"
#import "DCPushManager.h"
#import "DCBluetoothManager.h"

@interface DCAppEngine : AppEngine
@property (nonatomic, readonly) DCDataManager *dataManager;
@property (nonatomic, readonly) DCUserManager *userManager;
@property (nonatomic, readonly) DCPushManager *pushManager;

+ (instancetype)shareEngine;

@end

#define APPDELEGATE     [[UIApplication sharedApplication] delegate]
#define APPENGINE       [DCAppEngine shareEngine]
