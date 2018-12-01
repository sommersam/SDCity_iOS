//
//  TopicReplyModel.h
//  SDCity
//
//  Created by wangweidong on 2017/12/20.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicReplyModel : NSObject

//TopicReplyModel是某个话题回复的Model
@property(nonatomic,copy)NSString *Id;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *createid;
@property(nonatomic,copy)NSNumber *createtime;
@property(nonatomic,copy)NSString *topicid;
@property(nonatomic,copy)NSString *replyid;
@property(nonatomic,copy)NSString *replyName;
@property(nonatomic,copy)NSString *headerURL;
@property(nonatomic,copy)NSString *createName;

@end
