//
//  MESDKHandler.h
//  MESDK
//
//  Created by 林开宇 on 2021/11/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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
- (NSString *)SDKVersion;

- (void)launchSDKWithAppID:(NSString *)app_id AppKey:(NSString *)app_key ServerID:(NSString *)server_id MerchantID:(NSString *)merchant_id Completion:(void (^)(NSString * _Nullable infoStr, NSString *statusCode))completion;
- (void)exitSDKWithCompltion:(void (^)(NSString * _Nullable infoStr, NSString *statusCode))completion;

//Protocol
- (void)showProtocolViewWithViewController:(UIViewController *)viewController completion:(void (^)(NSString *statusCode))completion;
- (void)hideProtocolView;
- (void)userAcceptProtocolWithCompletion:(void (^)(NSString *statusCode))completion;

//Login
- (void)showLoginWithViewController:(UIViewController *)viewController completion:(void (^)(NSDictionary *user, NSString *statusCode))completion;
- (void)logoutWithCompletion:(void (^)(NSString *statusCode))completion;

//UserInfo
- (void)getUserInfoWithToken:(NSString *)token completion:(void (^)(NSDictionary *user_info, NSString *statusCode))completion;
- (void)showUserInfoBannerWithViewController:(UIViewController *)viewController Avatar:(NSString *)aURL Name:(NSString *)uName completion:(void (^)(NSString *statusCode))completion;

//RealName Certificate
- (void)showRealNameCertificateViewWithViewController:(UIViewController *)viewController completion:(void (^)(NSString *statusCode))completion;

@end

NS_ASSUME_NONNULL_END
