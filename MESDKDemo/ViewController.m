//
//  ViewController.m
//  MESDKDemo
//
//  Created by 林开宇 on 2021/11/10.
//

#import "ViewController.h"

#import <MESDK/MESDK.h>
#import "UIImageView+WebCache.h"

@interface ViewController ()


@property (nonatomic, strong) UIView *userinfo_view;
@property (nonatomic, strong) UILabel *username_label;
@property (nonatomic, strong) UILabel *userid_label;
@property (nonatomic, strong) UILabel *realname_label;
@property (nonatomic, strong) UIImageView *avatar_imgview;

@property (nonatomic, strong) UIButton *login_button;
@property (nonatomic, strong) UIButton *logout_button;
@property (nonatomic, strong) UIButton *protocol_button;

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
}

#pragma mark - Button Action
- (void)clickLoginButtonAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [[MESDKHandler shareHandler] showLoginWithViewController:self completion:^(NSDictionary * _Nonnull user, NSString * _Nonnull statusCode) {
        if ([statusCode isEqualToString:SDKCodeLoginSuccess]) {
            NSLog(@"登录成功: %@", user);
            weakSelf.userid_label.text = [NSString stringWithFormat:@"ID: %@", user[@"uid"]];
            weakSelf.username_label.text = [NSString stringWithFormat:@"Name: %@", user[@"username"]];
            weakSelf.realname_label.text = [user[@"realname_verified"] boolValue] ? @"RealName: YES" : @"RealName: NO";
            [weakSelf.avatar_imgview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", user[@"avatar"]]]];
        } else {
            NSLog(@"登录失败");
        }
    }];
}
- (void)clickLogoutButtonAction:(UIButton *)sender {
    [[MESDKHandler shareHandler] logoutWithCompletion:^(NSString * _Nonnull statusCode) {
        if ([statusCode isEqualToString:SDKCodeLogoutSuccess]) {
            NSLog(@"退出登录成功");
        } else {
            NSLog(@"退出登录失败");
        }
    }];
//    [[MESDKHandler shareHandler] exitSDKWithCompltion:^(NSString * _Nonnull statusCode, NSString * _Nullable infoStr) {
//        if ([statusCode isEqualToString:SDKCodeSuccess]) {
//            NSLog(@"退出成功");
//        } else {
//            NSLog(@"退出失败");
//        }
//    }];
}
- (void)clickProtocolButtonAction:(UIButton *)sender {
    [[MESDKHandler shareHandler] showProtocolViewWithViewController:self completion:^(NSString * _Nonnull statusCode) {
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
        
        [_login_button addTarget:self action:@selector(clickLoginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
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
        
        [_protocol_button addTarget:self action:@selector(clickProtocolButtonAction:) forControlEvents:UIControlEventTouchUpInside];
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
        
        [_logout_button addTarget:self action:@selector(clickLogoutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
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


@end
