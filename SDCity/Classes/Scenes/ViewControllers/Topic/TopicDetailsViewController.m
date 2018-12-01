//
//  TopicDetailsViewController.m
//  SDCity
//
//  Created by wangweidong on 2017/12/20.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "TopicDetailsViewController.h"
#import "TopicDetailsNullCell.h"
#import "ReportUserViewController.h"
#import "ReportViewController.h"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"
#import "WclEmitterButton.h"
#import "TopicReplyModel.h"
#import "TopicDetailCell.h"
#import "TopicReplyView.h"
#import "UserManager.h"
#import "HttpManager.h"
#import "MJRefresh.h"
@interface TopicDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,TopicReplyViewDelegate>{
    
    int curPage;
}


@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)UIView *topicView;//话题详情的View
@property(nonatomic,strong)NSMutableArray *mainDataArray;

@property(nonatomic,strong)TopicReplyView *topicReplyView;

@end

@implementation TopicDetailsViewController

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
    titleButton.titleLabel.font = [UIFont fontWithName:@"迷你简娃娃篆" size:20];
    [titleButton setTitle:[NSString stringWithFormat:@" %@",_topicModel.title] forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"detail_title.png"] forState:UIControlStateNormal];
    titleButton.userInteractionEnabled = NO;
    self.navigationItem.titleView = titleButton;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewControllerAciton)];
    self.navigationItem.leftBarButtonItem.tintColor = KmyColor(240, 240, 240);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"话题回复"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(replyTopicAction)];
  
}

-(void)popViewControllerAciton{
 
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIView *)topicView{
    
    if (_topicView == nil) {
        _topicView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KmainWidth, KmainHeight-StatusHeight-44)];
        _topicView.backgroundColor = [UIColor whiteColor];
        //头像
        UIImageView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
        headerView.layer.cornerRadius = 10.f;
        headerView.layer.masksToBounds = YES;
        headerView.layer.borderColor = [SDUtils hexStringToColor:KmainColor].CGColor;
        headerView.layer.borderWidth = 0.3f;
        [headerView sd_setImageWithURL:[NSURL URLWithString:_topicModel.headerURL]];
        [_topicView addSubview:headerView];

        //姓名
        UILabel *nameLabel= [[UILabel alloc]initWithFrame:CGRectMake(40, 0, KmainWidth/2-40, 40)];
        nameLabel.text = _topicModel.createName;
        nameLabel.textColor = [UIColor lightGrayColor];
        nameLabel.font = [UIFont systemFontOfSize:14];
        [_topicView addSubview:nameLabel];
        
        //时间
        UILabel *timeLabel= [[UILabel alloc]initWithFrame:CGRectMake(KmainWidth/2, 0, KmainWidth/2-10, 40)];
        timeLabel.text = [SDUtils compareNowWithDate:[_topicModel.createtime longLongValue]];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.textColor = [UIColor lightGrayColor];
        timeLabel.font = [UIFont systemFontOfSize:14];
        [_topicView addSubview:timeLabel];
        
        //内容
        CGFloat contectHeight = [SDUtils heightForString:_topicModel.contect fontSize:17 andWidth:KmainWidth-20];
        UILabel *contectLabel= [[UILabel alloc]initWithFrame:CGRectMake(10, 60, KmainWidth-20, contectHeight)];
        _topicView.frame = CGRectMake(0, 0, KmainWidth, contectHeight+80+20+10);//根据内容设定整体的大小
        contectLabel.text = _topicModel.contect;
        contectLabel.numberOfLines = 0;
        [_topicView addSubview:contectLabel];
        
        //标签
        UILabel *labelLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(contectLabel.frame)+20, 40, 20)];
        labelLabel.text = _topicModel.label;
        labelLabel.layer.cornerRadius = 3.0f;
        labelLabel.layer.masksToBounds = YES;
        labelLabel.backgroundColor = [SDUtils hexStringToColor:KmainColor];
        labelLabel.textAlignment = NSTextAlignmentCenter;
        labelLabel.textColor = [UIColor whiteColor];
        labelLabel.font = [UIFont systemFontOfSize:12];
        [_topicView addSubview:labelLabel];
        
        if ([_topicModel.label isEqualToString:@"说说"]) {
            labelLabel.backgroundColor = [SDUtils hexStringToColor:KmainColor];
        }else if ([_topicModel.label isEqualToString:@"分享"]){
            labelLabel.backgroundColor = KmyColor(63, 148, 242);
        }else if ([_topicModel.label isEqualToString:@"日志"]){
            labelLabel.backgroundColor = KmyColor(38, 249, 96);
        }else if ([_topicModel.label isEqualToString:@"签到"]){
            labelLabel.backgroundColor = KmyColor(98, 210, 244);
        }else if ([_topicModel.label isEqualToString:@"吐槽"]){
            labelLabel.backgroundColor = KmyColor(247, 177, 13);
        }else if ([_topicModel.label isEqualToString:@"其他"]){
            labelLabel.backgroundColor = KmyColor(166, 165, 165);
        }
        
        //赞
        WclEmitterButton * zanButton = [[WclEmitterButton alloc]initWithFrame:CGRectMake(KmainWidth-60, CGRectGetMaxY(contectLabel.frame)+20, 50, 20)];
        zanButton.isHaveAnimation = YES;
        zanButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [zanButton setTitleColor:[SDUtils hexStringToColor:@"c0c0c0"] forState:UIControlStateNormal];
        [zanButton setImage:[UIImage imageNamed:@"未赞"] forState:UIControlStateNormal];
        [zanButton setImage:[UIImage imageNamed:@"已赞"] forState:UIControlStateSelected];
        [zanButton setTitle:[NSString stringWithFormat:@" 0喜欢"] forState:UIControlStateNormal];
        [zanButton addTarget:self action:@selector(zanAction:) forControlEvents:UIControlEventTouchUpInside];
        [_topicView addSubview:zanButton];

    }
    
    return _topicView;
}

-(TopicReplyView *)topicReplyView{
    
    if (_topicReplyView == nil) {
        _topicReplyView = [[TopicReplyView alloc]init];
        _topicReplyView.topicModel = _topicModel;
        _topicReplyView.delegate = self;
    }
    return _topicReplyView;
}

-(UITableView *)mainTableView{
    
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusHeight+44, KmainWidth, KmainHeight-44-StatusHeight) style:UITableViewStyleGrouped];
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.tableHeaderView = self.topicView;
        _mainTableView.showsVerticalScrollIndicator = NO;
        [_mainTableView registerClass:[TopicDetailCell class] forCellReuseIdentifier:@"TopicDetailCell"];
        [_mainTableView registerClass:[TopicDetailsNullCell class] forCellReuseIdentifier:@"TopicDetailsNullCell"];
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

    [HttpManager getTopicReplyListWithTopicId:_topicModel.topicId curPage:curPage pageSize:10 andHandle:^(NSString *error, NSArray<TopicReplyModel *> *listArray) {
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
    
    [HttpManager getTopicReplyListWithTopicId:_topicModel.topicId  curPage:curPage*10 pageSize:10 andHandle:^(NSString *error, NSArray<TopicReplyModel *> *listArray) {
        if (error == nil) {
            
            [weakself.mainDataArray  addObjectsFromArray:listArray];
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
    if (_mainDataArray.count == 0) {
        return 1;
    }else{
        return _mainDataArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_mainDataArray.count == 0) {
        TopicDetailsNullCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicDetailsNullCell" forIndexPath:indexPath];
        return  cell;
    }
    
    TopicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicDetailCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    TopicReplyModel *model = _mainDataArray[indexPath.row];
    [cell setCellDataWithTopicReplyModel:model andTopicModel:_topicModel];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_mainDataArray.count == 0) {
        return  100;
    }

    TopicReplyModel *model = _mainDataArray[indexPath.row];
    CGFloat contectHeight = 0;

    if ([_topicModel.createName isEqualToString:model.replyName]) {
        contectHeight = [SDUtils heightForString:[NSString stringWithFormat:@"回复楼主说: %@",model.content] fontSize:16 andWidth:KmainWidth-70];
    }else{
        contectHeight = [SDUtils heightForString:[NSString stringWithFormat:@"回复%@说: %@",model.replyName,model.content] fontSize:16 andWidth:KmainWidth-70];
    }
    
    return contectHeight+60+10;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //回复列表
    UIView *replyHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KmainWidth, 40)];
    replyHeaderView.backgroundColor = [SDUtils hexStringToColor:@"f1f1f1"];

    UIButton *replyHeader = [UIButton buttonWithType:UIButtonTypeCustom];
    replyHeader.frame = CGRectMake(10, 0, KmainWidth-10, 40);
    replyHeader.titleLabel.font = KBoldFont(17);
    [replyHeader setTitle:@" 所有评论" forState:UIControlStateNormal];
    [replyHeader setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];
    [replyHeader setTitleColor:[SDUtils hexStringToColor:KmainColor] forState:UIControlStateNormal];
    replyHeader.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [replyHeaderView addSubview:replyHeader];
    
    return replyHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    KweakSelf(self);
    UIAlertAction *reportAction = [UIAlertAction actionWithTitle:@"举报内容" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        ReportViewController *vc = [[ReportViewController alloc]init];
        [weakself presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
    }];

    
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertVC addAction:reportAction];
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
}


#pragma mark ---- 点赞 和 评论 ----
-(void)zanAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    
}

-(void)replyTopicAction{
    
    if ([UserManager standardUserManager].userId == nil) {
        LoginViewController *vc = [[LoginViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
        
    }else{
        if (!self.topicReplyView.isShow) {
            [self.view addSubview:self.topicReplyView];
            [self.topicReplyView showTopicReplyView];
        }
        
    }
    

}

-(void)successSendReplyMessageAction{
    
    [self loadAllDataSource];
    
}


@end
