//
//  ProjectSimpleViewController.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 2017/12/27.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectSimpleViewController : UIViewController

@property(nonatomic,strong) NSDictionary * sdeviceDic;
@property(nonatomic,strong) NSDictionary * ssiteDict;
//    是否是从预览进入 0:否   1:是
//@property(nonatomic,assign) int spre;
//  预览进入有项目数据  检查项纪录数据  （非检查项表  检查项记录表）
//@property(nonatomic,strong) NSDictionary * sitemsDict;
//   扫码进入
//@property(nonatomic,assign) BOOL sisCode;
//  自动匹配点进入
@property(nonatomic,assign) int sisLocationPush;
@end
