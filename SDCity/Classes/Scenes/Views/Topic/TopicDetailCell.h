//
//  TopicDetailCell.h
//  SDCity
//
//  Created by wangweidong on 2017/12/20.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicReplyModel.h"
#import "TopicModel.h"

@interface TopicDetailCell : UITableViewCell

//TopicDetailCell是话题详情页的Cell
-(void)setCellDataWithTopicReplyModel:(TopicReplyModel *)model andTopicModel:(TopicModel *)topic;


@end
