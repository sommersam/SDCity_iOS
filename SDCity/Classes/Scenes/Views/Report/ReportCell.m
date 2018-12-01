//
//  ReportCell.m
//  Starrunning
//
//  Created by wangweidong on 2017/7/31.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "ReportCell.h"
#define KCellHeight 40.0f

@interface ReportCell ()

@property(nonatomic,strong)UILabel *titleLable;

@end

@implementation ReportCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor lightGrayColor];
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.frame = CGRectMake(0, 0, KCellHeight, KCellHeight);
        [_selectButton setImage:[UIImage imageNamed:@"举报未选中"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"举报选中"] forState:UIControlStateSelected];
        [self.contentView addSubview:_selectButton];
        
        _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(KCellHeight+5, 0, KmainWidth-KCellHeight-5, KCellHeight)];
        _titleLable.font = [UIFont systemFontOfSize:16];
        _titleLable.textColor = [UIColor blackColor];
        [self.contentView addSubview:_titleLable];
    }
    
    return self;
}

-(void)setMainTitleWithTitle:(NSString *)title{

    _titleLable.text = title;
}


@end
