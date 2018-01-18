//
//  YGWeakTimer.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/11/6.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HWTimerHandler)(id userInfo);

@interface YGWeakTimer : NSObject

+ (NSTimer *) scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      target:(id)aTarget
                                    selector:(SEL)aSelector
                                    userInfo:(id)userInfo
                                     repeats:(BOOL)repeats;

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(HWTimerHandler)block
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats;
@end
