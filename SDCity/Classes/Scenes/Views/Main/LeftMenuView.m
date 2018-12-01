//
//  LeftMenuView.m
//  SDCity
//
//  Created by wangweidong on 2017/12/19.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "LeftMenuView.h"
#import "UserManager.h"
#import "HttpManager.h"
#import "UIImageView+WebCache.h"
@interface LeftMenuView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIView *mainView;
@property(nonatomic,strong)UIView *notLoginHeaderView;
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UIImageView *headerImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIImageView *gradeImageView;
@property(nonatomic,strong)UITableView *mainTableView;

@end

@implementation LeftMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = CGRectMake(-KmainWidth, 0, KmainWidth, KmainHeight);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, KmainHeight)];
        _mainView.backgroundColor = [SDUtils hexStringToColor:@"fafafa"];
        [self addSubview:_mainView];
        [_mainView addSubview:self.mainTableView];
        UISwipeGestureRecognizer *swipe  = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(removeLeftMenuView)];
        [swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addGestureRecognizer:swipe];
        
        
        _isShow = NO;
    }
    return self;
}

-(UIView *)notLoginHeaderView{
    
    if (_notLoginHeaderView == nil) {
        _notLoginHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, StatusHeight+44, 300, 100)];
        _notLoginHeaderView.backgroundColor = [UIColor whiteColor];
        
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(20, 0, 280, 100);
        _loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _loginButton.titleLabel.numberOfLines = 0;
        [_loginButton setImage:[UIImage imageNamed:@"未登录"] forState:UIControlStateNormal];
        [_loginButton setTitle:@"    当前还未登录\n    点击登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[SDUtils hexStringToColor:@"808080"] forState:UIControlStateNormal];
        [_notLoginHeaderView addSubview:_loginButton];
    }
    
    return _notLoginHeaderView;
}

-(UIView *)headerView{
    
    if (_headerView == nil) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, StatusHeight+44, 300, 100)];
        _headerView.backgroundColor = [UIColor whiteColor];

        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 190, 40)];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = KBoldFont(20);
        _nameLabel.text = @"未登录";
        
        _gradeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed: @"level_6"]];
        _gradeImageView.frame = CGRectMake(100, 50, 30, 30);
        [_headerView addSubview:self.headerImageView];
        [_headerView addSubview:_nameLabel];
        [_headerView addSubview:_gradeImageView];
        [self loadUserInfomationAction];

    }
    
    return _headerView;
}

-(UIImageView *)headerImageView{
    
    if (_headerImageView == nil) {
        _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80 , 80)];

    }
    return _headerImageView;
}

-(UITableView *)mainTableView{
    
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusHeight+44+120, 300, 300) style:UITableViewStyleGrouped];
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.backgroundColor = [SDUtils hexStringToColor:@"fafafa"];
        _mainTableView.bounces = NO;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    
    return _mainTableView;
}


#pragma mark ---- UITableViewDataSoure 和 UITableViewDelegate ----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.imageView.contentMode = UIViewContentModeCenter;
    cell.backgroundColor = [SDUtils hexStringToColor:@"fafafa"];
    cell.textLabel.font = KBoldFont(17);
    [cell.textLabel.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    switch (indexPath.row) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"User"];
            cell.textLabel.text = @"个人中心";
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"Puzzle"];
            cell.textLabel.text = @"修改密码";
            break;
        case 2:{
            cell.imageView.image = [UIImage imageNamed:@"Message"];
            cell.textLabel.text = @"消息";
            
            if (![[UserManager standardUserManager].messageNumber isEqualToString:@""] && ![[UserManager standardUserManager].messageNumber isEqualToString:@"0"] && [UserManager standardUserManager].messageNumber != nil) {
                NSLog(@"%@",[UserManager standardUserManager].messageNumber);
                
                UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.textLabel.bounds.size.width-40, 15, 30, 30)];
                detailLabel.font = KBoldFont(14);
                detailLabel.text = [UserManager standardUserManager].messageNumber;
                detailLabel.textAlignment = NSTextAlignmentCenter;
                detailLabel.textColor = [UIColor whiteColor];
                detailLabel.backgroundColor = [SDUtils hexStringToColor:KmainColor];
                detailLabel.layer.cornerRadius = 15.0f;
                detailLabel.layer.masksToBounds = YES;
                [cell.textLabel addSubview:detailLabel];
            }
        }

            break;
        case 3:
            cell.imageView.image = [UIImage imageNamed:@"Settings"];
            cell.textLabel.text = @"设置";
            break;
    }
    

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(selectMenuCellWithIndexPath:)]) {
        [self.delegate selectMenuCellWithIndexPath:indexPath.row];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.00f;
}

#pragma mark --- 事件更新 ----
-(void)showLeftMenuView{
    
    if ([UserManager standardUserManager].userId != nil) {
        KweakSelf(self);
        [HttpManager getMessageNumberWithUserId:[UserManager standardUserManager].userId andHandle:^(NSString *error, NSDictionary *result) {
            if (error == nil) {
                NSLog(@"%@",result);
                [weakself.mainTableView reloadData];
            }
        }];
    }
    
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, 0, KmainWidth, KmainHeight);
    } completion:^(BOOL finished) {
        _isShow = YES;
    }];
}

-(void)removeLeftMenuView{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(-KmainWidth, 0, KmainWidth, KmainHeight);
    } completion:^(BOOL finished) {
        _isShow = NO;
    }];
}

-(void)loadUserInfomationAction{
    if ([UserManager standardUserManager].userId != nil) {
        self.nameLabel.text = [UserManager standardUserManager].userName;
        _gradeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"level_%d",[UserManager standardUserManager].grade]];
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[UserManager standardUserManager].headerURL]];
        _headerImageView.layer.cornerRadius = 40.0f;
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.layer.borderColor = [SDUtils hexStringToColor:KmainColor].CGColor;
        _headerImageView.layer.borderWidth = 1.0f;
        [_mainView addSubview:self.headerView];
        [self.notLoginHeaderView removeFromSuperview];
    }else{
        [self.headerView removeFromSuperview];
        [_mainView addSubview:self.notLoginHeaderView];
    }
}

@end
