//
//  MessageCell.h
//  SDCity
//
//  Created by wangweidong on 2018/1/4.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
@class MessageCell;

@protocol MessageCellDelegate<NSObject>

-(void)clickLinkWithCell:(MessageCell *)cell;//点击超链接

@end

@interface MessageCell : UITableViewCell

//MessageCell是用户消息页面的Cell

@property(nonatomic,weak)id <MessageCellDelegate>delegate;

-(void)setCellDataWithMessageModel:(MessageModel*)model;

@end
