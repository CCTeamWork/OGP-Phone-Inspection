//
//  TimerPost.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/25.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "TimerPost.h"
#import "DataBaseManager.h"
#import "SiteModel.h"
#import "TimerModel.h"
@implementation TimerPost

/**
 通过当前计划集成闹钟数组

 @return 闹钟数组
 */
+(NSArray *)timeArrayFromTask
{
    //   获取计划数组
    NSArray * taskarray = [USERDEFAULT valueForKey:SCH_SITE_DEVICE_ARRAY];
    //   定义闹钟数据
    NSMutableArray * timerMulArray = [[NSMutableArray alloc]init];
    //  遍历计划   得到闹钟数据
    for (NSDictionary * taskDict in taskarray) {
        NSMutableDictionary * mulDict = [[NSMutableDictionary alloc]init];
        [mulDict setObject:taskDict[@"start_time"] forKey:@"timer_time"];
        DataBaseManager * db = [DataBaseManager shareInstance];
        NSArray * array = [db selectSomething:@"site_record" value:[NSString stringWithFormat:@"site_id = %@",taskDict[@"site_id"]] keys:[ToolModel allPropertyNames:[SiteModel class]] keysKinds:[ToolModel allPropertyAttributes:[SiteModel class]]];
        if (array.count == 0) {
            [mulDict setObject:array[0][@"site_id"] forKey:@"timer_name"];
        }else{
            [mulDict setObject:array[0][@"site_name"] forKey:@"timer_name"];
        }
        [mulDict setObject:@(1) forKey:@"timer_state"];
        [mulDict setObject:@(1) forKey:@"timer_kind"];
        [mulDict setObject:[ToolModel uuid] forKey:@"timer_infokey"];
        [timerMulArray addObject:mulDict];
    }
    [USERDEFAULT setObject:timerMulArray forKey:TIMER_ARRAY];
    //   启动闹钟
    TimerModel * model=[[TimerModel alloc]init];
    [model addLocalNotification:timerMulArray];
    return timerMulArray;
}
@end
