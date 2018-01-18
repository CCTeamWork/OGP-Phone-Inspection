//
//  PickerViewController.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/28.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "PickerViewController.h"

@interface PickerViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong) UIImage * pickerImage;
@property(nonatomic,strong) NSTimer * timer;
@property(nonatomic,strong) UILabel * timeLa;
//   拍照倒计时时间
@property(nonatomic,assign) int pickerTime;
@end

@implementation PickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //   如果是防作弊
    if (self.isCheat) {
        self.timeLa=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, WIDTH, 20)];
        self.timeLa.textAlignment=NSTextAlignmentCenter;
        self.timeLa.text=[NSString stringWithFormat:@"拍照倒计时：%ds",60];
        self.timeLa.textColor=[UIColor redColor];
        [self.view addSubview:self.timeLa];
        self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(addTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        self.pickerTime=60;
    }
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    self.sourceType = UIImagePickerControllerSourceTypeCamera;
    if(![UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
//    self.sourceType=UIImagePickerControllerSourceTypeCamera;
//    
//    //录制视频时长，默认10s
//    self.videoMaximumDuration = 15;
//    self.videoQuality = UIImagePickerControllerQualityTypeHigh;
//    //设置摄像头模式（拍照，录制视频）为录像模式
//    self.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    
    self.allowsEditing=YES;
    self.delegate=self;
    
    if ([[USERDEFAULT valueForKey:@"PhotoAlert"] intValue] != 1 && self.isCheat) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"防作弊拍照！" message:@"请按要求拍一张照片" delegate:self cancelButtonTitle:@"不再提示" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
- (void) alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [USERDEFAULT setObject:@(1) forKey:@"PhotoAlert"];
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.pickerImage=[info objectForKey:UIImagePickerControllerEditedImage];
    if (self.pickerImage==nil) {
        self.pickerImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    }
    NSData * data=[self pickerImage:self.pickerImage];
    NSDictionary * dic=@{@"PickerImage":data,
                         @"content_path":[ToolModel saveImage:data],
                         @"data_record_show":[NSString stringWithFormat:@"%ld",[data length]],
                         @"file_name":[NSString stringWithFormat:@"%@.jpg",[ToolModel uuid]]};
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
            // 改变状态栏的颜色  改变为白色
//            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
//        [self.navigationController popViewControllerAnimated:YES];
    });
    [self.timer invalidate];
    self.timer=nil;
    [self choose:dic];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self.timer invalidate];
    self.timer=nil;
    [self choose:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(NSData *)pickerImage:(UIImage *)image
{
    NSData *data=UIImageJPEGRepresentation(image, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(image, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(image, 0.4);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(image, 0.6);
        }
    }
    return data;
}

/**
 防作弊拍照倒计时
 */
-(void)addTime
{
    self.timeLa.text = [NSString stringWithFormat:@"拍照倒计时：%ds",self.pickerTime];
    //   拍照时间到  （未拍照）
    if (self.pickerTime == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.timer invalidate];
            self.timer=nil;
            [self choose:nil];
            [self dismissViewControllerAnimated:YES completion:^{}];
        });
    }
    self.pickerTime--;
}
-(void)choose:(NSDictionary *)dic
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        switch (self.isCheat) {
            case 0:
                //   不是防作弊
                //    如果是从项目页面进入
                if (self.isProject == YES) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProjectPhotoFinish"
                                                                        object:nil
                                                                      userInfo:dic];
                }else{
                    //   正常事件页面的拍照
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"PickerImageFinish"
                                                                        object:nil
                                                                      userInfo:dic];
                }
                break;
            case 1:
                //   上班防作弊
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CheckCheatPhotoFinish"
                                                                    object:nil
                                                                  userInfo:dic];
                break;
            case 2:
                //  主页扫码防作弊
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeQRCheatPhotoFinish"
                                                                    object:nil
                                                                  userInfo:dic];
                break;
            case 3:
                //  设备扫码防作弊
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DeviceQRCheatPhotoFinish"
                                                                    object:nil
                                                                  userInfo:dic];
                break;
            case 4:
                //   点击设备防作弊
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DeviceTouchCheatPhotoFinish"
                                                                    object:nil
                                                                  userInfo:dic];
                break;
            default:
                break;
        }
//    });
    
}
//-(void)viewWillAppear:(BOOL)animated {
//    self.tabBarController.tabBar.hidden = YES;
//}
-(void)viewWillDisappear:(BOOL)animated {

}
//-(void)dealloc{
//     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ProjectPhotoFinish" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PickerImageFinish" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CheckCheatPhotoFinish" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HomeQRCheatPhotoFinish" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DeviceQRCheatPhotoFinish" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DeviceTouchCheatPhotoFinish" object:nil];
//}
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
