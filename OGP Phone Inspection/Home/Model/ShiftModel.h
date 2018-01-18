//
//  ShiftModel.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/25.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShiftModel : NSObject

@property(nonatomic,assign) NSInteger * shift_id;
@property(nonatomic,strong) NSString * shift_name;
@property(nonatomic,strong) NSString * working_hours;
@property(nonatomic,strong) NSString * off_hours;
@property(nonatomic,assign) NSInteger * compare_id;
@end
