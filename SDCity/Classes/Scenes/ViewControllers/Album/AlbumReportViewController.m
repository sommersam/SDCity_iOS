

//
//  AlbumReportViewController.m
//  SDCity
//
//  Created by lipengju on 2018/1/7.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import "AlbumReportViewController.h"

@interface AlbumReportViewController ()

@end

@implementation AlbumReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = [SDUtils hexStringToColor:@"e5e5e5"];
    
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"发现图片"]];
    imgView.frame = CGRectMake(20, StatusHeight +44, KmainWidth-40, (KmainWidth-40)/611.0*240);
    [self.view addSubview:imgView];
    
    UIImageView *shieldView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"盾牌"]];
    shieldView.frame = CGRectMake(KmainWidth/2-50, CGRectGetMaxY(imgView.frame)+20, 100, 100);
    [self.view addSubview:shieldView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(KmainWidth *0.1, KmainHeight-(KmainWidth *0.8/614.0*103)-20, KmainWidth *0.8, KmainWidth *0.8/614.0*103);
    [cancelButton setImage:[UIImage imageNamed:@"我知道了"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}
-(void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
