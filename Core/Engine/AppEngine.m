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

static NSMutableArray<id<UIApplicationDelegate>> *managers = nil;

@interface AppEngine ()
@property (nonatomic, strong) NetworkManager *networkManager;
@property (nonatomic, strong) PushManager *pushManager;
@end

@implementation AppEngine

- (instancetype)init {
    self = [super init];
    if (self) {
        
        //日志
        [DDLog addLogger:[DDTTYLogger sharedInstance] withLevel:DDLogLevelVerbose];
        [DDLog addLogger:[DDASLLogger sharedInstance] withLevel:DDLogLevelInfo];
        
        self.networkManager = [NetworkManager new];
        self.pushManager = [PushManager new];
    }
    return self;
}

//消息分发
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSString *selector = NSStringFromSelector(anInvocation.selector);
    if (![selector hasPrefix:@"application"]) {
        return;
    }
    [managers enumerateObjectsUsingBlock:^(id<UIApplicationDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:anInvocation.selector]) {
            DDLogDebug(@"-[%@ %@]", obj, selector);
            [anInvocation invokeWithTarget:obj];
        }
    }];
}

/**********************************************************************/
#pragma mark - Public
/**********************************************************************/

+ (BOOL)registerManager:(id<UIApplicationDelegate>)manager {
    if (!manager) {
        return NO;
    }
    if (managers == nil) {
        managers = [NSMutableArray array];
    }
    DDLogDebug(@"已注册：%@", manager);
    [managers addObject:manager];
    return YES;
}

+ (BOOL)unRegisterManager:(id<UIApplicationDelegate>)manager {
    if (managers && [managers containsObject:manager]) {
        DDLogDebug(@"已卸载：%@", manager);
        [managers removeObject:manager];
        return YES;
    }
    return NO;
}

@end
