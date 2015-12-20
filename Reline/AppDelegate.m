//
//  AppDelegate.m
//  Reline
//
//  Created by Realank on 15/12/9.
//  Copyright © 2015年 Realank. All rights reserved.
//

#import "AppDelegate.h"
#import "ChangyanSDK.h"
#import "StartViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    application.applicationIconBadgeNumber = 0;
    
    [self initEaseMobWithApplication:application withOptions:launchOptions];
    
    [self registRemoteNotificationWithApplication:application];
    
    [self initChangYan];
    
    return YES;
}

#pragma mark - 初始化第三方sdk
- (void)initEaseMobWithApplication:(UIApplication*) application withOptions:(NSDictionary *)launchOptions{
    NSString *apnsCertName = nil;
#if 0//DEBUG
    apnsCertName = @"reline_apns_dev";
#else
    apnsCertName = @"reline_apns_product";
#endif
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"realank-com#reline" apnsCertName:apnsCertName];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)registRemoteNotificationWithApplication:(UIApplication*) application{
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
}

- (void)initChangYan{
    [ChangyanSDK registerApp:@"cys5h4gcM"
                      appKey:@"3e4a7b532abeb06d7bd02f288a0f80e0"
                 redirectUrl:@"http://10.2.58.251:8081/login-success.html"
        anonymousAccessToken:@"realankhBcOtwGzEapYEsKt69Us55p8xBPbvxZ8EhW0"];
    
    [ChangyanSDK setAllowSelfLogin:YES];
    [ChangyanSDK setLoginViewController:[[StartViewController alloc] init]];
    
//    [ChangyanSDK setAllowAnonymous:YES];
    [ChangyanSDK setAllowRate:YES];
    [ChangyanSDK setAllowUpload:YES];
}

#pragma mark - 处理app代理

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    NSLog(@"error -- %@",error);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     [[EaseMob sharedInstance] applicationWillEnterForeground:application];
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

@end
