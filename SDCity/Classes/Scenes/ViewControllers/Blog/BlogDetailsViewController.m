//
//  BlogDetailsViewController.m
//  SDCity
//
//  Created by wangweidong on 2017/12/26.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "BlogDetailsViewController.h"
#import "HttpManager.h"
#import "BlogModel.h"
#import <WebKit/WebKit.h>
@interface BlogDetailsViewController ()<WKNavigationDelegate>

@property(nonatomic,strong)WKWebView *webView;

@end

@implementation BlogDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, StatusHeight+44, KmainWidth, KmainHeight-44-StatusHeight)];
    _webView.navigationDelegate = self;
    [self loadNavgationBar];
    [self.view addSubview:_webView];
    
    NSLog(@"%@",[NSString stringWithFormat:@"http://www.dong-city.cn/sdlive/Api/blog/detail/%@",_blogId]);
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.dong-city.cn/sdlive/Api/blog/detail/%@",_blogId]]]];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

-(void)loadNavgationBar{
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.frame = CGRectMake(0, 0, KmainWidth-64*2, 44);
    titleButton.titleLabel.font = [UIFont fontWithName:@"迷你简娃娃篆" size:20];
    [titleButton setTitle:@"文章详情" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"detail_title.png"] forState:UIControlStateNormal];
    titleButton.userInteractionEnabled = NO;
    self.navigationItem.titleView = titleButton;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewControllerAciton)];
    self.navigationItem.leftBarButtonItem.tintColor = KmyColor(240, 240, 240);
    
}

-(void)popViewControllerAciton{
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    [SVProgressHUD showWithStatus:@"文章正在加载..."];
    
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [SVProgressHUD dismiss];


}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [SVProgressHUD dismiss];

    UIView *errorView = [[UIView alloc]initWithFrame:CGRectMake(0, StatusHeight+44, KmainWidth, KmainHeight-44-StatusHeight)];
    errorView.backgroundColor = KmyColor(240, 240, 240);
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, KmainWidth-40, KmainHeight-44-StatusHeight-40)];
    label.text = @"当前页面丢失了,去其他页面看看吧......";
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:@"Senty" size:32];
    label.textColor = [SDUtils hexStringToColor:KmainColor];
    [errorView addSubview:label];
    [self.view addSubview:errorView];
    
}


@end
