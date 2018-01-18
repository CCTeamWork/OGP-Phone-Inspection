//
//  DevicePost.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/4.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "DevicePost.h"
#import "DataBaseManager.h"
#import "YYModel.h"
#import "AllKindModel.h"
@implementation DevicePost

/**
 查找计划下设备数据
 
 @param sitedict 计划设备对应表
 @return <#return value description#>
 */
-(NSArray *)device_sitedict:(NSDictionary *)sitedict
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    //   计划设备对应表数组
    NSArray * scharray = [db selectSomething:@"sch_device_record" value:[NSString stringWithFormat:@"sch_id = %d and same_sch_seq = %d",[sitedict[@"sch_id"] intValue],[sitedict[@"same_sch_seq"] intValue]] keys:@[@"sch_id",@"site_device_id",@"same_sch_seq"] keysKinds:@[@"int",@"int",@"int"]];
    NSMutableArray * mulArray = [[NSMutableArray alloc]init];
    //   循环查找出所有的对应设备数据
    for (NSDictionary * dic in scharray) {
        NSArray * devicearray = [db selectSomething:@"device_record" value:[NSString stringWithFormat:@"site_device_id = %d",[dic[@"site_device_id"] intValue]] keys:[ToolModel allPropertyNames:[DeviceModel class]] keysKinds:[ToolModel allPropertyAttributes:[DeviceModel class]]];
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
        }
    }
    [db dbclose];
    return mulArray;
}

/**
 判断是否已经查询出来的计划

 @param sitedict 计划对应线路表
 @return <#return value description#>
 */
-(NSArray *)deviceDidUser_sitedict:(NSDictionary *)sitedict
{
    NSArray * ar = [[NSArray alloc]init];
    //   获取计划和设备的保存信息
    NSArray * schArray = [USERDEFAULT valueForKey:SCH_SITE_DEVICE_ARRAY];
    NSMutableArray * schMulArray = [[NSMutableArray alloc]init];
    //   遍历信息
    for (NSDictionary * dict in schArray) {
        //   如果是当前计划
        if ([dict[@"sch_id"] intValue] == [sitedict[@"sch_id"] intValue] && [dict[@"same_sch_seq"] intValue] == [sitedict[@"same_sch_seq"] intValue] && [dict[@"sch_shift_id"] intValue] == [sitedict[@"sch_shift_id"] intValue]) {
            NSMutableDictionary * schdict = [NSMutableDictionary dictionaryWithDictionary:dict];
            //   取出计划中的字典数组
            NSArray * deviceArr = dict[@"device_array"];
            //    如果数组为nil   说明是第一次巡检这个设备
            if (deviceArr.count == 0) {
                //   查询数据库
                ar = [self device_sitedict:sitedict];
                //  将查询到的设备数组  加到当前计划的字典中
                [schdict setObject:ar forKey:@"device_array"];
                [schMulArray addObject:schdict];
            }else{
                //   数组不为nil   直接返回设备数组
                return deviceArr;
            }
        }else{
            [schMulArray addObject:dict];
        }
    }
    [USERDEFAULT setObject:schMulArray forKey:SCH_SITE_DEVICE_ARRAY];
    return ar;
}

/**
 更新当前计划的设备数据  设备状态
 
 @param sitedict 线路字典
 @param devicedict 设备字典
 @param key 要改变的字段
 */
-(void)updateDeviceArray:(NSDictionary *)sitedict deviceDic:(NSDictionary *)devicedict key:(NSString *)key value:(NSString *)value
{
    //   获取到所有计划和设备内容
    NSArray * schSiteArray = [USERDEFAULT valueForKey:SCH_SITE_DEVICE_ARRAY];
    //   将所有内容转换为可变数组
    NSMutableArray * mulsiteArray = [[NSMutableArray alloc]init];
    //   遍历计划   得到当前计划
    for (NSDictionary * schDict in schSiteArray) {
        //   将每一个计划转换为可变字典
        NSMutableDictionary * mulsiteDict = [NSMutableDictionary dictionaryWithDictionary:schDict];
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
                    NSMutableDictionary * muldict = [NSMutableDictionary dictionaryWithDictionary:devicedic];
                    [muldict setObject:value forKey:key];
                    //   将改变之后的设备  添加到设备数组中
                    [mulArray addObject:muldict];
                }else{
                    //   不是当前设备  直接添加到设备数组中
                    [mulArray addObject:devicedic];
                }
            }
            //   将当前设备的数组  添加到当前计划的可变字典中
            [mulsiteDict setObject:mulArray forKey:@"device_array"];
            //   将当前计划的可变字典  添加到计划的数组中
            [mulsiteArray addObject:mulsiteDict];
        }else{
            //   不是当前计划的字典  直接添加到计划中
            [mulsiteArray addObject:schDict];
        }
    }
    //   将改变后的数据储存
    [USERDEFAULT setObject:mulsiteArray forKey:SCH_SITE_DEVICE_ARRAY];
}

/**
 判断是不是按顺序巡检

 @param deviceArr 当前计划下的所有设备
 @return <#return value description#>
 */
-(BOOL)deviceIsSequence:(NSArray *)deviceArr touchDict:(NSDictionary *)touchDict sequence_type:(int)type
{
    //   正序
    if (type == 0) {
        BOOL k = YES;
        //    如果是正序 判断是不是第一个
        for (NSDictionary * devicedict in deviceArr) {
            if ([devicedict[@"patrol_state"] intValue] != 0) {
                //   如果已经有其他设备开始巡检了
                k = NO;
            }
        }
        if (k == YES) {
            //   一个设备都没巡检
            //   如果当前设备序号等于最小的序号
            if ([touchDict[@"sequence"] intValue] == [self getMinSequence:deviceArr type:type]) {
                return YES;
            }else{
                return NO;
            }
        }else{
            //   已经有设备巡检了
            for (NSDictionary * deviceDict in deviceArr) {
                if ([deviceDict[@"sequence"] intValue] < [touchDict[@"sequence"] intValue]) {
                    if ([deviceDict[@"patrol_state"] intValue] != 3) {
                        return NO;
                    }
                }
            }
        }
    }
    //   倒叙
    if (type == 1) {
        BOOL k = YES;
        //    判断是不是第一个
        for (NSDictionary * devicedict in deviceArr) {
            if ([devicedict[@"patrol_state"] intValue] != 0) {
                //   如果已经有其他设备开始巡检了
                k = NO;
            }
        }
        if (k == YES) {
            //   一个设备都没巡检
            //   如果当前设备序号等于最大的序号
            if ([touchDict[@"sequence"] intValue] == [self getMinSequence:deviceArr type:type]) {
                return YES;
            }else{
                return NO;
            }
        }else{
            //   已经有设备巡检了
            for (NSDictionary * deviceDict in deviceArr) {
                if ([deviceDict[@"sequence"] intValue] > [touchDict[@"sequence"] intValue]) {
                    if ([deviceDict[@"patrol_state"] intValue] != 3) {
                        return NO;
                    }
                }
            }
        }
    }
    //   正序  倒叙 都可以
    if (type == 2) {
        BOOL k = YES;
        // 判断是不是第一个
        for (NSDictionary * devicedict in deviceArr) {
            if ([devicedict[@"patrol_state"] intValue] != 0) {
                //   如果已经有其他设备开始巡检了
                k = NO;
            }
        }
        //   一个设备都没检
        if (k == YES) {
            //   判断是不是第一个
            if ([touchDict[@"sequence"] intValue] == [self getMinSequence:deviceArr type:0] || [touchDict[@"sequence"] intValue] == [self getMinSequence:deviceArr type:1]) {
                return YES;
            }else{
                return NO;
            }
        }else{
            int value = 0;
            //   已经有设备巡检了
            for (NSDictionary * devicedict in deviceArr) {
                if ([devicedict[@"sequence"] intValue] < [touchDict[@"sequence"] intValue]) {
                    if ([devicedict[@"patrol_state"] intValue] != 0) {
                        //   说明是顺叙
                        value = 1;
                    }
                }else{
                    if ([devicedict[@"patrol_state"] intValue] != 0) {
                        //   说明是倒叙
                        value = 2;
                    }
                }
            }
            //   正序   判断是不是按顺序
            if (value == 1) {
                for (NSDictionary * deviceDict in deviceArr) {
                    if ([deviceDict[@"sequence"] intValue] < [touchDict[@"sequence"] intValue]) {
                        if ([deviceDict[@"patrol_state"] intValue] != 3) {
                            return NO;
                        }
                    }
                }
            }else{
                for (NSDictionary * deviceDict in deviceArr) {
                    if ([deviceDict[@"sequence"] intValue] > [touchDict[@"sequence"] intValue]) {
                        if ([deviceDict[@"patrol_state"] intValue] != 3) {
                            return NO;
                        }
                    }
                }
            }
        }
    }
    return YES;
}

/**
 得到此计划中   最小的设备号

 @param deviceArr <#deviceArr description#>
 @return <#return value description#>
 */
-(int)getMinSequence:(NSArray *)deviceArr type:(int)type
{
    if (type == 0) {
        //   一个设备都没巡检
        int sum = 0;
        //   循环得到最小的序号
        for (NSDictionary * devicedict in deviceArr) {
            //   第一次对比  将第一个数给对比者
            if (sum == 0) {
                sum = [devicedict[@"sequence"] intValue];
            }else{
                //   将相对小的数给sum
                if (sum > [devicedict[@"sequence"] intValue]) {
                    sum = [devicedict[@"sequence"] intValue];
                }
            }
        }
        return sum;
    }else{
        int sum = 0;
        //   循环得到最大的序号
        for (NSDictionary * devicedict in deviceArr) {
            //   第一次对比  将第一个数给对比者
            if (sum == 0) {
                sum = [devicedict[@"sequence"] intValue];
            }else{
                //   将相对大的数给sum
                if (sum < [devicedict[@"sequence"] intValue]) {
                    sum = [devicedict[@"sequence"] intValue];
                }
            }
        }
        return sum;
    }
}

/**
 判断是否可以进行巡检（是否按顺序   是否是未进行巡检的特殊计划）

 @param deviceDict 当前点击的设备信息
 @return 是否可以跳转
 */
-(BOOL)isPushProjectController:(NSDictionary *)deviceDict allDeviceArray:(NSArray *)allDeviceArray touchSchdict:(NSDictionary *)touchSchdict
{
    //   判断是不是特殊计划  如果是  判断是否已经巡检过  (如果是  提取出同步过来的储存信息)
    if ([touchSchdict[@"sch_type"] intValue] != 0) {
        DataBaseManager * db = [DataBaseManager shareInstance];
        NSArray * finishArray = [db selectSomething:@"other_task_status" value:[NSString stringWithFormat:@"sch_id = %d and same_sch_seq = %d",[touchSchdict[@"sch_id"] intValue],[touchSchdict[@"same_sch_seq"] intValue]] keys:@[@"sch_id",@"site_device_id",@"patrol_flag",@"same_sch_seq"] keysKinds:@[@"int",@"int",@"int",@"int"]];
        for (NSDictionary * dic in finishArray) {
            if ([dic[@"sch_id"] intValue] == [touchSchdict[@"sch_id"] intValue] && [dic[@"same_sch_seq"] intValue] == [touchSchdict[@"same_sch_seq"] intValue] && [dic[@"site_device_id"] intValue] == [deviceDict[@"site_device_id"] intValue] && [dic[@"patrol_flag"] intValue] == 1) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Device_alert_other_finish",@"") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"All_sure",@"") otherButtonTitles:nil, nil];
                [alert show];
                return NO;
            }
        }
    }
    //   是否规定按顺序巡检
    if ([touchSchdict[@"squenct_check"] intValue] == 1) {
        //   当前点击的设备已经开始巡检  不需再次判断顺序
        if ([deviceDict[@"patrol_state"] intValue] != 0) {
            return YES;
        }else{
            //  判断是否按顺序巡检了
            if ([self deviceIsSequence:allDeviceArray touchDict:deviceDict sequence_type:[touchSchdict[@"sequence_type"] intValue]]) {
                return YES;
            }else{
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Device_alert_isno_order",@"") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"All_sure",@"") otherButtonTitles:nil, nil];
                [alert show];
                return NO;
            }
        }
    }else{
        return YES;
    }
    return YES;
}

/**
 是否需要防作弊拍照

 @param deviceDict 当前点击的设备信息
 @return 是否可以跳转
 */
-(BOOL)isPushPickerViewController:(NSDictionary *)deviceDict schDict:(NSDictionary *)schDict generateType:(int)generateType
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    NSArray * array = [db selectSomething:@"allkind_record" value:[NSString stringWithFormat:@"record_uuid = '%@'",deviceDict[@"record_uuid"]] keys:[ToolModel allPropertyNames:[AllKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[AllKindModel class]]];
    if (array.count == 0) {
        if ([self.scanpost photoRate]) {
            //   需要随机拍照
            return YES;
            
        }else{
            //    不需要防作弊
            [RecordKeepModel recordKeep_recordType:@"PATROL"
                                           schDict:schDict
                                        deviceDict:deviceDict
                                         itemsDict:nil
                                      generateType:generateType
                                         cheatDict:[RecordKeepModel cheat_mustPhoto:0 photoFlag:0 photoName:nil recordcontent:nil eventDeviceCode:nil]];
            return NO;
        }
    }else{
        return NO;
    }
}
-(ScanCodePost *)scanpost
{
    if (_scanpost == nil) {
        _scanpost = [[ScanCodePost alloc]init];
    }
    return _scanpost;
}
@end
