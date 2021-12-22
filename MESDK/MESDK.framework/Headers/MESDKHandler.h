//
//  MESDKHandler.h
//  MESDK
//
//  Created by 林开宇 on 2021/11/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MESDKOrientationType) {
    MESDKOrientationPortrait,
    MESDKOrientationLandscape,
    MESDKOrientationAuto,
};

typedef void (^SDKResponseBlock)(id _Nullable returnValue, NSString *statusCode);

@interface MESDKHandler : NSObject

/*
 *  服务 ID
 */
@property (nonatomic, copy) NSString *server_id;
/*
 *  商户 ID
 */
@property (nonatomic, copy) NSString *merchant_id;
/*
 *  应用 ID
 */
@property (nonatomic, copy) NSString *app_id;
/*
 *
 */
@property (nonatomic, copy) NSString *app_key;

/*
 *  SDK 单例
 */
+ (instancetype)shareHandler;
+ (NSString *)SDKVersion;

// Config - 设置方向
- (void)setOrientationType:(MESDKOrientationType)oType;
// Config - 设置防沉迷轮询间隔时长，默认60秒
- (void)setTeenagerListenerDuration:(NSTimeInterval)duration;
// Config - 设置API模式
- (void)setAPIMode:(BOOL)apiMode;
- (BOOL)getAPIMode;

// 初始化SDK
- (void)launchSDKWithAppID:(NSString *)app_id AppKey:(NSString *)app_key ServerID:(NSString *)server_id MerchantID:(NSString *)merchant_id Completion:(SDKResponseBlock)completion;
// 获取 Config
- (void)getConfigWithCompletion:(SDKResponseBlock)completion;
// 退出SDK
- (void)exitSDKWithViewController:(UIViewController *)viewController WithCompltion:(SDKResponseBlock)completion;



// 显示协议弹窗
- (void)showProtocolViewWithViewController:(UIViewController *)viewController completion:(SDKResponseBlock)completion;
// 隐藏协议弹窗
- (void)hideProtocolView;
// 用户接受协议
//- (void)userAcceptProtocolWithCompletion:(SDKResponseBlock)completion;



/*
 *  显示登录弹窗
 *
 *  statucCode = [SDKCodeLoginSuccess|SDKCodeTokenLoginSuccess|SDKCodeExpiredToken|SDKCodeUserCancel]
 */
- (void)loginActionWithViewController:(UIViewController *)viewController completion:(SDKResponseBlock)completion;
// 登出
- (void)logoutActionWithCompletion:(SDKResponseBlock)completion;
// 显示登录信息Banner
- (void)showUserInfoBannerWithViewController:(UIViewController *)viewController Avatar:(NSString *)aURL Name:(NSString *)uName completion:(SDKResponseBlock)completion;



// 创建角色
- (void)createRoleWithRoleName:(NSString *)role_name roleID:(NSString *)role_id serverName:(NSString *)server_name completion:(SDKResponseBlock)completion;
// 通知区服
- (void)notifyZoneWithRoleName:(NSString *)role_name roldID:(NSString *)role_id serverName:(NSString *)server_name completion:(SDKResponseBlock)completion;

// 显示实名认证弹窗
- (void)showRealNameCertificateViewWithViewController:(UIViewController *)viewController completion:(SDKResponseBlock)completion;

// 显示防沉迷弹窗
- (void)showTeenagerAlertWithViewController:(UIViewController *)viewController andAlertInfo:(NSDictionary *)alertInfo completion:(SDKResponseBlock)completion;
- (void)checkTeenagerListenerWithCompletion:(SDKResponseBlock)completion;
- (void)stopTeenagerListener;

@end

NS_ASSUME_NONNULL_END
