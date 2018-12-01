//
//  TopicViewController.m
//  SDCity
//
//  Created by wangweidong on 2017/12/19.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "TopicViewController.h"
#import "TopicDetailsViewController.h"
#import "ReportUserViewController.h"
#import "ReportViewController.h"
#import "TopicModel.h"
#import "HttpManager.h"
#import "TopicMainCell.h"
#import "MJRefresh.h"
@interface TopicViewController ()<UITableViewDelegate,UITableViewDataSource,TopicMainCellDelegate>{
    
    int curPage;
}

@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)NSMutableArray *mainDataArray;

@end

@implementation TopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainTableView];
    [self loadAllDataSource];
}


#pragma mark --- 懒加载 -----
-(UITableView *)mainTableView{
    
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusHeight+44, KmainWidth, KmainHeight-44-StatusHeight) style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        
        if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            _mainTableView.separatorInset = UIEdgeInsetsZero;
        }
        if ([_mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            _mainTableView.layoutMargins = UIEdgeInsetsZero;
        }
        
        [_mainTableView registerClass:[TopicMainCell class] forCellReuseIdentifier:@"TopicMainCell"];
        [self addRefreshView];
    }
    
    return _mainTableView;
}

#pragma mark ---- tableView上拉刷新和下拉加载 ----

-(void)addRefreshView{
    
    MJRefreshNormalHeader *refreshHeaderView = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadAllDataSource)];
    [refreshHeaderView setTitle:@"刷新完成" forState:MJRefreshStateNoMoreData];
    [refreshHeaderView setTitle:@"松开即刻刷新" forState:MJRefreshStatePulling];
    [refreshHeaderView setTitle:@"刷新中 ..." forState:MJRefreshStateRefreshing];
    _mainTableView.mj_header = refreshHeaderView;
    _mainTableView.mj_footer =[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadLastData)];

}


#pragma mark ---- 加载数据源 ----

-(void)loadAllDataSource{
    curPage = 0;
    KweakSelf(self);
    [HttpManager getTopicListWithCurPage:curPage pageSize:10 andHandle:^(NSString *error, NSArray<TopicModel *> *listArray) {
       
        if (error == nil) {
            
            weakself.mainDataArray = [NSMutableArray arrayWithArray:listArray];
            [weakself.mainTableView reloadData];
        }
        
        [_mainTableView.mj_header endRefreshing];
    }];
}

-(void)loadLastData{
    
    curPage ++;
    KweakSelf(self);
    [HttpManager getTopicListWithCurPage:curPage*10 pageSize:10 andHandle:^(NSString *error, NSArray<TopicModel *> *listArray) {
        
        if (error == nil) {
            
            [weakself.mainDataArray addObjectsFromArray:listArray];
            [weakself.mainTableView reloadData];
        }
        
        [_mainTableView.mj_footer endRefreshing];
    }];
}


#pragma mark ---- UITableViewDataSoure 和 UITableViewDelegate ----

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _mainDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TopicMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicMainCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    TopicModel *model = _mainDataArray[indexPath.row];
    [cell setCellDataWithTopicModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    TopicModel *model = _mainDataArray[indexPath.row];
    CGFloat contectHeight = [SDUtils heightForString:model.contect fontSize:14 andWidth:KmainWidth-20];

    return 40+40+contectHeight+40+10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicModel *model = _mainDataArray[indexPath.row];
    TopicDetailsViewController *vc = [[TopicDetailsViewController alloc]init];
    vc.topicModel = model;
    [self.navigationController pushViewController:vc animated:YES];
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


#pragma mark ---- 举报功能 ----
-(void)clickWithMoreButtonAction{

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    KweakSelf(self);
    UIAlertAction *reportAction = [UIAlertAction actionWithTitle:@"举报内容" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        ReportViewController *vc = [[ReportViewController alloc]init];
        [weakself presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
    }];
    UIAlertAction *reportUserAction = [UIAlertAction actionWithTitle:@"举报用户" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        ReportUserViewController *vc = [[ReportUserViewController alloc]init];
        [weakself presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
    }];
    
    

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertVC addAction:reportAction];
    [alertVC addAction:reportUserAction];
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}




@end
