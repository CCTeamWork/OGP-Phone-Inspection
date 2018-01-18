//
//  ScanCodeView.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/5.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "ScanCodeView.h"
#define SCANVIEW_EdgeTop 40.0
#define SCANVIEW_EdgeLeft 50.0
#define TINTCOLOR_ALPHA 0.2 //浅色透明度
#define DARKCOLOR_ALPHA 0.5 //深色透明度
@implementation ScanCodeView

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.qrIsLighton=NO;
    }
    return self;
}
-(void)qrCodeViewMake:(int)kind
{
    [self createTimer];
    UIView * upView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , 0 , WIDTH , SCANVIEW_EdgeTop+50 )];
    upView. alpha = TINTCOLOR_ALPHA ;
    upView. backgroundColor = [ UIColor blackColor ];
    [ self addSubview :upView];
    UIImageView * QRimage=[[UIImageView alloc]init];
    QRimage.image=nil;
    [upView addSubview:QRimage];
    [QRimage makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(upView.left).offset(WIDTH/6);
        make.bottom.equalTo(upView.bottom).offset(-10);
        make.width.equalTo(WIDTH-2*SCANVIEW_EdgeLeft-40);
        make.height.equalTo(60);
    }];
    //左侧的view
    UIView *leftView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , SCANVIEW_EdgeTop+50 , SCANVIEW_EdgeLeft , WIDTH - 2 * SCANVIEW_EdgeLeft )];
    leftView. alpha = TINTCOLOR_ALPHA ;
    leftView. backgroundColor = [ UIColor blackColor ];
    [ self addSubview :leftView];
    /******************中间扫描区域****************************/
    UIImageView *scanCropView=[[ UIImageView alloc ] initWithFrame : CGRectMake ( SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop+50 , WIDTH - 2 * SCANVIEW_EdgeLeft , WIDTH - 2 * SCANVIEW_EdgeLeft )];
    //scanCropView.image=[UIImage imageNamed:@""];
    //scanCropView. layer . borderColor =[ UIColor getThemeColor ] . CGColor ;
    scanCropView. layer . borderWidth = 2.0 ;
    scanCropView. backgroundColor =[ UIColor clearColor ];
    [ self addSubview :scanCropView];
    //右侧的view
    UIView *rightView = [[ UIView alloc ] initWithFrame : CGRectMake ( WIDTH - SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop+50 , SCANVIEW_EdgeLeft , WIDTH - 2 * SCANVIEW_EdgeLeft )];
    rightView. alpha = TINTCOLOR_ALPHA ;
    rightView. backgroundColor = [ UIColor blackColor ];
    [ self addSubview :rightView];
    //底部view
    UIView *downView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , WIDTH - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop +50, WIDTH , HEIGHT -( WIDTH - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop+114) )];
    //downView.alpha = TINTCOLOR_ALPHA;
    downView. backgroundColor = [[ UIColor blackColor ] colorWithAlphaComponent : TINTCOLOR_ALPHA ];
    [ self addSubview :downView];
    //用于说明的label
    UILabel *labIntroudction= [[ UILabel alloc ] init ];
    labIntroudction. backgroundColor = [ UIColor clearColor ];
    labIntroudction. frame = CGRectMake ( 5 , 5 , WIDTH , 50 );
    labIntroudction. numberOfLines = 0;
    labIntroudction. font =[ UIFont systemFontOfSize : 15.0 ];
    labIntroudction. textAlignment = NSTextAlignmentCenter ;
    labIntroudction. textColor =[ UIColor whiteColor ];
    labIntroudction. text = NSLocalizedString(@"QRCode_message",@"") ;
    [downView addSubview :labIntroudction];
    
    UIView *darkView = [[ UIView alloc ] init];
    if (kind == 1) {
        darkView.frame =  CGRectMake ( 0 , downView. frame . size . height - 100 , WIDTH , 100.0 );
    }else{
        darkView.frame =  CGRectMake ( 0 , downView. frame . size . height - 150.0 , WIDTH , 100.0 );
    }
    darkView. backgroundColor = [[ UIColor blackColor ]  colorWithAlphaComponent : DARKCOLOR_ALPHA ];
    [downView addSubview :darkView];
    
    
    //用于开关灯操作的button
    UIButton *openButton=[[ UIButton alloc ] initWithFrame : CGRectMake (WIDTH/2-90 , 20 , 180.0 , 40.0 )];
    [openButton setTitle : NSLocalizedString(@"QRCode_torch_open",@"") forState: UIControlStateNormal ];
    [openButton setTitleColor :[ UIColor whiteColor ] forState : UIControlStateNormal ];
    openButton. titleLabel . textAlignment = NSTextAlignmentCenter ;
    //openButton. backgroundColor =[ UIColor getThemeColor ];
    openButton. titleLabel . font =[ UIFont systemFontOfSize : 22.0 ];
    [openButton addTarget : self action : @selector (turnOnLede) forControlEvents : UIControlEventTouchUpInside ];
    [darkView addSubview :openButton];
    //画中间的基准线
    self.qrCodeLine = [[ UIView alloc ] initWithFrame : CGRectMake ( SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop+50 , WIDTH - 2 * SCANVIEW_EdgeLeft , 2 )];
    self.qrCodeLine . backgroundColor = [ UIColor whiteColor ];
    [ self addSubview : self.qrCodeLine ];
}
//二维码界面的闪光灯控制
-(void)turnOnLede {
    self.qrCodedevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (![self.qrCodedevice hasTorch]) {//判断是否有闪光灯
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"All_message",@"") message:NSLocalizedString(@"QRCode_torch_message",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"All_sure",@"") otherButtonTitles:nil, nil];
        [alter show];
    }
    self.qrIsLighton = 1-self.qrIsLighton;
    if (self.qrIsLighton) {
        [self turnOnLede:YES];
    }else{
        [self turnOffLede:YES];
    }
}
//打开闪光灯
-(void) turnOnLede:(bool)update
{
    [self.qrCodedevice lockForConfiguration:nil];
    [self.qrCodedevice setTorchMode:AVCaptureTorchModeOn];
    [self.qrCodedevice unlockForConfiguration];
}
//关闭闪光灯
-(void) turnOffLede:(bool)update
{
    [self.qrCodedevice lockForConfiguration:nil];
    [self.qrCodedevice setTorchMode: AVCaptureTorchModeOff];
    [self.qrCodedevice unlockForConfiguration];
}
- ( void )createTimer
{
    //创建一个时间计数
    self.timer=[NSTimer scheduledTimerWithTimeInterval: 2.0 target: self selector: @selector (moveUpAndDownLine) userInfo: nil repeats: YES ];
}
//二维码的横线移动
- ( void )moveUpAndDownLine
{
    CGFloat Y= self.qrCodeLine . frame . origin . y ;
    //CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, VIEW_WIDTH-2*SCANVIEW_EdgeLeft, 1)]
    if (WIDTH- 2 *SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop==Y-50){
        [UIView beginAnimations: @"asa" context: nil ];
        [UIView setAnimationDuration: 2 ];
        self.qrCodeLine.frame=CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop+50, WIDTH- 2 *SCANVIEW_EdgeLeft, 1 );
        [UIView commitAnimations];
    } else if (SCANVIEW_EdgeTop==Y-50){
        [UIView beginAnimations: @"asa" context: nil ];
        [UIView setAnimationDuration: 2 ];
        self.qrCodeLine.frame=CGRectMake(SCANVIEW_EdgeLeft, WIDTH- 2 *SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop+50, WIDTH- 2 *SCANVIEW_EdgeLeft, 1 );
        [UIView commitAnimations];
    }
}

@end
