//
//  TopicModel.h
//  SDCity
//
//  Created by wangweidong on 2017/12/19.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicModel : NSObject

//TopicModel是话题的Model

@property(nonatomic,copy)NSString *topicId;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *contect;
@property(nonatomic,copy)NSString *imgURL;
@property(nonatomic,copy)NSString *headerURL;
@property(nonatomic,copy)NSString *label;
@property(nonatomic,copy)NSNumber *createtime;
@property(nonatomic,copy)NSString *createId;
@property(nonatomic,copy)NSString *createName;


@end
