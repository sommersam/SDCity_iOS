//
//  MessageViewController.m
//  SDCity
//
//  Created by wangweidong on 2017/12/29.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "MessageViewController.h"
#import "TopicDetailsViewController.h"
#import "MessageCell.h"
#import "HttpManager.h"
#import "UserManager.h"
#import "MJRefresh.h"
@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource,MessageCellDelegate>{
    
    int curPage;
}

@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)NSMutableArray *mainDataArray;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNavgationBar];
    [self.view addSubview:self.mainTableView];
    [self loadAllDataSource];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)loadNavgationBar{
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.frame = CGRectMake(0, 0, KmainWidth-64*2, 44);
    titleButton.titleLabel.font = KBoldFont(20);
    [titleButton setTitle:@" 我的消息" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"Message"] forState:UIControlStateNormal];
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

#pragma mark ---- 懒加载 ----

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
        
        [_mainTableView registerClass:[MessageCell class] forCellReuseIdentifier:@"MessageCell"];
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
    [HttpManager getMessageListWithUserId:[UserManager standardUserManager].userId curPage:curPage pageSize:10 andHandle:^(NSString *error, NSArray<MessageModel *> *listArray) {
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
    [HttpManager getMessageListWithUserId:[UserManager standardUserManager].userId curPage:curPage*10  pageSize:10 andHandle:^(NSString *error, NSArray<MessageModel *> *listArray) {
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
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    MessageModel *model = _mainDataArray[indexPath.row];
    [cell setCellDataWithMessageModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MessageModel *model = _mainDataArray[indexPath.row];
    
    NSMutableAttributedString *attributedString  = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"在《%@》中对你说到:",model.topicName]];
    [attributedString addAttribute:NSLinkAttributeName value:model.topicid range:NSMakeRange(1, model.topicName.length+2)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[SDUtils hexStringToColor:@"67bafc"] range:NSMakeRange(1, model.topicName.length+2)];
    CGFloat textHeight = [SDUtils getSpaceLabelHeightWithFont:[UIFont systemFontOfSize:15] withWidth:KmainWidth-20 withString:attributedString];
    CGFloat contentHeight = [SDUtils heightForString:[NSString stringWithFormat:@"  %@",model.content] fontSize:15 andWidth:KmainWidth-20];

    return 50+10+textHeight+10+contentHeight+20+10;
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

#pragma mark ---- 点击超链接 ----
-(void)clickLinkWithCell:(MessageCell *)cell{
    
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    MessageModel *model = _mainDataArray[indexPath.row];

    [HttpManager getTopicDetailsWithTopicId:model.topicid userId:[UserManager standardUserManager].userId andHandle:^(NSString *error, TopicModel *model) {
       
        if (error == nil) {
            TopicDetailsViewController *vc = [[TopicDetailsViewController alloc]init];
            vc.topicModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
}

@end
