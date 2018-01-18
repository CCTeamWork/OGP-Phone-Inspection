//
//  ScanCodeView.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/5.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ScanCodeView : UIView
@property(nonatomic,strong) UIView * qrCodeLine;
@property(nonatomic,strong) AVCaptureDevice * qrCodedevice;
@property(nonatomic,assign) BOOL qrIsLighton;
@property(nonatomic,strong) NSTimer * timer;
-(void)qrCodeViewMake:(int)kind;
@end
