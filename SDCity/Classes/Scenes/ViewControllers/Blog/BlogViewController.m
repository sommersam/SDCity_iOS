//
//  BlogViewController.m
//  SDCity
//
//  Created by wangweidong on 2017/12/19.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "BlogViewController.h"
#import "BlogDetailsViewController.h"
#import "BlogMainCell.h"
#import "HttpManager.h"
#import "BlogModel.h"
#import "MJRefresh.h"

@interface BlogViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    int curPage;
}

@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)NSMutableArray *mainDataArray;

@end

@implementation BlogViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mainTableView];
    [self loadAllDataSource];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(UITableView *)mainTableView{
    
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusHeight + 44, KmainWidth, KmainHeight-StatusHeight-44) style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        [_mainTableView registerClass:[BlogMainCell class] forCellReuseIdentifier:@"BlogMainCell"];
        [self addRefreshView];
        if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            _mainTableView.separatorInset = UIEdgeInsetsZero;
        }
        if ([_mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            _mainTableView.layoutMargins = UIEdgeInsetsZero;
        }
        
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
    
    [HttpManager getBlogListWithCurPage:curPage pageSize:10 andHandle:^(NSString *error, NSArray<BlogModel *> *listArray) {
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
    
    [HttpManager getBlogListWithCurPage:curPage*10 pageSize:10 andHandle:^(NSString *error, NSArray<BlogModel *> *listArray) {
        if (error == nil) {
            
            [weakself.mainDataArray addObjectsFromArray:listArray];
            [weakself.mainTableView reloadData];
        }
        
        [_mainTableView.mj_footer endRefreshing];
    }];
}

#pragma mark ---- UITableViewDelegate和UITableViewDataSource ----

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _mainDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BlogMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BlogMainCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    BlogModel*model = _mainDataArray[indexPath.row];
    [cell setCellDataWithBlogModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100.0f;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BlogModel*model = _mainDataArray[indexPath.row];
    BlogDetailsViewController *vc = [[BlogDetailsViewController alloc]init];
    vc.blogId = model.blogId;
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end

