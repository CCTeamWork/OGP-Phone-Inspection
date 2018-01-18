//
//  HomePagePost.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/1.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "HomePagePost.h"
#import "DataBaseManager.h"
#import "ShiftModel.h"
#import "TaskPost.h"
#import "ScheduleModel.h"
#import "AllKindModel.h"
#import "DeviceModel.h"
#import "ItemsKindModel.h"
#import "DataModel.h"
@implementation HomePagePost

/**
 上班是否随机拍照

 @return <#return value description#>
 */
+(BOOL)photoRate
{
    int rate=[LOGIN_BACK[@"checkin_rate"] intValue];
//    int rate = 100;
    int armRate=arc4random()%101;
    if (armRate>0 && armRate<rate+1) {
        return YES;
    }
    return NO;
}
/**
 处理下载的数据

 @param deviceDict 设备数据，
 @param itemDict 项目数据
 */
+(void)downLoad_deviceDict:(NSDictionary *)deviceDict itemDict:(NSDictionary *)itemDict
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    //   删除所有数据
    [db deleteAll:@"shift_record"];
    [db deleteAll:@"site_record"];
    [db deleteAll:@"device_record"];
    [db deleteAll:@"schedule_record"];
    [db deleteAll:@"sch_device_record"];
    [db deleteAll:@"emergency_contact_record"];
    
    [db deleteAll:@"device_status_record"];
    [db deleteAll:@"items_record"];
    [db deleteAll:@"device_items_record"];
    [db deleteAll:@"options_record"];
    [db deleteAll:@"unit_record"];
    [db deleteAll:@"event_record"];
    
    //   设备信息
    //   给班次排序
    NSArray * shiftArray = [deviceDict[@"shift_record"] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        return [obj1[@"working_hours"] compare:obj2[@"working_hours"]];
    }];
    //   给班次加顺序标示
    NSMutableArray * shiftMulArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < shiftArray.count; i ++) {
        NSMutableDictionary * mulDict = [NSMutableDictionary dictionaryWithDictionary:shiftArray[i]];
        //  添加
        [mulDict setObject:@(i) forKey:@"compare_id"];
        [shiftMulArray addObject:mulDict];
    }
    [db insertTbName:@"shift_record" array:shiftMulArray];
    [db insertTbName:@"site_record" array:deviceDict[@"site_record"]];
    [db insertTbName:@"device_record" array:deviceDict[@"device_record"]];
    //   增加字段    特殊计划是否已经开启
    for (NSMutableDictionary * dict in deviceDict[@"schedule_record"]) {
        [dict setObject:@(0) forKey:@"other_has_start"];
    }
    [db insertTbName:@"schedule_record" array:deviceDict[@"schedule_record"]];
    //   计划设备关联表
    NSArray * array = deviceDict[@"schedule_record"];
    for (NSDictionary * dict in array) {
        for (NSMutableDictionary * schmulDict in dict[@"sch_device_record"]) {
            [schmulDict setObject:@([dict[@"same_sch_seq"] intValue]) forKey:@"same_sch_seq"];
        }
        [db insertTbName:@"sch_device_record" array:dict[@"sch_device_record"]];
    }
    [db insertTbName:@"emergency_contact_record" array:deviceDict[@"emergency_contact_record"]];
    
    //    项目信息
    [db insertTbName:@"device_status_record" array:itemDict[@"device_status_record"]];
    [db insertTbName:@"items_record" array:itemDict[@"items_record"]];
    [db insertTbName:@"device_items_record" array:itemDict[@"device_items_record"]];
    [db insertTbName:@"options_record" array:itemDict[@"options_record"]];
    [db insertTbName:@"unit_record" array:itemDict[@"unit_record"]];
    [db insertTbName:@"event_record" array:itemDict[@"event_record"]];
    [db dbclose];
    
    if ([[USERDEFAULT valueForKey:CHECK_STATE] intValue] == 1) {
        //  当前班次
        NSDictionary * nowShiftDict = [USERDEFAULT valueForKey:SHIFT_DICT];
        NSArray * shiftArray = [db selectAll:@"shift_record" keys:[ToolModel allPropertyNames:[ShiftModel class]] keysKinds:[ToolModel allPropertyAttributes:[ShiftModel class]]];
        for (NSDictionary * shiftDict in shiftArray) {
            if ([shiftDict[@"shift_id"] intValue] == [nowShiftDict[@"shift_id"] intValue]) {
                [USERDEFAULT setObject:shiftDict forKey:SHIFT_DICT];
            }
        }
        //  清除当前检查项数据
        NSArray * array1 = [USERDEFAULT valueForKey:SCH_SITE_DEVICE_ARRAY];
        for (NSDictionary * dict in array1) {
            NSArray * arr = dict[@"device_array"];
            for (NSDictionary * dic in arr) {
                [USERDEFAULT removeObjectForKey:dic[@"record_uuid"]];
            }
        }
        //   当前计划和设备所有数据
        [USERDEFAULT removeObjectForKey:SCH_SITE_DEVICE_ARRAY];
        //   当前点击的计划
        [USERDEFAULT removeObjectForKey:SCH_NOW_TOUCH];
        [HomePagePost startDownLoad];
    }
}

/**
 根据当前时间  判断出当前可选择的班次

 @param shiftArray 全部班次
 @return <#return value description#>
 */
+(NSArray *)shiftArrayFromTime:(NSArray *)shiftArray
{
    //   获取当前时间
    NSDate * senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSDate * nowtimes = [dateformatter dateFromString:locationString];
    long stmptime = [nowtimes timeIntervalSince1970];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:stmptime];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    NSTimeInterval interval = [destinationTimeZone secondsFromGMT];
    NSDate *localDate = [detaildate dateByAddingTimeInterval:interval];

    
    //  判断当前时间所在的班次内
    NSMutableArray * finishArr = [[NSMutableArray alloc]init];
    //  当前时间之后的所有班次
//    NSMutableArray * nextArr = [[NSMutableArray alloc]init];
    
    for (NSDictionary * shiftDict in shiftArray) {
        NSDate * shiftstart = [TaskPost hourMinToMonDay:shiftDict[@"working_hours"]];
        NSDate * shiftend = [TaskPost hourMinToMonDay:shiftDict[@"off_hours"]];
        if (shiftend < shiftstart || shiftend == shiftstart) {
            shiftend = [TaskPost isNotToday:shiftend];
        }
        if ((localDate > shiftstart || localDate == shiftstart) && (localDate < shiftend || localDate == shiftend)) {
            //  当前时间所在的班次内
            [finishArr addObject:shiftDict];
        }else if (localDate < shiftstart){
            //  当前时间小于班次的开始时间的班次
            [finishArr addObject:shiftDict];
        }
    }
//    NSDate * date = [[NSDate alloc]init];
//    for (NSDictionary * nextDict in nextArr) {
//        NSDate * shiftstart = [TaskPost hourMinToMonDay:nextDict[@"working_hours"]];
//        NSDate * shiftend = [TaskPost hourMinToMonDay:nextDict[@"off_hours"]];
//        if (shiftend < shiftstart) {
//            shiftend = [TaskPost isNotToday:shiftend];
//        }
//        if (date < shiftstart || date == shiftstart) {
//            date = date;
//        }else{
//            date = shiftstart;
//        }
//    }
//
//    for (NSDictionary *  nextDict in nextArr) {
//        NSDate * shiftstart = [TaskPost hourMinToMonDay:nextDict[@"working_hours"]];
//        if (shiftstart == date) {
//            [finishArr addObject:nextDict];
//        }
//    }
    ///------------------------------------------
//    NSMutableArray * mulfinishArr = [[NSMutableArray alloc]init];
    //   将可选择的所有班次都加日期
//    for (NSDictionary * finishDict in finishArr) {
//        NSMutableDictionary * mulfinDict = [NSMutableDictionary dictionaryWithDictionary:finishDict];
//        NSDate * shiftstart = [TaskPost hourMinToMonDay:finishDict[@"working_hours"]];
//        NSDate * shiftend = [TaskPost hourMinToMonDay:finishDict[@"off_hours"]];
//        if (shiftend < shiftstart) {
//            shiftend = [TaskPost isNotToday:shiftend];
//        }
//        [mulfinDict setObject:shiftstart forKey:@"working_hours"];
//        [mulfinDict setObject:shiftend forKey:@"off_hours"];
//        [mulfinishArr addObject:mulfinDict];
//    }
    return finishArr;
}

/**
 获取当前时间显示在上班按钮上
 */
+(NSString *)checkTextGet
{
    NSDate * date = [NSDate date];
    //   根据时区  转换成当地时间
//    long stmptime = [date timeIntervalSince1970];
//    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:stmptime];
//    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
//    NSTimeInterval interval = [destinationTimeZone secondsFromGMT];
//    NSDate *localDate = [detaildate dateByAddingTimeInterval:interval];
    NSDateFormatter * input=[[NSDateFormatter alloc]init];
    [input setDateFormat:@"HH:mm:ss"];
    
    return [input stringFromDate:date];
}

/**
 下班处理数据
 */
-(void)checkoutRemoveModel
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    //   清除上班标记
    [USERDEFAULT setObject:@(0) forKey:CHECK_STATE];
    //  当前班次
    [USERDEFAULT removeObjectForKey:SHIFT_DICT];
    //  清除当前检查项数据
    NSArray * array = [USERDEFAULT valueForKey:SCH_SITE_DEVICE_ARRAY];
    for (NSDictionary * dict in array) {
        NSArray * arr = dict[@"device_array"];
        for (NSDictionary * dic in arr) {
            [USERDEFAULT removeObjectForKey:dic[@"record_uuid"]];
        }
    }
    //   当前计划和设备所有数据
    [USERDEFAULT removeObjectForKey:SCH_SITE_DEVICE_ARRAY];
    //   当前点击的计划
    [USERDEFAULT removeObjectForKey:SCH_NOW_TOUCH];
    //   清除当前闹钟和闹钟数组
    [self.timermodel deleteAllLocalNotification];
    [USERDEFAULT removeObjectForKey:TIMER_ARRAY];
    //   删除 上 下拉的标示
    [USERDEFAULT removeObjectForKey:LAST_SCH_ARRAY];
    [USERDEFAULT removeObjectForKey:NEXT_SCH_ARRAY];
    //  删除未完成的巡检数据
    NSArray * needDeleteRecordArray = [db selectSomething:@"allkind_record" value:[NSString stringWithFormat:@"user_name = '%@' and record_state = 0 and patrol_state != 3 and record_category = 'PATROL'",[USERDEFAULT valueForKey:NAMEING]] keys:[ToolModel allPropertyNames:[AllKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[AllKindModel class]]];
    [db deleteSomething:@"allkind_record" value:[NSString stringWithFormat:@"user_name = '%@' and record_state = 0 and patrol_state != 3 and record_category = 'PATROL'",[USERDEFAULT valueForKey:NAMEING]]];
    // 根据设备信息 删除检查项信息和流数据
    for (NSDictionary * deviceDict in needDeleteRecordArray) {
        NSArray * itemArr = [db selectSomething:@"itemskind_record" value:[NSString stringWithFormat:@"record_uuid = '%@'",deviceDict[@"record_uuid"]] keys:[ToolModel allPropertyNames:[ItemsKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[ItemsKindModel class]]];
        //    NSLog(@"%@",itemArr);
        [db deleteSomething:@"itemskind_record" key:@"record_uuid" value:[NSString stringWithFormat:@"'%@'",deviceDict[@"record_uuid"]]];
        
        //   删除项目中的流数据
        for (NSDictionary * itemDict in itemArr) {
            NSArray * dataArr = [db selectSomething:@"data_record" value:[NSString stringWithFormat:@"data_uuid = '%@'",itemDict[@"data_uuid"]] keys:[ToolModel allPropertyNames:[DataModel class]] keysKinds:[ToolModel allPropertyAttributes:[DataModel class]]];
            //   删除流数据
            [db deleteSomething:@"data_record" key:@"data_uuid" value:[NSString stringWithFormat:@"'%@'",itemDict[@"data_uuid"]]];
            for (NSDictionary * dataDict in dataArr) {
                if ([dataDict[@"event_category"] isEqualToString:@"PHOTO"] || [dataDict[@"event_category"] isEqualToString:@"HANDWRITE"]) {
                    //   删除照片
                    [ToolModel deleteFile:dataDict[@"content_path"]];
                }else if ([dataDict[@"event_category"] isEqualToString:@"VOICE"])
                {
                    //   删除录音
                    [self deleteSound:dataDict[@"content_path"]];
                }
            }
        }
    }
    
}
//   删除沙盒里的录音
-(void)deleteSound:(NSString *)path
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!blHave) {
        NSLog(@"没有可以删除的文件");
        return ;
    }else {
        BOOL blDele= [fileManager removeItemAtPath:path error:nil];
        if (blDele) {
            NSLog(@"删除成功");
        }else {
            NSLog(@"删除失败");
        }
    }
}
/**
 上班过程中  下载档案   更新计划和设备数据   继续显示之前的巡检状态
 */
+(void)startDownLoad
{
    NSDictionary * nowShiftDict = [USERDEFAULT valueForKey:SHIFT_DICT];
    NSDictionary * nowShiftTimeDict = [USERDEFAULT valueForKey:[NSString stringWithFormat:@"shift%d",[nowShiftDict[@"shift_id"] intValue]]];
    //   查询出当前班次的所有计划
    DataBaseManager * db = [DataBaseManager shareInstance];
    NSArray * allSchArray = [TaskPost getIsShiftTask:[db selectSomething:@"schedule_record" value:@"(other_has_start = 1 or sch_type = 0) order by site_id,start_time,sch_id,same_sch_seq" keys:[ToolModel allPropertyNames:[ScheduleModel class]] keysKinds:[ToolModel allPropertyAttributes:[ScheduleModel class]]] shift:nowShiftDict];
    //   符合班次和工作日的本班次计划
    allSchArray = [TaskPost taskWorkDay:allSchArray];
    //   将添加到当前任务的特殊任务   移到数组后面
    NSMutableArray * mulNowArray = [[NSMutableArray alloc]init];
    [mulNowArray addObjectsFromArray:allSchArray];
    for (NSDictionary * schDict in allSchArray) {
        if ([schDict[@"other_has_start"] intValue] == 1) {
            [mulNowArray removeObject:schDict];
            [mulNowArray insertObject:schDict atIndex:mulNowArray.count];
        }
    }
    allSchArray = mulNowArray;
    [USERDEFAULT setObject:allSchArray forKey:SCH_SITE_DEVICE_ARRAY];
    //  查询出当前班次已经保存的纪录的信息
    NSString * startStr = [[NSString stringWithFormat:@"%@",nowShiftTimeDict[@"send_shift_start_time"]] substringToIndex:16];
    NSArray * hadSendDeviceArray = [db selectSomething:@"allkind_record" value:[NSString stringWithFormat:@"user_name = '%@' and record_category <> 'EVENT' and record_shift_starttime = '%@' and record_category = 'PATROL'",[USERDEFAULT valueForKey:NAMEING],startStr] keys:[ToolModel allPropertyNames:[AllKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[AllKindModel class]]];
    [HomePagePost changeSchDeviceArray:hadSendDeviceArray];
}

/**
 根据已经上传的数据  重新组合userdefault

 @param deviceRecordArray 已经上传的数据
 */
+(void)changeSchDeviceArray:(NSArray *)deviceRecordArray
{
    NSArray * allSchArray = [USERDEFAULT valueForKey:SCH_SITE_DEVICE_ARRAY];
    NSMutableArray * schMulArray = [[NSMutableArray alloc]init];
    for (NSDictionary * schDict in allSchArray) {
        NSMutableDictionary * mulSchdict = [NSMutableDictionary dictionaryWithDictionary:schDict];
        NSArray * array = [HomePagePost deviceArray_schDict:schDict sendDeviceArray:deviceRecordArray];
        [mulSchdict setObject:array forKey:@"device_array"];
        [schMulArray addObject:mulSchdict];
    }
    [USERDEFAULT setObject:schMulArray forKey:SCH_SITE_DEVICE_ARRAY];
    
    //   计算出当前班次的上传的开始和结束时间
    NSDictionary * nowShiftDict = [USERDEFAULT valueForKey:SHIFT_DICT];
    NSDate * shiftstart = [TaskPost hourMinToMonDay:nowShiftDict[@"working_hours"]];
    NSDate * shiftend = [TaskPost hourMinToMonDay:nowShiftDict[@"off_hours"]];
    //   如果结束时间小于开始时间   说明是垮台呢班次
    if (shiftend < shiftstart) {
        shiftend = [TaskPost isNotToday:shiftend];
    }
    [USERDEFAULT setObject:@{@"send_shift_start_time":shiftstart,@"send_shift_end_time":shiftend} forKey:[NSString stringWithFormat:@"shift%d",[nowShiftDict[@"shift_id"] intValue]]];
}

/**
 组合新的设备信息

 @param schDict 计划字典
 @param sendDeviceArray 已经上传的设备字典
 @return 组合好的设备数组
 */
+(NSArray *)deviceArray_schDict:(NSDictionary *)schDict sendDeviceArray:(NSArray *)sendDeviceArray
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    //   计划设备对应表数组
    NSArray * scharray = [db selectSomething:@"sch_device_record" value:[NSString stringWithFormat:@"sch_id = %d and same_sch_seq = %d",[schDict[@"sch_id"] intValue],[schDict[@"same_sch_seq"] intValue]] keys:@[@"sch_id",@"site_device_id",@"same_sch_seq"] keysKinds:@[@"int",@"int",@"int"]];
    NSMutableArray * mulArray = [[NSMutableArray alloc]init];
    //   循环查找出所有的对应设备数据
    for (NSDictionary * dic in scharray) {
        NSArray * devicearray = [db selectSomething:@"device_record" value:[NSString stringWithFormat:@"site_device_id = %d",[dic[@"site_device_id"] intValue]] keys:[ToolModel allPropertyNames:[DeviceModel class]] keysKinds:[ToolModel allPropertyAttributes:[DeviceModel class]]];
        //   遍历当前计划下的所有设备
        for (NSDictionary * dict in devicearray) {
            NSMutableDictionary * muldict = [NSMutableDictionary dictionaryWithDictionary:dict];
            //   设备状态
            [muldict setObject:@"normal" forKey:@"device_state"];
            //    巡检状态
            [muldict setObject:@(0) forKey:@"patrol_state"];
            //    完成项目数
            [muldict setObject:@(0) forKey:@"device_finish_number"];
            //   设备record_uuid
            [muldict setObject:[ToolModel uuid] forKey:@"record_uuid"];
            //   与流记录关联id
            [muldict setObject:[ToolModel uuid] forKey:@"data_uuid"];
            //   发送状态
            [muldict setObject:@(0) forKey:@"record_state"];
            //    发送时间
            [muldict setObject:@"" forKey:@"record_sendtime"];
            [mulArray addObject:muldict];
            
            //  遍历本班次已经发送的所有设备
            for (NSDictionary * sendDict in sendDeviceArray) {
                //   如果已经发送的设备中  有这个设备
                if ([sendDict[@"record_sch_id"] intValue] == [schDict[@"sch_id"] intValue] && [sendDict[@"record_sch_seq"] intValue] == [schDict[@"same_sch_seq"] intValue] && [sendDict[@"record_device_mark"] isEqualToString:dict[@"device_mark"]] && [sendDict[@"record_shift_id"] intValue] == [schDict[@"sch_shift_id"] intValue]) {
                    //  如果此计划中有设备被巡检  更改此计划的巡检状态
                    [HomePagePost changeSchStatus:schDict];
                    
                    [mulArray removeObject:muldict];
                    //   设备状态
                    [muldict setObject:sendDict[@"record_status"] forKey:@"device_state"];
                    //    巡检状态
                    [muldict setObject:@([sendDict[@"patrol_state"] intValue]) forKey:@"patrol_state"];
                    //    完成项目数
                    [muldict setObject:@(0) forKey:@"device_finish_number"];
                    //   设备record_uuid
                    [muldict setObject:sendDict[@"record_uuid"] forKey:@"record_uuid"];
                    //   与流记录关联id
                    [muldict setObject:sendDict[@"data_uuid"] forKey:@"data_uuid"];
                    //   发送状态
                    [muldict setObject:@([sendDict[@"record_state"] intValue]) forKey:@"record_state"];
                    //    发送时间
                    [muldict setObject:@"" forKey:@"record_sendtime"];
                    [mulArray addObject:muldict];
                }
            }
        }
    }
    [db dbclose];
    return mulArray;
}

/**
 改变当前计划的巡检状态

 @param schDict 当前计划
 */
+(void)changeSchStatus:(NSDictionary *)schDict
{
    NSArray * allSchArray = [USERDEFAULT valueForKey:SCH_SITE_DEVICE_ARRAY];
    NSMutableArray * mulArray = [[NSMutableArray alloc]init];
    [mulArray addObjectsFromArray:allSchArray];
    for (NSDictionary * dict in allSchArray) {
        if ([schDict[@"sch_id"] intValue] == [dict[@"sch_id"] intValue] && [schDict[@"same_sch_seq"] intValue] == [dict[@"same_sch_seq"] intValue] && [schDict[@"sch_shift_id"] intValue] == [dict[@"sch_shift_id"] intValue]) {
            NSMutableDictionary * mulDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            [mulDict setObject:@(1) forKey:@"sch_state"];
            [mulArray removeObject:dict];
            [mulArray addObject:mulDict];
        }
    }
    [USERDEFAULT setObject:mulArray forKey:SCH_SITE_DEVICE_ARRAY];
}
-(TimerModel *)timermodel
{
    if (_timermodel == nil) {
        _timermodel = [[TimerModel alloc]init];
    }
    return _timermodel;
}
@end
