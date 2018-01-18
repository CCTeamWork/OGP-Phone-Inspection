//
//  ToolModel.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/4.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "ToolModel.h"
#import "SSKeychain.h"
#import <sys/utsname.h>
#import <objc/message.h>
#import "LoginModel.h"
@implementation ToolModel

//  获取当前语言
+(NSString *)currentLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = [languages objectAtIndex:0];
    return currentLang;
}
//返回应用程序名称
+(NSString *) getAppName{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleDisplayName"];
}
//返回应用版本号
+(NSString *) getAppVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

+(NSString *) getAppBundleVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleVersion"];
}
//  判断是不是第一次打开app
+(BOOL)isLineFirst
{
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"isLineFirst"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isLineFirst"];
        return YES;
    }
    return NO;
}
//   根据当前时区 转换为当前时间
+(NSDate *)timeFromZone:(NSDate *)date
{
    long stmptime = [date timeIntervalSince1970];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:stmptime];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    NSTimeInterval interval = [destinationTimeZone secondsFromGMT];
    NSDate * localDate = [detaildate dateByAddingTimeInterval:interval];
    return localDate;
}

//  获取当前时间
+(NSString *)achieveNowTime
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}
//   获取当前星期
+(NSString *)getWeekNow
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"EEEE"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}
//  获取当前时间戳
+(long)achieveIntervalSinceNow
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
    [dMatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *netDate = [dMatter dateFromString:timeString];
    long s = (long)[netDate timeIntervalSince1970];
    return s;
}

/**
 时间   －》    时间 ＋ 日期

 @param dateTime <#dateTime description#>
 @return <#return value description#>
 */
+(NSString *)allHourMinToMonDay:(NSString *)dateTime
{
    NSDate * date = [NSDate date];
    NSDateFormatter * input=[[NSDateFormatter alloc]init];
    [input setDateFormat:@"yyyy-MM-dd"];
    //   当前日期字符串
    NSString * dateStr =[input stringFromDate:date];
    //   组合成日期+时间
    NSString * locastring = [NSString stringWithFormat:@"%@ %@",dateStr,dateTime];
    //   转换成date
    [input setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate * finsihDate = [input dateFromString:locastring];
    
    //   根据时区  转换成当地时间
    long stmptime = [finsihDate timeIntervalSince1970];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:stmptime];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    NSTimeInterval interval = [destinationTimeZone secondsFromGMT];
    NSDate *localDate = [detaildate dateByAddingTimeInterval:interval];
    NSString * localStr = [input stringFromDate:localDate];
    
    return localStr;
}
//    生成当前唯一ID
+(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}
//   获取手机mark
+ (NSString *)getDeviceId
{
    NSString * currentDeviceUUIDStr = [SSKeychain passwordForService:@" " account:@"uuid"];
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""])
    {
        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
        [SSKeychain setPassword: currentDeviceUUIDStr forService:@" " account:@"uuid"];
    }
    return currentDeviceUUIDStr;
}
//+(int)walkCount
//{
//    [[WLHealthKitManage shareInstance] getRealTimeStepCountCompletionHandler:^(double value, NSError *error) {
//        if (error.code == 0) {
//            NSLog(@"-------当天步数-------%f",value);
//            [USERDEFAULT setObject:[NSNumber numberWithInt:value] forKey:WALK_COUNTS];
//        }
//        else{
//            NSLog(@"------未获取权限--------");
//        }
//    }];
//    return 0;
//}
//  判断两时间  时差
+(int)max:(NSDate *)datatime
{
    //创建日期格式化对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *  senddate=[NSDate date];
    NSString *  locationString=[dateFormatter stringFromDate:senddate];
    NSDate *date=[dateFormatter dateFromString:locationString];
    //取两个日期对象的时间间隔：
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
    NSTimeInterval time=[date timeIntervalSinceDate:datatime];
    int days=((int)time)/(3600*24);
    return days;
}

+ (UIImage *)drawLinearGradient {
    CGRect rect = CGRectMake(0, 0, WIDTH, 64);
    rect.size.height += 20;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0, 1.0};
    NSArray *colors = @[(__bridge id)[UIColor colorWithRed:227.0/255.0 green:45.0/255.0 blue:68.0/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:250.0/255.0 green:27.0/255.0 blue:46.0/255.0 alpha:1.0].CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    CGRect pathRect = CGPathGetBoundingBox(path.CGPath);
    
    CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMinY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}
//+(BOOL)textFieldKeepNo:(NSString *)str
//{
//    NSLog(@"str＝＝＝＝＝%@",str);
//    NSString * strr=@"^[\u4E00-\u9FA5A-Za-z0-9_]+$";
//    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",strr];
//    if ([regexPredicate evaluateWithObject:str]) {
//        return YES;
//    }
//    return NO;
//}
//获得设备型号
+ (NSString *)getCurrentDeviceModel
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])  return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])  return @"iPad Mini 2G";

    if ([platform isEqualToString:@"iPad4,6"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])   return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])  return @"iPhone Simulator";
    
    return platform;
    
}
//  如果是第一次安装    添加默认IP
+(void)firstAddHost
{
    NSMutableArray * array=[[NSMutableArray alloc]init];
    NSMutableDictionary * modic=[[NSMutableDictionary alloc]init];
    [modic setObject:@"RemoteHost" forKey:@"name"];
    [modic setObject:@"mp.hulianxungeng.com" forKey:@"ip"];
    [array addObject:modic];
    
    NSMutableDictionary * modic1=[[NSMutableDictionary alloc]init];
    [modic1 setObject:@"USAHost" forKey:@"name"];
    [modic1 setObject:@"appus.onlineguardpatrol.com" forKey:@"ip"];
    [array addObject:modic1];
    [USERDEFAULT setObject:array forKey:HOST_IP_ARRAY];

    if([[ToolModel currentLanguage] compare:@"zh-Hans-CN" options:NSCaseInsensitiveSearch]==NSOrderedSame || [[ToolModel currentLanguage] compare:@"zh-Hant-CN" options:NSCaseInsensitiveSearch]==NSOrderedSame)
    {
        [USERDEFAULT setObject:@"mp.hulianxungeng.com" forKey:HOST_IPING];
        [USERDEFAULT setObject:@(0)forKey:@"duihao"];
    }else{
        [USERDEFAULT setObject:@"appus.onlineguardpatrol.com" forKey:HOST_IPING];
        [USERDEFAULT setObject:@(1) forKey:@"duihao"];
    }
}
+(NSDictionary *)loginMessage
{
    NSDictionary * dict = [USERDEFAULT valueForKey:@"loginMessage"];
    return dict;
}
+(NSDictionary *)loginBack
{
    NSDictionary * dict = [USERDEFAULT valueForKey:@"loginBack"];
    
    return dict;
}
// 删除沙盒里的图片
+(void)deleteFile:(NSString *)strpath
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:strpath];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"没有可以删除的文件");
        return ;
    }else {
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"删除成功");
        }else {
            NSLog(@"删除失败");
        }
    }
}
/**
 将图片保存到沙盒中
 
 @param imageData 要保存的图片
 @return 成功或者失败
 */
+(NSString *)saveImage:(NSData *)imageData
{
    NSString * imagestr=[ToolModel achieveNowTime];
    UIImage *image = [UIImage imageWithData: imageData];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imagestr]];
    // 保存文件的名称
    BOOL result = [UIImagePNGRepresentation(image)writeToFile: filePath atomically:YES];
    if (result) {
        return imagestr;
    }
    else{
        return nil;
    }
}

///通过运行时获取当前对象的所有属性的名称，以数组的形式返回
+ (NSArray *) allPropertyNames:(id)projectClass{
    ///存储所有的属性名称
    NSMutableArray *allNames = [[NSMutableArray alloc] init];
    
    ///存储属性的个数
    unsigned int propertyCount = 0;
    
    ///通过运行时获取当前类的属性
    objc_property_t *propertys = class_copyPropertyList(projectClass, &propertyCount);
    
    //把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
        ///取出第一个属性
        objc_property_t property = propertys[i];
        
        const char * propertyName = property_getName(property);
        
        [allNames addObject:[NSString stringWithUTF8String:propertyName]];
    }
    
    ///释放
    free(propertys);
    
    return allNames;
}

+(NSArray *) allPropertyAttributes:(id)projectClass
{
    ///存储所有的属性名称
    NSMutableArray *allNames = [[NSMutableArray alloc] init];
    
    ///存储属性的个数
    unsigned int propertyCount = 0;
    
    ///通过运行时获取当前类的属性
    objc_property_t *propertys = class_copyPropertyList(projectClass, &propertyCount);
    
    //把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
        ///取出第一个属性
        objc_property_t property = propertys[i];
        
        const char * propertyName = property_getAttributes(property);
        
        NSString * typeString = [NSString stringWithUTF8String:propertyName];
        NSArray * attributes = [typeString componentsSeparatedByString:@","];
        NSString * typeAttribute = [attributes objectAtIndex:0];
        NSString * propertyType = [typeAttribute substringFromIndex:1];
        const char * rawPropertyType = [propertyType UTF8String];
        
        if (strcmp(rawPropertyType, @encode(double)) == 0) {
            [allNames addObject:@"double"];
        } else if (strcmp(rawPropertyType, @encode(NSInteger *)) == 0) {
            [allNames addObject:@"int"];
        }else if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1) {
            NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];  //turns
            Class typeClass = NSClassFromString(typeClassName);
            if (typeClass != nil) {
                if ([typeClass isSubclassOfClass:[NSString class]]) {
                    [allNames addObject:@"NSString"];
                }
            }  
        }else{
            NSLog(@"????");
        }
    }
    
    ///释放
    free(propertys);
    
    return allNames;
}
@end
