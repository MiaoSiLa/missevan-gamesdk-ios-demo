//
//  MESDKStatusCode.h
//  MESDK
//
//  Created by 林开宇 on 2021/11/18.
//

#ifndef MESDKStatusCode_h
#define MESDKStatusCode_h

#import <Foundation/Foundation.h>

// 接口成功
static NSString * const SDKCodeSuccess = @"100000";

// 协议
static NSString * const SDKCodeProtocolConfirm = @"200000";
static NSString * const SDKCodeProtocolReject = @"200001";
static NSString * const SDKCodeProtocolUpdateReject = @"200101";

// 登录
static NSString * const SDKCodeLoginSuccess = @"300000";
static NSString * const SDKCodeLoginUserCancel = @"300001";

static NSString * const SDKCodeLogoutSuccess = @"300100";
static NSString * const SDKCodeLogoutFailed = @"300101";

// 未知失败
static NSString * const SDKCodeUnknownError = @"900000";
// 服务器失败
static NSString * const SDKCodeServersError = @"900001";



#endif /* MESDKStatusCode_h */
