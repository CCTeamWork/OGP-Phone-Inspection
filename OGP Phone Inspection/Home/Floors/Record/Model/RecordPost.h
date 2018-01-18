//
//  RecordPost.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/13.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordPost : NSObject


/**
 记录时间过长  删除数据
 */
-(void)isLongTime;


/**
 删除设备类型 （设备  项目  流）
 
 @param dict 记录数据
 */
-(void)deleteDeviceType:(NSDictionary *)dict itemsdict:(NSDictionary *)itemsdict;

/**
 根据类型显示文字类型
 */
+(NSString *)recordTypeString:(NSString *)recordType;
/**
 根据类型显示文字类型
 */
+(UIColor *)recordTypeColor:(NSString *)recordType;
@end
