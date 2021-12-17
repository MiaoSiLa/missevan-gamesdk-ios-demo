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
static NSString * const SDKCodeSuccess =                @"100000";
static NSString * const SDKCodeUserCancel =             @"100001";

// 协议
static NSString * const SDKCodeProtocolConfirm =        @"200000";
static NSString * const SDKCodeProtocolReject =         @"200001";
static NSString * const SDKCodeProtocolUpdateReject =   @"200101";

// 登录
static NSString * const SDKCodeLoginSuccess =           @"300000";
static NSString * const SDKCodeTokenLoginSuccess =      @"300100";

static NSString * const SDKCodeLogoutSuccess =          @"300200";
static NSString * const SDKCodeLogoutFailed =           @"300201";
static NSString * const SDKCodeCertificateSuccess =     @"300300";
static NSString * const SDKCodeChangeUser =             @"300400";

// 未知失败
static NSString * const SDKCodeUnknownError =           @"900000";
// 服务器失败
static NSString * const SDKCodeServersError =           @"900001";
// 参数不合法
static NSString * const SDKCodeParametersIllegal =      @"900002";
// 需要登录
static NSString * const SDKCodeNeedLogin =              @"900003";
// Token 过期
static NSString * const SDKCodeExpiredToken =           @"900101";
static NSString * const SDKCodeTeenagerForbidden =      @"900102";



#endif /* MESDKStatusCode_h */
