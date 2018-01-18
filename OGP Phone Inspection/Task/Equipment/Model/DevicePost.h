//
//  DevicePost.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/4.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceModel.h"
#import "ScanCodePost.h"
@interface DevicePost : NSObject

@property(nonatomic,strong) DeviceModel * device;
@property(nonatomic,strong) ScanCodePost * scanpost;

/**
 查找计划下设备数据

 @param sitedict 计划设备对应表
 @return <#return value description#>
 */
-(NSArray *)device_sitedict:(NSDictionary *)sitedict;

/**
 判断是否已经查询出来的计划
 
 @param sitedict 计划对应线路表
 @return <#return value description#>
 */
-(NSArray *)deviceDidUser_sitedict:(NSDictionary *)sitedict;


/**
 更新当前班次设备数据
 
 @param sitedict 线路字典
 @param devicedict 设备字典
 @param key 要改变的字段
 */
-(void)updateDeviceArray:(NSDictionary *)sitedict deviceDic:(NSDictionary *)devicedict key:(NSString *)key value:(NSString *)value;

/**
 判断是不是按顺序巡检
 
 @param deviceArr 当前计划下的所有设备
 @return <#return value description#>
 */
-(BOOL)deviceIsSequence:(NSArray *)deviceArr touchDict:(NSDictionary *)touchDict sequence_type:(int)type;

/**
 判断是否可以进行巡检（是否按顺序   是否是未进行巡检的特殊计划）
 
 @param deviceDict 当前点击的设备信息
 @return 是否可以跳转
 */
-(BOOL)isPushProjectController:(NSDictionary *)deviceDict allDeviceArray:(NSArray *)allDeviceArray touchSchdict:(NSDictionary *)touchSchdict;

/**
 是否需要防作弊拍照
 
 @param deviceDict 当前点击的设备信息
 @return 是否可以跳转
 */
-(BOOL)isPushPickerViewController:(NSDictionary *)deviceDict schDict:(NSDictionary *)schDict generateType:(int)generateType;
@end
