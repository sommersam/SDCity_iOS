//
//  AlbumMainCell.m
//  SDCity
//
//  Created by wangweidong on 2017/12/21.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "AlbumMainCell.h"
#import "UIImageView+WebCache.h"
@interface AlbumMainCell()

@property(nonatomic,strong)UIButton *createNameButton;
@property(nonatomic,strong)UIButton *contentButton;

@end

@implementation AlbumMainCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"图墙Cell背景.jpg"]];
        self.contentView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognizerAction)];
        [self.contentView addGestureRecognizer:longPressGestureRecognizer];
        
        
        _mainImageView = [[UIImageView alloc]initWithFrame:CGRectMake(KmainWidth/6.0, 10, KmainWidth/3*2, KmainWidth/3*2)];
        _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
        _mainImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _mainImageView.layer.borderWidth = 1.0f;
        _mainImageView.layer.masksToBounds = YES;
        _mainImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTapAction)];
        [_mainImageView addGestureRecognizer:tap];
        [self.contentView addSubview:_mainImageView];
        
        _createNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _createNameButton.frame = CGRectMake(KmainWidth/6.0, CGRectGetMaxY(_mainImageView.frame)+10,KmainWidth/6.0*5 , 40);
        _createNameButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _createNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _createNameButton.userInteractionEnabled = NO;
        [_createNameButton setImage:[UIImage imageNamed:@"Smile"] forState:UIControlStateNormal];
        [_createNameButton setTitle:@"  骚栋" forState:UIControlStateNormal];
        [_createNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_createNameButton];

        _contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _contentButton.frame = CGRectMake(KmainWidth/6.0, CGRectGetMaxY(_createNameButton.frame)+10,KmainWidth/6.0*5 , 40);
        _contentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _contentButton.userInteractionEnabled = NO;
        _contentButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_contentButton setTitle:@"  新年快乐" forState:UIControlStateNormal];
        [_contentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_contentButton setImage:[UIImage imageNamed:@"Label"] forState:UIControlStateNormal];
        [self.contentView addSubview:_contentButton];
    }
    
    return self;
}

-(void)setCellDataWithAlbumModel:(AlbumModel *)model{
    
    [_createNameButton setTitle:[NSString stringWithFormat:@"  %@",model.createName] forState:UIControlStateNormal];
    [_contentButton setTitle:[NSString stringWithFormat:@"  %@",model.details] forState:UIControlStateNormal];

    [_mainImageView sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"图片占位图"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
       
        if (!model.isLoad){
            model.isLoad = YES;
        }
    }];
}

-(void)imageViewTapAction{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(imageViewTapAction:)]) {
        [self.delegate imageViewTapAction:self];
    }

}

-(void)longPressGestureRecognizerAction{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(longPressGestureRecognizerAction:)]) {
        [self.delegate longPressGestureRecognizerAction:self];
    }
}

@end
