# 猫耳FM 游戏 SDK 集成 V1.0.0

猫耳FM 游戏 SDK 开发包（简称：SDK）主要用来向第三方应用程序提供便捷、安全以及可靠的登录、支付服务。本文主要描述 SDK 用户登录、支付接口的使用方法，供合作伙伴的开发者接入使用。

### 1.SDK 接入前准备

| 参数名称    | 参数说明                        |
| ----------- | ------------------------------- |
| server_id   | 分配给研发的区服 ID             |
| merchant_id | 分配给研发的商户 ID             |
| app_id      | 分配给研发的游戏 ID             |
| app_key     | SDK 客户端与 SDK 服务器通信密钥 |

这些参数请通过开放平台或与我方人员联系获取

**app_key 是客户端签名所使用的的 key，是 SDK 初始化时必填的参数**

**重要提示：研发接入需根据不同 app_id 分配单独的服务器部署，基于平台游戏 app_id + 用户 uid 对应游戏内用户唯一 ID，以便区分用户。**

### 2.SDK 快速接入

#### 2.1 基础环境

本教程适用于 XCode 开发工具

#### 2.2 SDK 导入
1. 将 Demo 项目中 MESDK 目录下的 **MESDK.framework** 与 **MESDKResource.bundle** 拖入项目中。
2. 在 **TARGETS - General** 的 **Frameworks, Libraries, and Embedded Content** 中添加 **libc++.tbd** 依赖库
3. 在 **TARGETS - Build Settings** 中设置 **Other Linker Flags** 添加 **-ObjC**
4. 在 **info.plist** 中添加 
```objective-c
    <key>NSAppTransportSecurity</key>
    <dict>
    <key>NSAllowsArbitrayLoads</key>
    <true/>
    </dict>
```
5. 使用时引入 `#import <MESDK/MESDK.h>`

### 3.SDK 初始化

#### 3.1 SDK 初始化接口

1. SDK 单例获取方法
```objective-c
    [MESDKHandler shareHandler];
```
2. 初始化方法调用如下
```objective-c
    [[MESDKHandler shareHandler] launchSDKWithAppID:app_id AppKey:app_key ServerID:server_id MerchantID:merchant_id Completion:^(id _Nullable launchInfo, NSString * _Nonnull statusCode) {
        //SDKCodeSuccess
    }];
```
关于 **statusCode** 请参考 SDK 中的 [MESDKStatusCode.h](#jump5)

#### 3.2 SDK 设置

在获取 SDK 对象后，可以调用其中接口。设置相关方法建议在初始化方法调用之后立即设置。

1. 获取配置方法
```objective-c
    - (void)getConfigWithCompletion:(SDKResponseBlock)completion;
```
2. 设置显示方向
```objective-c
    // MESDKOrientationPortrait | MESDKOrientationLandscape | MESDKOrientationAuto

    - (void)setOrientationType:(MESDKOrientationType)oType;
```
3. 设置防沉迷轮询间隔，默认60秒
```objective-c
    - (void)setTeenagerListenerDuration:(NSTimeInterval)duration;
```
4. 设置 API 模式 （DEBUG）
```objective-c
    - (void)setAPIMode:(BOOL)apiMode;
```

### 4.SDK 接口介绍

接入前建议运行 Demo，从而全面了解我方 SDK，具体详情可以参考 Demo **ViewController.m**

关于 **SDKResponseBlock** 说明
```objective-c
    typedef void (^SDKResponseBlock)(id _Nullable returnValue, NSString *statusCode);
```

#### 4.1 登录接口

1. 登录
```objective-c
    /*
        Response

        id<NSDictionary *> returnValue = @{ @"uid": id<NSString *>,
                                            @"username": id<NSString *>,
                                            @"avatar": id<NSString *>, 
                                            @"realname_verified": id<NSString *>,
                                            @"expire_at": id<NSString *>,
                                            @"token": id<NSString *> };
        id<NSString *> statusCode = SDKCodeLoginSuccess;
                                    SDKCodeTokenLoginSuccess
                                    SDKCodeTeenCheckAlert
                                    SDKCodeExpiredToken

    */
    - (void)loginActionWithViewController:(UIViewController *)viewController completion:(SDKResponseBlock)completion;
```
调用该方法，会打开猫耳游戏用户登录界面，引导用户输入用户名、密码完成登录过程，登录成功后弹出欢迎弹窗，可以切换用户，**需确保每次进入游戏前都调用**。

**注意：停服相关公告接口会在登录之前调用，停服维护期间不要调用 SDK 登录接口（若游戏有多个区服，停服维护的区服不可调用SDK接口，其他正常区服可调用）**

在登录成功后需要调用```showUserInfoBannerWithViewController:Avatar:Name:completion:```用于显示用户信息。
确认登录返回信息 **realname_verified** 字段 **boolValue**
- 如为 **false** 需要调用```showRealNameCertificateViewWithViewController:completion:```显示实名弹窗，进行实名认证。
- 如为 **true** 请开启防沉迷轮询```startTeenagerListener```。


2. 登出
```objective-c
    /*
        Response

        id returnValue = nil;
        id<NSString *> statusCode = SDKCodelogoutSuccess;
    */
    - (void)logoutActionWithCompletion:(SDKResponseBlock)completion;
```
3. 显示登录用户信息提示
顶部提示消失时间为 3s
```objective-c
    /* 
        @param  aURL    登录后返回的头像 URL
        @param  uName   登录后返回的用户名称   

        Response

        id returnValue = nil;
        id<NSString *> statusCode = SDKCodeChangeUser
    */
    - (void)showUserInfoBannerWithViewController:(UIViewController *)viewController Avatar:(NSString *)aURL Name:(NSString *)uName completion:(SDKResponseBlock)completion;
```
如用户点击 **更换用户** 操作，请调用登出接口```logoutActionWithCompletion:```

#### 4.2 协议弹窗

1. 显示协议弹窗
```objective-c
    /*
        Response

        id returnValue = nil;
        id<NSString *> statusCode = SDKCodeProtocolConfirm
                                    SDKCodeProtocolReject
                                    SDKCodeProtocolUpdateReject
    */
    - (void)showProtocolViewWithViewController:(UIViewController *)viewController completion:(SDKResponseBlock)completion;
```
根据流程图，app 在启动时调用协议弹窗，检查是否为第一次登录，是否有协议更新。
在用户拒绝同意协议时，将退出app

2. 隐藏协议弹窗
```objective-c
    - (void)hideProtocolView;
```

#### 4.3 实名认证弹窗

1. 显示实名认证弹窗
```objective-c
    /*
        Response

        id returnValue = nil;
        id<NSString *> statusCode = SDKCodeTeenAlertExit
                                    SDKCodeTeenCheckSuccess
    */
    - (void)showRealNameCertificateViewWithViewController:(UIViewController *)viewController completion:(SDKResponseBlock)completion;
```
在登录后用户需要实名认证时弹出，如果用户拒绝实名认证，需要退出当前登录用户。

2. 隐藏实名认证弹窗
```objective-c
    - (void)hideRealNameCertificateView;
```

#### 4.4 防沉迷相关

1. 显示防沉迷弹窗
```objective-c
    /*
        Response

        id returnValue = nil;
        id<NSString *> statucCode = SDKCodeTeenAlertExit
    */
    - (void)showTeenagerAlertWithViewController:(UIViewController *)viewController andAlertInfo:(id)alertObj completion:(SDKResponseBlock)completion;
```

2. 启动防沉迷轮询
```objective-c
    /*
        Response

        id returnValue = nil;
        id<NSString *> statucCode = SDKCodeTeenCheckAlert
                                    SDKCodeTeenCheckSuccess
    */
    - (void)checkTeenagerListenerWithCompletion:(SDKResponseBlock)completion;
```
在用户登录时与未成年用户登录后超过时限时会弹出防沉迷弹窗，根据接口返回信息实行强制退出app或关闭弹窗

3. 关闭防沉迷轮询
```objective-c
    - (void)stopTeenagerListener;
```

#### 4.5 创建角色
```objective-c
    /*
        @param  role_name   角色名称
        @param  role_id     角色ID
        @param  server_name 服务器名称

        Response

        id<NSDictionary *> returnValue = @{ @"role_id": id<NSString *>, 
                                            @"role_name": id<NSString *>, 
                                            @"app_id": Int,
                                            @"server_id": Int,
                                            @"server_name": id<NSString *>,
                                            @"uid": Int };
        id<NSString *> statusCode = SDKCodeSuccess
    */
    - (void)createRoleWithRoleName:(NSString *)role_name roleID:(NSString *)role_id serverName:(NSString *)server_name completion:(SDKResponseBlock)completion;
```
在用户成功创建角色后调用

#### 4.6 通知区服
```objective-c
    /*
        @param  role_name   角色名称
        @param  role_id     角色ID
        @param  server_name 服务器名称

        Response

        id<NSDictionary *> returnValue = @{ @"role_id": id<NSString *>, 
                                            @"role_name": id<NSString *>, 
                                            @"app_id": Int,
                                            @"server_id": Int,
                                            @"server_name": id<NSString *>,
                                            @"uid": Int };
        id<NSString *> statusCode = SDKCodeSuccess
    */
    - (void)notifyZoneWithRoleName:(NSString *)role_name roldID:(NSString *)role_id serverName:(NSString *)server_name completion:(SDKResponseBlock)completion;
```
在用户登录并选择角色以及服务器后调用

#### 4.7 退出 SDK
```objective-c
    /*
        Response

        id returnValue = nil;
        id<NSString *> statusCode = SDKCodeSuccess
                                    SDKCodeUserCancel
    */
    - (void)exitSDKWithViewController:(UIViewController *)viewController WithCompltion:(SDKResponseBlock)completion;
```
调用该接口会弹出退出提示弹窗，用户确认后退出app

### <span id="jump5">5.SDK statusCode 说明</span>
> // 接口成功
>
> static NSString * const SDKCodeSuccess =                @"100000";
>
> static NSString * const SDKCodeUserCancel =             @"100001";
>
> // 协议
>
> static NSString * const SDKCodeProtocolConfirm =        @"200000";
>
> static NSString * const SDKCodeProtocolReject =         @"200001";
>
> static NSString * const SDKCodeProtocolUpdateReject =   @"200101";
>
> // 登录
>
> static NSString * const SDKCodeLoginSuccess =           @"300000";
>
> static NSString * const SDKCodeTokenLoginSuccess =      @"300100";
>
>
> static NSString * const SDKCodeLogoutSuccess =          @"300200";
>
> static NSString * const SDKCodeLogoutFailed =           @"300201";
>
> static NSString * const SDKCodeCertificateSuccess =     @"300300";
>
> static NSString * const SDKCodeChangeUser =             @"300400";
>
> static NSString * const SDKCodeTeenCheckSuccess =       @"400000";
>
> static NSString * const SDKCodeTeenCheckAlert =         @"400001";
>
> static NSString * const SDKCodeTeenCheckError =         @"400002";
>
> static NSString * const SDKCodeTeenAlertCancel =        @"400100";
>
> static NSString * const SDKCodeTeenAlertExit =          @"400101";
>
> // 未知失败
>
> static NSString * const SDKCodeUnknownError =           @"900000";
>
> // 服务器失败
>
> static NSString * const SDKCodeServersError =           @"900001";
>
> // 参数不合法
>
> static NSString * const SDKCodeParametersIllegal =      @"900002";
>
> // 需要登录
>
> static NSString * const SDKCodeNeedLogin =              @"900003";
>
> // 未成年禁止登录
>
> static NSString * const SDKCodeExpiredToken =           @"900101";
>
> static NSString * const SDKCodeTeenagerForbidden =      @"900102";
