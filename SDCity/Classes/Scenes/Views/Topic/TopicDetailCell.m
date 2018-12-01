//
//  TopicDetailCell.m
//  SDCity
//
//  Created by wangweidong on 2017/12/20.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "TopicDetailCell.h"
#import "UIImageView+WebCache.h"
@interface TopicDetailCell()

@property(nonatomic,strong)UIImageView *headerView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UILabel *timeLabel;

@end

@implementation TopicDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [SDUtils hexStringToColor:@"f6f6f6"];
        _headerView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        _headerView.layer.cornerRadius = 20.f;
        _headerView.layer.masksToBounds = YES;
        _headerView.layer.borderColor = [SDUtils hexStringToColor:KmainColor].CGColor;
        _headerView.layer.borderWidth = 0.3f;
        [self.contentView addSubview:self.headerView];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, KmainWidth/3*2-60, 40)];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(KmainWidth/3*2, 0, KmainWidth/3-10, 60)];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 60, KmainWidth-70, 40)];
        _contentLabel.font = [UIFont systemFontOfSize:16];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
    }
    return self;
}

-(void)setCellDataWithTopicReplyModel:(TopicReplyModel *)model andTopicModel:(TopicModel *)topic{
    
    
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:model.headerURL]];
    _nameLabel.text = model.createName;
    _timeLabel.text = [SDUtils compareNowWithDate:[model.createtime longLongValue]];

    
    if ([topic.createName isEqualToString:model.replyName]) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"回复楼主说: %@",model.content]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[SDUtils hexStringToColor:KmainColor] range:NSMakeRange(2, 2)];
        CGFloat contectHeight = [SDUtils heightForString:[NSString stringWithFormat:@"回复楼主说: %@",model.content] fontSize:16 andWidth:KmainWidth-70];
        _contentLabel.frame = CGRectMake(60, 60, KmainWidth-70, contectHeight);
        _contentLabel.attributedText = attributedString;
    }else{
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"回复%@说: %@",model.replyName,model.content]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[SDUtils hexStringToColor:KmainColor] range:NSMakeRange(2, model.replyName.length)];
        CGFloat contectHeight = [SDUtils heightForString:[NSString stringWithFormat:@"回复%@说: %@",model.replyName,model.content] fontSize:16 andWidth:KmainWidth-70];
        _contentLabel.frame = CGRectMake(60, 60, KmainWidth-70, contectHeight);
        _contentLabel.attributedText = attributedString;
    }
    
}



@end
