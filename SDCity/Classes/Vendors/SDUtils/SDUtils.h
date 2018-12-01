//
//  SDUtils.h
//  Starrunning
//
//  Created by luying on 2017/5/10.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SDUtils : NSObject

//SDUtils是一个辅助工具类,有着各种实用的类方法.

+(NSString*) uuid;
/*
 * 16进制颜色(html颜色值)字符串转为UIColor
 */
+ (UIColor *)hexStringToColor:(NSString *)stringToConvert;

//图片切圆
+(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset;


+(NSDictionary  *)returnTokenString;
/**
 网络封装方法

 @param query 请求路径
 @param params 具体请求参数,不需要加通用参数
 @param ispost 是否是post请求方式
 @param handler 请求返回结果
 */
+(void)asyncWithQueryString:(NSString *)query
                     params:(NSDictionary *)params
                     isPost:(BOOL)ispost
          completionHandler:(void (^)(NSDictionary *result, NSString *error))handler;
+(void)modifyUserInfo:(NSString *)uid avatar:(NSString *)avatar completionHandler:(void (^)(NSString *string))handler;

#pragma mark ---比较两个时间----
+ (NSString *)compareCurrentTime:(NSString *)dateTimeStr;


#pragma mark ---- 字符串计算高度和宽度 ----

+(float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;
+(float)widthForString:(NSString *)value fontSize:(float)fontSize andHight:(float)hight;
+(float)getSpaceLabelHeightWithFont:(UIFont*)font withWidth:(CGFloat)width withString:(NSAttributedString *)string;

#pragma mark ---- 关于时间的处理 ----
+(NSString *)compareNowWithDate:(NSTimeInterval)anotherDate;

#pragma mark ---- 图片处理 ----
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

#pragma mark ---- 字典转JSON字符串 ----
+(NSString *)convertToJsonData:(id)object;


#pragma mark ---- 判断某个字符串是否为空或者为nil ----

+(BOOL)isEmptyWithTestString:(NSString *)textString;


@end


//快速通知框
NS_INLINE void tipWithMessage(NSString *message,UIViewController *superVC){
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        [superVC presentViewController:alertVC animated:YES completion:nil];
        
        UIAlertAction *cancalAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:cancalAction];
        
        
    });
    
}
