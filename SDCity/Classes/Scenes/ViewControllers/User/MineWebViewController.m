//
//  MineWebViewController.m
//  YuQing
//
//  Created by wangweidong on 2017/11/23.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "MineWebViewController.h"
#import "UIImage+Image.h"
#import <WebKit/WebKit.h>
@interface MineWebViewController ()

@property(nonatomic,strong)WKWebView *webView;

@end

@implementation MineWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNavigation];
    self.webView = [[WKWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    NSString *htmlName;
    switch (_indexRow) {
        case 0:
            htmlName = @"policy";
            break;
        case 1:
            htmlName = @"contactus";
            break;
    }
    NSString* path = [[NSBundle mainBundle] pathForResource:htmlName ofType:@"html"];
        NSLog(@"%@",path);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    
    [self.webView loadRequest: request];
    [self.view addSubview:self.webView];
}

-(void)loadNavigation{
    
    [self.navigationController setNavigationBarHidden:NO];
    NSString *title;

    switch (_indexRow) {
        case 0:
            title = @"用户协议";
            break;
        case 1:
            title = @"联系骚栋";
            break;
    }
    self.navigationItem.title = title;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backViewcontroller)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [SDUtils hexStringToColor:KmainColor];
    self.navigationController.navigationBar.translucent = YES;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >10.0) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KmainWidth, 64)];
        bgView.backgroundColor = [SDUtils hexStringToColor:KmainColor];
        [self.navigationController.navigationBar setValue:bgView forKey:@"backgroundView"];
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[SDUtils hexStringToColor:KmainColor]]
                                                     forBarPosition:UIBarPositionAny
                                                         barMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }
    
}
-(void)backViewcontroller{
    [self.navigationController popViewControllerAnimated: YES];
}

@end
