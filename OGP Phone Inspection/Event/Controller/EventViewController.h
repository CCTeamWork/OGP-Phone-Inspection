//
//  EventViewController.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/4.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventViewController : UIViewController
//  是否与项目绑定
@property(nonatomic,assign) BOOL isProject;

@property(nonatomic,strong) void (^projectEventBlock)(NSDictionary * dic);
//   项目界面已经有的时间数据
@property(nonatomic,strong) NSDictionary * projectDict;


//   计划 设备  项目数据
@property(nonatomic,strong) NSDictionary * deviceDict;
@property(nonatomic,strong) NSDictionary * schDict;
@property(nonatomic,strong) NSDictionary * itemDict;
@end
