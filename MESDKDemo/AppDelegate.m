//
//  AppDelegate.m
//  MESDKDemo
//
//  Created by 林开宇 on 2021/11/10.
//

#import "AppDelegate.h"

#import <MESDK/MESDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    MESDKHandler *handler = [MESDKHandler shareHandler];
    handler.app_id = @"1";
    handler.merchant_id = @"1";
    handler.server_id = @"1";
    handler.app_key = @"JqCB4Jun1pWYaoiTbhC2a$0icKv2JSsu";
    [handler launchSDKWithCompletion:^(NSString * _Nonnull statusCode, NSString * _Nullable infoStr) {
        if ([statusCode isEqualToString:SDKCodeSuccess]) {
            NSLog(@"初始化成功");
        } else {
            if (infoStr) {
                NSLog(@"%@", infoStr);
            } else {
                NSLog(@"初始化失败");
            }
        }
    }];
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
