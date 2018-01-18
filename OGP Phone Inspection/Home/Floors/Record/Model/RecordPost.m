//
//  RecordPost.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/13.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "RecordPost.h"
#import "DataBaseManager.h"
#import "AllKindModel.h"
#import "ItemsKindModel.h"
#import "DataModel.h"
@implementation RecordPost

/**
 记录时间过长  删除数据
 */
-(void)isLongTime
{
    //    取出记录中的所有数据
    DataBaseManager * db = [DataBaseManager shareInstance];
    NSArray * recordArray = [db selectAll:@"allKind_record" keys:[ToolModel allPropertyNames:[AllKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[AllKindModel class]]];
    [db dbclose];
    //    获取数据保存时间
    int i = [[USERDEFAULT valueForKey:RECORD_KEEP_TIME] intValue];
    for (NSDictionary * recordDict in recordArray) {
        NSDateFormatter * input=[[NSDateFormatter alloc]init];
        [input setDateFormat:@"yyyy-MM-DD"];
         NSDate * starttime = [input dateFromString:recordDict[@"recordDict"]];
        NSDate *  senddate=[NSDate date];
        NSString *  locationString=[input stringFromDate:senddate];
        NSDate *date=[input dateFromString:locationString];
        
        NSTimeInterval time=[date timeIntervalSinceDate:starttime];
        int mon=((int)time)/(3600*24*30);
        //   如果时间等于保存时间或者大于保存时间
        if (mon == i || mon > i) {
            //   判断类型删除数据
            //   如果是普通类型   直接删除记录
            if ([recordDict[@"record_category"] isEqualToString:@"LOGIN"] || [recordDict[@"record_category"] isEqualToString:@"LOGOUT"] ||[recordDict[@"record_category"] isEqualToString:@"CHECKIN"] ||[recordDict[@"record_category"] isEqualToString:@"CHECKOUT"]){
                [self deleteSameKind:recordDict];
                //    如果是事件类型
            }else if ([recordDict[@"record_category"] isEqualToString:@"EVENT"]){
                
                //    如果是设备类型
            }else{
                //   删除住记录
                DataBaseManager * db = [DataBaseManager shareInstance];
                [db deleteSomething:@"allKind_record" key:@"record_uuid" value:[NSString stringWithFormat:@"'%@'",recordDict[@"record_uuid"]]];
                [self deleteDeviceType:recordDict itemsdict:nil];
            }
        }
    }
}

/**
 删除普通记录数据

 @param dict 记录数据
 */
-(void)deleteSameKind:(NSDictionary *)dict
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    [db deleteSomething:@"allKind_record" key:@"record_uuid" value:[NSString stringWithFormat:@"'%@'",dict[@"record_uuid"]]];
    [db dbclose];
}

/**
 删除设备类型 （设备  项目  流）

 @param dict 记录数据
 */
-(void)deleteDeviceType:(NSDictionary *)dict itemsdict:(NSDictionary *)itemsdict
{
    //   删除住记录
    DataBaseManager * db = [DataBaseManager shareInstance];
    NSArray * itemArr = [[NSArray alloc]init];
    //   删除项目记录
    //   如果是时间过长
    if (itemsdict == nil) {
        itemArr = [db selectSomething:@"itemskind_record" value:[NSString stringWithFormat:@"record_uuid = '%@'",dict[@"record_uuid"]] keys:[ToolModel allPropertyNames:[ItemsKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[ItemsKindModel class]]];
        //    NSLog(@"%@",itemArr);
        [db deleteSomething:@"itemskind_record" key:@"record_uuid" value:[NSString stringWithFormat:@"'%@'",dict[@"record_uuid"]]];
    }else{
        //   如果是翻页
        itemArr = [db selectSomething:@"itemskind_record" value:[NSString stringWithFormat:@"record_uuid = '%@' and items_id = %d",dict[@"record_uuid"],[itemsdict[@"items_id"] intValue]] keys:[ToolModel allPropertyNames:[ItemsKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[ItemsKindModel class]]];
        //    NSLog(@"%@",itemArr);
        [db deleteSomething:@"itemskind_record" value:[NSString stringWithFormat:@"record_uuid = '%@' and items_id = %d",dict[@"record_uuid"],[itemsdict[@"items_id"] intValue]]];
    }
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
    [db dbclose];
}
-(void)deleteEventType:(NSDictionary *)dict
{
    DataBaseManager * db =[DataBaseManager shareInstance];
    [db deleteSomething:@"allKind_record" key:@"record_uuid" value:[NSString stringWithFormat:@"'%@'",dict[@"record_uuid"]]];
    //   删除流数据
    NSArray * dataArr = [db selectSomething:@"data_record" value:[NSString stringWithFormat:@"record_uuid = '%@'",dict[@"record_uuid"]] keys:[DataModel class] keysKinds:[ToolModel allPropertyAttributes:[DataModel class]]];
    [db deleteSomething:@"data_record" key:@"record_uuid" value:[NSString stringWithFormat:@"'%@'",dict[@"record_uuid"]]];
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
    [db dbclose];
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
 根据类型显示文字类型
 */
+(NSString *)recordTypeString:(NSString *)recordType
{
    if ([recordType isEqualToString:@"LOGIN"]) {
        return @"登录";
    }else if ([recordType isEqualToString:@"LOGOUT"]){
        return @"退出";
    }else if ([recordType isEqualToString:@"CHECKIN"]){
        return @"上班";
    }else if ([recordType isEqualToString:@"CHECKOUT"]){
        return @"下班";
    }else if ([recordType isEqualToString:@"PATROL"]){
        return @"设备";
    }else if ([recordType isEqualToString:@"EVENT"]){
        return NSLocalizedString(@"All_event_title",@"");
    }
    return @"未知类型";
}
/**
 根据类型显示文字类型
 */
+(UIColor *)recordTypeColor:(NSString *)recordType
{
    if ([recordType isEqualToString:@"LOGIN"]) {
        return [UIColor colorWithRed:0.18 green:0.81 blue:0.84 alpha:1.00];//
    }else if ([recordType isEqualToString:@"LOGOUT"]){
        return [UIColor colorWithRed:0.88 green:0.15 blue:0.24 alpha:1.00];//
    }else if ([recordType isEqualToString:@"CHECKIN"]){
        return [UIColor colorWithRed:0.28 green:0.54 blue:0.93 alpha:1.00];//
    }else if ([recordType isEqualToString:@"CHECKOUT"]){
        return [UIColor colorWithRed:0.00 green:0.81 blue:0.72 alpha:1.00];//
    }else if ([recordType isEqualToString:@"PATROL"]){
        return [UIColor colorWithRed:1.00 green:0.59 blue:0.12 alpha:1.00];//
    }else if ([recordType isEqualToString:@"EVENT"]){
        return [UIColor colorWithRed:0.00 green:0.81 blue:0.72 alpha:1.00];
    }
    return [UIColor blackColor];
}
@end
