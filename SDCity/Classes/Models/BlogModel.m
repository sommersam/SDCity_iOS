//
//  BlogModel.m
//  SDCity
//
//  Created by wangweidong on 2017/12/26.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "BlogModel.h"

@implementation BlogModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        _blogId = (NSString *)value;
    }
}


@end
