//
//  ToolModel.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/4.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolModel : NSObject

@property(nonatomic,assign) int k;

+(BOOL)isLineFirst;

+(NSString *) getAppBundleVersion;

+(NSString *) getAppVersion;

+(NSString *) getAppName;

+(NSString *)currentLanguage;

+(NSString *)achieveNowTime;
//   获取当前星期
+(NSString *)getWeekNow;

+(long)achieveIntervalSinceNow;
//   根据当前时区 转换为当前时间
+(NSDate *)timeFromZone:(NSDate *)date;

+(NSString *)allHourMinToMonDay:(NSString *)dateTime;

+(NSString*) uuid;

+ (NSString *)getDeviceId;

//+(NSDictionary *)loginDict;
+ (UIImage *)drawLinearGradient;
//+(int)walkCount;
//+(int)offline;

+ (NSString *)getCurrentDeviceModel;

//+(BOOL)textFieldKeepNo:(NSString *)str;
+(int)max:(NSDate *)datatime;

+(void)firstAddHost;
+(NSDictionary *)loginMessage;
+(NSDictionary *)loginBack;
// 删除沙盒里的图片
+(void)deleteFile:(NSString *)strpath;
/**
 将图片保存到沙盒中
 
 @param imageData 要保存的图片
 @return 成功或者失败
 */
+(NSString *)saveImage:(NSData *)imageData;
///通过运行时获取当前对象的所有属性的名称，以数组的形式返回
+ (NSArray *) allPropertyNames:(id)projectClass;

+ (NSArray *) allPropertyAttributes:(id)projectClass;
@end
