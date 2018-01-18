//
//  ScanCodePost.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/5.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "ScanCodePost.h"
#import <AudioToolbox/AudioToolbox.h>
#import "YYModel.h"
#import "DataBaseManager.h"
#import "TaskPost.h"
#import "ScheduleModel.h"
#import "DevicePost.h"
@implementation ScanCodePost
//   随机判断二维码是否需要防作弊拍照
-(BOOL)photoRate
{
    int rate=[LOGIN_BACK[@"scan_qr_rate"] intValue];
    int armRate=arc4random()%101;
    if (armRate>0 && armRate<rate+1) {
        return YES;
    }
    return NO;
}
-(NSString *)qrCodeStr:(NSString *)qrCodestr
{
    //   如果该账号   限制二维码（只扫描符合规则的二维码）
    if ([LOGIN_BACK[@"qrcode"] intValue]==0) {
        if (qrCodestr.length<=12) {
            [self vibrate];
            return nil;
        }
        //  截取获得的字符串前十位（被加密之后的十个数字）
        NSString * str1=[qrCodestr substringToIndex:10];
        //   将上面的十位数解密  得到一个两位的字符串
        NSString * str2=[self getmd5WithString:str1];
        //   如果解密的字符串小于两位  说明第一位是0
        if ([str2 length]<2) {
            str2=[NSString stringWithFormat:@"0%@",str2];
        }
        //   截取11  12 位  与前面解密的两位相比较
        NSString * str3=[qrCodestr substringWithRange:NSMakeRange(11,2)];
        //   如果符合规则
        if ([str2 isEqualToString:str3]) {
            [self vibrate];
            return str1;
        }
        //   不符合规则
        else{
            [self vibrate];
            return nil;
        }
    }
    //   可以扫描所有二维码
    else{
        [self vibrate];
        //  截取获得的字符串前十位（被加密之后的十个数字）
        NSString * str1=[qrCodestr substringToIndex:10];
        //   将上面的十位数解密  得到一个两位的字符串
        NSString * str2=[self getmd5WithString:str1];
        //   如果解密的字符串小于两位  说明第一位是0
        if ([str2 length]<2) {
            str2=[NSString stringWithFormat:@"0%@",str2];
        }
        //   截取11  12 位  与前面解密的两位相比较
        NSString * str3=[qrCodestr substringWithRange:NSMakeRange(11,2)];
        //   如果符合规则
        if ([str2 isEqualToString:str3]) {
            [self vibrate];
            return str1;
        }
        if ([qrCodestr length]>64) {
            NSString * str4=[qrCodestr substringToIndex:64];
            return str4;
        }
        else{
            return qrCodestr;
        }
    }
}
//   计算时间差
-(int)timeLitleTime:(NSString *)QRCodeTime pickerTime:(NSString *)pickerTime
{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:QRCodeTime];
    NSDate *endD = [date dateFromString:pickerTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int second = (int)value %60;//秒
    //    int minute = (int)value /60%60;
    //    int house = (int)value / (24 * 3600)%3600;
    //    int day = (int)value / (24 * 3600);
    //    NSString *str;
    //    if (day != 0) {
    //        str = [NSString stringWithFormat:@"耗时%d天%d小时%d分%d秒",day,house,minute,second];       
    //    }else if (day==0 && house != 0) {
    //        str = [NSString stringWithFormat:@"耗时%d小时%d分%d秒",house,minute,second];
    //    }else if (day== 0 && house== 0 && minute!=0) {
    //        str = [NSString stringWithFormat:@"耗时%d分%d秒",minute,second];
    //    }else{
    //        str = [NSString stringWithFormat:@"耗时%d秒",second];
    //    }
    return second;
}
//将MD5编码的数据转换成字符串
-(NSString *)getmd5WithString:(NSString *)string
{
    const char* original_str=[string UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    Byte zed=0;
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        zed=zed+digist[i];
        [outPutStr appendFormat:@"%02x", digist[i]];
        // 小写 x 表示输出的是小写 MD5 ，大写 X 表示输出的是大写 MD5
        self.qrMD5Str = [NSString stringWithFormat:@"%0X",zed];
    }
    return self.qrMD5Str;
}

/**
 主页二维码      是否在当前班次的所有计划中
 
 @param deviceDict 设备信息
 @return 是否
 */
-(NSArray *)isShiftSch:(NSDictionary *)deviceDict qrstring:(NSString *)qrstring
{
    NSMutableArray * mulArray = [[NSMutableArray alloc]init];
    DataBaseManager * db = [DataBaseManager shareInstance];
    //   得到所有的本班次计划
    NSArray * allHadSchArr = [USERDEFAULT valueForKey:SCH_SITE_DEVICE_ARRAY];
    //   得到计划下的所有设备
    for (NSDictionary * schDict in allHadSchArr) {
        [self.devicepost deviceDidUser_sitedict:schDict];
    }
    allHadSchArr = [USERDEFAULT valueForKey:SCH_SITE_DEVICE_ARRAY];
    //  当此设备在当前班次计划中  并且 没有被巡检过  需要更新本地计划数组
    NSMutableArray * mulNewArray = [[NSMutableArray alloc]init];
    for (NSDictionary * hadSchDict in allHadSchArr) {
        //   用于更新数据
        NSMutableDictionary * mulNewDict = [NSMutableDictionary dictionaryWithDictionary:hadSchDict];
        NSArray * hadDevArr = hadSchDict[@"device_array"];
        //   如果已查计划的设备中有数据
        if (hadDevArr.count != 0) {
            for (NSDictionary * hadDevDict in hadDevArr) {
                //   将便利到的设备的二维码号转换成数组
                NSArray * hadQrArr = [hadDevDict[@"device_number_qr"] componentsSeparatedByString:@","];
                //  如果包含此二维码
                if ([hadQrArr containsObject:qrstring]) {
                    //   符合规则   加到数组中
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                    [dict setObject:hadDevDict forKey:@"device_dict"];
                    [dict setObject:hadSchDict forKey:@"sch_dict"];
                    [mulArray addObject:dict];
                }
            }
        }else{
            //   如果已查计划的设备中无数据
            NSArray * scharray = [db selectSomething:@"sch_device_record" value:[NSString stringWithFormat:@"sch_id = %d and same_sch_seq = %d",[hadSchDict[@"sch_id"] intValue],[hadSchDict[@"same_sch_seq"] intValue]] keys:@[@"sch_id",@"site_device_id",@"same_sch_seq"] keysKinds:@[@"int",@"int",@"int"]];
            for (NSDictionary * dict in scharray) {
                NSArray * devicearray = [db selectSomething:@"device_record" value:[NSString stringWithFormat:@"site_device_id = %d",[dict[@"site_device_id"] intValue]] keys:[ToolModel allPropertyNames:[DeviceModel class]] keysKinds:[ToolModel allPropertyAttributes:[DeviceModel class]]];
                //   遍历数组   判断是否包含
                for (int i = 0; i < devicearray.count; i++) {
                    NSDictionary * dict = devicearray[i];
                    if ( dict == deviceDict) {
                        //   制作好的设备
                        deviceDict = [self makeDeviceDict:deviceDict];
                        //  替换数组中的制作好的设备
                        NSMutableArray * newdeviceArr = [NSMutableArray arrayWithArray:devicearray];
                        [newdeviceArr replaceObjectAtIndex:i withObject:deviceDict];
                        [mulNewDict setObject:newdeviceArr forKey:@"device_array"];
                        //   符合规则   加到数组中
                        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                        [dict setObject:deviceDict forKey:@"device_dict"];
                        [dict setObject:hadSchDict forKey:@"sch_dict"];
                        [mulArray addObject:dict];
                    }
                }
            }
        }
        [mulNewArray addObject:mulNewDict];
    }
    [USERDEFAULT setObject:mulNewArray forKey:SCH_SITE_DEVICE_ARRAY];
    //   包含此设备的计划数组
    return mulArray;
}

/**
 设备页的二维码

 @param deviceDict 设备字典
 @param qrstring 二维码
 @return 当前制作好的计划和制作好的设备
 */
-(NSArray *)isTouchSch:(NSDictionary *)deviceDict qrstring:(NSString *)qrstring
{
    NSMutableArray * mulArray = [[NSMutableArray alloc]init];
    //   获取当前点击的计划字典
    NSDictionary * hadSchDict = [USERDEFAULT valueForKey:SCH_NOW_TOUCH];
    NSArray * allSchDeviceArray = [USERDEFAULT valueForKey:SCH_SITE_DEVICE_ARRAY];
    //   得到计划下的所有设备
    for (NSDictionary * schDict in allSchDeviceArray) {
        [self.devicepost deviceDidUser_sitedict:schDict];
    }
    allSchDeviceArray = [USERDEFAULT valueForKey:SCH_SITE_DEVICE_ARRAY];
    NSArray * hadDeviceArr;
    for (NSDictionary * dict in allSchDeviceArray) {
        if ([dict[@"sch_id"] intValue] == [hadSchDict[@"sch_id"] intValue] && [dict[@"same_sch_seq"] intValue] == [hadSchDict[@"same_sch_seq"] intValue] && [dict[@"sch_shift_id"] intValue] == [hadSchDict[@"sch_shift_id"] intValue]) {
            hadDeviceArr = hadSchDict[@"device_array"];
        }
    }
    for (NSDictionary * hadDevDict in hadDeviceArr) {
        //   将便利到的设备的二维码号转换成数组
        NSArray * hadQrArr = [hadDevDict[@"device_number_qr"] componentsSeparatedByString:@","];
        //  如果包含此二维码
        if ([hadQrArr containsObject:qrstring]) {
            //   符合规则   加到数组中
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            [dict setObject:hadDevDict forKey:@"device_dict"];
            [dict setObject:hadSchDict forKey:@"sch_dict"];
            [mulArray addObject:dict];
        }
    }
    return mulArray;
}
/**
 设备符合   制作将要使用的设备
 
 @param device 设备表中查询的设备
 @return 完成的设备
 */
-(NSDictionary *)makeDeviceDict:(NSDictionary *)device
{
    NSMutableDictionary * mulDict = [NSMutableDictionary dictionaryWithDictionary:device];
    
    //   设备状态
    [mulDict setObject:@"normal" forKey:@"device_state"];
    //    巡检状态
    [mulDict setObject:@(0) forKey:@"patrol_state"];
    //    完成项目数
    [mulDict setObject:@(0) forKey:@"device_finish_number"];
    //   设备record_uuid
    [mulDict setObject:[ToolModel uuid] forKey:@"record_uuid"];
    //   发送状态
    [mulDict setObject:@(0) forKey:@"record_state"];
    //    发送时间
    [mulDict setObject:@"" forKey:@"record_sendtime"];
    
    return mulDict;
}
/**
 获取设备信息    档案中的所有设备

 @param qrString <#qrString description#>
 */
-(NSDictionary *)qrStrDeviceFromAll:(NSString *)qrString
{
    //   判断是否在档案中
    DataBaseManager * db = [DataBaseManager shareInstance];
//    NSArray * qrdeviceArr = [db selectSomething:@"device_record" value:[NSString stringWithFormat:@"device_number_qr = '%@'",qrString] keys:[ToolModel allPropertyNames:[DeviceModel class]] keysKinds:[ToolModel allPropertyAttributes:[DeviceModel class]]];
    
    NSArray * allDeviceArr = [db selectAll:@"device_record" keys:[ToolModel allPropertyNames:[DeviceModel class]] keysKinds:[ToolModel allPropertyAttributes:[DeviceModel class]]];
    for (NSDictionary * deviceDict in allDeviceArr) {
        NSArray * hadQrArr = [deviceDict[@"device_number_qr"] componentsSeparatedByString:@","];
        if ([hadQrArr containsObject:qrString]) {
            return deviceDict;
        }
    }
    [db dbclose];
    return nil;
}

/**
 震动
 */
- (void)vibrate   {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
-(DevicePost *)devicepost
{
    if (_devicepost == nil) {
        _devicepost = [[DevicePost alloc]init];
    }
    return _devicepost;
}
@end
