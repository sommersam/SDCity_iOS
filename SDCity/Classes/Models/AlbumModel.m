

//
//  AlbumModel.m
//  SDCity
//
//  Created by wangweidong on 2017/12/21.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "AlbumModel.h"

@implementation AlbumModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        _albumId = (NSString *)value;
    }
}


@end
