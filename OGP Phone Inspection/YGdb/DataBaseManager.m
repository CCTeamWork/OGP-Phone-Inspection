//
//  DataBaseManager.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/24.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "DataBaseManager.h"

@implementation DataBaseManager

+(DataBaseManager *)shareInstance
{
    static DataBaseManager * db = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db= [[DataBaseManager alloc]init];
        [db initTheDb];
    });
    return db;
}
-(void)initTheDb
{
    self.db = [[FMDatabase alloc] initWithPath:[USERDEFAULT valueForKey:@"FMDB_PATH"]];
}
/**
 创建数据库
 */
- (void)createSqlite
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"PhonePatrol.db"];
    [USERDEFAULT setObject:dbPath forKey:@"FMDB_PATH"];
    self.db = [[FMDatabase alloc] initWithPath:dbPath];
    if ([self.db open]) {
        [self createTable];
    }
}
/**
 创建所有的表
 
 @return 成功  失败
 */
-(BOOL)createTable
{
    BOOL result = true;
    if (![self isTableOK:@"login_message"]) {
        //   登录信息表
        result = [self.db executeUpdate:@"create table if not exists login_message ('login_uuid' text, 'login_name' text, 'company_name' text, 'login_id' text, 'password' text, 'user_remeber' integer, 'user_auto' integer, 'user_ip' text)"];
    }
    if (![self isTableOK:@"login_back"]) {
        //   登陆返回信息表
        result = [self.db executeUpdate:@"create table if not exists login_back ('login_id' text, 'user_name' text, 'session_id' text, 'offline_login' integer, 'track_record' integer, 'archives_address' text, 'upload_address' text, 'pull_msg_address' text, 'mqtt_address' text, 'map_type' integer, 'other_qrcode' integer, 'scan_qr_rate' integer, 'checkin_rate' integer, 'wifi_upload_flow' integer, 'timezone' text, 'auto_location' integer, 'feedback_url' text, 'auto_send' integer, 'location_interval_time' integer)"];
    }
    if (![self isTableOK:@"shift_record"]) {
        //   班次表
        result = [self.db executeUpdate:@"create table if not exists shift_record('shift_id' integer, 'shift_name' text, 'working_hours' text, 'off_hours' text, 'compare_id' integer)"];
    }
    if (![self isTableOK:@"site_record"]) {
        //   线路表
        result = [self.db executeUpdate:@"create table if not exists site_record('site_id' integer, 'site_name' text)"];
    }
    if (![self isTableOK:@"device_record"]) {
        //    设备表
        result = [self.db executeUpdate:@"create table if not exists device_record('site_device_id' integer, 'device_mark' text, 'device_number' text, 'device_number_qr' text, 'device_number_nfc' text, 'device_name' text, 'site_id' integer, 'def_lng' text, 'def_lat' text, 'gps_check' integer, 'gps_range' integer, 'sequence' integer, 'modify_flag' integer, 'status_id' text, 'items_ids' text, 'gps_match_range' integer)"];
    }
    if (![self isTableOK:@"schedule_record"]) {
        //    计划表
        result = [self.db executeUpdate:@"create table if not exists schedule_record('sch_id' integer, 'site_id' integer, 'sch_type' integer, 'valid_date_start' text, 'valid_date_end' text, 'start_time' text, 'end_time' text, 'other_start_date' integer, 'other_end_date' integer, 'tolerance' integer, 'working_day' text, 'squenct_check' integer, 'sequence_type' integer, 'repeat_interval' integer, 'same_sch_seq' integer, 'sch_device_record' text, 'other_has_start' integer)"];
    }
    if (![self isTableOK:@"sch_device_record"]) {
        //    计划下设备表
        result = [self.db executeUpdate:@"create table if not exists sch_device_record('sch_id' integer, 'site_device_id' integer, 'same_sch_seq' integer)"];
    }
        //    紧急联系人表
    if (![self isTableOK:@"emergency_contact_record"]) {
        result = [self.db executeUpdate:@"create table if not exists emergency_contact_record('emergency_contact_phone' text, 'emergency_contact' text)"];
    }
    if (![self isTableOK:@"device_status_record"]) {
        //    设备状态表
        result = [self.db executeUpdate:@"create table if not exists device_status_record('status_id' text, 'status_name' text)"];
    }
    if (![self isTableOK:@"items_record"]) {
        //    检查项表
        result = [self.db executeUpdate:@"create table if not exists items_record('items_id' integer, 'items_name' text, 'category' integer, 'options_group_id' integer, 'standard' text, 'comments' text, 'standar_value_option' text, 'standar_value_number_start' text, 'standar_value_number_end' text, 'standar_value_format' text, 'unit_id' integer, 'device_status_code' text)"];
    }
    if (![self isTableOK:@"device_items_record"]) {
        //    设备对应检查项表
        result = [self.db executeUpdate:@"create table if not exists device_items_record('site_device_id' integer, 'items_id' integer, 'items_name' text, 'category' integer, 'options_group_id' integer, 'standard' text, 'comments' text, 'standar_value_option' text, 'standar_value_number_start' text, 'standar_value_number_end' text, 'standar_value_format' text, 'unit_id' integer, 'device_status_code' text)"];
    }
    if (![self isTableOK:@"options_record"]) {
        //   选项表
        result = [self.db executeUpdate:@"create table if not exists options_record('options_group_id' integer, 'option_id' integer, 'option_name' text)"];
    }
    if (![self isTableOK:@"unit_record"]) {
        //   单位表
        result = [self.db executeUpdate:@"create table if not exists unit_record('unit_id' integer, 'unit_name' text)"];
    }
    if (![self isTableOK:@"event_record"]) {
        //   预置事件表
        result = [self.db executeUpdate:@"create table if not exists event_record('event_mark' text, 'event_name' text)"];
    }
    if (![self isTableOK:@"allkind_record"]) {
        //    信息记录表
        result = [self.db executeUpdate:@"create table if not exists allkind_record('user_name' text, 'record_sendtime' text,'record_device_name' text, 'record_device_number' integer, 'record_state' integer, 'record_uuid' text, 'items_uuid' text, 'data_uuid' text, 'record_site_id' integer, 'record_shift_id' integer, 'record_sch_id' integer, 'record_sch_start_time' text, 'record_sch_end_time' text, 'record_category' text,'record_device_mark' text, 'record_content' text, 'record_scantime' text, 'record_gps_time' text, 'record_longitude' text, 'record_latitude' text, 'record_offline' integer, 'record_must_photo' integer, 'record_photo_flag' integer, 'record_location_category' text, 'record_overdue' integer, 'record_status' text, 'record_gps_outside' integer, 'event_device_code' text, 'record_shift_starttime' text, 'record_sch_seq' integer, 'photo_name' text, 'patrol_state' integer, 'record_generate_type' integer)"];
    }
    if (![self isTableOK:@"itemskind_record"]) {
        //    项目纪录表
        result = [self.db executeUpdate:@"create table if not exists itemskind_record('record_uuid' text, 'items_uuid' text, 'data_uuid' text, 'items_id' integer, 'items_overdue' integer, 'items_miss' integer, 'items_offline' integer, 'items_category' integer, 'items_value' text, 'items_scantime' text, 'items_gps_time' text, 'items_location_category' text, 'items_longitude' text, 'items_latitude' text, 'items_status' text, 'items_value_status' integer)"];
    }
    if (![self isTableOK:@"data_record"]) {
        //     流记录表
        result = [self.db executeUpdate:@"create table if not exists data_record('content_path' text,'data_record_show' text, 'data_uuid' text, 'event_category' text, 'file_name' text, 'file_scantime' text, 'file_gps_time' text, 'file_longitude' text, 'file_latitude' text, 'file_offline' integer, 'file_location_category' text, 'file_overdue' integer, 'items_uuid' text, 'data_state' integer, 'user_name' text)"];
    }
    if (![self isTableOK:@"message_record"]) {
        //     通知信息表
        result = [self.db executeUpdate:@"create table if not exists message_record('user_name' text, 'msg_serial_id' integer, 'user_id' integer, 'company_id' integer, 'message_id' integer, 'source' text, 'read_feedback' integer, 'read_feedback_url' text, 'data_category' text, 'icon_url' text, 'message_title' text, 'message_category' text, 'msg_category_name' text, 'content_type' text, 'content' text, 'createtime_utc' text, 'target_url' text, 'secured' integer, 'isread' integer, 'msg_time' text)"];
    }
    if (![self isTableOK:@"cheat_record"]) {
        //   防作弊流记录表
        result = [self.db executeUpdate:@"create table if not exists cheat_record('content_path' text, 'data_record_show' text, 'data_uuid' text, 'file_name' text, 'cheat_state' integer, 'user_name' text)"];
    }
    if (![self isTableOK:@"other_task_status"]) {
        //   同步特殊计划记录表
        result = [self.db executeUpdate:@"create table if not exists other_task_status('sch_id' integer, 'site_device_id' integer, 'patrol_flag' integer, 'same_sch_seq' integer)"];
    }
    if (![self isTableOK:@"track_record"]) {
        //   行迹记录表
        result = [self.db executeUpdate:@"create table if not exists track_record('gps_time' text, 'location_category' text, 'longitude' text, 'latitude' text, 'speed' text)"];
    }
    if (![self isTableOK:@"event_record"]) {
        //   预置事件表
        result = [self.db executeUpdate:@"create table if not exists event_record('event_mark' text, 'event_name' text)"];
    }
    NSLog(@"%d",result);
    return result;
}

/**
 判断表是否存在

 @param tableName 表名
 @return 是否
 */
- (BOOL) isTableOK:(NSString *)tableName
{
    FMResultSet *rs = [self.db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return NO;
}
#pragma mark 增
/**
 向某一个表中添加数据
 
 @param tableName 表名
 @param values 要添加的值
 @return 成功  失败
 */
-(BOOL)insertSomething:(NSString *)tableName keys:(NSArray *)keys values:(NSArray *)values
{
    NSMutableArray *vs = [NSMutableArray arrayWithArray:values];
    for (int i = 0; i<values.count; i++) {
        id obj = [values objectAtIndex:i];
        if ([obj isKindOfClass:[NSNull class]]) {
            [vs replaceObjectAtIndex:i withObject:@"null"];
        }
        if ([obj isKindOfClass:[NSArray class]]) {
             NSString *str1 = [obj componentsJoinedByString:@","];
            NSString *str = [NSString stringWithFormat:@"'%@'", str1];
            [vs replaceObjectAtIndex:i withObject:str];
        }
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *str = [NSString stringWithFormat:@"'%@'", obj];
            [vs replaceObjectAtIndex:i withObject:str];
        }
    }
    NSString *key = [keys componentsJoinedByString:@","];
    NSString *value = [vs componentsJoinedByString:@","];
    
    NSString * sqlStr= [NSString stringWithFormat:@"insert into %@(%@) values (%@)",tableName,key,value];
    BOOL result = [self.db executeUpdate:sqlStr];
    return result;
}

/**
 添加一组值到数据库   1
 
 @param name 表名
 @param dict 数据字典
 @return 成功  失败
 */
-(BOOL)insertTbName:(NSString *)name dict:(NSDictionary *)dict {
    NSArray *keys = [dict allKeys];
    NSArray *values = [dict allValues];
    return [self insertSomething:name keys:keys values:values];
}

/**
 添加多组数据到数据库   多
 
 @param name 表名
 @param array 多组数据字典
 @return 成功  失败
 */
-(BOOL)insertTbName:(NSString *)name array:(NSArray *)array {
    [self.db beginTransaction];
    NSInteger flag = 0;
    for (NSDictionary *dict in array) {
        if (![self insertTbName:name dict:dict]) {
            flag = 1;
        }
    }
    if (flag) {
        [self.db rollback];
        return NO;
    }
    [self.db commit];
    return YES;
}
#pragma mark 删
/**
 删除某一个表中   与某一个值相等的数据
 
 @param tableName 表名
 @param key key
 @param value 值
 @return 成功  失败
 */
-(BOOL)deleteSomething:(NSString *)tableName key:(NSString *)key value:(NSString *)value
{
    NSString * sqlStr = [NSString stringWithFormat:@"delete from %@ where %@ = %@",tableName,key,value];
    BOOL result = [self.db executeUpdate:sqlStr];
    return result;
}
-(BOOL)deleteSomething:(NSString *)tableName value:(NSString *)value
{
    NSString * sqlStr = [NSString stringWithFormat:@"delete from %@ where %@",tableName,value];
    BOOL result = [self.db executeUpdate:sqlStr];
    return result;

}
/**
 删除表中所有数据

 @param tableName 表名
 @return 成功  失败
 */
-(BOOL)deleteAll:(NSString *)tableName
{
    BOOL result = [self.db executeUpdate:[NSString stringWithFormat:@"delete from %@",tableName]];
    return result;
}
#pragma mark 改
/**
 更新某一个表中的某一条数据
 
 @param tableName 表名
 @param value 键  值
 @return 成功  失败
 */
-(BOOL)updateSomething:(NSString *)tableName key:(NSString *)key value:(NSString *)value sql:(NSString *)sql
{
    NSString * sqlStr = [NSString stringWithFormat:@"update %@ set %@ = %@",tableName,key,value];
    NSString *updateSql =[NSString stringWithFormat:@"%@ where %@", sqlStr,sql];
    BOOL result = [self.db executeUpdate:updateSql];
    return result;
}


/**
 更新某一个表中的很多值

 @param tableName 表名
 @param updataSql 更新语句
 @param whereSql 条件语句
 @return <#return value description#>
 */
-(BOOL)updateMoreSomething:(NSString *)tableName updataSql:(NSString *)updataSql whereSql:(NSString *)whereSql
{
    NSString * sqlStr = [NSString stringWithFormat:@"update %@ set %@",tableName,updataSql];
    NSString *updateSql =[NSString stringWithFormat:@"%@ where %@", sqlStr,whereSql];
    BOOL result = [self.db executeUpdate:updateSql];
    return result;

}
#pragma mark 查
/**
 查询某一个表的所有数据
 
 @param tableName 表名
 @param keys keys数组
 @return 数组
 */
-(NSMutableArray *)selectAll:(NSString *)tableName keys:(NSArray *)keys keysKinds:(NSArray *)keysKinds
{
    NSString * sqlStr=[NSString stringWithFormat:@"select * from %@",tableName];
    FMResultSet *set = [_db executeQuery:sqlStr];
    return [self selectAllStudentsHelper:set keys:keys keysKinds:keysKinds];
}
/**
 根据某一个值  查询某一个表中的数据
 
 @param tableName 表名
 @param value 键  值
 @param keys keys数组
 @return 数组
 */
-(NSMutableArray *)selectSomething:(NSString *)tableName value:(NSString *)value keys:(NSArray *)keys keysKinds:(NSArray *)keysKinds
{
    NSString * sqlStr=[NSString stringWithFormat:@"select * from %@ where %@",tableName,value];
    FMResultSet *set = [_db executeQuery:sqlStr];
    return [self selectAllStudentsHelper:set keys:keys keysKinds:keysKinds];
}

/**
 查询符合条件的数据的数量

 @param tableName 表名
 @param value 条件
 @return 数量
 */
-(int)selectNumber:(NSString *)tableName value:(NSString *)value
{
    NSString * sqlStr = [NSString stringWithFormat:@"select count(*) from %@ where %@",tableName,value];
    FMResultSet * set = [_db executeQuery:sqlStr];
    int i = 0;
    while ([set next]) {
        i = [set intForColumnIndex:0];
    }
    return i;
}
/**
 将查询出来的数据 转换成数组
 
 @param FMSet 数据
 @param keys keys数组
 @return 数组
 */
-(NSMutableArray *)selectAllStudentsHelper:(FMResultSet *)FMSet keys:(NSArray *)keys keysKinds:(NSArray *)keysKinds
{
    NSMutableArray * selectResult = [NSMutableArray array];
    NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
    while ([FMSet next]) {
        
        for (int i = 0; i < keys.count; i++) {
            if ([FMSet stringForColumn:keys[i]] == nil) {
                [dict setValue:[FMSet stringForColumn:keys[i]] forKey:keys[i]];
            }else{
                if ([keysKinds[i] isEqualToString:@"int"]) {
                    [dict setValue:@([FMSet intForColumn:keys[i]]) forKey:keys[i]];
                }else if ([keysKinds[i] isEqualToString:@"NSString"]) {
                    [dict setValue:[FMSet stringForColumn:keys[i]] forKey:keys[i]];
                }else if ([keysKinds[i] isEqualToString:@"double"]){
                    NSLog(@"测试double类型的地理位置  %lf",[FMSet doubleForColumn:keys[i]]);
                    [dict setValue:@([FMSet doubleForColumn:keys[i]]) forKey:keys[i]];
                }
            }
        }
        [selectResult addObject:[dict copy]];
//        [selectResult insertObject:[dict copy] atIndex:0];
    }
    return selectResult;
}
-(BOOL)dbopen
{
   return [self.db open];
}
-(BOOL)dbclose
{
//    return [self.db close];
    return 1;
}
@end
