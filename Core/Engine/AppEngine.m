//
//  AppEngine.m
//  LZSoccer
//
//  Created by 青秀斌 on 16/9/3.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "AppEngine.h"

#ifdef DEBUG
const int ddLogLevel = DDLogLevelVerbose;
#else
const int ddLogLevel = DDLogLevelWarning;
#endif

@interface AppEngine ()
@property (nonatomic, strong) NetworkManager *networkManager;
@end

@implementation AppEngine

- (instancetype)init {
    self = [super init];
    if (self) {
        
        //日志
        [DDLog addLogger:[DDTTYLogger sharedInstance] withLevel:DDLogLevelVerbose];
        [DDLog addLogger:[DDASLLogger sharedInstance] withLevel:DDLogLevelInfo];
        
        self.networkManager =[NetworkManager new];
    }
    return self;
}

+ (instancetype)shareEngine {
    static AppEngine *instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[AppEngine alloc] init];
    });
    return instance;
}


@end
