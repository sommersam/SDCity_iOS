//
//  TopicMainCell.h
//  SDCity
//
//  Created by wangweidong on 2017/12/19.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicModel.h"

@protocol TopicMainCellDelegate<NSObject>

@optional
-(void)clickWithMoreButtonAction;

@end

@interface TopicMainCell : UITableViewCell

@property(nonatomic,weak)id<TopicMainCellDelegate> delegate;

-(void)setCellDataWithTopicModel:(TopicModel *)model;

@end
