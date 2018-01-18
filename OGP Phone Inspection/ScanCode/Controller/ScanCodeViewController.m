//
//  ScanCodeViewController.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/4.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "ScanCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanCodeView.h"
#import "EventViewController.h"
#import "ScanCodePost.h"
#import "DataBaseManager.h"
#import "TaskPost.h"
#import "ScheduleModel.h"
#import "ChooseSchWithDevice.h"
#import "ProjectViewController.h"
#import "PickerViewController.h"
#import "DevicePost.h"
@interface ScanCodeViewController () <AVCaptureMetadataOutputObjectsDelegate>
@property(nonatomic,strong) ScanCodeView * scanCode;
@property(nonatomic,strong) AVCaptureSession * qrCodesession;
@property(nonatomic,strong) AVCaptureDevice * qrCodedevice;
@property(nonatomic,copy) NSString * QRCodeStr;
@property(nonatomic,strong) ScanCodePost * scancodepost;
@property(nonatomic,strong) ChooseSchWithDevice * chooseView;
//   查询到的计划和设备信息
@property(nonatomic,strong) NSDictionary * schDict;
@property(nonatomic,strong) NSDictionary * deviceDict;
@property(nonatomic,strong) DevicePost * devicepost;

@end

@implementation ScanCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray * allHadSchArr = [USERDEFAULT valueForKey:SCH_SITE_DEVICE_ARRAY];
    if (allHadSchArr.count == 0) {
        DataBaseManager * db = [DataBaseManager shareInstance];
        NSArray * schArray = [TaskPost getIsShiftTask:[db selectSomething:@"schedule_record" value:@"(sch_type = 0 or other_has_start = 1)" keys:[ToolModel allPropertyNames:[ScheduleModel class]] keysKinds:[ToolModel allPropertyAttributes:[ScheduleModel class]]] shift:[USERDEFAULT valueForKey:SHIFT_DICT]];
        schArray = [TaskPost taskWorkDay:schArray];
        [USERDEFAULT setObject:schArray forKey:SCH_SITE_DEVICE_ARRAY];
    }
    
    UIImage *image = [ToolModel drawLinearGradient];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    // Do any additional setup after loading the view.
    self.qrCodedevice=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    NSError *error = nil;
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:self.qrCodedevice error:&error];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //初始化链接对象
    self.qrCodesession = [[AVCaptureSession alloc]init];
    //高质量采集率
    [self.qrCodesession setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.qrCodesession canAddInput:input]) {
        [self.qrCodesession addInput:input];
        [self.qrCodesession addOutput:output];
        
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        
        self.scanCode=[[ScanCodeView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:self.qrCodesession];
        layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
        layer.frame=self.scanCode.layer.bounds;
        [self.view addSubview:self.scanCode];
        [self.scanCode.layer addSublayer:layer];
        [self.scanCode qrCodeViewMake:self.kind];
        
        //扫描区域
        output.rectOfInterest=CGRectMake(0.15f, 0.12f, 0.5f, 0.76f);
        //开始捕获
        [self.qrCodesession startRunning];
        //   选择完扫描到的设备
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseDeviceFinish:) name:@"ChooseDevice" object:nil];
        //   防作弊拍照完成
        //   主页
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cheatPhotoFinishCode:) name:@"HomeQRCheatPhotoFinish" object:nil];
        //   设备页
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cheatPhotoFinishCode:) name:@"DeviceQRCheatPhotoFinish" object:nil];
    }else{
        NSLog(@"未检测到摄像头");
        self.view.backgroundColor = [UIColor whiteColor];
    }
}
//处理扫面结果  判断获得的字符串
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    [self.qrCodesession stopRunning];
    AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
    //   得到有效字符串
    self.QRCodeStr = [self.scancodepost qrCodeStr:metadataObject.stringValue];
    NSLog(@"%@",self.QRCodeStr);
    //   二维码是否可用
    if (self.QRCodeStr.length == 0) {
        //   二维码不可用
        [self notQrString:@"该二维码不可用！"];
    }else{
        //   事件绑定设备
        if (self.kind == 1) {
            NSDictionary * dict = @{@"scanCode":metadataObject.stringValue};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"EQUIPMENT_NUMBER" object:self userInfo:dict];
            
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[EventViewController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
        }else{
            //   未上班  不能扫码巡检
            if ([[USERDEFAULT valueForKey:CHECK_STATE] intValue] == 0) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Task_alert_nocheckin_title",@"") message:NSLocalizedString(@"Task_alert_nocheckin_message",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"All_sure",@"") otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
                //   不需要防作弊拍照
                //   获取设备信息
                NSDictionary * deviceDict = [self.scancodepost qrStrDeviceFromAll:self.QRCodeStr];
                if (deviceDict == nil) {
                    [self notQrString:@"档案中无此设备"];
                }else{
                    //   主页
                    if (self.type == 1) {
                        NSArray * array = [self.scancodepost isShiftSch:deviceDict qrstring:self.QRCodeStr];
                        //   通过查询的数量  判断操作
                        if (array.count == 0) {
                            [self notQrString:@"本班次计划中无此设备"];
                        }else if (array.count == 1){
                            //   直接跳入项目页面
                             [self pushProjectViewController:array[0][@"sch_dict"] device:array[0][@"device_dict"]];
                        }else{
                            //   多条计划  提供选择
                            self.chooseView = [[ChooseSchWithDevice alloc]initWithFrame:CGRectMake(0, 0, 0, 0) array:array where:0];
                            UIWindow * window = [UIApplication sharedApplication].keyWindow;
                            [window addSubview:self.chooseView];
                            [self.chooseView makeConstraints:^(MASConstraintMaker *make) {
                                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
                            }];
                        }
                    }else{
                        //   设备页
                        NSArray * array = [self.scancodepost isTouchSch:deviceDict qrstring:self.QRCodeStr];
                        if (array.count != 0) {
                            [self pushProjectViewController:array[0][@"sch_dict"] device:array[0][@"device_dict"]];
                        }else{
                            [self notQrString:@"本计划中无此设备"];
                        }
                    }
                }
            
        }
    }
}

/**
 选择设备完成

 @param sender <#sender description#>
 */
-(void)chooseDeviceFinish:(NSNotification *)sender
{
    //  移除选择窗口
    [self.chooseView removeFromSuperview];
    NSDictionary * dict = sender.userInfo;
    [self pushProjectViewController:dict[@"sch_dict"] device:dict[@"device_dict"]];
}
/**
 跳转到项目界面
 */
-(void)pushProjectViewController:(NSDictionary *)schDict device:(NSDictionary *)deviceDict
{
    self.schDict = schDict;
    self.deviceDict = deviceDict;
    //  设备已经巡检完
    if ([deviceDict[@"patrol_state"] intValue] == 3) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"All_alert_title",@"") message:NSLocalizedString(@"Device_hasFinish_iswill_look",@"") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"All_sure",@"") style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self cheatAndPush:schDict device:deviceDict];
        }]];
        [alert addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"All_cancel",@"") style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.qrCodesession startRunning];
        }]];
        [self presentViewController: alert animated: YES completion: nil];
        return;
    }

    //   如果需要顺序巡检
    if ([schDict[@"squenct_check"] intValue] == 1) {
        if ([deviceDict[@"patrol_state"] intValue] != 0) {
            //   已经开始的   不再检测顺序
            [self cheatAndPush:schDict device:deviceDict];
        }else{
            if ([self.devicepost deviceIsSequence:schDict[@"device_array"] touchDict:deviceDict sequence_type:[schDict[@"sequence_type"] intValue]]) {
                //   如果是按顺序的
                [self cheatAndPush:schDict device:deviceDict];
            }else{
                UIAlertController * alert1 = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Device_alert_isno_order",@"") message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alert1 addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"All_sure",@"") style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [self.qrCodesession startRunning];
                }]];
                [self presentViewController: alert1 animated: YES completion: nil];
            }
        }
    }else{//   如果不需要顺序
        [self cheatAndPush:schDict device:deviceDict];
    }
}
-(void)cheatAndPush:(NSDictionary *)schDict device:(NSDictionary *)deviceDict
{
    if ([self.devicepost isPushPickerViewController:deviceDict schDict:schDict generateType:1]) {
        //   需要防作弊拍照
        PickerViewController * picker = [[PickerViewController alloc]init];
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        picker.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        picker.isProject = NO;
        if (self.type == 1) {
            picker.isCheat = 2;
        }else{
            picker.isCheat = 3;
        }
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            //   不需要防作弊拍照
            ProjectViewController * project = [[ProjectViewController alloc]init];
            project.siteDict = schDict;
            project.deviceDic = deviceDict;
//            project.mustPhoto = 0;
//            project.photoFlag = 0;
//            project.fildName = nil;
//            project.qrDataDict = nil;
            project.isCode = YES;
            //    project.deviceContent = self.QRCodeStr;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:project animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        });
    }
//    if ([self.scancodepost photoRate]) {
//        //   需要防作弊拍照
//        PickerViewController * picker = [[PickerViewController alloc]init];
//        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
//        picker.isProject = NO;
//        if (self.type == 1) {
//            picker.isCheat = 2;
//        }else{
//            picker.isCheat = 3;
//        }
//        [self.navigationController presentViewController:picker animated:YES completion:nil];
//    }else{
//        [RecordKeepModel recordKeep_recordType:@"PATROL"
//                                       schDict:self.schDict
//                                    deviceDict:deviceDict
//                                     itemsDict:nil
//                                  generateType:1
//                                     cheatDict:[RecordKeepModel cheat_mustPhoto:0 photoFlag:0 photoName:nil recordcontent:nil eventDeviceCode:nil]];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //   不需要防作弊拍照
//            ProjectViewController * project = [[ProjectViewController alloc]init];
//            project.siteDict = schDict;
//            project.deviceDic = deviceDict;
//            project.mustPhoto = 0;
//            project.photoFlag = 0;
//            project.fildName = nil;
//            project.qrDataDict = nil;
//            project.isCode = YES;
//            //    project.deviceContent = self.QRCodeStr;
//            self.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:project animated:YES];
//            self.hidesBottomBarWhenPushed = NO;
//        });
//    }
}
/**
 防作弊拍照完成

 @param sender <#sender description#>
 */
-(void)cheatPhotoFinishCode:(NSNotification *)sender
{
    // 获得的照片信息
    NSDictionary * dict = sender.userInfo;
    if (dict == nil) {
        //   储存住记录信息
        [RecordKeepModel recordKeep_recordType:@"PATROL"
                                       schDict:self.schDict
                                    deviceDict:self.deviceDict
                                     itemsDict:nil
                                  generateType:1
                                     cheatDict:[RecordKeepModel cheat_mustPhoto:1 photoFlag:0 photoName:nil recordcontent:nil eventDeviceCode:nil]];
    }else{
        NSDictionary * recordDict = [RecordKeepModel recordKeep_recordType:@"PATROL"
                                                                   schDict:self.schDict
                                                                deviceDict:self.deviceDict
                                                                 itemsDict:nil
                                                              generateType:1
                                                                 cheatDict:[RecordKeepModel cheat_mustPhoto:1 photoFlag:1 photoName:dict[@"file_name"] recordcontent:nil eventDeviceCode:nil]];
        //   储存防作弊流信息
        [RecordKeepModel cheat_cheatDict:dict recordDict:recordDict];
    }
//    dispatch_async(dispatch_get_main_queue(), ^{
        ProjectViewController * project = [[ProjectViewController alloc]init];
        project.siteDict = self.schDict;
        project.deviceDic = self.deviceDict;
//        project.mustPhoto = 1;
//        project.photoFlag = 1;
//        project.fildName = dict[@"file_name"];
//        project.qrDataDict = dict;
//        if (dict == nil) {
//            project.photoFlag = 0;
//        }
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:project animated:YES];
        self.hidesBottomBarWhenPushed = NO;
//    });
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.qrCodesession stopRunning];
}
/**
 无效二维码提示

 @param title 提示信息
 */
-(void)notQrString:(NSString *)title
{
    UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertControler addAction: [UIAlertAction actionWithTitle:NSLocalizedString(@"All_sure",@"") style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.qrCodesession startRunning];
    }]];
    [self presentViewController: alertControler animated: YES completion: nil];
}
-(ScanCodePost *)scancodepost
{
    if (_scancodepost == nil) {
        _scancodepost = [[ScanCodePost alloc]init];
    }
    return _scancodepost;
}
-(DevicePost *)devicepost
{
    if (_devicepost == nil) {
        _devicepost = [[DevicePost alloc]init];
    }
    return _devicepost;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.qrCodesession startRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
