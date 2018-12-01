//
//  SettingViewController.m
//  SDCity
//
//  Created by wangweidong on 2017/12/29.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "SettingViewController.h"
#import "MineWebViewController.h"
#import "UserManager.h"
#import "SVProgressHUD.h"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *mainTableView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNavgationBar];
    [self.view addSubview:self.mainTableView];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)loadNavgationBar{
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.frame = CGRectMake(0, 0, KmainWidth-64*2, 44);
    titleButton.titleLabel.font = KBoldFont(20);
    [titleButton setTitle:@" 设置" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"Settings"] forState:UIControlStateNormal];
    titleButton.userInteractionEnabled = NO;
    self.navigationItem.titleView = titleButton;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:KBoldFont(20),NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewControllerAciton)];
    self.navigationItem.leftBarButtonItem.tintColor = KmyColor(240, 240, 240);
}

-(void)popViewControllerAciton{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Senty" size:32],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITableView *)mainTableView{
    
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusHeight+44, KmainWidth, KmainHeight-44-StatusHeight) style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.bounces = NO;
        if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            _mainTableView.separatorInset = UIEdgeInsetsZero;
        }
        if ([_mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            _mainTableView.layoutMargins = UIEdgeInsetsZero;
        }
        
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SettingCell"];
    }
    
    return _mainTableView;
}

#pragma mark ---- UITableViewDataSoure 和 UITableViewDelegate ----

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if ([UserManager standardUserManager].userId != nil) {
        return 2;
    }else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    switch (indexPath.section) {
        case 0:{
            NSArray *dataArray = @[@"  用户协议",@"  联系骚栋",@"  在App Store赞我们"];
            cell.textLabel.text = dataArray[indexPath.row];
        }break;
        case 1:{
            cell.textLabel.text = @"注销登录";
            cell.textLabel.textColor = [UIColor redColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }break;

    }
    
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 20.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        if (indexPath.row != 2) {
            MineWebViewController *webVC = [[MineWebViewController alloc]init];
            webVC.indexRow = (int)indexPath.row;
            [self.navigationController pushViewController:webVC animated:YES];
        }else{
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@&mt=8", @"1332583990"]];
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
        
        
        
    }
    
    if (indexPath.section == 1) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"用户注销" message:[NSString stringWithFormat:@"确定要注销用户'%@'吗?",[UserManager standardUserManager].userName] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * exitAction = [UIAlertAction actionWithTitle:@"注销用户" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [UserManager clearUserInfo];
            [_mainTableView reloadData];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserAccount];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserPassword];
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangeUserInfoNotification object:nil];
            [SVProgressHUD showSuccessWithStatus:@"用户注销成功!"];
            [SVProgressHUD dismissWithDelay:1.0];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:exitAction];
        [self presentViewController:alertController animated:YES completion:nil];

    }

    
    
}


@end
