//
//  TopicDetailsNullCell.m
//  SDCity
//
//  Created by wangweidong on 2017/12/21.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "TopicDetailsNullCell.h"

@interface TopicDetailsNullCell()


@end

@implementation TopicDetailsNullCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIButton *mainButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, KmainWidth, 100)];
        mainButton.titleLabel.font = [UIFont fontWithName:@"迷你简娃娃篆" size:14];
        [mainButton setImage:[UIImage imageNamed:@"椅子"] forState:UIControlStateNormal];
        [mainButton setTitle:@"当前还没有人评论,快来评论抢首发~" forState:UIControlStateNormal];
        [mainButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:mainButton];
        
    }
    return self;
}

@end
