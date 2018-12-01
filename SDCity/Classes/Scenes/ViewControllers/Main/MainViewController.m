//
//  MainViewController.m
//  SDCity
//
//  Created by wangweidong on 2017/12/18.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "MainViewController.h"
#import "TopicViewController.h"
#import "AlbumViewController.h"
#import "BlogViewController.h"
#import "AddTopicViewController.h"
#import "AddPhotoViewController.h"
#import "LoginViewController.h"
#import "UserInfoViewController.h"
#import "ChangePassWordViewController.h"
#import "MessageViewController.h"
#import "SettingViewController.h"
#import "LeftMenuView.h"
#import "UIImage+Image.h"
#import "UserManager.h"
@interface MainViewController ()<UITabBarDelegate,LeftMenuViewDelegate>

@property(nonatomic,strong)LeftMenuView *leftMenuView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNavigation];
    [self loadAllSubViewController];
    [self.view addSubview:self.leftMenuView];
    self.view.backgroundColor = [UIColor whiteColor];

    //添加通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserLoginSucceedAction) name:ChangeUserInfoNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}
-(void)loadNavigation{
    
    self.navigationItem.title = @"话题";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"菜单"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenuView)];
    self.navigationItem.leftBarButtonItem.tintColor = KmyColor(255, 255, 255);

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"新增话题"] style:UIBarButtonItemStylePlain target:self action:@selector(showAddNewTopicAction)];
    self.navigationItem.rightBarButtonItem.tintColor = KmyColor(255, 255, 255);
}


-(void)showMenuView{
    
    if (self.leftMenuView.isShow) {
        [self.leftMenuView removeLeftMenuView];
    }else{
        [self.leftMenuView showLeftMenuView];
    }   
}

-(LeftMenuView *)leftMenuView{
    
    if (_leftMenuView == nil) {
        _leftMenuView = [[LeftMenuView alloc]initWithFrame:CGRectMake(-KmainWidth, 0, KmainWidth, KmainHeight)];
        _leftMenuView.delegate = self;
        [_leftMenuView loadUserInfomationAction];
        [_leftMenuView.loginButton addTarget:self action:@selector(showLoginViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _leftMenuView;
}

//加载所有的子控制器
-(void)loadAllSubViewController{
 
    TopicViewController *topicVC = [[TopicViewController alloc]init];
    topicVC.tabBarItem.title = @"话题";
    topicVC.tabBarItem.image = [[UIImage imageNamed:@"话题未选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    topicVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"话题选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self loadtabBarColorWithTabBarItem:topicVC.tabBarItem];

    AlbumViewController *albumVC = [[AlbumViewController alloc]init];
    albumVC.tabBarItem.title = @"图墙";
    albumVC.tabBarItem.image = [[UIImage imageNamed:@"相册未选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    albumVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"相册选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self loadtabBarColorWithTabBarItem:albumVC.tabBarItem];
    
    BlogViewController *blogVC = [[BlogViewController alloc]init];
    blogVC.tabBarItem.title = @"技术圈";
    blogVC.tabBarItem.image = [[UIImage imageNamed:@"技术圈未选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    blogVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"技术圈选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self loadtabBarColorWithTabBarItem:blogVC.tabBarItem];

    self.viewControllers = @[topicVC,albumVC,blogVC];
}

//加载颜色设置
-(void)loadtabBarColorWithTabBarItem:(UITabBarItem *)tabBarItem{
    
    NSDictionary *selectHome =@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[SDUtils hexStringToColor:KmainColor] };
    [tabBarItem setTitleTextAttributes:selectHome forState:UIControlStateSelected];
    NSDictionary *normalHome =@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[SDUtils hexStringToColor:KmainNotSelectColor] };
    [tabBarItem setTitleTextAttributes:normalHome forState:UIControlStateNormal];
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    if ([item.title isEqualToString:@"话题"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"新增话题"] style:UIBarButtonItemStylePlain target:self action:@selector(showAddNewTopicAction)];
        self.navigationItem.rightBarButtonItem.tintColor = KmyColor(255, 255, 255);
    }
    
    if ([item.title isEqualToString:@"图墙"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"新增图片"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(showAddNewPhotoAction)];
    }
    if ([item.title isEqualToString:@"技术圈"]) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    self.navigationItem.title = item.title;
}

#pragma mark ---- 新增话题和图片 ----
-(void)showAddNewTopicAction{
    
    if ([UserManager standardUserManager].userId == nil) {
        [self showLoginViewController];
    }else{
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[AddTopicViewController new]];
        [nav setNavigationBarHidden:YES];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
}

-(void)showAddNewPhotoAction{
    
    if ([UserManager standardUserManager].userId == nil) {
        [self showLoginViewController];
    }else{
        [self presentViewController:[AddPhotoViewController new] animated:YES completion:nil];
    }
}


#pragma mark ---- 用户登录以及用户登录通知 ----

-(void)showLoginViewController{
    
    LoginViewController *vc = [[LoginViewController alloc]init];
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:vc];
    [navVC setNavigationBarHidden:YES];
    [self presentViewController:navVC animated:YES completion:nil];
}


//用户登录成功通知
-(void)UserLoginSucceedAction{
    
    if (_leftMenuView != nil) {
        [_leftMenuView loadUserInfomationAction];
    }
}
#pragma mark ---- 菜单栏选项 ----

-(void)selectMenuCellWithIndexPath:(NSInteger)indexPath{

    switch (indexPath) {
        case 0:{
            if ([UserManager standardUserManager].userId == nil) {
                [self showLoginViewController];
            }else{
                [self.navigationController pushViewController:[UserInfoViewController new] animated:YES];
            }
        }break;
        case 1:{
            if ([UserManager standardUserManager].userId == nil) {
                [self showLoginViewController];
            }else{
                [self.navigationController pushViewController:[ChangePassWordViewController new] animated:YES];
            }
        }break;
        case 2:{
            if ([UserManager standardUserManager].userId == nil) {
                [self showLoginViewController];
            }else{
                [self.navigationController pushViewController:[MessageViewController new] animated:YES];
            }
        }break;
        case 3:
            [self.navigationController pushViewController:[SettingViewController new] animated:YES];
            break;
    }
}



-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
