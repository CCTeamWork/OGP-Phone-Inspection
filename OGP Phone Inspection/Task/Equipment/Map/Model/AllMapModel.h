//
//  AllMapModel.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/11.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DevicePost.h"
#import  <MapKit/MapKit.h>
@interface AllMapModel : NSObject


//   自动匹配点信息
//   上次匹配到的设备信息
@property(nonatomic,strong) NSDictionary * lastDeviceDict;
//   上次匹配到的设备时的定位信息
@property(nonatomic,strong) CLLocation * lastLocation;
//  自动匹配点计时器
@property(nonatomic,strong) NSTimer * deviceTimer;
//   本次的定位信息（用于取定位时间）
@property(nonatomic,strong) CLLocation * nowLocation;
//   自动定位计时
@property(nonatomic,assign) int deviceTime;
//   本次定位信息（用于取经纬度）
@property(nonatomic,assign) CLLocationCoordinate2D deviceDinate2D;
@property(nonatomic,strong) DevicePost * devicepost;

//   行迹信息
//  每一次定位储存的计时器
@property(nonatomic,strong) NSTimer * keepLocationTimer;
//   储存定位的时长
@property(nonatomic,assign) int keepTime;
//   每一次上传行迹的计时器
@property(nonatomic,strong) NSTimer * sendLocationTimer;
//   上传行迹的时长
@property(nonatomic,assign) int sendTime;



//计算移动的距离
+(BOOL)distanceOldLat:(double)oldLat oldLong:(double)oldLong nowLat:(double)nowLat nowLong:(double)nowLong;

/**
 制作自动匹配计时器
 
 @param location 定位信息
 */
-(void)timerFromLocation:(CLLocation *)location deviceDinate2D:(CLLocationCoordinate2D)deviceDinate2D;
@end
