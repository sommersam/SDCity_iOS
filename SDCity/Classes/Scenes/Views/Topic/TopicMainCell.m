//
//  TopicMainCell.m
//  SDCity
//
//  Created by wangweidong on 2017/12/19.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "TopicMainCell.h"
#import "UIImageView+WebCache.h"
@interface TopicMainCell()

@property(nonatomic,strong)UIImageView *headerView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIButton *moreButton;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UILabel *labelLabel;

@end

@implementation TopicMainCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _headerView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
        _headerView.layer.cornerRadius = 10.f;
        _headerView.layer.masksToBounds = YES;
        _headerView.layer.borderColor = [SDUtils hexStringToColor:KmainColor].CGColor;
        _headerView.layer.borderWidth = 0.3f;
        [self.contentView addSubview:self.headerView];

        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, KmainWidth-50-40, 20)];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_nameLabel];

        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.frame = CGRectMake(KmainWidth-10-40, 0, 40,40);
        [_moreButton setImage:[UIImage imageNamed:@"举报按钮"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_moreButton];

        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, KmainWidth-20, 30)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, KmainWidth-20, 40)];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_contentLabel];
        
        _labelLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_contentLabel.frame)+10, 40, 20)];
        _labelLabel.layer.cornerRadius = 3.0f;
        _labelLabel.layer.masksToBounds = YES;
        _labelLabel.backgroundColor = [SDUtils hexStringToColor:KmainColor];
        _labelLabel.textAlignment = NSTextAlignmentCenter;
        _labelLabel.textColor = [UIColor whiteColor];
        _labelLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_labelLabel];
    }
    return self;
}


-(void)setCellDataWithTopicModel:(TopicModel *)model{
    
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:model.headerURL]];
    _nameLabel.text = model.createName;
    _titleLabel.text = model.title;
    if (model.imgURL == nil) {
        
        CGFloat contectHeight = [SDUtils heightForString:model.contect fontSize:14 andWidth:KmainWidth-20];
        _contentLabel.frame = CGRectMake(10, 80, KmainWidth-20, contectHeight);
        _contentLabel.text = model.contect;
        _labelLabel.frame = CGRectMake(10, CGRectGetMaxY(_contentLabel.frame)+10, 40, 20);
        _labelLabel.text = model.label;
        
        if ([model.label isEqualToString:@"说说"]) {
            _labelLabel.backgroundColor = [SDUtils hexStringToColor:KmainColor];
        }else if ([model.label isEqualToString:@"分享"]){
            _labelLabel.backgroundColor = KmyColor(63, 148, 242);
        }else if ([model.label isEqualToString:@"日志"]){
            _labelLabel.backgroundColor = KmyColor(38, 249, 96);
        }else if ([model.label isEqualToString:@"签到"]){
            _labelLabel.backgroundColor = KmyColor(98, 210, 244);
        }else if ([model.label isEqualToString:@"吐槽"]){
            _labelLabel.backgroundColor = KmyColor(247, 177, 13);
        }else if ([model.label isEqualToString:@"其他"]){
            _labelLabel.backgroundColor = KmyColor(166, 165, 165);
        }
    }
  
}


-(void)moreButtonAction{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickWithMoreButtonAction)]) {
        [self.delegate clickWithMoreButtonAction];
    }
}

@end
