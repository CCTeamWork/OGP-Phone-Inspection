//
//  TimerModel.m
//  OGP phone patrol
//
//  Created by 张建伟 on 17/5/8.
//  Copyright © 2017年 张建伟. All rights reserved.
//

#import "TimerModel.h"
#define DAY 60*60*24
@implementation TimerModel
/**
 下载完成  添加巡逻提醒

 @param array 下载来的巡逻提醒数据
 */
- (void)addLocalNotification:(NSArray *)array
{
    [self deleteAllLocalNotification];
        // 设置一个按照固定时间的本地推送
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        components = [calendar components:unitFlags fromDate:now];
    
    //   通过循环  将每一个时间都设置成本地推送
        for (int i=0; i<array.count; i++) {
            
            if ([array[i][@"state"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                //设置时区（跟随手机的时区）
                UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                localNotification.timeZone = [NSTimeZone defaultTimeZone];
                if (localNotification) {
                    //   设置推送时的显示内容
                    localNotification.alertBody = array[i][@"timer_name"];
                    localNotification.alertAction = NSLocalizedString(@"All_open",@"");
                    //   推送的铃声  不能超过30秒  否则会自定变为默认铃声
                    localNotification.soundName = @"2.caf";
                    //小图标数字
                    localNotification.applicationIconBadgeNumber++;
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"HH:mm"];
                    NSDate *date = [formatter dateFromString:array[i][@"timer_time"]];
                    //通知发出的时间
                    localNotification.fireDate = date;
                }
                //循环通知的周期   每天
                localNotification.repeatInterval = kCFCalendarUnitDay;
                
                //设置userinfo方便撤销
                NSDictionary * info = @{@"timer_infokey":array[i][@"timer_infokey"],@"timer_name":array[i][@"timer_name"]};
                localNotification.userInfo = info;
                //启动任务
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            }
        }
}

/**
 删除某一个巡逻提醒   开关关闭

 @param dict 要删除的巡逻提醒数据
 */
-(void) deleteLocalNotification:(NSDictionary *)dict
{
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    for (UILocalNotification *notification in localNotifications)
    {
        NSDictionary *userInfo = notification.userInfo;
        if ([dict[@"timer_infokey"] isEqualToString:userInfo[@"timer_infokey"]]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

/**
 添加一个巡逻提醒    开关打开

 @param dic 要添加的巡逻提醒数据
 */
- (void)addLocalNotificationOne:(NSDictionary *)dic
{
    // 设置一个按照固定时间的本地推送
    NSDate *now = [NSDate date];
    //取得系统时间
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    components = [calendar components:unitFlags fromDate:now];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        //设置时区（跟随手机的时区）
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        if (localNotification) {
            localNotification.alertBody = dic[@"timer_name"];
            localNotification.alertAction = NSLocalizedString(@"All_open",@"");
            localNotification.soundName = @"2.caf";
            //小图标数字
            localNotification.applicationIconBadgeNumber++;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm"];
            NSDate *date = [formatter dateFromString:dic[@"timer_time"]];
            //通知发出的时间
            localNotification.fireDate = date;
        //循环通知的周期
        localNotification.repeatInterval = NSCalendarUnitDay;
        
        //设置userinfo方便撤销
        NSDictionary * info = @{@"timer_infokey":dic[@"timer_infokey"],@"timer_name":dic[@"timer_name"]};
        localNotification.userInfo = info;
        //启动任务
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

/**
 自定义闹钟   不重复

 @param dic   要添加的数据
 */
-(void)addMineLocalNoAgain:(NSDictionary *)dic
{
    // 设置一个按照固定时间的本地推送
    NSDate *now = [NSDate date];
    //取得系统时间
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    components = [calendar components:unitFlags fromDate:now];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    //设置时区（跟随手机的时区）
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    if (localNotification) {
        localNotification.alertBody = dic[@"timer_name"];
        localNotification.alertAction = NSLocalizedString(@"All_open",@"");
        localNotification.soundName = @"2.caf";
        //小图标数字
        localNotification.applicationIconBadgeNumber++;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSDate *date = [formatter dateFromString:dic[@"timer_time"]];
        //通知发出的时间
        localNotification.fireDate = date;
        //循环通知的周期
        localNotification.repeatInterval = kCFCalendarUnitEra;
        
        //设置userinfo方便撤销
        NSDictionary * info = @{@"timer_infokey":dic[@"timer_infokey"],@"timer_name":dic[@"timer_name"]};
        localNotification.userInfo = info;
        //启动任务
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

/**
 自定义闹钟    有重复

 @param dict 巡逻提醒数据
 @param array 要重复的日期（周几）
 */
-(void)addMineLocalNotification:(NSDictionary *)dict againTime:(NSMutableArray *)array
{
    if (array.count==0) {
        [self addMineLocalNoAgain:dict];
        return;
    }
    NSArray *clockTimeArray = [dict[@"timer_time"] componentsSeparatedByString:@":"];
    NSDate *dateNow = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    //[calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    //[comps setTimeZone:[NSTimeZone timeZoneWithName:@"CMT"]];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    comps = [calendar components:unitFlags fromDate:dateNow];
    [comps setHour:[[clockTimeArray objectAtIndex:0] intValue]];
    [comps setMinute:[[clockTimeArray objectAtIndex:1] intValue]];
    [comps setSecond:0];
    
    //获取当前的日期以及设定好对比数据
    Byte weekday = [comps weekday];
    Byte i = 0;
    Byte j = 0;
    int days = 0;
    int	temp = 0;
    Byte count = [array count];
    Byte clockDays[7];
    
    NSArray *tempWeekdays = [NSArray arrayWithObjects:@"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
    //查找设定的周期模式
    for (i = 0; i < count; i++) {
        for (j = 0; j < 7; j++) {
            if ([[array objectAtIndex:i] isEqualToString:[tempWeekdays objectAtIndex:j]]) {
                clockDays[i] = j + 1;
                break;
            }
        }
    }
    //  根据相差天数  计算出第一次响铃的日期  并设置周循环
    for (i = 0; i < count; i++) {
        temp = clockDays[i] - weekday;
        days = (temp >= 0 ? temp : temp + 7);
        NSDate *newFireDate = [[calendar dateFromComponents:comps] dateByAddingTimeInterval:3600 * 24 * days];
        
        UILocalNotification *newNotification = [[UILocalNotification alloc] init];
        if (newNotification) {
            newNotification.fireDate = newFireDate;
            newNotification.alertBody = dict[@"timer_name"];
            newNotification.applicationIconBadgeNumber++;
            newNotification.soundName = @"2.caf";
            newNotification.alertAction = NSLocalizedString(@"All_open",@"");
            newNotification.repeatInterval = NSCalendarUnitWeekday;
            NSDictionary * info = @{@"timer_infokey":dict[@"timer_infokey"],@"timer_name":dict[@"timer_name"]};
            newNotification.userInfo = info;
            [[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
        }
    }
}

/**
 删除所有巡逻提醒
 */
-(void) deleteAllLocalNotification
{
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    for (UILocalNotification *notification in localNotifications)
    {
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    }
}
@end
