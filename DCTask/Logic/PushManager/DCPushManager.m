//
//  DCPushManager.m
//  DCTask
//
//  Created by 青秀斌 on 2016/11/8.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCPushManager.h"

@implementation DCPushManager

- (void)presentLocalNotificationNow:(Plan *)plan {
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    if ([UIDevice systemVersion]>=8.2) {
        localNote.alertTitle = @"新任务提醒";
    }
    localNote.alertBody = @"收到一条巡检任务";
    localNote.alertAction = @"解锁";
    localNote.hasAction = NO;
    localNote.applicationIconBadgeNumber = 1;
    localNote.soundName = @"Voicemail.caf";
    localNote.userInfo = @{@"plan_id":plan.plan_id, @"plan_date":plan.plan_date};
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNote];
}

- (void)scheduleLocalNotification:(Plan *)plan {
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    if ([UIDevice systemVersion]>=8.2) {
        localNote.alertTitle = @"任务到期提醒";
    }
    localNote.fireDate = [plan.plan_date dateByAddingDays:-1];
    localNote.repeatInterval = NSCalendarUnitDay;
    localNote.alertBody = @"您有一条未处理的任务即将到期";
    localNote.alertAction = @"解锁";
    localNote.hasAction = NO;
    localNote.applicationIconBadgeNumber = 1;
    localNote.soundName = UILocalNotificationDefaultSoundName;
    localNote.userInfo = @{@"plan_id":plan.plan_id, @"plan_date":plan.plan_date};
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
}

- (void)cancelLocalNotification:(Plan *)plan {
    [[UIApplication sharedApplication].scheduledLocalNotifications enumerateObjectsUsingBlock:^(UILocalNotification * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.userInfo[@"plan_id"] isEqualToString:plan.plan_id]) {
            [[UIApplication sharedApplication] cancelLocalNotification:obj];
            *stop = YES;
        }
    }];
}

/**********************************************************************/
#pragma mark - UIApplicationDelegate
/**********************************************************************/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [application setApplicationIconBadgeNumber:0];
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    AudioServicesPlaySystemSound(1002);
    
    //Toast提示通知
    if (application.applicationState == UIApplicationStateActive) {
        [application setApplicationIconBadgeNumber:0];
        [SVProgressHUD showInfoWithStatus:notification.alertBody];
    }
    
    //到期后清除通知
    NSDate *plan_date = notification.userInfo[@"plan_date"];
    if (plan_date && plan_date.timeIntervalSince1970 <= [[NSDate date] dateByAddingDays:-1].timeIntervalSince1970) {
        [application cancelLocalNotification:notification];
    }
}

@end
