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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [[MESDKHandler shareHandler] loginWithAccount:@"353339279@qq.com" Password:@"111111"];
    
    [self createView];
}

#pragma mark - CreateView
- (void)createView {
    [self.view addSubview:self.login_button];
}

#pragma mark - Button Action
- (void)clickLoginButtonAction:(UIButton *)sender {
    [[MESDKHandler shareHandler] showLoginWithViewController:self completion:^{
        
    }];
}

#pragma mark - Get/Set
- (UIButton *)login_button {
    if (!_login_button) {
        _login_button = [[UIButton alloc] initWithFrame:CGRectMake(200, 100, 100, 40)];
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


@end
