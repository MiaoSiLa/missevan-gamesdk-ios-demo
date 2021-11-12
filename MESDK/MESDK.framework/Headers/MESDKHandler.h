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
 *
 */
@property (nonatomic, copy) NSString *server_id;
/*
 *
 */
@property (nonatomic, copy) NSString *merchant_id;
/*
 *
 */
@property (nonatomic, copy) NSString *app_id;
/*
 *
 */
@property (nonatomic, copy) NSString *app_key;


+ (instancetype)shareHandler;

- (void)initSDK;

- (NSString *)SDKVersion;

- (void)loginWithAccount:(NSString *)account Password:(NSString *)passowrd;

- (void)showLoginWithViewController:(UIViewController *)viewController completion:(void (^)(void))compltion;

@end

NS_ASSUME_NONNULL_END
