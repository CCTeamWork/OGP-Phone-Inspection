//
//  RecordKeepModel.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/21.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "RecordKeepModel.h"
#import <MapKit/MapKit.h>
#import "DataBaseManager.h"
@implementation RecordKeepModel


/**
 集成住记录字典
 
 @param type 记录类型
 @param schDict 线路数据
 @param deviceDict 设备数据
 @param itemsDict 项目数据
 @param cheatDict 防作弊数据
 @return 住记录
 */
+(NSDictionary *)recordKeep_recordType:(NSString *)type
                               schDict:(NSDictionary *)schDict
                            deviceDict:(NSDictionary *)deviceDict
                             itemsDict:(NSDictionary *)itemsDict
                          generateType:(int)generateType
                             cheatDict:(NSDictionary *)cheatDict
{
    NSDictionary * dict = [RecordKeepModel record_recordType:type schDict:schDict deviceDict:deviceDict itemsDict:itemsDict generateType:generateType cheatDict:cheatDict];
    DataBaseManager * db = [DataBaseManager shareInstance];
    [db insertTbName:@"allkind_record" dict:dict];
    return dict;
}
/**
 集成住记录字典

 @param type 记录类型
 @param schDict 线路数据
 @param deviceDict 设备数据
 @param itemsDict 项目数据
 @param cheatDict 防作弊数据
 @return 住记录
 */
+(NSDictionary *)record_recordType:(NSString *)type
                           schDict:(NSDictionary *)schDict
                        deviceDict:(NSDictionary *)deviceDict
                         itemsDict:(NSDictionary *)itemsDict
                      generateType:(int)generateType
                         cheatDict:(NSDictionary *)cheatDict
{
//    DataBaseManager * db = [DataBaseManager shareInstance];
    NSNull * null = [[NSNull alloc]init];
    NSMutableDictionary * mulDict = [[NSMutableDictionary alloc]init];
    //  如果是设备  使用制作的
    if ([type isEqualToString:@"PATROL"]) {
        [mulDict setObject:deviceDict[@"record_uuid"] forKey:@"record_uuid"];
        [mulDict setObject:deviceDict[@"data_uuid"] forKey:@"data_uuid"];
    }else{
        //   记录唯一id
        [mulDict setObject:[ToolModel uuid] forKey:@"record_uuid"];
        //   防作弊流uuid
        [mulDict setObject:[ToolModel uuid] forKey:@"data_uuid"];
    }
    //   判断设备是由哪种方式进入
    [mulDict setObject:@(generateType) forKey:@"record_generate_type"];
    //   事件与项目关联id
    if(itemsDict != nil){
        [mulDict setObject:itemsDict[@"items_uuid"] forKey:@"items_uuid"];
    }else{
        [mulDict setObject:null forKey:@"items_uuid"];
    }
    //   当前用户
    [mulDict setObject:[USERDEFAULT valueForKey:NAMEING] forKey:@"user_name"];
    //   发送状态
    [mulDict setObject:@(0) forKey:@"record_state"];
    //   当前时间  （记录储存时间）
    [mulDict setObject:[ToolModel achieveNowTime] forKey:@"record_scantime"];
    //   定位信息
    if ([[USERDEFAULT valueForKey:MAP_TIME] length] != 0) {
        [mulDict setObject:[NSString stringWithFormat:@"%@",[USERDEFAULT valueForKey:MAP_TIME]] forKey:@"record_gps_time"];
    }else{
//        [mulDict setObject:null forKey:@"record_gps_time"];
    }
    if ([[USERDEFAULT valueForKey:MAP_LONGNUM] intValue] != 0) {
        [mulDict setObject:[NSString stringWithFormat:@"%@",[USERDEFAULT valueForKey:MAP_LONGNUM]] forKey:@"record_longitude"];
    }else{
//        [mulDict setObject:null forKey:@"record_longitude"];
    }
    if ([[USERDEFAULT valueForKey:MAP_LUAITNUM] intValue] != 0) {
        [mulDict setObject:[NSString stringWithFormat:@"%@",[USERDEFAULT valueForKey:MAP_LUAITNUM]] forKey:@"record_latitude"];
    }else{
//        [mulDict setObject:null forKey:@"record_latitude"];
    }
    [mulDict setObject:@"GPS" forKey:@"record_location_category"];
    //  离线数据
    [mulDict setObject:@([[USERDEFAULT valueForKey:OFFLINE] intValue]) forKey:@"record_offline"];
    //   记录类型
    [mulDict setObject:type forKey:@"record_category"];

    
    //   如果是设备信息
    if (deviceDict != nil) {
        //   设备名
        [mulDict setObject:deviceDict[@"device_name"] forKey:@"record_device_name"];
        //   线路id
        [mulDict setObject:@([schDict[@"site_id"] intValue]) forKey:@"record_site_id"];
        //    计划id
        [mulDict setObject:@([schDict[@"sch_id"] intValue]) forKey:@"record_sch_id"];
        //    计划开始结束时间
        NSString * startStr = [[NSString stringWithFormat:@"%@",schDict[@"send_task_start_time"]] substringToIndex:16];
        NSString * endStr = [[NSString stringWithFormat:@"%@",schDict[@"send_task_end_time"]] substringToIndex:16];
        [mulDict setObject:startStr forKey:@"record_sch_start_time"];
        [mulDict setObject:endStr forKey:@"record_sch_end_time"];
        //   设备识别码
        [mulDict setObject:deviceDict[@"device_mark"] forKey:@"record_device_mark"];
        //   设备状态
        [mulDict setObject:deviceDict[@"device_state"] forKey:@"record_status"];
        //   是否超出巡检范围
        [mulDict setObject:@([RecordKeepModel deviceLocation:deviceDict]) forKey:@"record_gps_outside"];
        //   设备巡检状态
        [mulDict setObject:@(0) forKey:@"patrol_state"];
    }else{
        //   设备名
        [mulDict setObject:null forKey:@"record_device_name"];
        //   线路id
        [mulDict setObject:null forKey:@"record_site_id"];
        //    计划id
        [mulDict setObject:null forKey:@"record_sch_id"];
        //    计划开始结束时间
        [mulDict setObject:null forKey:@"record_sch_start_time"];
        [mulDict setObject:null forKey:@"record_sch_end_time"];
        //   设备识别码
        [mulDict setObject:null forKey:@"record_device_mark"];
        //   设备状态
        [mulDict setObject:null forKey:@"record_status"];
        //   是否超出巡检范围
        [mulDict setObject:null forKey:@"record_gps_outside"];
        //   设备巡检状态
        [mulDict setObject:null forKey:@"patrol_state"];
    }
    //    班次id
     NSDictionary * shiftdic = [USERDEFAULT valueForKey:SHIFT_DICT];
    //    上传时需要的班次始末时间
    NSDictionary * shiftTimeDict = [USERDEFAULT valueForKey:[NSString stringWithFormat:@"shift%d",[shiftdic[@"shift_id"] intValue]]];

    if (shiftdic != nil) {  //  也许是登陆等信息 没有班次
        if (schDict[@"sch_shift_id"] != nil) {
            //   若果是设备信息  使用真实的班次
            [mulDict setObject:@([schDict[@"sch_shift_id"] intValue]) forKey:@"record_shift_id"];
        }else{
            [mulDict setObject:@([shiftdic[@"shift_id"] intValue]) forKey:@"record_shift_id"];
        }
        //   班次开始时间
        NSString * startStr = [[NSString stringWithFormat:@"%@",shiftTimeDict[@"send_shift_start_time"]] substringToIndex:16];
        [mulDict setObject:startStr forKey:@"record_shift_starttime"];
    }else{
        [mulDict setObject:null forKey:@"record_shift_id"];
        //   班次开始时间
        [mulDict setObject:null forKey:@"record_shift_starttime"];
    }
    
    //   如果是设备信息
    if ([type isEqualToString:@"PATROL"]) {
        //  如果是扫码进入 有防作弊信息
        if (cheatDict[@"record_content"] != nil) {
            [mulDict setObject:[NSString stringWithFormat:@"QR:%@",cheatDict[@"record_content"]] forKey:@"record_content"];
        }else{
            [mulDict setObject:[NSString stringWithFormat:@"QR:%@",deviceDict[@"device_number_qr"]] forKey:@"record_content"];
        }
    }else if ([type isEqualToString:@"EVENT"]) {
        if (cheatDict[@"record_content"] != nil) {
            [mulDict setObject:cheatDict[@"record_content"] forKey:@"record_content"];
        }else{
            [mulDict setObject:itemsDict[@"items_name"] forKey:@"record_content"];
        }
    }else{
        [mulDict setObject:null forKey:@"record_content"];
    }
    
    if (cheatDict != nil) {
        [mulDict setObject:@([cheatDict[@"must_photo"] intValue]) forKey:@"record_must_photo"];
        [mulDict setObject:@([cheatDict[@"photo_flag"] intValue]) forKey:@"record_photo_flag"];
        if (cheatDict[@"photo_name"] != nil) {
            [mulDict setObject:cheatDict[@"photo_name"] forKey:@"photo_name"];
        }else{
            [mulDict setObject:null forKey:@"photo_name"];
        }
    }else{
        [mulDict setObject:null forKey:@"record_must_photo"];
        [mulDict setObject:null forKey:@"record_photo_flag"];
    }
    
    //   是否超时
    if (schDict != nil) {
        if ([RecordKeepModel schIsLongTime:schDict]) {
            [mulDict setObject:@(1) forKey:@"record_overdue"];
        }else{
            [mulDict setObject:@(0) forKey:@"record_overdue"];
        }
        //   第几次巡检
        [mulDict setObject:@([schDict[@"same_sch_seq"] intValue]) forKey:@"record_sch_seq"];
    }else{
        [mulDict setObject:null forKey:@"record_overdue"];
        [mulDict setObject:null forKey:@"record_sch_seq"];
    }
    //   与事件关联设备号
    if (cheatDict[@"event_device_code"] != nil) {
        [mulDict setObject:[NSString stringWithFormat:@"QR:%@",cheatDict[@"event_device_code"]] forKey:@"event_device_code"];
    }else{
        [mulDict setObject:null forKey:@"event_device_code"];
    }
    return mulDict;
}
/**
 判断此设备时间是否超出计划
 
 @param sitedict <#sitedict description#>
 @return <#return value description#>
 */
+(BOOL)schIsLongTime:(NSDictionary *)sitedict
{
    NSDate *dates = [NSDate date];
    
    long stmptime = [dates timeIntervalSince1970];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:stmptime];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    NSTimeInterval interval = [destinationTimeZone secondsFromGMT];
    NSDate * localDate = [detaildate dateByAddingTimeInterval:interval];

    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //   计算计划时间  （误差时间）
    NSTimeInterval intervals = 60 * [sitedict[@"tolerance"] intValue];
//    NSDate * endtime = [dateformatter dateFromString:sitedict[@"send_task_end_time"]];
    NSDate * date = [[NSDate alloc]init];
    if ([sitedict[@"send_task_end_time"] isKindOfClass:[NSString class]]) {
        date = [dateformatter dateFromString:sitedict[@"send_task_end_time"]];
    }else{
        date = sitedict[@"send_task_end_time"];
    }
    NSDate *detea = [NSDate dateWithTimeInterval:intervals sinceDate:date];
//    NSComparisonResult result = [detea compare:localDate];
    if (localDate > detea) {
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
+(int)deviceLocation:(NSDictionary *)devicedict;
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
/**
 集成项目信息记录
 
 @param schDict 计划数据
 @param deviceDict 设备数据
 @param itemsDict 项目数据
 @return 项目信息
 */
+(NSDictionary *)itemsKeep_schDict:(NSDictionary *)schDict deviceDict:(NSDictionary *)deviceDict itemsDict:(NSDictionary *)itemsDict
{
    NSDictionary * dict = [RecordKeepModel items_schDict:schDict deviceDict:deviceDict itemsDict:itemsDict];
    DataBaseManager * db = [DataBaseManager shareInstance];
    [db insertTbName:@"itemskind_record" dict:dict];
    return dict;
}
/**
 集成项目信息记录

 @param schDict 计划数据
 @param deviceDict 设备数据
 @param itemsDict 项目数据
 @return 项目信息
 */
+(NSDictionary *)items_schDict:(NSDictionary *)schDict deviceDict:(NSDictionary *)deviceDict itemsDict:(NSDictionary *)itemsDict
{
    NSNull * null = [[NSNull alloc]init];
    NSMutableDictionary * mulDict = [[NSMutableDictionary alloc]init];
    //   与事件关联id
    [mulDict setObject:itemsDict[@"items_uuid"] forKey:@"items_uuid"];
    //   与设备关联id
    [mulDict setObject:deviceDict[@"record_uuid"] forKey:@"record_uuid"];
    //   项目本身流关联id
    [mulDict setObject:itemsDict[@"data_uuid"] forKey:@"data_uuid"];
    //   检查项id
    [mulDict setObject:@([itemsDict[@"items_id"] intValue]) forKey:@"items_id"];
    //   是否超时
    if([RecordKeepModel schIsLongTime:schDict]){
        [mulDict setObject:@(1) forKey:@"items_overdue"];
    }else{
        [mulDict setObject:@(0) forKey:@"items_overdue"];
    }
    //   是否漏检
    [mulDict setObject:@([itemsDict[@"items_finish_state"] intValue]) forKey:@"items_miss"];
    //  是否离线
    [mulDict setObject:@([[USERDEFAULT valueForKey:OFFLINE] intValue]) forKey:@"items_offline"];
    //    检查项类型
    if (itemsDict[@"category"] == nil) {
        [mulDict setObject:@([itemsDict[@"items_category"] intValue]) forKey:@"items_category"];
    }else{
        [mulDict setObject:@([itemsDict[@"category"] intValue]) forKey:@"items_category"];
    }
    //   检查项值
    if(itemsDict[@"items_value"] != nil){
        [mulDict setObject:itemsDict[@"items_value"] forKey:@"items_value"];
    }else{
        [mulDict setObject:null forKey:@"items_value"];
    }
    //   当前时间
    [mulDict setObject:[ToolModel achieveNowTime] forKey:@"items_scantime"];
    //   定位信息
    if ([[USERDEFAULT valueForKey:MAP_TIME] length] != 0) {
        [mulDict setObject:[NSString stringWithFormat:@"%@",[USERDEFAULT valueForKey:MAP_TIME]] forKey:@"items_gps_time"];
    }else{
//        [mulDict setObject:null forKey:@"items_gps_time"];
    }
    if ([[USERDEFAULT valueForKey:MAP_LONGNUM] intValue] != 0) {
        [mulDict setObject:[NSString stringWithFormat:@"%@",[USERDEFAULT valueForKey:MAP_LONGNUM]] forKey:@"items_longitude"];
    }else{
//        [mulDict setObject:null forKey:@"items_longitude"];
    }
    if ([[USERDEFAULT valueForKey:MAP_LUAITNUM] intValue] != 0) {
        [mulDict setObject:[NSString stringWithFormat:@"%@",[USERDEFAULT valueForKey:MAP_LUAITNUM]] forKey:@"items_latitude"];
    }else{
//        [mulDict setObject:null forKey:@"items_latitude"];
    }
    [mulDict setObject:@"GPS" forKey:@"items_location_category"];
    //  检查项状态
    if([itemsDict[@"items_state"] intValue] == 0){
        [mulDict setObject:@"normal" forKey:@"items_status"];
    }else{
        [mulDict setObject:@"disable" forKey:@"items_status"];
    }
    //   检查结果是否正常
    [mulDict setObject:@([itemsDict[@"items_value_status"] intValue]) forKey:@"items_value_status"];

    return mulDict;
}


/**
 集成流记录信息
 
 @param recordDict 关联流记录的主信息
 @param schDict 计划数据
 @param dataDict 流数据
 @param dataType 流类型
 @return 流数据
 */
+(NSDictionary *)dataKeep_recordDict:(NSDictionary *)recordDict schDict:(NSDictionary *)schDict dataDict:(NSDictionary *)dataDict dataType:(NSString *)dataType
{
    NSDictionary * dict = [RecordKeepModel data_recordDict:recordDict schDict:schDict dataDict:dataDict dataType:dataType];
    DataBaseManager * db = [DataBaseManager shareInstance];
    [db insertTbName:@"data_record" dict:dict];
//    DataBaseManager * db = [DataBaseManager shareInstance];
    return dict;
}
/**
 集成流记录信息

 @param recordDict 关联流记录的主信息
 @param schDict 计划数据
 @param dataDict 流数据
 @param dataType 流类型
 @return 流数据
 */
+(NSDictionary *)data_recordDict:(NSDictionary *)recordDict schDict:(NSDictionary *)schDict dataDict:(NSDictionary *)dataDict dataType:(NSString *)dataType
{
//    NSNull * null = [[NSNull alloc]init];
    NSMutableDictionary * mulDict  = [[NSMutableDictionary alloc]init];
    //  数据流位置］
    if (dataDict[@"content_path"] != nil) {
        [mulDict setObject:dataDict[@"content_path"] forKey:@"content_path"];
    }
    //   记录中需要展示的信息
    if (dataDict[@"data_record_show"] != nil) {
        [mulDict setObject:dataDict[@"data_record_show"] forKey:@"data_record_show"];
    }
    //   与住记录关联id

    [mulDict setObject:recordDict[@"data_uuid"] forKey:@"data_uuid"];
    //    数据类型
    [mulDict setObject:dataType forKey:@"event_category"];
    //    流数据名称
    [mulDict setObject:dataDict[@"file_name"] forKey:@"file_name"];
    //   读点时间
    [mulDict setObject:[ToolModel achieveNowTime] forKey:@"file_scantime"];
    //   定位信息
    if ([[USERDEFAULT valueForKey:MAP_TIME] length] != 0) {
        [mulDict setObject:[NSString stringWithFormat:@"%@",[USERDEFAULT valueForKey:MAP_TIME]] forKey:@"file_gps_time"];
    }else{
//        [mulDict setObject:null forKey:@"file_gps_time"];
    }
    if ([[USERDEFAULT valueForKey:MAP_LONGNUM] intValue] != 0) {
        [mulDict setObject:[NSString stringWithFormat:@"%@",[USERDEFAULT valueForKey:MAP_LONGNUM]] forKey:@"file_longitude"];
    }else{
//        [mulDict setObject:null forKey:@"file_longitude"];
    }
    if ([[USERDEFAULT valueForKey:MAP_LUAITNUM] intValue] != 0) {
        [mulDict setObject:[NSString stringWithFormat:@"%@",[USERDEFAULT valueForKey:MAP_LUAITNUM]] forKey:@"file_latitude"];
    }else{
//        [mulDict setObject:null forKey:@"file_latitude"];
    }
    [mulDict setObject:@"GPS" forKey:@"file_location_category"];
    //  是否是离线数据
    [mulDict setObject:@([[USERDEFAULT valueForKey:OFFLINE] intValue]) forKey:@"file_offline"];
    //   是否超时
    if(schDict != nil){
        if ([RecordKeepModel schIsLongTime:schDict]) {
            [mulDict setObject:@(1) forKey:@"file_overdue"];
        }else{
            [mulDict setObject:@(0) forKey:@"file_overdue"];
        }
    }else{
        [mulDict setObject:@(0) forKey:@"file_overdue"];
    }
    //  流记录放松状态
    [mulDict setObject:@(0) forKey:@"data_state"];
    //   用户名
    [mulDict setObject:[USERDEFAULT valueForKey:NAMEING] forKey:@"user_name"];
    return mulDict;
}

/**
 集成防作弊流数据信息

 @param cheatDict 防作弊流数据
 @param recordDict 关联的住记录信息
 @return 防作弊数据
 */
+(NSDictionary *)cheat_cheatDict:(NSDictionary *)cheatDict recordDict:(NSDictionary *)recordDict
{
    NSMutableDictionary * mulDict = [[NSMutableDictionary alloc]init];
    //  数据流位置
    [mulDict setObject:cheatDict[@"content_path"] forKey:@"content_path"];
    //   图片名称
    [mulDict setObject:cheatDict[@"file_name"] forKey:@"file_name"];
    //   记录显示
    [mulDict setObject:cheatDict[@"data_record_show"] forKey:@"data_record_show"];
    //   与住记录关联id
    [mulDict setObject:recordDict[@"data_uuid"] forKey:@"data_uuid"];
    //   发送状态
    [mulDict setObject:@(0) forKey:@"cheat_state"];
    //  用户名
    [mulDict setObject:[USERDEFAULT valueForKey:NAMEING] forKey:@"user_name"];
    DataBaseManager * db = [DataBaseManager  shareInstance];
    [db insertTbName:@"cheat_record" dict:mulDict];
    return mulDict;
}
/**
 集成防作弊数据

 @param mustPhoto 是否要求拍照
 @param photoFlag 是否进行了拍照
 @param photoName 照片名
 @param recordcontent 二维码
 @return 防作弊数据
 */
+(NSDictionary *)cheat_mustPhoto:(int)mustPhoto photoFlag:(int)photoFlag photoName:(NSString *)photoName recordcontent:(NSString *)recordcontent eventDeviceCode:(NSString *)eventDeviceCode
{
    NSMutableDictionary * mulDict = [[NSMutableDictionary alloc]init];
    [mulDict setObject:@(mustPhoto) forKey:@"must_photo"];
    [mulDict setObject:@(photoFlag) forKey:@"photo_flag"];
    if (photoName != nil) {
        [mulDict setObject:photoName forKey:@"photo_name"];
    }
    if (recordcontent != nil) {
        [mulDict setObject:recordcontent forKey:@"record_content"];
    }
    //   与事件关联的设备号
    if (eventDeviceCode != nil) {
        [mulDict setObject:eventDeviceCode forKey:@"event_device_code"];
    }
    return mulDict;
}
@end
