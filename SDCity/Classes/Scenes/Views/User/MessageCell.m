//
//  MessageCell.m
//  SDCity
//
//  Created by wangweidong on 2018/1/4.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import "MessageCell.h"
#import "UIImageView+WebCache.h"

#define KMarginWidth 10 //边距宽度

@interface MessageCell ()<UITextViewDelegate>

@property(nonatomic,strong)UIImageView *headerImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UITextView *titleView;
@property(nonatomic,strong)UILabel *contentLabel;

@end

@implementation MessageCell

-(UIImageView *)headerImageView{
    
    if (_headerImageView == nil) {
        _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        _headerImageView.layer.cornerRadius = 15.0f;
        _headerImageView.layer.masksToBounds = YES;
    }
    return _headerImageView;
}

-(UILabel *)nameLabel{
    
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, KmainWidth/3.0*2-50, 50)];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _nameLabel;
}

-(UILabel *)timeLabel{
    
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(KmainWidth/3.0*2, 0, KmainWidth/3.0-10, 50)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor lightGrayColor];
    }
    return _timeLabel;
}

-(UITextView *)titleView{
    
    if (_titleView == nil) {
        _titleView = [[UITextView alloc]init];
        _titleView.delegate = self;
        _titleView.scrollEnabled =NO;
        _titleView.showsVerticalScrollIndicator =NO;
        _titleView.editable =NO;
    }
    return _titleView;
}


-(UILabel *)contentLabel{
    
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.layer.cornerRadius = 5.0f;
        _contentLabel.layer.masksToBounds = YES;
        _contentLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _contentLabel.layer.borderWidth = 0.3f;
    }
    return _contentLabel;
}




#pragma mark ----赋值和布局----
-(void)setCellDataWithMessageModel:(MessageModel*)model{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.contentView addSubview:self.headerImageView];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.headerURL]];
    
    [self.contentView addSubview:self.nameLabel];
    NSLog(@"%@",model.createName);
    self.nameLabel.text = model.createName;
    
    [self.contentView addSubview:self.timeLabel];
    self.timeLabel.text = [SDUtils compareNowWithDate:([model.createtime longLongValue])];
    
    [self.contentView addSubview:self.titleView];
    NSMutableAttributedString *attributedString  = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"在《%@》中对你说到:",model.topicName]];
    [attributedString addAttribute:NSLinkAttributeName value:model.topicid range:NSMakeRange(1, model.topicName.length+2)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[SDUtils hexStringToColor:@"67bafc"] range:NSMakeRange(1, model.topicName.length+2)];
    CGFloat textHeight = [SDUtils getSpaceLabelHeightWithFont:[UIFont systemFontOfSize:15] withWidth:KmainWidth-20 withString:attributedString];
    self.titleView.frame = CGRectMake(KMarginWidth,  CGRectGetMaxY(self.nameLabel.frame), KmainWidth-20, textHeight+10);
    self.titleView.attributedText = attributedString;
    self.titleView.backgroundColor = [UIColor clearColor];

    [self.contentView addSubview:self.contentLabel];
    CGFloat contentHeight = [SDUtils heightForString:[NSString stringWithFormat:@"  %@",model.content] fontSize:15 andWidth:KmainWidth-KMarginWidth*2];
    self.contentLabel.frame = CGRectMake(KMarginWidth, CGRectGetMaxY(self.titleView.frame)+10,  KmainWidth-20, contentHeight+20);
    self.contentLabel.text = [NSString stringWithFormat:@"  %@",model.content];

}


#pragma mark ---- 点击超链接 ----
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickLinkWithCell:)]) {
        [self.delegate clickLinkWithCell:self];
    }
    return NO;
}


@end
