//
//  ViewController.m
//  MESDKDemo
//
//  Created by 林开宇 on 2021/11/10.
//

#import "ViewController.h"

#import <MESDK/MESDK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[MESDKHandler shareHandler] loginWithAccount:@"353339279@qq.com" Password:@"111111"];
}


@end
