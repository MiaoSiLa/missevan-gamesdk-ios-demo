//
//  MESDKHandler.h
//  MESDK
//
//  Created by 林开宇 on 2021/11/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MESDKHandler : NSObject

/*
 *
 */
@property (nonatomic, strong) NSString *server_id;
/*
 *
 */
@property (nonatomic, strong) NSString *merchant_id;
/*
 *
 */
@property (nonatomic, strong) NSString *app_id;
/*
 *
 */
@property (nonatomic, strong) NSString *app_key;


+ (instancetype)shareHandler;

- (void)initSDK;

- (void)loginWithAccount:(NSString *)account Password:(NSString *)passowrd;

@end

NS_ASSUME_NONNULL_END
