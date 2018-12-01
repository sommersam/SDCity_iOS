//
//  AlbumMainCell.h
//  SDCity
//
//  Created by wangweidong on 2017/12/21.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumModel.h"

@class AlbumMainCell;
@protocol AlbumMainCellDelegate<NSObject>

@optional
-(void)imageViewTapAction:(AlbumMainCell *)cell;

-(void)longPressGestureRecognizerAction:(AlbumMainCell *)cell;

@end

@interface AlbumMainCell : UITableViewCell

@property(nonatomic,strong)UIImageView *mainImageView;

@property(nonatomic,weak)id<AlbumMainCellDelegate> delegate;

-(void)setCellDataWithAlbumModel:(AlbumModel *)model;

@end
