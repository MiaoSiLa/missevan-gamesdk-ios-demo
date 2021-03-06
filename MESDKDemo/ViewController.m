//
//  ViewController.m
//  MESDKDemo
//
//  Created by 林开宇 on 2021/11/10.
//

#import "ViewController.h"

#import <MESDK/MESDK.h>
#import "UIImageView+WebCache.h"

#import "AppDelegate.h"
#import "SceneDelegate.h"

@interface ViewController ()


@property (nonatomic, strong) UIView *userinfo_view;
@property (nonatomic, strong) UILabel *username_label;
@property (nonatomic, strong) UILabel *userid_label;
@property (nonatomic, strong) UILabel *realname_label;
@property (nonatomic, strong) UIImageView *avatar_imgview;

@property (nonatomic, strong) UIButton *login_button;
@property (nonatomic, strong) UIButton *logout_button;
@property (nonatomic, strong) UIButton *exit_button;

@property (nonatomic, strong) UIButton *role_button;
@property (nonatomic, strong) UIButton *notify_button;

@property (nonatomic, strong) UILabel *api_label;
@property (nonatomic, strong) UISwitch *api_switch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createView];
    
    [self ProtocolAction];
}

#pragma mark - CreateView
- (void)createView {
    [self.view addSubview:self.userinfo_view];
    [self.userinfo_view addSubview:self.avatar_imgview];
    [self.userinfo_view addSubview:self.userid_label];
    [self.userinfo_view addSubview:self.username_label];
    [self.userinfo_view addSubview:self.realname_label];
    
    [self.view addSubview:self.login_button];
    [self.view addSubview:self.logout_button];
    [self.view addSubview:self.exit_button];
    [self.view addSubview:self.role_button];
    [self.view addSubview:self.notify_button];
    [self.view addSubview:self.api_label];
    [self.view addSubview:self.api_switch];
}

#pragma mark - Button Action
- (void)clickLoginButtonAction {
    __weak typeof(self) weakSelf = self;
    [[MESDKHandler shareHandler] loginActionWithViewController:self completion:^(id _Nullable returnValue, NSString * _Nonnull statusCode) {
        if ([statusCode isEqualToString:SDKCodeLoginSuccess] || [statusCode isEqualToString:SDKCodeTokenLoginSuccess]) {
            if ([returnValue isKindOfClass:[NSDictionary class]]) {
                NSDictionary *user = returnValue;
                NSLog(@"登录成功: %@", user);
                weakSelf.userid_label.text = [NSString stringWithFormat:@"ID: %@", user[@"uid"]];
                weakSelf.username_label.text = [NSString stringWithFormat:@"Name: %@", user[@"username"]];
                weakSelf.realname_label.text = [user[@"realname_verified"] boolValue] ? @"RealName: YES" : @"RealName: NO";
                [weakSelf.avatar_imgview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", user[@"avatar"]]]];
                
                //Show Banner
                [[MESDKHandler shareHandler] showUserInfoBannerWithViewController:weakSelf Avatar:user[@"avatar"] Name:user[@"username"] completion:^(id  _Nullable returnValue, NSString * _Nonnull statusCode) {
                    if ([statusCode isEqualToString:SDKCodeChangeUser]) {
                        NSLog(@"更换用户");
                        [weakSelf clickChangeButtonAction];
                    }
                }];
                
                if (![user[@"realname_verified"] boolValue]) {
                    //Show Realname
                    [[MESDKHandler shareHandler] showRealNameCertificateViewWithViewController:weakSelf completion:^(id  _Nullable returnValue, NSString * _Nonnull statusCode) {
                        if ([statusCode isEqualToString:SDKCodeCertificateSuccess]) {
                            NSLog(@"认证成功");
                            [[MESDKHandler shareHandler] hideRealNameCertificateView];
                            
                            [weakSelf startTeenagerListener];
                        } else if ([statusCode isEqualToString:SDKCodeUserCancel]) {
                            NSLog(@"用户取消");
                            [weakSelf clickLogoutButtonAction];
                        } else {
                            NSLog(@"发生错误");
                        }
                    }];
                } else {
                    [weakSelf startTeenagerListener];
                }
            }
        } else if ([statusCode isEqualToString:SDKCodeTeenCheckAlert]) {
            [[MESDKHandler shareHandler] showTeenagerAlertWithViewController:weakSelf andAlertInfo:returnValue completion:^(id  _Nullable returnValue, NSString * _Nonnull statusCode) {
                if ([statusCode isEqualToString:SDKCodeTeenAlertExit]) {
                    NSLog(@"需要强制退出");
                    exit(0);
                } else {
                    NSLog(@"不需要强制退出");
                }
            }];
        } else {
            NSLog(@"登录失败");
        }
    }];
}
- (void)clickChangeButtonAction {
    __weak typeof(self) weakSelf = self;
    [[MESDKHandler shareHandler] logoutActionWithCompletion:^(id  _Nullable returnValue, NSString * _Nonnull statusCode) {
        if ([statusCode isEqualToString:SDKCodeLogoutSuccess]) {
            weakSelf.avatar_imgview.image = nil;
            weakSelf.userid_label.text = @"";
            weakSelf.username_label.text = @"";
            weakSelf.realname_label.text = @"";
            NSLog(@"退出登录成功");
            [weakSelf clickLoginButtonAction];
        } else {
            NSLog(@"退出登录失败");
        }
    }];
}
- (void)clickLogoutButtonAction {
    [self stopTeenagerListener];
    
    __weak typeof(self) weakSelf = self;
    [[MESDKHandler shareHandler] logoutActionWithCompletion:^(id  _Nullable returnValue, NSString * _Nonnull statusCode) {
        if ([statusCode isEqualToString:SDKCodeLogoutSuccess]) {
            weakSelf.avatar_imgview.image = nil;
            weakSelf.userid_label.text = @"";
            weakSelf.username_label.text = @"";
            weakSelf.realname_label.text = @"";
            NSLog(@"退出登录成功");
        } else {
            NSLog(@"退出登录失败");
        }
    }];
}
- (void)ProtocolAction {
    [[MESDKHandler shareHandler] showProtocolViewWithViewController:self completion:^(id  _Nullable returnValue, NSString * _Nonnull statusCode) {
        if ([statusCode isEqualToString:SDKCodeProtocolConfirm]) {
            NSLog(@"确认协议");
            [[MESDKHandler shareHandler] hideProtocolView];
        } else if ([statusCode isEqualToString:SDKCodeProtocolReject]) {
            NSLog(@"拒绝协议");
            exit(0);
        } else if ([statusCode isEqualToString:SDKCodeProtocolUpdateReject]) {
            NSLog(@"拒绝更新协议");
            exit(0);
        } else {
            NSLog(@"发生错误");
        }
    }];
}
- (void)clickExitButtonAction {
    [[MESDKHandler shareHandler] exitSDKWithViewController:self WithCompltion:^(NSString * _Nullable infoStr, NSString * _Nonnull statusCode) {
        if ([statusCode isEqualToString:SDKCodeSuccess]) {
            NSLog(@"退出成功");
            exit(0);
        } else if ([statusCode isEqualToString:SDKCodeUserCancel]) {
            NSLog(@"用户取消");
        } else {
            NSLog(@"%@", infoStr);
        }
    }];
}
- (void)clickRoleButtonAction {
    [[MESDKHandler shareHandler] createRoleWithRoleName:@"怪兽" roleID:@"222" serverName:@"猫耳1区" completion:^(NSDictionary * _Nullable infoDic, NSString * _Nonnull statusCode) {
        if ([statusCode isEqualToString:SDKCodeSuccess]) {
            NSLog(@"%@", infoDic);
        } else if ([statusCode isEqualToString:SDKCodeParametersIllegal]) {
            NSLog(@"参数错误");

        } else {
            NSLog(@"发生错误");
        }
    }];
}
- (void)clickNotifyButtonAction {
    [[MESDKHandler shareHandler] notifyZoneWithRoleName:@"怪兽" roldID:@"222" serverName:@"猫耳1区" completion:^(NSDictionary * _Nullable infoDic, NSString * _Nonnull statusCode) {
        if ([statusCode isEqualToString:SDKCodeSuccess]) {
            NSLog(@"%@", infoDic);
        } else if ([statusCode isEqualToString:SDKCodeParametersIllegal]) {
            NSLog(@"参数错误");
        } else {
            NSLog(@"发生错误");
        }
    }];
}
- (void)switchAction:(UISwitch *)sender {
    [[MESDKHandler shareHandler] setAPIMode:sender.isOn];
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"设置完 API 请重启 APP" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *exitaction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        exit(0);
    }];
    [vc addAction:exitaction];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)startTeenagerListener {
    __weak typeof(self) weakSelf = self;
    [[MESDKHandler shareHandler] checkTeenagerListenerWithCompletion:^(id _Nonnull returnValue, NSString * _Nonnull statusCode) {
        if ([statusCode isEqualToString:SDKCodeTeenCheckAlert]) {
            [[MESDKHandler shareHandler] showTeenagerAlertWithViewController:weakSelf andAlertInfo:returnValue completion:^(id  _Nullable returnValue, NSString * _Nonnull statusCode) {
                if ([statusCode isEqualToString:SDKCodeTeenAlertExit]) {
                    NSLog(@"需要强制退出");
                    exit(0);
                } else {
                    NSLog(@"不需要强制退出");
                }
            }];
        } else if ([statusCode isEqualToString:SDKCodeTeenCheckSuccess]) {
            NSLog(@"正常");
        } else {
            NSLog(@"发生错误, %@", returnValue);
        }
    }];
}
- (void)stopTeenagerListener {
    [[MESDKHandler shareHandler] stopTeenagerListener];
}

#pragma mark - Get/Set
- (UIButton *)login_button {
    if (!_login_button) {
        _login_button = [[UIButton alloc] initWithFrame:CGRectMake(15, 210, ([UIScreen mainScreen].bounds.size.width - 60) / 3.f, 40)];
        [_login_button setTitle:@"登录" forState:UIControlStateNormal];
        [_login_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _login_button.layer.cornerRadius = 5.f;
        _login_button.layer.masksToBounds = YES;
        _login_button.layer.borderWidth = .5f;
        _login_button.layer.borderColor = [UIColor blackColor].CGColor;
        
        [_login_button addTarget:self action:@selector(clickLoginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _login_button;
}
- (UIButton *)logout_button {
    if (!_logout_button) {
        _logout_button = [[UIButton alloc] initWithFrame:CGRectMake(30 + (([UIScreen mainScreen].bounds.size.width - 60) / 3.f), 210, ([UIScreen mainScreen].bounds.size.width - 60) / 3.f, 40)];
        [_logout_button setTitle:@"登出" forState:UIControlStateNormal];
        [_logout_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _logout_button.layer.cornerRadius = 5.f;
        _logout_button.layer.masksToBounds = YES;
        _logout_button.layer.borderWidth = .5f;
        _logout_button.layer.borderColor = [UIColor blackColor].CGColor;
        
        [_logout_button addTarget:self action:@selector(clickLogoutButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logout_button;
}

- (UIView *)userinfo_view {
    if (!_userinfo_view) {
        _userinfo_view = [[UIView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 100)];
    }
    return _userinfo_view;
}
- (UILabel *)username_label {
    if (!_username_label) {
        _username_label = [[UILabel alloc] initWithFrame:CGRectMake(110, 35, [UIScreen mainScreen].bounds.size.width - 120, 20)];
        _username_label.font = [UIFont systemFontOfSize:15.f];
        _username_label.textColor = [UIColor colorWithWhite:61.f / 255.f alpha:1.f];
    }
    return _username_label;
}
- (UILabel *)userid_label {
    if (!_userid_label) {
        _userid_label = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, [UIScreen mainScreen].bounds.size.width - 120, 15)];
        _userid_label.font = [UIFont systemFontOfSize:11.f];
        _userid_label.textColor = [UIColor colorWithWhite:61.f / 255.f alpha:1.f];
    }
    return _userid_label;
}
- (UILabel *)realname_label {
    if (!_realname_label) {
        _realname_label = [[UILabel alloc] initWithFrame:CGRectMake(110, 60, [UIScreen mainScreen].bounds.size.width - 120, 20)];
        _realname_label.font = [UIFont systemFontOfSize:15.f];
        _realname_label.textColor = [UIColor colorWithWhite:61.f / 255.f alpha:1.f];
    }
    return _realname_label;
}
- (UIImageView *)avatar_imgview {
    if (!_avatar_imgview) {
        _avatar_imgview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 80, 80)];
        _avatar_imgview.layer.cornerRadius = 40;
        _avatar_imgview.layer.masksToBounds = YES;
    }
    return _avatar_imgview;
}
- (UIButton *)exit_button {
    if (!_exit_button) {
        _exit_button = [[UIButton alloc] initWithFrame:CGRectMake(45 + (([UIScreen mainScreen].bounds.size.width - 60) / 3.f) * 2, 210, ([UIScreen mainScreen].bounds.size.width - 60) / 3.f, 40)];
        [_exit_button setTitle:@"退出游戏" forState:UIControlStateNormal];
        [_exit_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _exit_button.layer.cornerRadius = 5.f;
        _exit_button.layer.masksToBounds = YES;
        _exit_button.layer.borderWidth = .5f;
        _exit_button.layer.borderColor = [UIColor blackColor].CGColor;
        
        [_exit_button addTarget:self action:@selector(clickExitButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exit_button;
}
- (UIButton *)role_button {
    if (!_role_button) {
        _role_button = [[UIButton alloc] initWithFrame:CGRectMake(15, 270, ([UIScreen mainScreen].bounds.size.width - 45) / 2.f, 40)];
        [_role_button setTitle:@"创建角色" forState:UIControlStateNormal];
        [_role_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _role_button.layer.cornerRadius = 5.f;
        _role_button.layer.masksToBounds = YES;
        _role_button.layer.borderWidth = .5f;
        _role_button.layer.borderColor = [UIColor blackColor].CGColor;
        
        [_role_button addTarget:self action:@selector(clickRoleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _role_button;
}
- (UIButton *)notify_button {
    if (!_notify_button) {
        _notify_button = [[UIButton alloc] initWithFrame:CGRectMake(30 + ([UIScreen mainScreen].bounds.size.width - 45) / 2.f, 270, ([UIScreen mainScreen].bounds.size.width - 45) / 2.f, 40)];
        [_notify_button setTitle:@"通知区服" forState:UIControlStateNormal];
        [_notify_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _notify_button.layer.cornerRadius = 5.f;
        _notify_button.layer.masksToBounds = YES;
        _notify_button.layer.borderWidth = .5f;
        _notify_button.layer.borderColor = [UIColor blackColor].CGColor;
        
        [_notify_button addTarget:self action:@selector(clickNotifyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _notify_button;
}
- (UILabel *)api_label {
    if (!_api_label) {
        _api_label = [[UILabel alloc] initWithFrame:CGRectMake(15, 330, 80, 40)];
        _api_label.text = [NSString stringWithFormat:@"当前API:%@", [[MESDKHandler shareHandler] getAPIMode] ? @"线上" : @"UAT"];
        _api_label.textColor = [UIColor blackColor];
        _api_label.font = [UIFont systemFontOfSize:13.f];
    }
    return _api_label;
}
- (UISwitch *)api_switch {
    if (!_api_switch) {
        _api_switch = [[UISwitch alloc] initWithFrame:CGRectMake(105 , 330, 50, 40)];
        [_api_switch setOn:[[MESDKHandler shareHandler] getAPIMode]];
        [_api_switch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _api_switch;
}


@end
