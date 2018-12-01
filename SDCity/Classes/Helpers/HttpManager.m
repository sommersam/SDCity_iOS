//
//  HttpManager.m
//  SDCity
//
//  Created by wangweidong on 2017/12/19.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "HttpManager.h"
#import "TopicModel.h"
#import "AlbumModel.h"
#import "TopicReplyModel.h"
#import "BlogModel.h"
#import "MessageModel.h"
#import "UserManager.h"
#import "AFNetworking.h"
@implementation HttpManager

#pragma mark ---- 用户登录 ----
+(void)userLoginActionWithAccount:(NSString *)account password:(NSString *)password  andHandle:(void (^)(NSString *error,NSDictionary * result))handle{
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                     @"account":account,
                                                                                     @"password":password
                                                                                     }];
    
    NSDictionary *requireParams = [SDUtils returnTokenString];
    NSMutableDictionary *fullParams = [NSMutableDictionary dictionary];
    [fullParams addEntriesFromDictionary:paramsDic];
    if (requireParams){
        [fullParams addEntriesFromDictionary:requireParams];
    }
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",KmainURL,@"/Api/user/login.json"] parameters:fullParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (nil != responseObject&&[responseObject isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *responseDic = [NSMutableDictionary dictionary];
            NSLog(@"%@",responseObject);
            responseDic  = responseObject;
            if ([responseDic[@"code"] intValue] == 200) {
                [[NSUserDefaults standardUserDefaults] setObject:account forKey:UserAccount];
                [[NSUserDefaults standardUserDefaults] setObject:password  forKey:UserPassword];
                [[UserManager standardUserManager] setValuesForKeysWithDictionary:responseDic[@"data"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:ChangeUserInfoNotification object:nil];
                handle(nil,responseDic);
            }else if ([responseDic[@"code"] intValue] == 1001){
                handle(nil,responseDic);
            }else if ([responseDic[@"code"] intValue] == -1){
                handle(nil,responseDic);
            }else{
                handle(@"服务器错误",nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        handle(@"请求错误",nil);
    }];
}


#pragma mark ---- 用户注册 ----
+(void)userRegisterActionWithAccount:(NSString *)account password:(NSString *)password repassword:(NSString *)repassword name:(NSString *)name email:(NSString *)email address:(NSString *)address phone:(NSString *)phone headerimg:(UIImage *)headerimg andHandle:(void (^)(NSString *error,NSDictionary * result))handle{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         
                                                         @"text/html",
                                                         
                                                         @"image/jpeg",
                                                         
                                                         @"image/png",
                                                         
                                                         @"application/octet-stream",
                                                         
                                                         @"text/json",
                                                         
                                                         nil];
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                     @"account":account,
                                                                                     @"password":password,
                                                                                     @"repassword":repassword,
                                                                                     @"name":name
                                                                                     }];

    if (email != nil) {
        [paramsDic setValue:email forKey:@"email"];
    }
    if (address != nil) {
        [paramsDic setValue:address forKey:@"address"];
    }
    if (phone != nil) {
        [paramsDic setValue:phone forKey:@"phone"];
    }
    NSDictionary *requireParams = [SDUtils returnTokenString];
    NSMutableDictionary *fullParams = [NSMutableDictionary dictionary];
    [fullParams addEntriesFromDictionary:paramsDic];
    if (requireParams){
        [fullParams addEntriesFromDictionary:requireParams];
    }
    [manager POST:[NSString stringWithFormat:@"%@%@",KmainURL,@"/Api/user/register.json"] parameters:fullParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (headerimg != nil) {
            
            NSData *imageData =UIImageJPEGRepresentation(headerimg,1);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat =@"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            //上传的参数(上传图片，以文件流的格式)
            
            [formData appendPartWithFileData:imageData
             
                                        name:@"headerimg"
             
                                    fileName:fileName
             
                                    mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (nil != responseObject&&[responseObject isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *responseDic = [NSMutableDictionary dictionary];
            responseDic  = responseObject;
            if ([responseDic[@"code"] intValue] == 200) {
                handle(nil,responseDic);
            }else if ([responseDic[@"code"] intValue] == 1008){
                handle(nil,responseDic);
            }else if ([responseDic[@"code"] intValue] == -1){
                handle(nil,responseDic);
            }else{
                handle(@"服务器错误",nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        handle(@"请求错误",nil);
    }];
}

//修改用户密码
+(void)changeUserPassWordActionWithUserId:(NSString *)userId oldpassword:(NSString *)oldpassword newpassword:(NSString *)newpassword andHandle:(void (^)(NSString *error,NSDictionary * result))handle{
    
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                     @"userId":userId,
                                                                                     @"oldpassword":oldpassword,
                                                                                     @"newpassword":newpassword
                                                                                     }];
    
    [SDUtils asyncWithQueryString:@"/Api/user/changePassword.json" params:paramsDic isPost:YES completionHandler:^(NSDictionary *result, NSString *error) {
        
        if ([result[@"code"] intValue] == 200) {
            
            handle(nil,result);
        }else{
            
            handle(error,nil);
        }
    }];

}

//获取用户信息
+(void)getUserInfoActionWithUserId:(NSString *)userId andHandle:(void (^)(NSString *error,NSDictionary * result))handle{
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                     @"userId":userId
                                                                                     }];
    
    NSDictionary *requireParams = [SDUtils returnTokenString];
    NSMutableDictionary *fullParams = [NSMutableDictionary dictionary];
    [fullParams addEntriesFromDictionary:paramsDic];
    if (requireParams){
        [fullParams addEntriesFromDictionary:requireParams];
    }
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",KmainURL,@"/Api/user/getUserInfo.json"] parameters:fullParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (nil != responseObject&&[responseObject isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *responseDic = [NSMutableDictionary dictionary];
            
            responseDic  = responseObject;
            if ([responseDic[@"code"] intValue] == 200) {
                [[UserManager standardUserManager] setValuesForKeysWithDictionary:responseDic[@"data"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:ChangeUserInfoNotification object:nil];
                handle(nil,responseDic);
            }else{
                handle(@"获取错误",nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        handle(@"请求错误",nil);
    }];
    
}


#pragma mark ---- 修改用户信息 ----
+(void)userUpdateInfoActionWithUserId:(NSString *)userId name:(NSString *)name email:(NSString *)email address:(NSString *)address phone:(NSString *)phone headerimg:(UIImage *)headerimg andHandle:(void (^)(NSString *error,NSDictionary * result))handle{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         
                                                         @"text/html",
                                                         
                                                         @"image/jpeg",
                                                         
                                                         @"image/png",
                                                         
                                                         @"application/octet-stream",
                                                         
                                                         @"text/json",
                                                         
                                                         nil];
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                     @"userId":userId,
                                                                                     @"name":name
                                                                                     }];
    
    if (email != nil) {
        [paramsDic setValue:email forKey:@"email"];
    }
    if (address != nil) {
        [paramsDic setValue:address forKey:@"address"];
    }
    if (phone != nil) {
        [paramsDic setValue:phone forKey:@"phone"];
    }
    NSDictionary *requireParams = [SDUtils returnTokenString];
    NSMutableDictionary *fullParams = [NSMutableDictionary dictionary];
    [fullParams addEntriesFromDictionary:paramsDic];
    if (requireParams){
        [fullParams addEntriesFromDictionary:requireParams];
    }
    [manager POST:[NSString stringWithFormat:@"%@%@",KmainURL,@"/Api/user/updataUserInfo.json"] parameters:fullParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (headerimg != nil) {
            
            NSData *imageData =UIImageJPEGRepresentation(headerimg,1);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat =@"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            //上传的参数(上传图片，以文件流的格式)
            
            [formData appendPartWithFileData:imageData
             
                                        name:@"headerimg"
             
                                    fileName:fileName
             
                                    mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (nil != responseObject&&[responseObject isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *responseDic = [NSMutableDictionary dictionary];
            responseDic  = responseObject;
            if ([responseDic[@"code"] intValue] == 200) {
                handle(nil,responseDic);
            }else if ([responseDic[@"code"] intValue] == 1008){
                handle(nil,responseDic);
            }else if ([responseDic[@"code"] intValue] == -1){
                handle(nil,responseDic);
            }else{
                handle(@"服务器错误",nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        handle(@"请求错误",nil);
    }];
    
}


#pragma mark ---- 获取用户消息未读消息数量 ----
+(void)getMessageNumberWithUserId:(NSString *)userId andHandle:(void (^)(NSString *error,NSDictionary * result))handle{
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                     @"userId":userId
                                                                                     }];
    
    [SDUtils asyncWithQueryString:@"/Api/user/replyNumber.json" params:paramsDic isPost:NO completionHandler:^(NSDictionary *result, NSString *error) {
        
        if ([result[@"code"] intValue] == 200) {
            handle(nil,result);
            [UserManager standardUserManager].messageNumber = result[@"number"];
        }else{
            handle(error,nil);
        }
    }];
}


#pragma mark ---- 获取用户消息列表 ----
+(void)getMessageListWithUserId:(NSString *)userId curPage:(int)curPage pageSize:(int)pageSize andHandle:(void (^)(NSString *error,NSArray <MessageModel*>*listArray))handle{
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                     @"userId":userId,
                                                                                     @"curPage":@(curPage),
                                                                                     @"pageSize":@(pageSize)
                                                                                     }];
    
    [SDUtils asyncWithQueryString:@"/Api/user/replyList.json" params:paramsDic isPost:NO completionHandler:^(NSDictionary *result, NSString *error) {
        NSLog(@"%@",result);
        if ([result[@"code"] intValue] == 200) {
            
            NSMutableArray *listArray = [NSMutableArray arrayWithCapacity:16];
            for (NSDictionary *obj in result[@"data"]) {
                
                MessageModel *model = [[MessageModel alloc]init];
                [model setValuesForKeysWithDictionary:obj];
                [listArray addObject:model];
            }
            handle(nil,listArray);
        }else{
            
            handle(error,nil);
        }
    }];
}



#pragma mark ---- 获取话题列表信息 ----
+(void)getTopicListWithCurPage:(int)curPage pageSize:(int)pageSize andHandle:(void (^)(NSString *error,NSArray <TopicModel*>*listArray))handle{
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                     @"curPage":@(curPage),
                                                                                     @"pageSize":@(pageSize)
                                                                                     }];
    
    [SDUtils asyncWithQueryString:@"/Api/topic/topicList.json" params:paramsDic isPost:NO completionHandler:^(NSDictionary *result, NSString *error) {
        
        if ([result[@"code"] intValue] == 200) {
            
            NSMutableArray *listArray = [NSMutableArray arrayWithCapacity:16];
            for (NSDictionary *obj in result[@"data"]) {
                
                TopicModel *model = [[TopicModel alloc]init];
                [model setValuesForKeysWithDictionary:obj];
                [listArray addObject:model];
            }
            handle(nil,listArray);
        }else{
            
            handle(error,nil);
        }
    }];
}

#pragma mark ---- 获取某个话题的详细内容 ----
+(void)getTopicDetailsWithTopicId:(NSString *)topicId userId:(NSString *)userId andHandle:(void (^)(NSString *error,TopicModel* model))handle{
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                     @"topicId":topicId,
                                                                                     @"userId":userId
                                                                                     }];
    
    [SDUtils asyncWithQueryString:@"/Api/topic/topicDetails.json" params:paramsDic isPost:NO completionHandler:^(NSDictionary *result, NSString *error) {
        NSLog(@"%@",result);
        if ([result[@"code"] intValue] == 200) {
            
            TopicModel *model = [[TopicModel alloc]init];
            [model setValuesForKeysWithDictionary:result[@"data"]];
            handle(nil,model);
        }else{
            
            handle(error,nil);
        }
    }];
    
    
    
}


#pragma mark ---- 获取某个话题的回复列表 ----
+(void)getTopicReplyListWithTopicId:(NSString *)topicId curPage:(int)curPage pageSize:(int)pageSize andHandle:(void (^)(NSString *error,NSArray <TopicReplyModel*>*listArray))handle{
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                     @"topicid":topicId,
                                                                                     @"curPage":@(curPage),
                                                                                     @"pageSize":@(pageSize)
                                                                                     }];
    
    [SDUtils asyncWithQueryString:@"/Api/topic/topicReplyList.json" params:paramsDic isPost:NO completionHandler:^(NSDictionary *result, NSString *error) {
        
        if ([result[@"code"] intValue] == 200) {
            
            NSMutableArray *listArray = [NSMutableArray arrayWithCapacity:16];
            for (NSDictionary *obj in result[@"data"]) {
                
                TopicReplyModel *model = [[TopicReplyModel alloc]init];
                [model setValuesForKeysWithDictionary:obj];
                [listArray addObject:model];
            }
            handle(nil,listArray);
        }else{
            
            handle(error,nil);
        }
    }];
}

#pragma mark ---- 新增一个话题 ----
+(void)sendTopicWithUserId:(NSString *)userId title:(NSString *)title contect:(NSString *)contect label:(NSString *)label andHandle:(void (^)(NSString *error,NSDictionary * result))handle{
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                     @"title":title,
                                                                                     @"userId":userId,
                                                                                     @"contect":contect,
                                                                                     @"label":label
                                                                                     }];
    
    [SDUtils asyncWithQueryString:@"/Api/topic/addTopic.json" params:paramsDic isPost:YES completionHandler:^(NSDictionary *result, NSString *error) {
        
        if ([result[@"code"] intValue] == 200) {
            handle(nil,result);
        }else{
            handle(error,nil);
        }
    }];
}


#pragma mark ---- 发送一条回复 ----
+(void)sendTopicReplyWithTopicId:(NSString *)topicId userId:(NSString *)userId replyId:(NSString *)replyId content:(NSString *)content andHandle:(void (^)(NSString *error,NSDictionary * result))handle{
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                     @"topicId":topicId,
                                                                                     @"userId":userId,
                                                                                     @"replyId":replyId,
                                                                                     @"content":content
                                                                                     }];
    
    [SDUtils asyncWithQueryString:@"/Api/topic/addReply.json" params:paramsDic isPost:YES completionHandler:^(NSDictionary *result, NSString *error) {
        
        if ([result[@"code"] intValue] == 200) {
            handle(nil,result);
        }else{
            handle(error,nil);
        }
    }];
}




#pragma mark ---- 获取图册列表 ----
+(void)getAlbumListWithCurPage:(int)curPage pageSize:(int)pageSize andHandle:(void (^)(NSString *error,NSArray <AlbumModel*>*listArray))handle{
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                     @"curPage":@(curPage),
                                                                                     @"pageSize":@(pageSize)
                                                                                     }];
    
    [SDUtils asyncWithQueryString:@"/Api/album/albumPagesList.json" params:paramsDic isPost:NO completionHandler:^(NSDictionary *result, NSString *error) {
        
        if ([result[@"code"] intValue] == 200) {
            
            NSMutableArray *listArray = [NSMutableArray arrayWithCapacity:16];
            for (NSDictionary *obj in result[@"data"]) {
                
                AlbumModel *model = [[AlbumModel alloc]init];
                model.isLoad = NO;
                [model setValuesForKeysWithDictionary:obj];
                [listArray addObject:model];
            }
            handle(nil,listArray);
        }else{
            
            handle(error,nil);
        }
    }];
}


#pragma mark ---- 新增一个图片 ----
+(void)addPhotoWithUserId:(NSString *)userId title:(NSString *)title details:(NSString *)details image:(UIImage *)image andHandle:(void (^)(NSString *error,NSDictionary * result))handle{
    

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         
                                                         @"text/html",
                                                         
                                                         @"image/jpeg",
                                                         
                                                         @"image/png",
                                                         
                                                         @"application/octet-stream",
                                                         
                                                         @"text/json",
                                                         
                                                         nil];
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                     @"userId":userId,
                                                                                     @"title":title,
                                                                                     @"details":details
                                                                                     }];
    
    NSDictionary *requireParams = [SDUtils returnTokenString];
    NSMutableDictionary *fullParams = [NSMutableDictionary dictionary];
    [fullParams addEntriesFromDictionary:paramsDic];
    if (requireParams){
        [fullParams addEntriesFromDictionary:requireParams];
    }
    [manager POST:[NSString stringWithFormat:@"%@%@",KmainURL,@"/Api/album/addPhoto.json"] parameters:fullParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (image != nil) {
            
            NSData *imageData =UIImageJPEGRepresentation(image,1);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat =@"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            //上传的参数(上传图片，以文件流的格式)
            
            [formData appendPartWithFileData:imageData
             
                                        name:@"image"
             
                                    fileName:fileName
             
                                    mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (nil != responseObject&&[responseObject isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *responseDic = [NSMutableDictionary dictionary];
            responseDic  = responseObject;
            if ([responseDic[@"code"] intValue] == 200) {
                handle(nil,responseDic);
            }else{
                handle(@"传输失败错误",nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        handle(@"请求错误",nil);
    }];
    
    
    
}

#pragma mark ---- 获取博客列表 ----
+(void)getBlogListWithCurPage:(int)curPage pageSize:(int)pageSize andHandle:(void (^)(NSString *error,NSArray <BlogModel*>*listArray))handle{
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                     @"curPage":@(curPage),
                                                                                     @"pageSize":@(pageSize)
                                                                                     }];
    
    [SDUtils asyncWithQueryString:@"/Api/blog/blogList.json" params:paramsDic isPost:NO completionHandler:^(NSDictionary *result, NSString *error) {
        
        if ([result[@"code"] intValue] == 200) {
            NSLog(@"%@",result);
            NSMutableArray *listArray = [NSMutableArray arrayWithCapacity:16];
            for (NSDictionary *obj in result[@"data"]) {
                
                BlogModel *model = [[BlogModel alloc]init];
                [model setValuesForKeysWithDictionary:obj];
                [listArray addObject:model];
            }
            handle(nil,listArray);
        }else{
            
            handle(error,nil);
        }
    }];
    
}

#pragma mark ---- 根据某个ID获取某一篇博客 ----
+(void)getBlogModelWithBlogId:(NSString *)blogId andHandle:(void (^)(NSString *error,BlogModel*blogModel))handle{
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                     @"blogid":blogId
                                                                                     }];
    
    [SDUtils asyncWithQueryString:@"/Api/blog/blogDetail.json" params:paramsDic isPost:NO completionHandler:^(NSDictionary *result, NSString *error) {
        
        if ([result[@"code"] intValue] == 200) {
            
            BlogModel *model = [[BlogModel alloc]init];
            [model setValuesForKeysWithDictionary:result[@"data"]];
            handle(nil,model);
        }else{
            
            handle(error,nil);
        }
    }];
    
}




@end
