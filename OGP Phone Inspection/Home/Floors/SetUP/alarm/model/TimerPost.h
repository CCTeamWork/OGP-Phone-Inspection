//
//  TimerPost.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/25.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerPost : NSObject

/**
 通过当前计划集成闹钟数组
 
 @return 闹钟数组
 */
+(NSArray *)timeArrayFromTask;
@end
