//
//  ScanCodePost.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/5.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceModel.h"
#import <CommonCrypto/CommonDigest.h>
@class DevicePost;
@interface ScanCodePost : NSObject

@property(nonatomic,strong) NSString * qrMD5Str;
@property(nonatomic,strong) NSString * qrBackStr;
@property(nonatomic,strong) DeviceModel * device;
@property(nonatomic,strong) DevicePost * devicepost;
/**
 是否需要拍照

 @return <#return value description#>
 */
-(BOOL)photoRate;

/**
 <#Description#>

 @param QRCodeTime <#QRCodeTime description#>
 @param pickerTime <#pickerTime description#>
 @return <#return value description#>
 */
-(int)timeLitleTime:(NSString *)QRCodeTime pickerTime:(NSString *)pickerTime;

/**
 验证扫描得到的二维码

 @param qrCodestr 二维码
 @return <#return value description#>
 */
-(NSString *)qrCodeStr:(NSString *)qrCodestr;

/**
 主页二维码      是否在当前班次的所有计划中
 
 @param deviceDict 设备信息
 @return 是否
 */
-(NSArray *)isShiftSch:(NSDictionary *)deviceDict qrstring:(NSString *)qrstring;
/**
 设备页的二维码
 
 @param deviceDict 设备字典
 @param qrstring 二维码
 @return 当前制作好的计划和制作好的设备
 */
-(NSArray *)isTouchSch:(NSDictionary *)deviceDict qrstring:(NSString *)qrstring;

/**
 设备符合   制作将要使用的设备
 
 @param device 设备表中查询的设备
 @return 完成的设备
 */
-(NSDictionary *)makeDeviceDict:(NSDictionary *)device;

/**
 获取设备信息    档案中的所有设备
 
 @param qrString <#qrString description#>
 */
-(NSDictionary *)qrStrDeviceFromAll:(NSString *)qrString;
@end
