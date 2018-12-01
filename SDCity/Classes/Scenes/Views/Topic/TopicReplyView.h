//
//  TopicReplyView.h
//  SDCity
//
//  Created by wangweidong on 2017/12/21.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicModel.h"

@protocol TopicReplyViewDelegate<NSObject>

@optional
-(void)successSendReplyMessageAction;

@end

@interface TopicReplyView : UIView

@property(nonatomic,assign)BOOL isShow;
@property(nonatomic,strong)TopicModel *topicModel;
@property(nonatomic,weak)id<TopicReplyViewDelegate> delegate;

-(void)showTopicReplyView;
-(void)removeTopicReplyView;


@end
