//
//  AllKindModel.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/25.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface AllKindModel : NSObject

@property(nonatomic,strong) NSString * user_name;
@property(nonatomic,strong) NSString * record_sendtime;
@property(nonatomic,strong) NSString * record_device_name;
@property(nonatomic,assign) NSInteger * record_device_number;
@property(nonatomic,strong) NSString * record_device_mark;
@property(nonatomic,assign) NSInteger * record_state;
@property(nonatomic,strong) NSString * record_uuid;
@property(nonatomic,strong) NSString * items_uuid;
@property(nonatomic,strong) NSString * data_uuid;
@property(nonatomic,assign) NSInteger * record_site_id;
@property(nonatomic,assign) NSInteger * record_shift_id;
@property(nonatomic,assign) NSInteger * record_sch_id;
@property(nonatomic,strong) NSString * record_sch_start_time;
@property(nonatomic,strong) NSString * record_sch_end_time;
@property(nonatomic,strong) NSString * record_category;
@property(nonatomic,strong) NSString * record_content;
@property(nonatomic,strong) NSString * record_scantime;
@property(nonatomic,strong) NSString * record_gps_time;
@property(nonatomic,strong) NSString * record_longitude;
@property(nonatomic,strong) NSString * record_latitude;
@property(nonatomic,assign) NSInteger * record_offline;
@property(nonatomic,assign) NSInteger * record_must_photo;
@property(nonatomic,assign) NSInteger * record_photo_flag;
@property(nonatomic,strong) NSString * record_location_category;
@property(nonatomic,assign) NSInteger * record_overdue;
@property(nonatomic,strong) NSString * record_status;
@property(nonatomic,assign) NSInteger * record_gps_outside;
@property(nonatomic,strong) NSString * event_device_code;
@property(nonatomic,strong) NSString * record_shift_starttime;
@property(nonatomic,assign) NSInteger * record_sch_seq;
@property(nonatomic,strong) NSString * photo_name;
@property(nonatomic,assign) NSInteger * patrol_state;
@property(nonatomic,assign) NSInteger * record_generate_type;
@end
