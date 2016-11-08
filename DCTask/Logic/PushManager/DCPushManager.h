//
//  DCPushManager.h
//  DCTask
//
//  Created by 青秀斌 on 2016/11/8.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCPushManager : NSObject<UIApplicationDelegate>

- (void)presentLocalNotificationNow:(Plan *)plan;
- (void)scheduleLocalNotification:(Plan *)plan;
- (void)cancelLocalNotification:(Plan *)plan;

@end
