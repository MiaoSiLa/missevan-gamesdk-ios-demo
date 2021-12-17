//
//  MESDKHandler.h
//  MESDK
//
//  Created by 林开宇 on 2021/11/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MESDKOrientationType) {
    MESDKOrientationAuto,
    MESDKOrientationPortrait,
    MESDKOrientationLandscape,
};

NS_ASSUME_NONNULL_BEGIN

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
- (void)setOrientationType:(MESDKOrientationType)oType;

// 初始化SDK
- (void)launchSDKWithAppID:(NSString *)app_id AppKey:(NSString *)app_key ServerID:(NSString *)server_id MerchantID:(NSString *)merchant_id Completion:(void (^)(NSString * _Nullable infoStr, NSString *statusCode))completion;
// 获取 Config
- (void)getConfigWithCompletion:(void (^)(NSDictionary * _Nullable infoDic, NSString *statusCode))completion;
// 退出SDK
- (void)exitSDKWithViewController:(UIViewController *)viewController WithCompltion:(void (^)(NSString * _Nullable infoStr, NSString *statusCode))completion;



// 显示协议弹窗
- (void)showProtocolViewWithViewController:(UIViewController *)viewController completion:(void (^)(NSString *statusCode))completion;
// 隐藏协议弹窗
- (void)hideProtocolView;
// 用户接受协议
- (void)userAcceptProtocolWithCompletion:(void (^)(NSString *statusCode))completion;



/*
 *  显示登录弹窗
 *
 *  statucCode = [SDKCodeLoginSuccess|SDKCodeTokenLoginSuccess|SDKCodeExpiredToken|SDKCodeUserCancel]
 */
- (void)loginActionWithViewController:(UIViewController *)viewController completion:(void (^)(NSDictionary *user, NSString *statusCode))completion;
// 登出
- (void)logoutActionWithCompletion:(void (^)(NSString *statusCode))completion;
// 显示登录信息Banner
- (void)showUserInfoBannerWithViewController:(UIViewController *)viewController Avatar:(NSString *)aURL Name:(NSString *)uName completion:(void (^)(NSString *statusCode))completion;



// 创建角色
- (void)createRoleWithRoleName:(NSString *)role_name roleID:(NSString *)role_id serverName:(NSString *)server_name completion:(void (^)(NSDictionary * _Nullable infoDic, NSString *statusCode))completion;
// 通知区服
- (void)notifyZoneWithRoleName:(NSString *)role_name roldID:(NSString *)role_id serverName:(NSString *)server_name completion:(void (^)(NSDictionary * _Nullable infoDic, NSString *statusCode))completion;

// 显示实名认证弹窗
- (void)showRealNameCertificateViewWithViewController:(UIViewController *)viewController completion:(void (^)(NSString *statusCode))completion;

@end

NS_ASSUME_NONNULL_END
