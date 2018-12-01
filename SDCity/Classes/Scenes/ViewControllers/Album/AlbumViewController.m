//
//  AlbumViewController.m
//  SDCity
//
//  Created by wangweidong on 2017/12/19.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "AlbumViewController.h"
#import "AlbumReportViewController.h"
#import "ReportUserViewController.h"
#import "ReportViewController.h"
#import "LBPhotoBrowserManager.h"
#import "UIView+LBFrame.h"
#import "AlbumMainCell.h"
#import "HttpManager.h"
#import "AlbumModel.h"
#import "MJRefresh.h"
@interface AlbumViewController ()<UITableViewDelegate,UITableViewDataSource,AlbumMainCellDelegate>{
    
    int curPage;
}

@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)NSMutableArray *mainDataArray;
@property (nonatomic , assign)BOOL hideStatusBar;

@end

@implementation AlbumViewController

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
        [_mainTableView registerClass:[AlbumMainCell class] forCellReuseIdentifier:@"AlbumMainCell"];
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstAppear"];
        
        [self presentViewController:[AlbumReportViewController new] animated:YES completion:nil];

    }else {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstAppear"];
        
    }
 
  
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
    
    [HttpManager getAlbumListWithCurPage:curPage pageSize:10 andHandle:^(NSString *error, NSArray<AlbumModel *> *listArray) {
        if (error == nil) {
            
            weakself.mainDataArray = [NSMutableArray arrayWithArray:listArray];
            [weakself.mainTableView reloadData];
            [self loadCellImageAction];
        }
        
        [_mainTableView.mj_header endRefreshing];
    }];
    
}

-(void)loadLastData{
    
    curPage ++;
    KweakSelf(self);

    [HttpManager getAlbumListWithCurPage:curPage*10 pageSize:10 andHandle:^(NSString *error, NSArray<AlbumModel *> *listArray) {
        if (error == nil) {
            
            [weakself.mainDataArray addObjectsFromArray:listArray];
            [weakself.mainTableView reloadData];
            [self loadCellImageAction];
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

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate){
        [self loadCellImageAction];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self loadCellImageAction];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _mainDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AlbumMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumMainCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    AlbumModel*model = _mainDataArray[indexPath.row];
    //当tableview正在被拖动或者滑动时  判断可见cell是否已经加载过图片 来判断在滑动时应该如何显示
    if (_mainTableView.dragging == YES || _mainTableView.decelerating == YES) {
        
        if (model.isLoad) {
            [cell setCellDataWithAlbumModel:model];
        }else {
            cell.mainImageView.image = [UIImage imageNamed:@"登录logo"];
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return KmainWidth;
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

-(void)loadCellImageAction{
    
    NSArray *visiblePaths = [_mainTableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths){
        AlbumMainCell *cell = (AlbumMainCell *)[_mainTableView cellForRowAtIndexPath:indexPath];
        [cell setCellDataWithAlbumModel:_mainDataArray[indexPath.row]];
    }
}



-(void)imageViewTapAction:(AlbumMainCell *)cell{
    
    self.hideStatusBar = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    AlbumModel*model = _mainDataArray[indexPath.row];
    NSMutableArray *items = [[NSMutableArray alloc]init];
    LBPhotoWebItem *item = [[LBPhotoWebItem alloc]initWithURLString:model.imgurl frame:CGRectMake(KmainWidth/6.0, 10, KmainWidth/3*2, KmainWidth/3*2)];
    [items addObject:item];
    
    [LBPhotoBrowserManager.defaultManager showImageWithWebItems:items selectedIndex:0 fromImageViewSuperView:cell.contentView].lowGifMemory = YES;
    
    KweakSelf(self);
    [[LBPhotoBrowserManager defaultManager] addPhotoBrowserWillDismissBlock:^{
        weakself.hideStatusBar = NO;
        [weakself setNeedsStatusBarAppearanceUpdate];
    }];
    
    
}

-(void)longPressGestureRecognizerAction:(AlbumMainCell *)cell{
    
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



- (BOOL)prefersStatusBarHidden {
    return _hideStatusBar;
}


@end
