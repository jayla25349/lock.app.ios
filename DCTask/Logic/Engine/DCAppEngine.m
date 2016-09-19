//
//  DCAppEngine.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/11.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCAppEngine.h"

@interface DCAppEngine ()
@property (nonatomic, strong) DCUserManager *userManager;
@property (nonatomic, strong) DCSyncManager *syncManager;
@property (nonatomic, strong) DCBluetoothManager *bluetoothManager;
@end

@implementation DCAppEngine

- (instancetype)init {
    self = [super init];
    if (self) {
        [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelWarn];
        [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"DCTaskModel"];
        
        self.userManager = [DCUserManager new];
        self.syncManager = [DCSyncManager new];
        self.bluetoothManager = [DCBluetoothManager new];
    }
    return self;
}

+ (instancetype)shareEngine {
    static DCAppEngine *instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[DCAppEngine alloc] init];
    });
    return instance;
}

@end