//
//  UserManager.h
//  SDCity
//
//  Created by wangweidong on 2017/12/22.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManager : NSObject

//UserManager是用户管理的单例
+(instancetype)standardUserManager;

@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *roleName;
@property(nonatomic,copy)NSString *headerURL;
@property(nonatomic,copy)NSNumber *createTime;
@property(nonatomic,copy)NSString *email;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *address;

@property(nonatomic,copy)NSString *messageNumber;//消息数量

@property(nonatomic,assign)int grade;//用户等级,根据创建时间来转换

//清除用户信息
+(void)clearUserInfo;

@end
