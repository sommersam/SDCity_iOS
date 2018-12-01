//
//  MessageModel.m
//  SDCity
//
//  Created by wangweidong on 2018/1/3.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        _ID = (NSString *)value;
    }
}


@end
