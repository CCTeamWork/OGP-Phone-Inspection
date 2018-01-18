//
//  AllMapModel.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/11.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "AllMapModel.h"
#import "DataBaseManager.h"
#import "PostUPNetWork.h"
#import "ProjectViewController.h"
#import "RecordDetailViewController.h"
@implementation AllMapModel

/**
 判断当前位置是否超过三米

 @param oldLat 上次纬度
 @param oldLong 上次经度
 @param nowLat 现在纬度
 @param nowLong 现在经度
 @return <#return value description#>
 */
+(BOOL)distanceOldLat:(double)oldLat oldLong:(double)oldLong nowLat:(double)nowLat nowLong:(double)nowLong;
{
    BOOL JuLi=NO;
    CLLocation *orig=[[CLLocation alloc] initWithLatitude:oldLat  longitude:oldLong];
    CLLocation* dist=[[CLLocation alloc] initWithLatitude:nowLat longitude:nowLong];
    
    CLLocationDistance kilometers=[orig distanceFromLocation:dist];
    if (kilometers > 3) {
        JuLi=YES;
    }
    else{
        JuLi=NO;
    }
    return JuLi;
}

// -------------------------------------------  自动匹配点  ----------------------------------------
/**
 制作自动匹配计时器

 @param location 定位信息
 */
-(void)timerFromLocation:(CLLocation *)location deviceDinate2D:(CLLocationCoordinate2D)deviceDinate2D
{
    self.nowLocation = location;
    self.deviceDinate2D = deviceDinate2D;
    
    //   如果需要自动匹配点
//    if ([LOGIN_BACK[@""] intValue] == 1) {
        //   制作自动匹配点计时器
    
        if (self.deviceTimer == nil && !self.deviceTimer.valid) {
            self.deviceTime = 0;
            self.deviceTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(isAutoDevice) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.deviceTimer forMode:NSRunLoopCommonModes];
        }
//    }
    //   如果需要上传行迹
    if ([LOGIN_BACK[@"track_record"] intValue] == 1) {
        //  制作保存行迹计时器
        if (self.keepLocationTimer == nil && !self.keepLocationTimer.valid) {
            self.keepTime = 0;
             self.keepLocationTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(keepLocation) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.keepLocationTimer forMode:NSRunLoopCommonModes];
        }
        //   制作上传行迹计时器
        if (self.sendLocationTimer == nil && !self.sendLocationTimer.valid) {
            self.sendTime = 0;
            self.sendLocationTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(sendLocation) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.sendLocationTimer forMode:NSRunLoopCommonModes];
        }
    }
}

/**
 计时是否需要自动匹配
 */
-(void)isAutoDevice
{
    self.deviceTime ++ ;
    int login = 0;
    if ([LOGIN_BACK[@"auto_location"] intValue] == 0) {
        login = 20;
    }else{
        login = [LOGIN_BACK[@"auto_location"] intValue];
    }
    if (self.deviceTime == login) {
        [self autoKnowDevice];
        self.deviceTime = 0;
    }
}
/**
 利用定位  自动匹配设备
 */
-(void)autoKnowDevice
{
    if ([[self getCurrentVC] isMemberOfClass:[ProjectViewController class]] || [[self getCurrentVC] isMemberOfClass:[RecordDetailViewController class]]) {
        return;
    }
    if (![self getPresentedViewController]) {
        return;
    }
    //   是否匹配到当前班次中的点
    NSDictionary * deviceDict = [self locationIsDevice:self.deviceDinate2D];
    if (deviceDict == nil) {
        return;
    }else{//  匹配到了当前班次中的点
        //  如果是上次的点  并且没有超过规定时间
        if ([deviceDict[@"site_device_id"] intValue] == [self.lastDeviceDict[@"site_device_id"] intValue] && [self isLongTimeForSameDevice:self.nowLocation lastLocation:self.lastLocation] == NO) {
            return;
        }else{//  点符合要求
            //  是否需要近距离识别   如果需要
//            if ([deviceDict[@"gps_match_range"] intValue] == -1) {
//                return;
//            }else{
                //   不需要近距离识别   检索出包含此设备的所有计划
                NSArray * finishArray = [self deviceFromSchArray:deviceDict];
                if (finishArray.count != 0) {
                    self.lastLocation = self.nowLocation;
                    self.lastDeviceDict = deviceDict;
                    NSDictionary * dict = @{@"finishLocationDevice":finishArray};
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"finish_location_device" object:nil userInfo:dict];
                }
//            }
        }
    }
    return;
}

/**
 检索出当前班次包涵此设备的计划

 @param deviceDict 设备信息
 @return <#return value description#>
 */
-(NSArray *)deviceFromSchArray:(NSDictionary *)deviceDict
{
    NSMutableArray * mulArray = [[NSMutableArray alloc]init];
    //   获取当前计划
    NSArray * allSchArray = [USERDEFAULT valueForKey:SCH_SITE_DEVICE_ARRAY];
    //   遍历计划  取得所有设备
    for (NSDictionary * schDict in allSchArray) {
        NSArray * deviceArray = [self.devicepost deviceDidUser_sitedict:schDict];
        for (NSDictionary * devicedict in deviceArray) {
            NSMutableDictionary * mulDict = [[NSMutableDictionary alloc]init];
            if ([deviceDict[@"site_device_id"] intValue] == [devicedict[@"site_device_id"] intValue]) {
                [mulDict setObject:schDict forKey:@"sch_dict"];
                [mulDict setObject:devicedict forKey:@"device_dict"];
                [mulArray addObject:mulDict];
            }
        }
    }
    return mulArray;
}
/**
 判断时间是否超过

 @param nowLocation 此时的定位
 @param lastLocation 上次的定位
 @return <#return value description#>
 */
-(BOOL)isLongTimeForSameDevice:(CLLocation *)nowLocation lastLocation:(CLLocation *)lastLocation
{
    NSTimeInterval interval = [LOGIN_BACK[@"location_interval_time"] intValue];
    NSDate * date = [NSDate dateWithTimeInterval:interval sinceDate:lastLocation.timestamp];
    if (date > nowLocation.timestamp) {
        return YES;
    }
    return NO;
}


/**
 判断当前位置在班次中哪个设备符合

 @param curCoordinate2D 当前位置
 @return 符合的设备数据
 */
-(NSDictionary *)locationIsDevice:(CLLocationCoordinate2D)curCoordinate2D
{
    //   获取所有计划
    NSArray * allSchArray = [USERDEFAULT valueForKey:SCH_SITE_DEVICE_ARRAY];
    //   遍历计划  取得所有设备
    for (NSDictionary * schDict in allSchArray) {
        NSArray * deviceArray = [self.devicepost deviceDidUser_sitedict:schDict];
        for (NSDictionary * deviceDict in deviceArray) {
            //   该设备是否需要自动匹配点
            if ([deviceDict[@"gps_match_range"] intValue] != -1) {
                CLLocation * loct = [[CLLocation alloc] initWithLatitude:curCoordinate2D.latitude longitude:curCoordinate2D.longitude];
                CLLocation * device = [[CLLocation alloc] initWithLatitude:[deviceDict[@"def_lat"] doubleValue] longitude:[deviceDict[@"def_lng"] doubleValue]];
                CLLocationDistance kilometers=[loct distanceFromLocation:device];
                //   如果在误差范围内
                if (kilometers < [deviceDict[@"gps_match_range"] intValue] || kilometers == [deviceDict[@"gps_match_range"] intValue]) {
                    return deviceDict;
                }
            }
        }
    }
    return nil;
}
/**
 获得当前正在显示的controller

 @return <#return value description#>
 */
- (UIViewController *)getCurrentVC

{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *result = appRootVC;
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = ((UITabBarController*)result).selectedViewController;
        if ([result isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)result;
            result = nav.visibleViewController;
            if ([result isKindOfClass:[UITabBarController class]]) {
                result = ((UITabBarController*)result).selectedViewController;
                if ([result isKindOfClass:[UINavigationController class]]) {
                    UINavigationController * nav = (UINavigationController *)result;
                    result = nav.visibleViewController;
                }else{
                    return result;
                }
            }else{
                return result;
            }
        }else{
            return result;
        }
    }else{
        return result;
    }
    return result;
}

/**
 当前prea出来的controller

 @return <#return value description#>
 */
- (BOOL)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        return NO;
    }
    return YES;
}
//   ------------------------------------------------------------------------------------------------
//   --------------------------------------------  行迹  ---------------------------------------------

/**
 计时判断保存定位信息
 */
-(void)keepLocation
{
    self.keepTime++;
    if (self.keepTime == [LOGIN_BACK[@"auto_location"] intValue]-1) {
        self.keepTime = 0;
        //  如果经纬度都不为0
        if (self.deviceDinate2D.latitude != 0 && self.deviceDinate2D.longitude != 0) {
            [self allKindOfArray:@"location_track" kingdict:[self makeTrackDict]];
        }
    }
}

/**
 计时判断上传定位信息
 */
-(void)sendLocation
{
    self.sendTime++;
    //   开始上传
    if (self.sendTime == [LOGIN_BACK[@"auto_send"] intValue]-1) {
        self.sendTime = 0;
        NSString * url = [NSString stringWithFormat:@"http://%@/%@",LOGIN_BACK[@"upload_address"],@"UPLOAD_PATROL_RECORD"];
        NSDictionary * postDict = [self trackPostDict];
        //   如果没有行迹  不上传
        if (postDict == nil) {
            return;
        }
        [PostUPNetWork requestWithRequestType:HTTPSRequestTypePost urlString:url paraments:postDict
                                completeBlock:^(NSDictionary * _Nullable paraments, NSDictionary * _Nullable object, NSError * _Nullable error) {
            if (error == nil) {
                if ([object[@"error_code"] intValue] == 0) {
                    //   上传成功  处理被上传的行迹数据
                    [self finishPostDeleteTrack:paraments];
                }
            }
        }];
    }
}

/**
 储存行迹
 
 @param kindArray 行迹标示
 @param kinddict 要储存的数据
 */
-(void)allKindOfArray:(NSString *)kindArray
             kingdict:(NSMutableDictionary *)kinddict
{
    NSMutableArray * muArray=[[NSMutableArray alloc]init];
    muArray=[USERDEFAULT valueForKey:[NSString stringWithFormat:@"%@%@", [USERDEFAULT valueForKey:NAMEING],kindArray]];
    NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
    [mutaArray addObjectsFromArray:muArray];
    [mutaArray addObject:kinddict];
    muArray=mutaArray;
    [USERDEFAULT setObject:muArray forKey:[NSString stringWithFormat:@"%@%@", [USERDEFAULT valueForKey:NAMEING],kindArray]];
    [USERDEFAULT synchronize];
}

/**
 制作需要上传的定位信息

 @return <#return value description#>
 */
-(NSMutableDictionary *)makeTrackDict
{
    NSMutableDictionary * mudict = [[NSMutableDictionary alloc]init];
    //   如果没有定位信息
    if (self.nowLocation.coordinate.longitude == 0) {
        return nil;
    }
    [mudict setObject:@(self.deviceDinate2D.longitude) forKey:@"longitude"];
    [mudict setObject:@(self.deviceDinate2D.latitude) forKey:@"latitude"];
    [mudict setObject:@(self.nowLocation.speed) forKey:@"speed"];
    [mudict setObject:[ToolModel achieveNowTime] forKey:@"gps_time"];
    [mudict setObject:@"GPS" forKey:@"location_category"];
    return mudict;
}

/**
 集成将要上传的行迹数据

 @return <#return value description#>
 */
-(NSDictionary *)trackPostDict
{
    NSMutableDictionary * mulDict = [[NSMutableDictionary alloc]init];
    NSNull * null = [[NSNull alloc]init];
    //   如果没有行迹   不上传
    if ([[USERDEFAULT valueForKey:[NSString stringWithFormat:@"%@%@", [USERDEFAULT valueForKey:NAMEING],@"location_track"]] count] != 0) {
        NSDictionary * shiftDict = [USERDEFAULT valueForKey:SHIFT_DICT];
        //   线路ID
        [mulDict setObject:@(0) forKey:@"site_id"];
        if (shiftDict != nil) {
            //    班次ID
            [mulDict setObject:@([shiftDict[@"shift_id"] intValue]) forKey:@"shift_id"];
            NSDictionary * shiftTimeDict = [USERDEFAULT valueForKey:[NSString stringWithFormat:@"shift%d",[shiftDict[@"shift_id"] intValue]]];
            //    班次开始时间
            NSString * startStr = [[NSString stringWithFormat:@"%@",shiftTimeDict[@"send_shift_start_time"]] substringToIndex:16];
            [mulDict setObject:startStr forKey:@"shift_starttime"];
        }
        //   计划ID
        [mulDict setObject:@(0) forKey:@"sch_id"];
        //   计划开始时间
        [mulDict setObject:null forKey:@"sch_start_time"];
        //    计划结束时间
        [mulDict setObject:null forKey:@"sch_end_time"];
        //   行迹数据
        NSArray * trackArray = [USERDEFAULT valueForKey:[NSString stringWithFormat:@"%@%@", [USERDEFAULT valueForKey:NAMEING],@"location_track"]];
        [mulDict setObject:trackArray forKey:@"track_record"];
    }
    if (mulDict == nil) {
        return nil;
    }
    NSArray * array = @[mulDict];
    //  集成最终上传字典
    NSDictionary * dict = @{@"data_type":@(1),@"record":array};
    
    return dict;
}

/**
 上传行迹成功  删除被上传的行迹

 @param dict 被上传的行迹
 */
-(void)finishPostDeleteTrack:(NSDictionary *)dict
{
    NSArray * postTrackArray = dict[@"record"][0][@"track_record"];
    NSArray * allTrackArray = [USERDEFAULT valueForKey:[NSString stringWithFormat:@"%@%@", [USERDEFAULT valueForKey:NAMEING],@"location_track"]];
    NSMutableArray * mulArray = [NSMutableArray arrayWithArray:allTrackArray];
    //   在所有的行迹记录中  删除刚刚上传的数据
    for (NSDictionary * dict in postTrackArray) {
        [mulArray removeObject:dict];
    }
    if (mulArray.count == 0) {
        [USERDEFAULT removeObjectForKey:[NSString stringWithFormat:@"%@%@", [USERDEFAULT valueForKey:NAMEING],@"location_track"]];
    }else{
        [USERDEFAULT setObject:mulArray forKey:[NSString stringWithFormat:@"%@%@", [USERDEFAULT valueForKey:NAMEING],@"location_track"]];
    }
}
-(DevicePost *)devicepost
{
    if (_devicepost == nil) {
        _devicepost = [[DevicePost alloc]init];
    }
    return _devicepost;
}
@end
