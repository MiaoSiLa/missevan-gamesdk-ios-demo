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


+ (instancetype)shareHandler;
- (NSString *)SDKVersion;

- (void)launchSDKWithCompletion:(void (^)(NSString *statusCode, NSString * _Nullable infoStr))completion;
- (void)exitSDKWithCompltion:(void (^)(NSString *statusCode, NSString * _Nullable infoStr))completion;

- (void)showProtocolViewWithViewController:(UIViewController *)viewController completion:(void (^)(NSString *statusCode))completion;
- (void)hideProtocolView;

@end

NS_ASSUME_NONNULL_END
