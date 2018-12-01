//
//  AlbumModel.h
//  SDCity
//
//  Created by wangweidong on 2017/12/21.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumModel : NSObject

//AlbumModel是图墙的Model
@property(nonatomic,copy)NSString *albumId;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *imgurl;
@property(nonatomic,copy)NSNumber *createtime;
@property(nonatomic,copy)NSString *createid;
@property(nonatomic,copy)NSString *details;
@property(nonatomic,copy)NSString *createName;

//用来判断图片是否已经加载成功了
@property (nonatomic , assign) BOOL isLoad;

@end
