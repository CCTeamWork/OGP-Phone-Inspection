//
//  ScheduleModel.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/25.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleModel : NSObject

@property(nonatomic,assign) NSInteger * sch_id;
@property(nonatomic,assign) NSInteger * site_id;
@property(nonatomic,assign) NSInteger * sch_type;
@property(nonatomic,strong) NSString * valid_date_start;
@property(nonatomic,strong) NSString * valid_date_end;
@property(nonatomic,strong) NSString * start_time;
@property(nonatomic,strong) NSString * end_time;
@property(nonatomic,assign) NSInteger * other_start_date;
@property(nonatomic,assign) NSInteger * other_end_date;
@property(nonatomic,assign) NSInteger * tolerance;
@property(nonatomic,strong) NSString * working_day;
@property(nonatomic,assign) NSInteger * squenct_check;
@property(nonatomic,assign) NSInteger * sequence_type;
@property(nonatomic,assign) NSInteger * repeat_interval;
@property(nonatomic,assign) NSInteger * same_sch_seq;
@property(nonatomic,assign) NSInteger * other_has_start;

@end
