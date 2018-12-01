//
//  BlogModel.h
//  SDCity
//
//  Created by wangweidong on 2017/12/26.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlogModel : NSObject

//BlogModel是博客的Model

@property(nonatomic,copy)NSString *blogId;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *createid;
@property(nonatomic,copy)NSNumber *createtime;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *markdownString;
@property(nonatomic,copy)NSString *categoryname;
@property(nonatomic,copy)NSString *createName;


@end
