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
    
    [[MESDKHandler shareHandler] launchSDKWithAppID:@"1" AppKey:@"JqCB4Jun1pWYaoiTbhC2a$0icKv2JSsu" ServerID:@"1" MerchantID:@"1" Completion:^(NSString * _Nullable infoStr, NSString * _Nonnull statusCode) {
        if ([statusCode isEqualToString:SDKCodeSuccess]) {
            NSLog(@"初始化成功");
            [[MESDKHandler shareHandler] getConfigWithCompletion:^(NSDictionary * _Nullable infoDic, NSString * _Nonnull statusCode) {
                if ([statusCode isEqualToString:SDKCodeSuccess] && infoDic) {
                    NSLog(@"获取配置成功: %@", infoDic);
                } else {
                    NSLog(@"获取配置失败");
                }
            }];
        } else {
            if (infoStr) {
                NSLog(@"%@", infoStr);
            } else {
                NSLog(@"初始化失败");
            }
        }
    }];
    [[MESDKHandler shareHandler] setOrientationType:MESDKOrientationAuto];
    
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
