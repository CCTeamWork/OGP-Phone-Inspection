 //
//  ProjectPost.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/5.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "ProjectPost.h"
#import "DataBaseManager.h"
#import "YYModel.h"
#import <MapKit/MapKit.h>
#import "DataBaseManager.h"
#import "ProjectTableViewCell.h"
#import "ItemsKindModel.h"
@implementation ProjectPost

/**
 获取设备下的项目数组

 @param devicedic 设备数据
 @return 项目数组
 */
-(NSArray *)itemsFromDevice:(NSDictionary *)devicedic
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    NSArray * itemsArray = [[NSArray alloc]init];
    NSMutableArray * itemsMulArray = [[NSMutableArray alloc]init];
    NSMutableArray * itemMulArr = [[NSMutableArray alloc]init];
    //   如果本次巡检 没有检查过此设备
    if ([USERDEFAULT valueForKey:devicedic[@"record_uuid"]] == nil) {
        //   查询数据库中的  此设备下的项目
        //   如果此设备参考设备类
        if ([devicedic[@"modify_flag"] intValue] == 1) {
            NSArray  *array = [devicedic[@"items_ids"] componentsSeparatedByString:@","];
            
            for (NSString * itemid in array) {
                itemsArray = [db selectSomething:@"items_record" value:[NSString stringWithFormat:@"items_id = %d and device_status_code like '%%%@%%'",[itemid intValue],devicedic[@"device_state"]] keys:[ToolModel allPropertyNames:[ItemsModel class]] keysKinds:[ToolModel allPropertyAttributes:[ItemsModel class]]];
                if (itemsArray.count != 0) {
                    [itemMulArr addObject:itemsArray[0]];
                }
            }
            itemsArray = itemMulArr;
        }else{
            //   不参考设备类
            itemsArray = [db selectSomething:@"device_items_record" value:[NSString stringWithFormat:@"site_device_id = %d and device_status_code like '%%%@%%'",[devicedic[@"site_device_id"] intValue],devicedic[@"device_state"]] keys:[ToolModel allPropertyNames:[DeviceItemModel class]] keysKinds:[ToolModel allPropertyAttributes:[DeviceItemModel class]]];
        }
        //  判断已经发送的数据中是否有这此设备的检查项的数据  如果有说明是重新下载过
        NSArray * sendItemsArray = [db selectSomething:@"itemskind_record" value:[NSString stringWithFormat:@"record_uuid = '%@'",devicedic[@"record_uuid"]] keys:[ToolModel allPropertyNames:[ItemsKindModel class]] keysKinds:[ToolModel allPropertyNames:[ItemsKindModel class]]];
        
        for (NSDictionary * itemdict in itemsArray) {
            NSMutableDictionary * muldict = [NSMutableDictionary dictionaryWithDictionary:itemdict];
            //   项目完成状态
            [muldict setObject:@(0) forKey:@"items_finish_state"];
            //    项目完成结果
            [muldict setObject:@"" forKey:@"items_value"];
            //    检查项状态
            [muldict setObject:@(1) forKey:@"items_state"];
            //    检查项结果是否正常
            [muldict setObject:@(1) forKey:@"items_value_status"];
            //    项目record_uuid
            [muldict setObject:devicedic[@"record_uuid"] forKey:@"record_uuid"];
            //    项目与事件关联 uuid
            [muldict setObject:[ToolModel uuid] forKey:@"items_uuid"];
            //   与流记录关联id
            [muldict setObject:[ToolModel uuid] forKey:@"data_uuid"];
            
            [itemsMulArray addObject:muldict];
            
            //  遍历已经发送的检查项数据
            for (NSDictionary * sendItemDict in sendItemsArray) {
                //   如果是这个检查项
                if ([itemdict[@"items_id"] intValue] == [sendItemDict[@"items_id"] intValue]) {
                    [itemsMulArray removeObject:muldict];
                    
                    NSMutableDictionary * muldict = [NSMutableDictionary dictionaryWithDictionary:itemdict];
                    //   项目完成状态
                    [muldict setObject:@(1) forKey:@"items_finish_state"];
                    //    项目完成结果
                    [muldict setObject:sendItemDict[@"items_value"] forKey:@"items_value"];
                    //    检查项状态
                    [muldict setObject:@(1) forKey:@"items_state"];
                    //    检查项结果是否正常
                    [muldict setObject:@([sendItemDict[@"items_value_status"] intValue]) forKey:@"items_value_status"];
                    //    项目record_uuid
                    [muldict setObject:devicedic[@"record_uuid"] forKey:@"record_uuid"];
                    //    项目与事件关联 uuid
                    [muldict setObject:sendItemDict[@"items_uuid"] forKey:@"items_uuid"];
                    //   与流记录关联id
                    [muldict setObject:sendItemDict[@"data_uuid"] forKey:@"data_uuid"];
                    
                    [itemsMulArray addObject:muldict];
                }
            }
        }
        if (itemsMulArray.count != 0) {
             [USERDEFAULT setObject:itemsMulArray forKey:devicedic[@"record_uuid"]];
        }
        
        itemsMulArray = [USERDEFAULT valueForKey:devicedic[@"record_uuid"]];
        
        //   此设备之前巡检了
    }else{
        itemsMulArray = [USERDEFAULT valueForKey:devicedic[@"record_uuid"]];
    }
    return itemsMulArray;
}
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

/**
 判断巡检项是否漏检

 @param kindCell 当前cell
 @param projectdict 巡检项信息
 @return 是否漏检
 */
-(int)projectIsMiss:(ProjectTableViewCell *)kindCell projectdict:(NSDictionary *)projectdict
{
    switch ([projectdict[@"category"] intValue]) {
        case 0:
            if (kindCell.finishStr.length == 0) {
                return 1;
            }
            return 0;
            break;
        case 1:
            if (kindCell.finishStr.length == 0) {
                return 1;
            }
            return 0;
            break;
        case 2:
            if (kindCell.finishStr.length == 0) {
                return 1;
            }
            return 0;
            break;
        case 3:
            if (kindCell.finishStr.length == 0) {
                return 1;
            }
            return 0;
            break;
        case 4:
            if (kindCell.finishStr.length == 0) {
                return 1;
            }
            return 0;
            break;
        case 5:
            if (kindCell.pickerImageArray.count == 0) {
                return 1;
            }
            return 0;
            break;
        case 6:
            if (kindCell.soundArray.count == 0) {
                return 1;
            }
            return 0;
            break;
        case 7:
            if (kindCell.signatureImage.image == nil) {
                return 1;
            }
            return 0;
            break;
        case 9:
            if (kindCell.finishStr.length == 0) {
                return 1;
            }
            return 0;
            break;
        case 10:
            if (kindCell.finishStr.length == 0) {
                return 1;
            }
            return 0;
            break;
        default:
            break;
    }
    return 0;
}

/**
 查询当前信息记录表

 @param devicedict 设备信息
 @return <#return value description#>
 */
-(NSDictionary *)deviceRecordDict:(NSDictionary *)devicedict
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    NSArray * array = [db selectSomething:@"allkind_record" value:[NSString stringWithFormat:@"record_uuid = '%@'",devicedict[@"record_uuid"]] keys:[ToolModel allPropertyNames:[AllKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[AllKindModel class]]];
    [db dbclose];
    if (array.count != 0) {
        return array[0];
    }
    return nil;
}
/**
 更新当前计划的设备数据  巡检状态和完成数量
 
 @param sitedict 线路字典
 @param devicedict 设备字典
 @param isfinish 是否是最后一项
 */
-(void)updateDeviceArray:(NSDictionary *)sitedict deviceDic:(NSDictionary *)devicedict isfinish:(BOOL)isfinish
{
    //   获取到所有计划和设备内容
    NSArray * schSiteArray = [USERDEFAULT valueForKey:SCH_SITE_DEVICE_ARRAY];
    //   将所有内容转换为可变数组
    NSMutableArray * mulsiteArray = [[NSMutableArray alloc]init];
    //   遍历计划   得到当前计划
    for (NSDictionary * schDict in schSiteArray) {
        //    如果是当前计划
        if ([schDict[@"sch_id"] intValue] == [sitedict[@"sch_id"] intValue] && [schDict[@"same_sch_seq"] intValue] == [sitedict[@"same_sch_seq"] intValue] && [schDict[@"sch_shift_id"] intValue] == [sitedict[@"sch_shift_id"] intValue]) {
            //   取得当前计划的设备数组
            NSArray * devicearr = schDict[@"device_array"];
            //   将当前计划的设备数组 变为可变数组
            NSMutableArray * mulArray = [[NSMutableArray alloc]init];
            //   遍历设备数组
            for (NSDictionary * devicedic in devicearr) {
                //   如果是当前设备
                if ([devicedic[@"site_device_id"] intValue] == [devicedict[@"site_device_id"] intValue]) {
                    //   改变当前设备状态
                    //   将改变之后的设备  添加到设备数组中
                    [mulArray addObject:[self makeChangeDict:devicedic isfinish:isfinish now:YES issch:NO mulArray:nil]];
                }else{
                    //   不是当前设备  直接添加到设备数组中
                    [mulArray addObject:[self makeChangeDict:devicedic isfinish:isfinish now:NO issch:NO mulArray:nil]];
                }
            }
            //   将当前计划的可变字典  添加到计划的数组中
            [mulsiteArray addObject:[self makeChangeDict:schDict isfinish:NO now:YES issch:YES mulArray:mulArray]];
        }else{
            //   不是当前计划的字典  直接添加到计划中
            [mulsiteArray addObject:[self makeChangeDict:schDict isfinish:NO now:NO issch:YES mulArray:nil]];
        }
    }
    //   将改变后的数据储存
    [USERDEFAULT setObject:mulsiteArray forKey:SCH_SITE_DEVICE_ARRAY];
}

/**
 改变巡检状态和完成数

 @param dict 要改变状态的字典
 @param isfinish 完成数量
 @return <#return value description#>
 */
-(NSDictionary *)makeChangeDict:(NSDictionary *)dict isfinish:(BOOL)isfinish now:(BOOL)now  issch:(BOOL)issch mulArray:(NSArray *)mulArray
{
    NSMutableDictionary * muldict = [NSMutableDictionary dictionaryWithDictionary:dict];
    DataBaseManager * db = [DataBaseManager shareInstance];
    //   如果是设备
    if (!issch) {
        if (now) {
            if ([muldict[@"patrol_state"] intValue] == 0 || [muldict[@"patrol_state"] intValue] == 2) {
                [db updateSomething:@"allkind_record" key:@"patrol_state" value:@"1" sql:[NSString stringWithFormat:@"record_uuid = '%@'",muldict[@"record_uuid"]]];
                [muldict setObject:@(1) forKey:@"patrol_state"];
            }
            if (isfinish) {
                [db updateSomething:@"allkind_record" key:@"patrol_state" value:@"3" sql:[NSString stringWithFormat:@"record_uuid = '%@'",muldict[@"record_uuid"]]];
                [muldict setObject:@(3) forKey:@"patrol_state"];
            }
        }else{
            if ([muldict[@"patrol_state"] intValue] == 1) {
                [db updateSomething:@"allkind_record" key:@"patrol_state" value:@"2" sql:[NSString stringWithFormat:@"record_uuid = '%@'",muldict[@"record_uuid"]]];
                [muldict setObject:@(2) forKey:@"patrol_state"];
            }
        }
    }else{//   如果是线路
        if (now) {
            if ([muldict[@"sch_state"] intValue] == 0 || [muldict[@"sch_state"] intValue] == 2) {
                [muldict setObject:@(1) forKey:@"sch_state"];
            }
            [muldict setObject:mulArray forKey:@"device_array"];
        }else{
            if ([muldict[@"sch_state"] intValue] == 1) {
                [muldict setObject:@(2) forKey:@"sch_state"];
            }
        }
    }
    return muldict;
}
/**
 更新巡检项结果
 
 @param itemsValue 结果
 @param valueStatus 结果状态
 @param itemsStatus 巡检项状态
 @param itemFinishStatus  是否漏检
 @param itemsDict  巡检项字典
 @return 巡检项数据
 */
-(NSDictionary *)updateItems:(NSString *)itemsValue
                 valueStatus:(int)valueStatus
                 itemsStatus:(int)itemsStatus
            itemFinishStatus:(int)itemFinishStatus
                    itemsDic:(NSDictionary *)itemsDict
{
    NSMutableDictionary * muldict = [NSMutableDictionary dictionaryWithDictionary:itemsDict];
    //   结果（除了数据流）
    if (itemsValue.length == 0) {
        [muldict setObject:@"" forKey:@"items_value"];
    }else{
        [muldict setObject:itemsValue forKey:@"items_value"];
    }
    //   结果是否正常
    [muldict setObject:@(valueStatus) forKey:@"items_value_status"];
    //   是否漏检
    [muldict setObject:@(itemFinishStatus) forKey:@"items_finish_state"];
    //    检查项状态
    [muldict setObject:@(itemsStatus) forKey:@"items_state"];
    
    NSArray * itemsArray = [USERDEFAULT valueForKey:itemsDict[@"record_uuid"]];
    NSMutableArray * mulArray = [[NSMutableArray alloc]init];
    for (NSDictionary * itemdict in itemsArray) {
        if ([itemdict[@"items_id"] intValue] == [muldict[@"items_id"] intValue]) {
            [mulArray addObject:muldict];
        }else{
            [mulArray addObject:itemdict];
        }
    }
    return muldict;
}

/**
 翻页或修改巡检项时   如果没有数据  直接保存数据   如果有数据  更新巡检项数据

 @param itemsDict 当前巡检项（来自items_record）
 */
-(void)nextOrFinishItems:(NSDictionary *)itemsDict deviceDict:(NSDictionary *)deviceDict schDict:(NSDictionary *)schDict projectCell:(ProjectTableViewCell *)projectCell
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    //   查询当前检查项的巡检内容
    NSArray * itemsArray = [db selectSomething:@"itemskind_record" value:[NSString stringWithFormat:@"record_uuid = '%@' and items_id = %d",itemsDict[@"record_uuid"],[itemsDict[@"items_id"] intValue]] keys:[ToolModel allPropertyNames:[ItemsKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[ItemsKindModel class]]];
    //   如果没有数据  直接添加
    if (itemsArray.count == 0) {
        //   项目是否漏检
        int i = [self projectIsMiss:projectCell projectdict:itemsDict];
        //   得到改变之后的字典（增加了完成状态  完成结果等） 并储存在user中
        NSDictionary * changeItemsDict = [self updateItems:projectCell.finishStr
                                               valueStatus:projectCell.finishi
                                               itemsStatus:0
                                          itemFinishStatus:i
                                                  itemsDic:itemsDict];
        //   储存项目数据准备上传
        [RecordKeepModel itemsKeep_schDict:schDict deviceDict:deviceDict itemsDict:changeItemsDict];
        //  储存流记录信息
        [self keepAllKindData_schDict:schDict projectCell:projectCell itemsRecordDict:changeItemsDict];
    }else{
        //   如果有数据  更新检查项表  并删除和添加data
        //   项目是否漏检
        int i = [self projectIsMiss:projectCell projectdict:itemsDict];
        //   得到改变之后的字典（增加了完成状态  完成结果等） 并储存在user中
        NSDictionary * changeItemsDict = [self updateItems:projectCell.finishStr
                                               valueStatus:projectCell.finishi
                                               itemsStatus:0
                                          itemFinishStatus:i
                                                  itemsDic:itemsDict];
        //   先集成当前项目的最新纪录
        NSDictionary * itemsRecordDict = [RecordKeepModel items_schDict:schDict deviceDict:deviceDict itemsDict:changeItemsDict];
        //   更新项目记录表(超时   漏检  离线  结果  时间  定位信息  状态  结果正常)
        [db updateMoreSomething:@"itemskind_record" updataSql:[NSString stringWithFormat:@"items_overdue = %d , items_miss = %d , items_offline = %d , items_value = '%@' , items_scantime = '%@' , items_gps_time = '%@' , items_longitude = '%@' , items_latitude = '%@' , items_status = '%@' , items_value_status = %d",[itemsRecordDict[@"items_overdue"] intValue],[itemsRecordDict[@"items_miss"] intValue],[itemsRecordDict[@"items_offline"] intValue],itemsRecordDict[@"items_value"],itemsRecordDict[@"items_scantime"],itemsRecordDict[@"items_gps_time"],itemsRecordDict[@"items_longitude"],itemsRecordDict[@"items_latitude"],itemsRecordDict[@"items_status"],[itemsRecordDict[@"items_value_status"] intValue]] whereSql:[NSString stringWithFormat:@"record_uuid = '%@' and items_id = %d",itemsDict[@"record_uuid"],[itemsDict[@"items_id"] intValue]]];
        //   查询当前项目的流数据
//        NSArray * dataArr = [db selectSomething:@"data_record" value:[NSString stringWithFormat:@"data_uuid = '%@'",itemsRecordDict[@"data_uuid"]] keys:[ToolModel allPropertyNames:[DataModel class]] keysKinds:[ToolModel allPropertyAttributes:[DataModel class]]];
        //   删除流数据
        [db deleteSomething:@"data_record" key:@"data_uuid" value:[NSString stringWithFormat:@"'%@'",itemsRecordDict[@"data_uuid"]]];
        //   删除当前项目的流数据
//        for (NSDictionary * dataDict in dataArr) {
//            if ([dataDict[@"event_category"] isEqualToString:@"PHOTO"] || [dataDict[@"event_category"] isEqualToString:@"HANDWRITE"]) {
//                //   删除照片
//                [ToolModel deleteFile:dataDict[@"content_path"]];
//            }else if ([dataDict[@"event_category"] isEqualToString:@"VOICE"])
//            {
//                //   删除录音
//                [self deleteSound:dataDict[@"content_path"]];
//            }
//        }
        //  储存流记录信息
        [self keepAllKindData_schDict:schDict projectCell:projectCell itemsRecordDict:itemsRecordDict];
    }
}

/**
 储存流数据信息

 @param schDict 计划信息
 @param projectCell 项目的cell
 */
-(void)keepAllKindData_schDict:(NSDictionary *)schDict projectCell:(ProjectTableViewCell *)projectCell itemsRecordDict:(NSDictionary *)itemsRecordDict
{
    int kind = 0;
    if (itemsRecordDict[@"items_category"] == nil) {
        kind = [itemsRecordDict[@"category"] intValue];
    }else{
        kind = [itemsRecordDict[@"items_category"] intValue];
    }
    //   储存项目关联的数据流
    //   集成文字信息字典
    NSDictionary * dict = @{@"file_name":projectCell.finishStr};
    switch (kind) {
        case 5:
            //   照片
            for (NSDictionary * dict in projectCell.pickerImageArray) {
                [RecordKeepModel dataKeep_recordDict:itemsRecordDict schDict:schDict dataDict:dict dataType:@"PHOTO"];
            }
            break;
        case 6:
            //   录音
            for (NSDictionary * dict in projectCell.soundArray) {
                [RecordKeepModel dataKeep_recordDict:itemsRecordDict schDict:schDict dataDict:dict dataType:@"VOICE"];
            }
            break;
        case 7:
            //   签名
            for (NSDictionary * dict in projectCell.signMulArray) {
                [RecordKeepModel dataKeep_recordDict:itemsRecordDict schDict:schDict dataDict:dict dataType:@"HANDWRITE"];
            }
            break;
        case 1:
            //   文字
            [RecordKeepModel dataKeep_recordDict:itemsRecordDict schDict:schDict dataDict:dict dataType:@"TEXT"];
            break;
        default:
            break;
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
 根据时间判断是否可以修改结果

 @param itemsDict 项目字典
 @return 是否
 */
+(NSString *)isChangeItmesValue:(NSDictionary *)itemsDict
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    ///  判断该设备是否已经完成了
    NSArray * array = [db selectSomething:@"allkind_record" value:[NSString stringWithFormat:@"record_uuid = '%@'",itemsDict[@"record_uuid"]] keys:[ToolModel allPropertyNames:[AllKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[AllKindModel class]]];
    if (array.count != 0) {
        NSDictionary * deviceDict = array[0];
        NSLog(@"%@",deviceDict);
        if ([deviceDict[@"patrol_state"] intValue] == 3) {
            return @"该设备已经巡检完成，不可更改数据！";
        }
    }
    NSArray * itemsRecordArray = [db selectSomething:@"itemskind_record" value:[NSString stringWithFormat:@"record_uuid = '%@' and items_id = %d",itemsDict[@"record_uuid" ],[itemsDict[@"items_id"] intValue]] keys:[ToolModel allPropertyNames:[ItemsKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[ItemsKindModel class]]];
    //  说明检查过
    if (itemsRecordArray.count != 0) {
        NSDateFormatter * input=[[NSDateFormatter alloc]init];
        [input setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *  senddate=[NSDate date];
        NSString *  locationString=[input stringFromDate:senddate];
        NSDate * date=[input dateFromString:locationString];
        NSDate * itemsDate = [input dateFromString:itemsRecordArray[0][@"items_scantime"]];
        
        NSTimeInterval time=[date timeIntervalSinceDate:itemsDate];
        int mon=((int)time)/(60);
        if (mon > 10) {
            return @"巡检间隔时间过长，不允许更改！";
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

/**
 根据项目查询出绑定的事件内容

 @param itemsDict 当前检查项
 @return 绑定的事件内容
 */
+(NSDictionary *)selectEventForItem:(NSDictionary *)itemsDict
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    //   先查询出跟此项目相关联的事件住记录
    NSArray * eventArray = [db selectSomething:@"allkind_record" value:[NSString stringWithFormat:@"items_uuid = '%@'",itemsDict[@"items_uuid"]] keys:[ToolModel allPropertyNames:[AllKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[AllKindModel class]]];
    //   根据事件的住记录data  查询出流数据
    NSArray * dataArray;
    if (eventArray.count != 0) {
        dataArray = [db selectSomething:@"data_record" value:[NSString stringWithFormat:@"data_uuid = '%@'",eventArray[0][@"data_uuid"]] keys:[ToolModel allPropertyNames:[DataModel class]] keysKinds:[ToolModel allPropertyAttributes:[DataModel class]]];
    }
    NSMutableArray * photoArr = [[NSMutableArray alloc]init];
    NSMutableArray * soundArr = [[NSMutableArray alloc]init];
    NSString * word = [[NSString alloc]init];
    for (NSDictionary * datadict in dataArray) {
        //   判断流记录类型  并使用查询出来的数据  集成正常可以显示的数据
        if ([datadict[@"event_category"] isEqualToString:@"PHOTO"]) {
            NSDictionary * dict = [self hadImageData:datadict];
            [photoArr addObject:dict];
        }else if ([datadict[@"event_category"] isEqualToString:@"VOICE"]){
            NSDictionary * dict = [self hadSoundData:datadict];
            [soundArr addObject:dict];
        }else if ([datadict[@"event_category"] isEqualToString:@"TEXT"]){
            word = [self hadWordData:datadict];
        }
    }
    //   将所有信息集成在一起
    NSMutableDictionary * muldict = [[NSMutableDictionary alloc]init];
    if (photoArr.count != 0) {
        [muldict setObject:photoArr forKey:@"photo"];
    }
    if (soundArr.count != 0) {
        [muldict setObject:soundArr forKey:@"sound"];
    }
    if (word.length != 0) {
        [muldict setObject:word forKey:@"word"];
    }
    return muldict;
}
/**
 集成正常添加的字典
 
 @param dict 流记录表字典
 */
+(NSDictionary *)hadImageData:(NSDictionary *)dict
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",dict[@"content_path"]]];   // 保存文件的名称
    UIImage * image = [UIImage imageWithContentsOfFile:filePath];
    NSData *data=UIImageJPEGRepresentation(image, 1.0);
    if (data.length == 0) {
        return nil;
    }
    NSMutableDictionary * muldict = [[NSMutableDictionary alloc]init];
    [muldict setObject:data forKey:@"PickerImage"];
    [muldict setObject:dict[@"content_path"] forKey:@"content_path"];
    [muldict setObject:dict[@"data_record_show"] forKey:@"data_record_show"];
    [muldict setObject:dict[@"file_name"] forKey:@"file_name"];
    
    return muldict;
}
/**
 集成正常添加的字典
 
 @param dict 流记录表字典
 */
+(NSDictionary *)hadSoundData:(NSDictionary *)dict
{
    NSString * str = dict[@"content_path"];
    if (str.length == 0) {
        return nil;
    }
    NSMutableDictionary * muldict = [[NSMutableDictionary alloc]init];
    [muldict setObject:@([dict[@"data_record_show"] intValue]) forKey:@"videoTime"];
    [muldict setObject:dict[@"content_path"] forKey:@"videoPath"];
    [muldict setObject:dict[@"content_path"] forKey:@"content_path"];
    [muldict setObject:dict[@"data_record_show"] forKey:@"data_record_show"];
    [muldict setObject:dict[@"file_name"] forKey:@"file_name"];
    
    return muldict;
}
+(NSString *)hadWordData:(NSDictionary *)dict
{
    NSString * word = dict[@"file_name"];
    if (word.length == 0) {
        return nil;
    }
    
    return word;
}

@end
