//
//  HomePagePost.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/1.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimerModel.h"
//#import "AllMapModel.h"
@interface HomePagePost : NSObject
@property(nonatomic,strong) TimerModel * timermodel;
//@property(nonatomic,strong) AllMapModel * mapmodel;

/**
 上班是否随机拍照
 
 @return <#return value description#>
 */
+(BOOL)photoRate;


/**
 处理下载的数据
 
 @param deviceDict 设备数据
 @param itemDict 项目数据
 */
+(void)downLoad_deviceDict:(NSDictionary *)deviceDict itemDict:(NSDictionary *)itemDict;


/**
 根据当前时间  判断出当前可选择的班次
 
 @param shiftArray 全部班次
 @return <#return value description#>
 */
+(NSArray *)shiftArrayFromTime:(NSArray *)shiftArray;


/**
 获取当前时间显示在上班按钮上
 */
+(NSString *)checkTextGet;


/**
 下班处理数据
 */
-(void)checkoutRemoveModel;


@end
