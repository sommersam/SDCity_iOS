//
//  HttpManager.h
//  SDCity
//
//  Created by wangweidong on 2017/12/19.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"

@class TopicModel;
@class TopicReplyModel;
@class AlbumModel;
@class BlogModel;
@class MessageModel;

@interface HttpManager : NSObject

#pragma mark ---- 用户相关 ----
//用户登录
+(void)userLoginActionWithAccount:(NSString *)account password:(NSString *)password  andHandle:(void (^)(NSString *error,NSDictionary * result))handle;

//用户注册
+(void)userRegisterActionWithAccount:(NSString *)account password:(NSString *)password repassword:(NSString *)repassword name:(NSString *)name email:(NSString *)email address:(NSString *)address phone:(NSString *)phone headerimg:(UIImage *)headerimg andHandle:(void (^)(NSString *error,NSDictionary * result))handle;

//修改用户密码
+(void)changeUserPassWordActionWithUserId:(NSString *)userId oldpassword:(NSString *)oldpassword newpassword:(NSString *)newpassword andHandle:(void (^)(NSString *error,NSDictionary * result))handle;

//获取用户信息
+(void)getUserInfoActionWithUserId:(NSString *)userId andHandle:(void (^)(NSString *error,NSDictionary * result))handle;

//修改用户信息
+(void)userUpdateInfoActionWithUserId:(NSString *)userId name:(NSString *)name email:(NSString *)email address:(NSString *)address phone:(NSString *)phone headerimg:(UIImage *)headerimg andHandle:(void (^)(NSString *error,NSDictionary * result))handle;

//获取用户消息未读消息数量
+(void)getMessageNumberWithUserId:(NSString *)userId andHandle:(void (^)(NSString *error,NSDictionary * result))handle;

//获取用户消息列表
+(void)getMessageListWithUserId:(NSString *)userId curPage:(int)curPage pageSize:(int)pageSize andHandle:(void (^)(NSString *error,NSArray <MessageModel*>*listArray))handle;


#pragma mark ---- 话题相关 ----
//获取话题列表信息
+(void)getTopicListWithCurPage:(int)curPage pageSize:(int)pageSize andHandle:(void (^)(NSString *error,NSArray <TopicModel*>*listArray))handle;

//获取某个话题的详细内容
+(void)getTopicDetailsWithTopicId:(NSString *)topicId userId:(NSString *)userId andHandle:(void (^)(NSString *error,TopicModel* model))handle;

//获取某个话题的回复列表
+(void)getTopicReplyListWithTopicId:(NSString *)topicId curPage:(int)curPage pageSize:(int)pageSize andHandle:(void (^)(NSString *error,NSArray <TopicReplyModel*>*listArray))handle;

//新增一个话题
+(void)sendTopicWithUserId:(NSString *)userId title:(NSString *)title contect:(NSString *)contect label:(NSString *)label andHandle:(void (^)(NSString *error,NSDictionary * result))handle;

//发送一条回复
+(void)sendTopicReplyWithTopicId:(NSString *)topicId userId:(NSString *)userId replyId:(NSString *)replyId content:(NSString *)content andHandle:(void (^)(NSString *error,NSDictionary * result))handle;

#pragma mark ---- 图册相关 ----
//获取图册列表
+(void)getAlbumListWithCurPage:(int)curPage pageSize:(int)pageSize andHandle:(void (^)(NSString *error,NSArray <AlbumModel*>*listArray))handle;

//新增一个图片
+(void)addPhotoWithUserId:(NSString *)userId title:(NSString *)title details:(NSString *)details image:(UIImage *)image andHandle:(void (^)(NSString *error,NSDictionary * result))handle;

#pragma mark ---- 博客相关 ----
//获取博客列表
+(void)getBlogListWithCurPage:(int)curPage pageSize:(int)pageSize andHandle:(void (^)(NSString *error,NSArray <BlogModel*>*listArray))handle;

//根据某个ID获取某一篇博客
+(void)getBlogModelWithBlogId:(NSString *)blogId andHandle:(void (^)(NSString *error,BlogModel*blogModel))handle;


@end
