//
//  DCAppEngine.h
//  DCTask
//
//  Created by 青秀斌 on 16/9/11.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "AppEngine.h"
#import "DCUserManager.h"
#import "DCSyncManager.h"
#import "DCBluetoothManager.h"

@interface DCAppEngine : AppEngine
@property (nonatomic, readonly) DCUserManager *userManager;
@property (nonatomic, readonly) DCSyncManager *syncManager;
@property (nonatomic, readonly) DCBluetoothManager *bluetoothManager;

+ (instancetype)shareEngine;

@end
