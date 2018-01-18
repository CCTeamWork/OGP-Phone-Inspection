//
//  TimerModel.h
//  OGP phone patrol
//
//  Created by 张建伟 on 17/5/8.
//  Copyright © 2017年 张建伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerModel : NSObject
- (void)addLocalNotification:(NSArray *)array;
- (void)deleteLocalNotification:(NSDictionary *)dict;
-(void) deleteAllLocalNotification;
- (void)addLocalNotificationOne:(NSDictionary *)dic;
-(void)addMineLocalNotification:(NSDictionary *)dict againTime:(NSMutableArray *)array;
@end
