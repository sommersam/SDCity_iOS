//
//  SDUtils.m
//  Starrunning
//
//  Created by luying on 2017/5/10.
//  Copyright © 2017年 Dong. All rights reserved.
//

#import "SDUtils.h"
#import "AFNetworking.h"
#import "AFNetworkReachabilityManager.h"

#import <CommonCrypto/CommonDigest.h>

@implementation SDUtils

+ (UIColor *)hexStringToColor:(NSString *)stringToConvert {
    NSString *cString = [[stringToConvert
                          stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
        return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor blackColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:1.0f];
}


+(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+(NSDictionary  *)returnTokenString{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%0.0f", a];
    NSString *md5String = [SDUtils md5:[NSString stringWithFormat:@"%@%@",@"YIDAIYILU$SILUYUN$WANNACRY",timeString]];
    
    
    return @{
             @"client":@"1",
             @"imei":MyUUID,
             @"token":md5String,
             @"timestamp":timeString
             };

}

+(NSString*) uuid{
    
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}


+(NSString *) md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)compareCurrentTime:(NSString *)dateTimeStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateTime=[dateFormatter dateFromString:dateTimeStr];
    long dateTimeLong=[dateTime timeIntervalSince1970];
    NSDate *compareDate =
    [[NSDate alloc] initWithTimeIntervalSince1970:dateTimeLong];
    NSTimeInterval timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if ((temp = timeInterval / 60) < 60) {
        result = [NSString stringWithFormat:@"%ld分钟前", temp];
    }
    
    else if ((temp = temp / 60) < 24) {
        result = [NSString stringWithFormat:@"%ld小时前", temp];
    }else{
        result=[dateTimeStr substringToIndex:10];
    }
    
    return result;
}



+(void)asyncWithQueryString:(NSString *)query
                      params:(NSDictionary *)params
                      isPost:(BOOL)ispost
           completionHandler:(void (^)(NSDictionary *result, NSString *error))handler {
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock: ^(AFNetworkReachabilityStatus status) {
        switch (status)
        {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:{
            
                if ([[NSUserDefaults standardUserDefaults] boolForKey:Suspended]) {
                    
                    [operationQueue setSuspended:YES];
                }else{
                    
                    [operationQueue setSuspended:NO];
                }
            
            }
                break;
        }
    }];
    
    [manager.reachabilityManager startMonitoring];
    NSDictionary *requireParams = [SDUtils returnTokenString];
    NSMutableDictionary *fullParams = [NSMutableDictionary dictionary];
    if (params)
        [fullParams addEntriesFromDictionary:params];
    if (requireParams)
        [fullParams addEntriesFromDictionary:requireParams];
    
    if (ispost)
    {
        
        [manager POST:[NSString stringWithFormat:@"%@%@",KmainURL,query] parameters:fullParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            NSLog(@"%@",responseObject);

            
            if (nil != responseObject&&[responseObject isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary *responseDic = [NSMutableDictionary dictionary];
                
                responseDic  = responseObject;
                
                
                
                if ([responseDic[@"code"] intValue] == 200) {
                    
                    if (handler){
                        handler(responseDic, nil);
                    }
                    
                }else{
                
                    if (handler){
                        handler(nil, [SDUtils hasError:[responseDic[@"code"] intValue]]);
                    }

                }
                
                
            }
 
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (handler){
                handler(nil, error.localizedDescription);
                
                NSLog(@"%@",error.localizedDescription);
            }
        }];

    }
    else
    {

        [manager GET:[NSString stringWithFormat:@"%@%@",KmainURL,query] parameters:fullParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (nil != responseObject &&[responseObject isKindOfClass:[NSDictionary class]]) {
                if ([responseObject[@"code"] intValue] == 200) {
                    
                    if (handler){
                        handler(responseObject, nil);
                    }
                    
                }else{
                    
                    if (handler){
                        handler(nil, [SDUtils hasError:[responseObject[@"code"] intValue]]);
                    }
                    
                }
                
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (handler){
                handler(nil, error.localizedDescription);
            }
        }];

    
    }
}


+(void)modifyUserInfo:(NSString *)uid avatar:(NSString *)avatar completionHandler:(void (^)(NSString * string))handler{
    NSDictionary *requireParams = [SDUtils returnTokenString];
    NSMutableDictionary *fullParams = [NSMutableDictionary dictionary];
    if (uid){
        [fullParams addEntriesFromDictionary:@{@"userId":uid}];
    }
    if (requireParams){
        [fullParams addEntriesFromDictionary:requireParams];
    }
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@",KmainURL,@"/user/modifyUserInfo.json"] parameters:fullParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(![SDUtils isBlankString:avatar])
        {
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:avatar] name:@"avatar" error:nil];
        }
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error)
        {
            handler(error.description);
        }
        else
        {
            int code = [[responseObject valueForKey:@"code"] intValue];
            if (code == 200)
            {
                if (handler){
                    handler(@"上传成功!");
                }
            }
        }
    }];
    
    [uploadTask resume];
    
}

+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:
          [NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

+(NSString *)hasError:(int )code {

    NSString *errormessage;
    
    switch (code) {
        case 301:
            errormessage = @"参数错误";
            break;
        case 302:
            errormessage = @"系统没有版本数据";
            break;
        case 401:
            errormessage = @"用户或密码错误";
            break;
        case 402:
            errormessage = @"手机号已注册";
            break;
        case 403:
            errormessage = @"用户已禁用";
            break;
        case 404:
            errormessage = @"用户密码错误";
            break;
        case 405:
            errormessage = @"找回密码，验证码错误";
            break;
        case 406:
            errormessage = @"用户注册，验证码错误";
            break;
        case 407:
            errormessage = @"用户绑定手机号，验证码错误";
            break;
        case 408:
            errormessage = @"用户不存在";
            break;
        case 501:
            errormessage = @"未知的服务端错误";
            break;
        case 601:
            errormessage = @"标签不存在";
            break;
        case 602:
            errormessage = @"标签状态不可显示";
            break;
        case 701:
            errormessage = @"内容不存在";
            break;
        case 702:
            errormessage = @"内容已下线";
            break;
        case 703:
            errormessage = @"评论内容存在敏感词";
            break;
        default:
            errormessage = @"未知错误";
            break;
    }

    return errormessage;
}

#pragma mark ---- 字符串计算高度和宽度 ----

+(float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width{
    
    CGSize newSizeToFit = [value boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    return newSizeToFit.height;
}

+(float)widthForString:(NSString *)value fontSize:(float)fontSize andHight:(float)hight{
    
    CGSize newSizeToFit = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, hight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil].size;

    return newSizeToFit.width;
}

+(float)getSpaceLabelHeightWithFont:(UIFont*)font withWidth:(CGFloat)width withString:(NSAttributedString *)string{

    CGSize size = [string boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    return size.height;
}

#pragma mark ---- 关于时间的处理 ----

+(NSString *)compareNowWithDate:(NSTimeInterval)anotherDate{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:anotherDate/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    
    NSTimeInterval nowTimeInterval =[date timeIntervalSinceNow];
    nowTimeInterval = -nowTimeInterval;
    if (nowTimeInterval  < 60) {
        
        return @"刚刚";
        
    }
    
    //n分钟前
    if (nowTimeInterval> 60 &&nowTimeInterval < 3600) {
        return [NSString stringWithFormat:@"%d分钟前",(int)nowTimeInterval/(60)];
    }
    
    //n个小时前
    if (nowTimeInterval > 3600 &&nowTimeInterval < 3600*12) {
        return [NSString stringWithFormat:@"%d小时前",(int)nowTimeInterval/(3600)];
        
    }
    
    //n天前
    if (nowTimeInterval> 3600*12) {
        return [dateFormatter stringFromDate:date];
    }
    
    return @"";
}

#pragma mark ---- 图片处理 ----
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{

    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark ---- 字典转JSON字符串 ----
+(NSString *)convertToJsonData:(id)object{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutableString = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutableString replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutableString.length};
    
    //去掉字符串中的换行符
    
    [mutableString replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    NSLog(@"%@",mutableString);
    NSLog(@"%@",jsonString);
    return mutableString;
}


#pragma mark ---- 判断某个字符串是否为空或者为nil ----

+(BOOL)isEmptyWithTestString:(NSString *)textString{
    
    BOOL isEmpty = NO;
    if ([textString isEqualToString:@""] || textString == nil) {
        isEmpty = YES;
    }
    return isEmpty;
}

@end
