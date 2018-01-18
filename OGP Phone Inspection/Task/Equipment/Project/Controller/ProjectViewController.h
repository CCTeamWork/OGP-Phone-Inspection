//
//  ProjectViewController.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/1.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectViewController : UIViewController

@property(nonatomic,strong) NSDictionary * deviceDic;
@property(nonatomic,strong) NSDictionary * siteDict;
//    是否是从预览进入 0:否   1:是
@property(nonatomic,assign) int pre;
//  预览进入有项目数据  检查项纪录数据  （非检查项表  检查项记录表）
@property(nonatomic,strong) NSDictionary * itemsDict;

//   扫码进入
@property(nonatomic,assign) BOOL isCode;
//@property(nonatomic,assign) int mustPhoto;
//@property(nonatomic,assign) int photoFlag;
//@property(nonatomic,strong) NSString * fildName;
//@property(nonatomic,strong) NSDictionary * qrDataDict;
//  自动匹配点进入
@property(nonatomic,assign) int isLocationPush;

@end
