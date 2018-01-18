//
//  RecordDetailViewController.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/21.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordDetailViewController : UIViewController
@property(nonatomic,strong) NSDictionary * deviceDict;

//   判断是记录  还是预览 0:记录  1:预览
@property(nonatomic,assign) int r;
//   计划字典 预览才有
@property(nonatomic,strong) NSDictionary * siteDict;
///   是否是扫码进入的
@property(nonatomic,assign) BOOL isCodeForPre;
@end
