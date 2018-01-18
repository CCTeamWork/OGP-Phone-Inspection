//
//  EventPost.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/12.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "EventPost.h"
#import "DataBaseManager.h"
#import <MapKit/MapKit.h>
@implementation EventPost

///**
// 储存住记录到数据库    与设备绑定
//
// @param array 设备数组
// @param titletext 事件标题
// */
//-(NSDictionary *)keepEvent_device:(NSArray *)array titletext:(NSString *)titletext
//{
//    NSDictionary * dict = [self eventRecord_device:array titletext:titletext];
//    DataBaseManager * db = [DataBaseManager shareInstance];
//    [db insertTbName:@"allKind_record" dict:dict];
//    return dict;
//}
//
///**
// 生成事件记录信息     与设备绑定
//
// @param array 设备数组
// */
//-(NSDictionary *)eventRecord_device:(NSArray *)array titletext:(NSString *)titletext
//{
//    NSNull * null = [[NSNull alloc]init];
//    NSMutableDictionary * eventMulDict = [[NSMutableDictionary alloc]init];
//    //    当前用户
//    [eventMulDict setObject:[USERDEFAULT valueForKey:NAMEING] forKey:@"user_name"];
//    //    发送状态
//    [eventMulDict setObject:@(0) forKey:@"record_state"];
//    //    记录uuid
//    [eventMulDict setObject:[ToolModel uuid] forKey:@"record_uuid"];
//    //    检查项uuid--- 计划结束时间
//    //   记录类型
//    [eventMulDict setObject:@"EVENT" forKey:@"record_category"];
//    ///   设备识别码
////    [eventMulDict setObject:@"" forKey:@"record_device_mark"];
//    //   事件标题
//    [eventMulDict setObject:titletext forKey:@"record_content"];
//    //    读点时间
//    [eventMulDict setObject:[ToolModel achieveNowTime] forKey:@"record_scantime"];
//    //    定位时间
//    if (MAP_TIME == nil) {
//        [eventMulDict setObject:null forKey:@"record_gps_time"];
//    }else{
//        [eventMulDict setObject:MAP_TIME forKey:@"record_gps_time"];
//    }
//    //    定位类型
//    [eventMulDict setObject:@"GPS" forKey:@"record_location_category"];
//    //    经度
//    if (MAP_LONGNUM == nil) {
//        [eventMulDict setObject:null forKey:@"record_longitude"];
//    }else{
//        [eventMulDict setObject:MAP_LONGNUM forKey:@"record_longitude"];
//    }
//    //    纬度
//    if (MAP_LUAITNUM == nil) {
//        [eventMulDict setObject:null forKey:@"record_latitude"];
//    }else{
//        [eventMulDict setObject:MAP_LUAITNUM forKey:@"record_latitude"];
//    }
//    //    离线数据
//    [eventMulDict setObject:@(0) forKey:@"record_offline"];
//    //     是否要求拍照
//    [eventMulDict setObject:@(0) forKey:@"record_must_photo"];
//    //    是否进行了拍照
//    [eventMulDict setObject:@(0) forKey:@"record_photo_flag"];
//    //   照片名
//    //    是否超时
//    [eventMulDict setObject:@(0) forKey:@"record_overdue"];
//    //    设备状态
//    //    是否超出巡检范围
//    [eventMulDict setObject:@(2) forKey:@"record_gps_outside"];
//    //    关联的设备
//     NSString *str = [array componentsJoinedByString:@","];
//    [eventMulDict setObject:str forKey:@"event_device_code"];
//    
//    return eventMulDict;
//}
//
//
///**
// 储存记录信息
//
// @param eventDict 事件具体内容
// @param recordDict 主记录内容
// @param datetype 事件类型
// */
//-(void)keepData_device:(NSDictionary *)eventDict recordDict:(NSDictionary *)recordDict datatype:(NSString *)datetype
//{
//    NSDictionary * dict = [self eventdataRecord_device:eventDict recordDict:recordDict datatype:datetype];
//    DataBaseManager * db = [DataBaseManager shareInstance];
//    [db insertTbName:@"data_record" dict:dict];
//}
///**
// 生成流记录信息
//
// @param eventDict 事件具体内容
// @param recordDict 主记录内容
// @param datetype 事件类型
// @return <#return value description#>
// */
//-(NSDictionary *)eventdataRecord_device:(NSDictionary *)eventDict recordDict:(NSDictionary *)recordDict datatype:(NSString *)datetype
//{
//    NSNull * null = [[NSNull alloc]init];
//    NSMutableDictionary * dataDict = [[NSMutableDictionary alloc]init];
//    //    数据流位置
//    if (eventDict[@"content_path"] == nil) {
//        [dataDict setObject:null forKey:@"content_path"];
//    }else{
//        [dataDict setObject:eventDict[@"content_path"] forKey:@"content_path"];
//    }
//    //    记录展示
//    if (eventDict[@"data_record_show"] == nil) {
//        [dataDict setObject:null forKey:@"data_record_show"];
//    }else{
//        [dataDict setObject:eventDict[@"data_record_show"] forKey:@"data_record_show"];
//    }
//    //    与项目关联uuid
//    if (recordDict[@"items_uuid"] != nil) {
//        [dataDict setObject:recordDict[@"items_uuid"] forKey:@"items_uuid"];
//    }
//    //     与事件绑定（事件用）
//    [dataDict setObject:recordDict[@"record_uuid"] forKey:@"record_uuid"];
//    //    数据类型
//    [dataDict setObject:datetype forKey:@"event_category"];
//    //    流数据名称
//    [dataDict setObject:eventDict[@"file_name"] forKey:@"file_name"];
//    //    读点时间
//    [dataDict setObject:[ToolModel achieveNowTime] forKey:@"file_scantime"];
//    //    定位时间
//    if (MAP_TIME == nil) {
//        [dataDict setObject:null forKey:@"file_gps_time"];
//    }else{
//        [dataDict setObject:MAP_TIME forKey:@"file_gps_time"];
//    }
//    //     定位类型
//    [dataDict setObject:@"GPS" forKey:@"file_location_category"];
//    //    经度
//    if (MAP_LONGNUM == nil) {
//        [dataDict setObject:null forKey:@"file_longitude"];
//    }else{
//        [dataDict setObject:MAP_LONGNUM forKey:@"file_longitude"];
//    }
//    //    纬度
//    if (MAP_LUAITNUM == nil) {
//        [dataDict setObject:null forKey:@"file_latitude"];
//    }else{
//        [dataDict setObject:MAP_LUAITNUM forKey:@"file_latitude"];
//    }
//    //    离线
//    [dataDict setObject:@(0) forKey:@"file_offline"];
//    //    是否超时
//    
//    return dataDict;
//}
////-----------------------------------------------------------------------
////---------------------------------------------------------------------------
////-------------------------------------------------------------------------------
///**
// 储存事件信息    与项目绑定
// 
// @param itemDict 项目信息
// @param deviceDict 设备信息
// @param schDict 计划信息
// @return <#return value description#>
// */
//-(NSDictionary *)keepEvent_items:(NSDictionary *)itemDict deviceDict:(NSDictionary *)deviceDict schDict:(NSDictionary *)schDict
//{
//    NSDictionary * dict = [self eventRecord_items:itemDict deviceDict:deviceDict schDict:schDict];
//    //   添加到数据库
//    DataBaseManager * db = [DataBaseManager shareInstance];
//    [db insertTbName:@"allKind_record" dict:dict];
//    [db dbclose];
//    return dict;
//}
///**
// 储存事件信息    与项目绑定
//
// @param itemDict 项目信息
// @param deviceDict 设备信息
// @param schDict 计划信息
// @return <#return value description#>
// */
//-(NSDictionary *)eventRecord_items:(NSDictionary *)itemDict deviceDict:(NSDictionary *)deviceDict schDict:(NSDictionary *)schDict
//{
//    NSNull * null = [[NSNull alloc]init];
//    NSMutableDictionary * eventMulDict = [[NSMutableDictionary alloc]init];
//    //    设备名
//    [eventMulDict setObject:deviceDict[@"device_name"] forKey:@"record_device_name"];
//    //   当前用户
//    [eventMulDict setObject:[USERDEFAULT valueForKey:NAMEING] forKey:@"user_name"];
//    //  消息记录uuid
//    [eventMulDict setObject:deviceDict[@"record_uuid"] forKey:@"record_uuid"];
//    //   发送状态
//    [eventMulDict setObject:@([deviceDict[@"record_state"] intValue]) forKey:@"record_state"];
//    //   检查项uuid(事件使用)
//    [eventMulDict setObject:itemDict[@"items_uuid"] forKey:@"items_uuid"];
//    //   线路ID
//    [eventMulDict setObject:schDict[@"site_id"] forKey:@"record_site_id"];
//    //   班次ID
//    NSDictionary * shiftdic = [USERDEFAULT valueForKey:SHIFT_DICT];
//    [eventMulDict setObject:shiftdic[@"shift_id"] forKey:@"record_shift_id"];
//    //    计划ID
//    [eventMulDict setObject:schDict[@"sch_id"] forKey:@"record_sch_id"];
//    //    计划开始结束时间
//    [eventMulDict setObject:schDict[@"start_time"] forKey:@"record_sch_start_time"];
//    [eventMulDict setObject:schDict[@"end_time"] forKey:@"record_sch_end_time"];
//    //    记录类型   根据设备表中的类型判断上传字段
//    [eventMulDict setObject:@"EVENT" forKey:@"record_category"];
//    //    设备识别码
//    [eventMulDict setObject:deviceDict[@"device_mark"] forKey:@"record_device_mark"];
//    //    卡号
//    //    [recordDict setObject:devicedict[@"device_mark"] forKey:@"record_content"];
//    //    读点时间
//    [eventMulDict setObject:[ToolModel achieveNowTime] forKey:@"record_scantime"];
//    //    定位时间
//    if (MAP_TIME == nil) {
//        [eventMulDict setObject:null forKey:@"record_gps_time"];
//    }else{
//        [eventMulDict setObject:MAP_TIME forKey:@"record_gps_time"];
//    }
//    //    定位类型
//    [eventMulDict setObject:@"GPS" forKey:@"record_location_category"];
//    //    经度
//    if (MAP_LONGNUM == nil) {
//        [eventMulDict setObject:null forKey:@"record_longitude"];
//    }else{
//        [eventMulDict setObject:MAP_LONGNUM forKey:@"record_longitude"];
//    }
//    //    纬度
//    if (MAP_LUAITNUM == nil) {
//        [eventMulDict setObject:null forKey:@"record_latitude"];
//    }else{
//        [eventMulDict setObject:MAP_LUAITNUM forKey:@"record_latitude"];
//    }
//    //    离线数据
//    [eventMulDict setObject:@(0) forKey:@"record_offline"];
//    //    是否要求拍照
//    [eventMulDict setObject:@(0) forKey:@"record_must_photo"];
//    //    是否进行了拍照
//    [eventMulDict setObject:@(0) forKey:@"record_photo_flag"];
//    //    照片名
//    //    [recordDict setObject:strNil forKey:@"photo_name"];
//    //    是否超时
//    if ([self schIsLongTime:schDict]) {
//        [eventMulDict setObject:@(1) forKey:@"record_overdue"];
//    }else{
//        [eventMulDict setObject:@(0) forKey:@"record_overdue"];
//    }
//    //     设备状态
//    [eventMulDict setObject:deviceDict[@"device_state"] forKey:@"record_status"];
//    //    是否超出考核范围
//    [eventMulDict setObject:@([self deviceLocation:deviceDict]) forKey:@"record_gps_outside"];
//    
//    return eventMulDict;
//}
/**
 判断此设备时间是否超出计划
 
 @param sitedict <#sitedict description#>
 @return <#return value description#>
 */
-(BOOL)schIsLongTime:(NSDictionary *)sitedict
{
    NSDate *dates = [NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HHmm"];
    //   计算计划时间  （误差时间）
    NSTimeInterval interval = 60 * [sitedict[@"tolerance"] intValue];
    NSDate * endtime = [dateformatter dateFromString:sitedict[@"sch_end_time"]];
    NSDate *detea = [NSDate dateWithTimeInterval:interval sinceDate:endtime];
    NSComparisonResult result = [detea compare:dates];
    if ((result == NSOrderedAscending || result == NSOrderedSame)) {
        //   超时
        return YES;
    }else{
        //   正常
        return NO;
    }
}

/**
 判断是否超出误差范围
 
 @param devicedict 设备数据
 @return <#return value description#>
 */
-(int)deviceLocation:(NSDictionary *)devicedict;
{
    //   是否需要gps考核
    if ([devicedict[@"gps_check"] intValue] == 0) {
        //   不需要
        return 2;
    }else{
        //   需要
        if (devicedict[@"def_lat"]==nil || devicedict[@"def_lng"]==nil || [USERDEFAULT valueForKey:MAP_LUAITNUM]==nil || [USERDEFAULT valueForKey:MAP_LONGNUM]==nil) {
            return 3;
        }
        CLLocation *orig=[[CLLocation alloc] initWithLatitude:[devicedict[@"def_lat"] doubleValue]  longitude:[devicedict[@"def_lng"] doubleValue]];
        CLLocation* dist=[[CLLocation alloc] initWithLatitude:[[USERDEFAULT valueForKey:MAP_LUAITNUM] doubleValue] longitude:[[USERDEFAULT valueForKey:MAP_LONGNUM] doubleValue]];
        CLLocationDistance meters=[orig distanceFromLocation:dist];
        if (meters > [devicedict[@"gps_range"] intValue]) {
            return 1;
        }else{
            return 0;
        }
    }
}

@end
