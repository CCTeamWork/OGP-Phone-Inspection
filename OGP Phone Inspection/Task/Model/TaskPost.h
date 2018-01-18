//
//  TaskPost.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/1.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShiftModel.h"
@interface TaskPost : NSObject

/**
 查询符合班次的计划

 @param array 所有计划
 @return 符合条件的计划
 */
+(NSMutableArray *)getIsShiftTask:(NSArray *)array shift:(NSDictionary *)dict;

/**
 判断计划是否在工作日内
 
 @param taskArray 符合班次的计划
 @return 符合班次和工作日的计划
 */
+(NSArray *)taskWorkDay:(NSArray *)taskArray;

/**
 将HH:mm   转换成   YYYY-MM-dd HH:mm
 
 @param dateTime 合成当前日期＋时间
 */
+(NSDate *)hourMinToMonDay:(NSString *)dateTime;

/**
 判断跨天的计划是否在班次内
 @param endtime 结束时间
 @return 计算后的结束时间
 */
+(NSDate *)isNotToday:(NSDate *)endtime;


/**
 同步功能   需要上传的信息
 
 @param schDict 需要同步的特殊计划信息
 @return <#return value description#>
 */
+(NSDictionary *)otherTaskFromOther:(NSDictionary *)schDict;

/**
 同步特殊任务进度完成
 
 @param schDcit 计划数据
 @param otherArray 同步得到的数据
 */
+(void)otherTaskGetFinish:(NSDictionary *)schDcit getOtherArray:(NSArray *)otherArray;

/**
 计算出特殊计划的开始和结束  日期+时间
 
 @param schDict 当前特殊计划
 */
+(NSMutableDictionary *)otherTaskStartAndEndTime:(NSDictionary *)schDict;

/**
 获取班次下的计划数据
 
 @param kind 判断上一个班次还是下一个班次
 */
+(void)lastOrNextShiftSchArray:(int)kind;
@end
