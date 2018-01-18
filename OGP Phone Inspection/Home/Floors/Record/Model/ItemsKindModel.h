//
//  ItemsKindModel.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/25.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemsKindModel : NSObject

//@property(nonatomic,strong) NSString * item_state;
@property(nonatomic,strong) NSString * record_uuid;
@property(nonatomic,strong) NSString * items_uuid;
@property(nonatomic,strong) NSString * data_uuid;
@property(nonatomic,assign) NSInteger * items_id;
@property(nonatomic,assign) NSInteger * items_overdue;
@property(nonatomic,assign) NSInteger * items_miss;
@property(nonatomic,assign) NSInteger * items_offline;
@property(nonatomic,assign) NSInteger * items_category;
@property(nonatomic,strong) NSString * items_value;
@property(nonatomic,strong) NSString * items_scantime;
@property(nonatomic,strong) NSString * items_gps_time;
@property(nonatomic,strong) NSString * items_location_category;
@property(nonatomic,strong) NSString * items_longitude;
@property(nonatomic,strong) NSString * items_latitude;
@property(nonatomic,strong) NSString * items_status;
@property(nonatomic,assign) NSInteger * items_value_status;


@end
