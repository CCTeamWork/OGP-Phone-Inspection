//
//  TimeFromInternet.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/20.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeFromInternet : NSObject
//   百度  谷歌轮换访问
@property(nonatomic,assign) BOOL change;
@property(nonatomic,strong) NSDateFormatter *dateFormatter;
//  时间戳
@property(nonatomic,assign) long tsmptime;
//   访问次数
@property(nonatomic,assign) int count;


/**
 对比时间    判断用户是否更改时间
 */
-(void)getTimeFromInternet;
@end
