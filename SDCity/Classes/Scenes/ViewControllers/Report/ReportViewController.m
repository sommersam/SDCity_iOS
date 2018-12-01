//
//  ReportViewController.m
//  Starrunning
//
//  Created by wangweidong on 2017/7/31.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "ReportViewController.h"
#import "ReportCell.h"
#import "SVProgressHUD.h"
@interface ReportViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)NSMutableArray *selectCellArray;;
@property(nonatomic,strong)UIButton *reportButton;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [SDUtils hexStringToColor:@"1b1b2f"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.reportButton];
    [self loadNavigation];
}

-(void)loadNavigation{
    self.navigationItem.title = @"内容举报";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:KBoldFont(20),NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backViewcontroller)];
    self.navigationItem.leftBarButtonItem.tintColor = KmyColor(240, 240, 240);
    self.navigationController.navigationBar.barTintColor = [SDUtils hexStringToColor:KmainColor];
}

-(void)backViewcontroller{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(UITableView *)mainTableView{

    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+StatusHeight, KmainWidth, KmainHeight-StatusHeight-44) style:UITableViewStylePlain];
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.backgroundColor = [SDUtils hexStringToColor:@"e5e5e5"];
        _mainTableView.bounces = NO;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _selectCellArray = [NSMutableArray arrayWithArray:@[@0,@0,@0,@0,@0,@0]];
        [_mainTableView registerClass:[ReportCell  class] forCellReuseIdentifier:@"ReportCell"];
    }

    return _mainTableView;
}

-(UIButton *)reportButton{

    if (_reportButton == nil) {
        
        _reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reportButton.layer.cornerRadius = 4.0f;
        _reportButton.layer.masksToBounds = YES;
        _reportButton.backgroundColor = [SDUtils hexStringToColor:@"ec5353"];
        _reportButton.frame = CGRectMake(20, KmainHeight-60, KmainWidth-40, 50);
        [_reportButton setTitle:@"提交" forState:UIControlStateNormal];
        [_reportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_reportButton addTarget:self action:@selector(reportAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _reportButton;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSArray *dataArray = @[@"色情低俗",@"政治敏感",@"营销广告",@"恶意攻击谩骂",@"违法乱纪",@"其他"];
    
    ReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReportCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.selectButton.selected = [_selectCellArray[indexPath.row] isEqual:@0]?NO:YES;
    [cell setMainTitleWithTitle:dataArray[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [_selectCellArray setArray:@[@0,@0,@0,@0,@0,@0]];
    _selectCellArray[indexPath.row] = @1;
    [self.mainTableView reloadData];

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KmainWidth, 45)];
    headerView.backgroundColor = [SDUtils hexStringToColor:@"e5e5e5"];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, KmainWidth-5, 45)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"请选择举报原因";
    [headerView addSubview:titleLabel];

    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 50.0f;
}

-(void)reportAction{
    
    BOOL isNoSelect = YES;
    
    for (NSNumber *obj in _selectCellArray) {
        
        if ([obj isEqual:@1]) {
            
            isNoSelect = NO;
        }
    }
    
    if (isNoSelect) {
        [SVProgressHUD showInfoWithStatus:@"请选择举报分类!"];
        [SVProgressHUD dismissWithDelay:1];
    }else{
    
        [SVProgressHUD showSuccessWithStatus:@"举报成功!"];
        KweakSelf(self);
        [SVProgressHUD dismissWithDelay:1 completion:^{
           
            [weakself.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    
}

@end
