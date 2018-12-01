//
//  MessageModel.h
//  SDCity
//
//  Created by wangweidong on 2018/1/3.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

//MessageModel 是我的消息对应的Model]

@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *createid;
@property(nonatomic,copy)NSNumber *createtime;
@property(nonatomic,copy)NSString *topicid;
@property(nonatomic,copy)NSString *replyid;
@property(nonatomic,copy)NSNumber *isread;
@property(nonatomic,copy)NSString *createName;
@property(nonatomic,copy)NSString *replyName;
@property(nonatomic,copy)NSString *headerURL;
@property(nonatomic,copy)NSString *topicName;

@end
