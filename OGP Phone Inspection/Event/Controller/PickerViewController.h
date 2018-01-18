//
//  PickerViewController.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/28.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerViewController : UIImagePickerController
//   是否是在项目页面进入
@property(nonatomic,assign) BOOL isProject;
//   是否是防作弊进入  (1:点击设备   2:扫码进入)
@property(nonatomic,assign) int isCheat;
@end
