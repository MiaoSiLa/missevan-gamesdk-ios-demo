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
@property (nonatomic, strong) UIButton *protocol_button;
@property (nonatomic, strong) UIButton *realname_button;
@property (nonatomic, strong) UIButton *exit_button;

@property (nonatomic, strong) UIButton *role_button;
@property (nonatomic, strong) UIButton *notify_button;

@property (nonatomic, strong) UILabel *api_label;
@property (nonatomic, strong) UISwitch *api_switch;
@property (nonatomic, strong) UILabel *teencheck_label;
@property (nonatomic, strong) UISwitch *teencheck_switch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createView];
    
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
    [self.view addSubview:self.protocol_button];
    [self.view addSubview:self.realname_button];
    [self.view addSubview:self.exit_button];
    [self.view addSubview:self.role_button];
    [self.view addSubview:self.notify_button];
    [self.view addSubview:self.teencheck_label];
    [self.view addSubview:self.teencheck_switch];
    
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
                        } else if ([statusCode isEqualToString:SDKCodeUserCancel]) {
                            NSLog(@"用户取消");
    //                        [weakSelf clickLogoutButtonAction];
                        } else {
                            NSLog(@"发生错误");
                        }
                    }];
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
- (void)clickProtocolButtonAction {
    [[MESDKHandler shareHandler] showProtocolViewWithViewController:self completion:^(id  _Nullable returnValue, NSString * _Nonnull statusCode) {
        if ([statusCode isEqualToString:SDKCodeProtocolConfirm]) {
            NSLog(@"确认协议");
            [[MESDKHandler shareHandler] hideProtocolView];
            [[MESDKHandler shareHandler] userAcceptProtocolWithCompletion:^(id  _Nullable returnValue, NSString * _Nonnull statusCode) {
                
            }];
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
- (void)clickRealNameButtonAction {
    __weak typeof(self) weakSelf = self;
    [[MESDKHandler shareHandler] showRealNameCertificateViewWithViewController:self completion:^(id  _Nullable returnValue, NSString * _Nonnull statusCode) {
        if ([statusCode isEqualToString:SDKCodeCertificateSuccess]) {
            NSLog(@"认证成功");
        } else if ([statusCode isEqualToString:SDKCodeUserCancel]) {
            NSLog(@"用户取消");
            [weakSelf clickLogoutButtonAction];
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
    if (sender.isOn) {
        __weak typeof(self) weakSelf = self;
        [[MESDKHandler shareHandler] checkTeenagerListenerWithCompletion:^(NSDictionary * _Nonnull alertInfo, NSString * _Nonnull statusCode) {
            if ([statusCode isEqualToString:SDKCodeTeenCheckAlert]) {
                [[MESDKHandler shareHandler] showTeenagerAlertWithViewController:weakSelf andAlertInfo:alertInfo completion:^(id  _Nullable returnValue, NSString * _Nonnull statusCode) {
                    if ([statusCode isEqualToString:SDKCodeTeenAlertExit]) {
                        NSLog(@"需要强制退出");
                    } else {
                        NSLog(@"不需要强制退出");
                    }
                }];
            } else if ([statusCode isEqualToString:SDKCodeTeenCheckSuccess]) {
                NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
                [mDic setObject:@(false) forKey:@"open_login"];
                [mDic setObject:@(true) forKey:@"has_notice"];
                [mDic setObject:@"3" forKey:@"notice_type"];
                [mDic setObject:@"防沉迷提示" forKey:@"title"];
                [mDic setObject:@"根据相关政策，未成年玩家在本时段无法登录游戏哦～" forKey:@"content"];
                [mDic setObject:@[@{@"msg": @"<a href='missevan-game://return'>我知道了</a>"}] forKey:@"buttons"];
                [[MESDKHandler shareHandler] showTeenagerAlertWithViewController:weakSelf andAlertInfo:mDic completion:^(id  _Nullable returnValue, NSString * _Nonnull statusCode) {
                    if ([statusCode isEqualToString:SDKCodeTeenAlertExit]) {
                        NSLog(@"需要强制退出");
                        exit(0);
                    } else {
                        NSLog(@"不需要强制退出");
                    }
                }];
                NSLog(@"正常");
            } else {
                NSLog(@"发生错误");
            }
        }];
    } else {
        [[MESDKHandler shareHandler] stopTeenagerListener];
    }
}

#pragma mark - Get/Set
- (UIButton *)login_button {
    if (!_login_button) {
        _login_button = [[UIButton alloc] initWithFrame:CGRectMake(15, 210, ([UIScreen mainScreen].bounds.size.width - 60) / 3.f, 40)];
        [_login_button setTitle:@"登陆" forState:UIControlStateNormal];
        [_login_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _login_button.layer.cornerRadius = 5.f;
        _login_button.layer.masksToBounds = YES;
        _login_button.layer.borderWidth = .5f;
        _login_button.layer.borderColor = [UIColor blackColor].CGColor;
        
        [_login_button addTarget:self action:@selector(clickLoginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _login_button;
}
- (UIButton *)protocol_button {
    if (!_protocol_button) {
        _protocol_button = [[UIButton alloc] initWithFrame:CGRectMake(45 + (([UIScreen mainScreen].bounds.size.width - 60) / 3.f) * 2, 210, ([UIScreen mainScreen].bounds.size.width - 60) / 3.f, 40)];
        [_protocol_button setTitle:@"协议弹窗" forState:UIControlStateNormal];
        [_protocol_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _protocol_button.layer.cornerRadius = 5.f;
        _protocol_button.layer.masksToBounds = YES;
        _protocol_button.layer.borderWidth = .5f;
        _protocol_button.layer.borderColor = [UIColor blackColor].CGColor;
        
        [_protocol_button addTarget:self action:@selector(clickProtocolButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _protocol_button;
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
- (UIButton *)realname_button {
    if (!_realname_button) {
        _realname_button = [[UIButton alloc] initWithFrame:CGRectMake(15, 260, ([UIScreen mainScreen].bounds.size.width - 60) / 3.f, 40)];
        [_realname_button setTitle:@"实名认证" forState:UIControlStateNormal];
        [_realname_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _realname_button.layer.cornerRadius = 5.f;
        _realname_button.layer.masksToBounds = YES;
        _realname_button.layer.borderWidth = .5f;
        _realname_button.layer.borderColor = [UIColor blackColor].CGColor;
        
        [_realname_button addTarget:self action:@selector(clickRealNameButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _realname_button;
}
- (UIButton *)exit_button {
    if (!_exit_button) {
        _exit_button = [[UIButton alloc] initWithFrame:CGRectMake(30 + (([UIScreen mainScreen].bounds.size.width - 60) / 3.f), 260, ([UIScreen mainScreen].bounds.size.width - 60) / 3.f, 40)];
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
        _role_button = [[UIButton alloc] initWithFrame:CGRectMake(15, 320, ([UIScreen mainScreen].bounds.size.width - 45) / 2.f, 40)];
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
        _notify_button = [[UIButton alloc] initWithFrame:CGRectMake(15, 370, ([UIScreen mainScreen].bounds.size.width - 45) / 2.f, 40)];
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
- (UILabel *)teencheck_label {
    if (!_teencheck_label) {
        _teencheck_label = [[UILabel alloc] initWithFrame:CGRectMake(25 + ([UIScreen mainScreen].bounds.size.width - 45) / 2.f, 320, 80, 40)];
        _teencheck_label.text = @"防沉迷轮询：";
        _teencheck_label.textColor = [UIColor blackColor];
        _teencheck_label.font = [UIFont systemFontOfSize:13.f];
    }
    return _teencheck_label;
}
- (UISwitch *)teencheck_switch {
    if (!_teencheck_switch) {
        _teencheck_switch = [[UISwitch alloc] initWithFrame:CGRectMake(105 + ([UIScreen mainScreen].bounds.size.width - 45) / 2.f, 320, 50, 40)];
        [_teencheck_switch setOn:NO];
        [_teencheck_switch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _teencheck_switch;
}


@end
