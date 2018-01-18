//
//  DeviceItemModel.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/25.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceItemModel : NSObject
@property(nonatomic,assign) NSInteger * site_device_id;
@property(nonatomic,assign) NSInteger * items_id;
@property(nonatomic,strong) NSString * items_name;
@property(nonatomic,assign) NSInteger * category;
@property(nonatomic,assign) NSInteger * options_group_id;
@property(nonatomic,strong) NSString * standard;
@property(nonatomic,strong) NSString * comments;
@property(nonatomic,strong) NSString * standar_value_option;
@property(nonatomic,strong) NSString * standar_value_number_start;
@property(nonatomic,strong) NSString * standar_value_number_end;
@property(nonatomic,strong) NSString * standar_value_format;
@property(nonatomic,assign) NSInteger * unit_id;
@property(nonatomic,strong) NSString * device_status_code;
@end
