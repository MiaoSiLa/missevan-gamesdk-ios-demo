//
//  ViewController.m
//  MESDKDemo
//
//  Created by 林开宇 on 2021/11/10.
//

#import "ViewController.h"

#import <MESDK/MESDK.h>

@interface ViewController ()

@property (nonatomic, strong) UIButton *login_button;
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
    [self.view addSubview:self.login_button];
    
    [self.view addSubview:self.protocol_button];
}

#pragma mark - Button Action
- (void)clickLoginButtonAction:(UIButton *)sender {
//    [[MESDKHandler shareHandler] showLoginWithViewController:self completion:^(NSString * _Nonnull statusCode) {
//
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
        _login_button = [[UIButton alloc] initWithFrame:CGRectMake(15, 100, 100, 40)];
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
        _protocol_button = [[UIButton alloc] initWithFrame:CGRectMake(130, 100, 100, 40)];
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


@end
