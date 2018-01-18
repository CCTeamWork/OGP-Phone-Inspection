//
//  TaskPost.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/1.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "TaskPost.h"
#import "TaskFromChooseTableViewCell.h"
#import "DataBaseManager.h"
#import "ScheduleModel.h"
@implementation TaskPost

/**
 查询符合班次的计划
 
 @param array 所有计划
 @return 符合条件的计划
 */
+(NSMutableArray *)getIsShiftTask:(NSArray *)array shift:(NSDictionary *)shiftDict
{
    NSMutableArray * mularray = [[NSMutableArray alloc]init];
    //   班次的开始时间和结束时间
    NSDate * shiftstart = [TaskPost hourMinToMonDay:shiftDict[@"working_hours"]];
    NSDate * shiftend = [TaskPost hourMinToMonDay:shiftDict[@"off_hours"]];
    //   如果结束时间小于开始时间   说明是垮台呢班次
    if (shiftend < shiftstart || shiftend == shiftstart) {
        shiftend = [TaskPost isNotToday:shiftend];
    }
    for (NSDictionary * dict in array) {
        if ([dict[@"sch_type"] intValue] == 0) {
            NSDate * starttime = [TaskPost hourMinToMonDay:dict[@"start_time"]];
            NSDate * endtime = [TaskPost hourMinToMonDay:dict[@"end_time"]];
            //    如果是结束时间小于开始时间  说明是跨天计划
            if (endtime < starttime || endtime == starttime) {
                endtime = [TaskPost isNotToday:endtime];
                if ([TaskPost compareDate:endtime endtime:starttime shiftstart:shiftstart shiftend:shiftend]) {
                    NSMutableDictionary * muldict = [NSMutableDictionary dictionaryWithDictionary:dict];
                    [muldict setObject:@(0) forKey:@"sch_state"];
                    [muldict setObject:@(0) forKey:@"sch_finish_number"];
                    [muldict setObject:@([shiftDict[@"shift_id"] intValue]) forKey:@"sch_shift_id"];
                    [mularray addObject:muldict];
                    break;
                }
            }
            if ([TaskPost compareDate:starttime endtime:endtime shiftstart:shiftstart shiftend:shiftend]) {
                NSMutableDictionary * muldict = [NSMutableDictionary dictionaryWithDictionary:dict];
                [muldict setObject:@(0) forKey:@"sch_state"];
                [muldict setObject:@(0) forKey:@"sch_finish_number"];
                [muldict setObject:@([shiftDict[@"shift_id"] intValue]) forKey:@"sch_shift_id"];
                [mularray addObject:muldict];
            }
        }else{
            NSMutableDictionary * muldict = [NSMutableDictionary dictionaryWithDictionary:dict];
            [muldict setObject:@(0) forKey:@"sch_state"];
            [muldict setObject:@(0) forKey:@"sch_finish_number"];
            [muldict setObject:@([shiftDict[@"shift_id"] intValue]) forKey:@"sch_shift_id"];
            [mularray addObject:muldict];
        }
    }
    //   为每条计划增加上传时使用的开始和结束时间
    for (NSMutableDictionary * mulDict in mularray) {
        if ([mulDict[@"sch_type"] intValue] == 0) {
            NSDate * starttime = [TaskPost hourMinToMonDay:mulDict[@"start_time"]];
            NSDate * endtime = [TaskPost hourMinToMonDay:mulDict[@"end_time"]];
            //    如果是结束时间小于开始时间  说明是跨天计划
            if (endtime < starttime) {
                endtime = [TaskPost isNotToday:endtime];
            }
            [mulDict setValue:starttime forKey:@"send_task_start_time"];
            [mulDict setValue:endtime forKey:@"send_task_end_time"];
        }
    }
    return mularray;
}

/**
 将HH:mm   转换成   YYYY-MM-dd HH:mm

 @param dateTime 合成当前日期＋时间
 */
+(NSDate *)hourMinToMonDay:(NSString *)dateTime
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
    NSDate * localDate = [detaildate dateByAddingTimeInterval:interval];
    return localDate;
}
/**
 判断跨天的计划是否在班次内
 @param endtime 结束时间
 @return 计算后的结束时间
 */
+(NSDate *)isNotToday:(NSDate *)endtime
{
    NSTimeInterval interval = 60 * 60 * 24;
    NSDate *detea = [NSDate dateWithTimeInterval:interval sinceDate:endtime];
    return detea;
}

/**
 对比时间

 @param starttime 计划开始时间
 @param endtime 计划结束时间
 @param shiftstart 班次开始时间
 @param shiftend 班次结束时间
 @return 是否符合
 */
+(BOOL)compareDate:(NSDate *)starttime endtime:(NSDate *)endtime shiftstart:(NSDate *)shiftstart shiftend:(NSDate *)shiftend
{
    NSComparisonResult result = [starttime compare:shiftstart];
    NSComparisonResult result1 = [starttime compare:shiftend];
    if ((result == NSOrderedDescending || result == NSOrderedSame) && result1 == NSOrderedAscending) {
        return YES;
    }else{
        NSComparisonResult result2 = [endtime compare:shiftstart];
        NSComparisonResult result3 = [endtime compare:shiftend];
        if (result2 == NSOrderedDescending && (result3 == NSOrderedSame || result3 == NSOrderedAscending))
        {
            return YES;
        }else{
            return NO;
        }
    }
    
}

/**
 判断计划是否在工作日内

 @param taskArray 符合班次的计划
 @return 符合班次和工作日的计划
 */
+(NSArray *)taskWorkDay:(NSArray *)taskArray
{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    for (NSDictionary * taskDict in taskArray) {
        NSArray * workArr = [taskDict[@"working_day"] componentsSeparatedByString:@","];
//        TaskFromChooseTableViewCell * cell = [[TaskFromChooseTableViewCell alloc]init];
        for (NSString * str in workArr) {
            if ([TaskPost changeStringToInt] == [str intValue]) {
                [array addObject:taskDict];
            }
        }
    }
    return array;
}
//   将获取的兴起转换为int
+(int)changeStringToInt
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate *now = [NSDate date];
    NSDateComponents *comps;
    comps = [calendar components:unitFlags fromDate:now];
    //NSInteger week = [comps week]; // 今年的第几周
    NSInteger weekday = [comps weekday]-1;
    return (int)weekday;
}

/**
 同步功能   需要上传的信息

 @param schDict 需要同步的特殊计划信息
 @return <#return value description#>
 */
+(NSDictionary *)otherTaskFromOther:(NSDictionary *)schDict
{
//    NSDate *  senddate=[NSDate date];
//    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"YYYY-MM"];
//    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    NSMutableDictionary * mulDict = [[NSMutableDictionary alloc]init];
    //   计划id
    [mulDict setObject:@([schDict[@"sch_id"] intValue]) forKey:@"sch_id"];
    //   计划开始日期
//    [mulDict setObject:[NSString stringWithFormat:@"%@",[TaskPost hourMinToMonDay:schDict[@"start_time"]]] forKey:@"start_date_time"];
    [mulDict setObject:schDict[@"send_task_start_time"] forKey:@"start_date_time"];
    //   计划结束日期
//    [mulDict setObject:[NSString stringWithFormat:@"%@",[TaskPost hourMinToMonDay:schDict[@"end_time"]]] forKey:@"end_date_time"];
    [mulDict setObject:schDict[@"send_task_end_time"] forKey:@"end_date_time"];
//    //   计划每天开始时间
//    [mulDict setObject:schDict[@"start_time"] forKey:@"start_time"];
//    //   计划每天结束时间
//    [mulDict setObject:schDict[@"end_time"] forKey:@"end_time"];
    //   同一计划巡检次数
    [mulDict setObject:@([schDict[@"same_sch_seq"] intValue]) forKey:@"same_sch_seq"];
    return mulDict;
}

/**
 同步特殊任务进度完成

 @param schDcit 计划数据
 @param otherArray 同步得到的数据
 */
+(void)otherTaskGetFinish:(NSDictionary *)schDcit getOtherArray:(NSArray *)otherArray
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    //   先删除跟此特殊计划相关的数据
    [db deleteSomething:@"other_task_status" value:[NSString stringWithFormat:@"sch_id = %d and same_sch_seq = %d",[schDcit[@"sch_id"] intValue],[schDcit[@"same_sch_seq"] intValue]]];
    NSMutableArray * mulArray = [[NSMutableArray alloc]init];
    for (NSDictionary * otherDict in otherArray) {
        NSMutableDictionary * mulDict = [NSMutableDictionary dictionaryWithDictionary:otherDict];
        [mulDict setObject:@([schDcit[@"sch_id"] intValue]) forKey:@"sch_id"];
        [mulDict setObject:@([schDcit[@"same_sch_seq"] intValue]) forKey:@"same_sch_seq"];
        [mulDict setObject:@([otherDict[@"site_device_id"] intValue]) forKey:@"site_device_id"];
        [mulDict setObject:@([otherDict[@"patrol_flag"] intValue]) forKey:@"patrol_flag"];
        [mulArray addObject:mulDict];
    }
    //  储存在数据库
    [db insertTbName:@"other_task_status" array:mulArray];
}

/**
 计算出特殊计划的开始和结束  日期+时间

 @param schDict 当前特殊计划
 */
+(NSMutableDictionary *)otherTaskStartAndEndTime:(NSDictionary *)schDict
{
    NSString * starttime; NSString * endtime;
    // 计算前后的时间差
    //   如果是周计划
    if ([schDict[@"sch_type"] intValue] == 1) {
        int startdays = 0;
        int enddays = 0;
        int weekday = [TaskPost changeStringToInt];
        startdays = weekday - [schDict[@"other_start_date"] intValue];
        enddays = [schDict[@"other_end_date"] intValue] - weekday;
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
        NSString *  locationString=[dateformatter stringFromDate:senddate];
        NSDate * dat = [dateformatter dateFromString:locationString];
        NSTimeInterval interval1 = -60 * 60 * 24*startdays;
        NSDate *detea1 = [NSDate dateWithTimeInterval:interval1 sinceDate:dat];
        starttime = [dateformatter stringFromDate:detea1];
        starttime = [NSString stringWithFormat:@"%@ %@",starttime,schDict[@"start_time"]];
        NSTimeInterval interval2 = 60 * 60 * 24*enddays;
        NSDate *detea2 = [NSDate dateWithTimeInterval:interval2 sinceDate:dat];
        endtime = [dateformatter stringFromDate:detea2];
        endtime = [NSString stringWithFormat:@"%@ %@",endtime,schDict[@"end_time"]];
    }else if ([schDict[@"sch_type"] intValue] == 2) {
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM"];
        NSString *  locationString=[dateformatter stringFromDate:senddate];
        if ([schDict[@"other_start_date"] intValue] < 10) {
            NSString * litteday = [NSString stringWithFormat:@"0%d",[schDict[@"other_start_date"] intValue]];
            starttime = [NSString stringWithFormat:@"%@-%@ %@",locationString,litteday,schDict[@"start_time"]];
        }else{
            starttime = [NSString stringWithFormat:@"%@-%d %@",locationString,[schDict[@"other_start_date"] intValue],schDict[@"start_time"]];
        }
        if ([schDict[@"other_end_date"] intValue] < 10) {
            NSString * litteday = [NSString stringWithFormat:@"0%d",[schDict[@"other_start_date"] intValue]];
            endtime = [NSString stringWithFormat:@"%@-%@ %@",locationString,litteday,schDict[@"end_time"]];
        }else{
            endtime = [NSString stringWithFormat:@"%@-%d %@",locationString,[schDict[@"other_start_date"] intValue],schDict[@"end_time"]];
        }
    }
    NSMutableDictionary * mulDict = [NSMutableDictionary dictionaryWithDictionary:schDict];
    [mulDict setValue:starttime forKey:@"send_task_start_time"];
    [mulDict setValue:endtime forKey:@"send_task_end_time"];
    NSDictionary * shiftDict = [USERDEFAULT valueForKey:SHIFT_DICT];
    [mulDict setValue:@([shiftDict[@"shift_id"] intValue]) forKey:@"sch_shift_id"];
    return mulDict;
}
/**
 获取班次下的计划数据

 @param kind 判断上一个班次还是下一个班次
 */
+(void)lastOrNextShiftSchArray:(int)kind
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    //   当前班次
    NSDictionary * nowShiftDict = [USERDEFAULT valueForKey:SHIFT_DICT];
    //   根据顺序找出对应的班次
    int compare = 0;
    NSArray * allShiftArray = [db selectAll:@"shift_record" keys:[ToolModel allPropertyNames:[ShiftModel class]] keysKinds:[ToolModel allPropertyAttributes:[ShiftModel class]]];
    //  上一个班次
    if (kind == 0) {
        compare = [nowShiftDict[@"compare_id"] intValue] - 1;
        //  说明是顺序排第一的班次    上一个是最后一个
        if (compare < 0) {
            compare = (int)allShiftArray.count - 1;
        }
    }else{//    下一个班次
        compare = [nowShiftDict[@"compare_id"] intValue] + 1;
        //   说明是顺序排在最后的班次   下一个是第一个
        if (compare > allShiftArray.count - 1) {
            compare = 0;
        }
    }
    //   根据顺序号  查询出对应的班次
    NSArray * shiftArray = [db selectSomething:@"shift_record" value:[NSString stringWithFormat:@"compare_id = %d",compare] keys:[ToolModel allPropertyNames:[ShiftModel class]] keysKinds:[ToolModel allPropertyAttributes:[ShiftModel class]]];
    if (shiftArray.count != 0) {
        NSDictionary * shiftDict = shiftArray[0];
        //   储存真实的时间
        //   将选择的班次时间转换为 添加年月日   （上传时使用）
        NSDate * shiftstart = [TaskPost hourMinToMonDay:shiftDict[@"working_hours"]];
        NSDate * shiftend = [TaskPost hourMinToMonDay:shiftDict[@"off_hours"]];
        //   如果结束时间小于开始时间   说明是垮台呢班次
        if (shiftend < shiftstart) {
            shiftend = [TaskPost isNotToday:shiftend];
        }
        //   根据班次ID保存班次真实事件
        [USERDEFAULT setObject:@{@"send_shift_start_time":shiftstart,@"send_shift_end_time":shiftend} forKey:[NSString stringWithFormat:@"shift%d",[shiftDict[@"shift_id"] intValue]]];
        
        //   根据班次查询出计划
         NSArray * array = [TaskPost getIsShiftTask:[db selectSomething:@"schedule_record" value:@"(other_has_start = 1 or sch_type = 0) order by site_id,start_time,sch_id,same_sch_seq" keys:[ToolModel allPropertyNames:[ScheduleModel class]] keysKinds:[ToolModel allPropertyAttributes:[ScheduleModel class]]] shift:shiftDict];
        //   将特殊计划放在后面
        NSMutableArray * mulNowArray = [[NSMutableArray alloc]init];
        [mulNowArray addObjectsFromArray:array];
        for (NSMutableDictionary * schDict in array) {
            if ([schDict[@"other_has_start"] intValue] == 1) {
                [mulNowArray removeObject:schDict];
                NSDate * starttime = [TaskPost hourMinToMonDay:schDict[@"start_time"]];
                NSDate * endtime = [TaskPost hourMinToMonDay:schDict[@"end_time"]];
                //    如果是结束时间小于开始时间  说明是跨天计划
                if (endtime < starttime) {
                    endtime = [TaskPost isNotToday:endtime];
                }
                [schDict setValue:starttime forKey:@"send_task_start_time"];
                [schDict setValue:endtime forKey:@"send_task_end_time"];
                [mulNowArray insertObject:schDict atIndex:mulNowArray.count];
            }
        }
        array = mulNowArray;
//        if (kind == 0) {
//            [USERDEFAULT setObject:array forKey:LAST_ARRAY];
//        }else{
//            [USERDEFAULT setObject:array forKey:NEXT_ARRAY];
//        }
        //   将查询出来的数组  放入当前数组中
        NSArray * nowSchArray = [USERDEFAULT valueForKey:SCH_SITE_DEVICE_ARRAY];
        if (kind == 0) {
            NSMutableArray * mulArray = [NSMutableArray arrayWithArray:array];
            [mulArray addObjectsFromArray:nowSchArray];
            [USERDEFAULT setObject:mulArray forKey:SCH_SITE_DEVICE_ARRAY];
        }else{
            NSMutableArray * mulArray = [NSMutableArray arrayWithArray:nowSchArray];
            [mulArray addObjectsFromArray:array];
            [USERDEFAULT setObject:mulArray forKey:SCH_SITE_DEVICE_ARRAY];
        }
    }
}
@end
