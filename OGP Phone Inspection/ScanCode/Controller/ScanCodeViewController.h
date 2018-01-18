//
//  ScanCodeViewController.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/4.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanCodeViewController : UIViewController
@property(nonatomic,assign) int kind;
//   判断是主页的二维码还是设备中的二维码
@property(nonatomic,assign) int type;
@end
