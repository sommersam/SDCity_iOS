//
//  UserManager.m
//  SDCity
//
//  Created by wangweidong on 2017/12/22.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager

static UserManager * userManager = nil;
+(instancetype)standardUserManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (userManager == nil) {
            userManager = [[UserManager alloc]init];
        }
    });
    
    return userManager;
}

//清除用户信息
+(void)clearUserInfo{
    
    userManager = [[UserManager alloc]init];
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"roleName"]) {
        NSString *roleName = (NSString *)value;
        if ([roleName isEqualToString:@"普通用户"]) {
            _grade = 1;
        }else if ([roleName isEqualToString:@"博主"]){
            _grade = 3;
        }else{
            _grade = 6;
        }
    }

}

@end
