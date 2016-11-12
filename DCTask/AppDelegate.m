//
//  AppDelegate.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/3.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "AppDelegate.h"
#import "DCLoginVC.h"
#import "DCRegisterVC.h"
#import "DCPushManager.h"
#import <JSPatchPlatform/JSPatch.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (void)initialize {
    [JSPatch startWithAppKey:@"6b71c529af64abac"];
    [DCAppEngine registerManager:APPENGINE.dataManager];
    [DCAppEngine registerManager:APPENGINE.userManager];
    [DCAppEngine registerManager:APPENGINE.pushManager];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [APPENGINE application:application didFinishLaunchingWithOptions:launchOptions];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor darkGrayColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5f];
    
//    self.mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    if (APPENGINE.userManager.user) {
//        self.window.rootViewController = [self.mainSB instantiateInitialViewController];
//    } else {
//        self.window.rootViewController = [self.mainSB instantiateViewControllerWithIdentifier:@"RegisterNav"];
//    }
//    [self.window makeKeyAndVisible];
     
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [APPENGINE applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [APPENGINE applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [APPENGINE applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [JSPatch sync];
    [APPENGINE applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [APPENGINE applicationWillTerminate:application];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [APPENGINE application:application didReceiveLocalNotification:notification];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [APPENGINE application:application didRegisterUserNotificationSettings:notificationSettings];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [APPENGINE application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APPENGINE application:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    [APPENGINE application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

@end
