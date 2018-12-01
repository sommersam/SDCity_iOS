//
//  BlogMainCell.m
//  SDCity
//
//  Created by wangweidong on 2017/12/26.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "BlogMainCell.h"

@interface BlogMainCell()

@property(nonatomic,strong)UIButton *titleButton;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *labelLabel;


@end

@implementation BlogMainCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.frame = CGRectMake(10, 5, KmainWidth-20, 40);
        _titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_titleButton setImage:[UIImage imageNamed:@"blogger"] forState:UIControlStateNormal];
        [self.contentView addSubview:_titleButton];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, KmainWidth/2-10, 50)];
        _nameLabel.textColor = [UIColor lightGrayColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameLabel];
        
        _labelLabel = [[UILabel alloc]initWithFrame:CGRectMake(KmainWidth-50, 65, 40, 20)];
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

-(void)setCellDataWithBlogModel:(BlogModel *)model{
    
    [_titleButton setTitle:[NSString stringWithFormat:@"  %@",model.title] forState:UIControlStateNormal];
    _nameLabel.text = model.createName;
    
    CGFloat labelWidth = [SDUtils widthForString:model.categoryname fontSize:12 andHight:20];
    _labelLabel.text = model.categoryname;
    if (labelWidth+5 > 40) {
        _labelLabel.frame = CGRectMake(KmainWidth-10-5-labelWidth, 65, 5+labelWidth, 20);
    }
}

@end
