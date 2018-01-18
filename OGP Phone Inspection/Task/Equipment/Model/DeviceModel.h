//
//  DeviceModel.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/25.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceModel : NSObject

@property(nonatomic,assign) NSInteger * site_device_id;
@property(nonatomic,strong) NSString * device_mark;
@property(nonatomic,strong) NSString * device_number;
@property(nonatomic,strong) NSString * device_number_qr;
@property(nonatomic,strong) NSString * device_number_nfc;
@property(nonatomic,strong) NSString * device_name;
@property(nonatomic,assign) NSInteger * site_id;
@property(nonatomic,strong) NSString * def_lng;
@property(nonatomic,strong) NSString * def_lat;
@property(nonatomic,assign) NSInteger * gps_range;
@property(nonatomic,assign) NSInteger * sequence;
@property(nonatomic,assign) NSInteger * modify_flag;
@property(nonatomic,strong) NSString * status_id;
@property(nonatomic,strong) NSString * items_ids;
@property(nonatomic,assign) NSInteger * gps_check;
@property(nonatomic,assign) NSInteger * gps_match_range;
@end
