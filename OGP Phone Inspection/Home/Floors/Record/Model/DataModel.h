//
//  DataModel.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/25.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property(nonatomic,strong) NSString * content_path;
@property(nonatomic,strong) NSString * data_record_show;
@property(nonatomic,strong) NSString * data_uuid;
@property(nonatomic,strong) NSString * event_category;
@property(nonatomic,strong) NSString * file_name;
@property(nonatomic,strong) NSString * file_scantime;
@property(nonatomic,strong) NSString * file_gps_time;
@property(nonatomic,strong) NSString * file_longitude;
@property(nonatomic,strong) NSString * file_latitude;
@property(nonatomic,assign) NSInteger * file_offline;
@property(nonatomic,strong) NSString * file_location_category;
@property(nonatomic,assign) NSInteger * file_overdue;
@property(nonatomic,strong) NSString * items_uuid;
@property(nonatomic,assign) NSInteger * data_state;
@property(nonatomic,strong) NSString * user_name;

@end
