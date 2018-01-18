//
//  HomePageViewController.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/4.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomePageView.h"
#import "RecordViewController.h"
#import "NoticeViewController.h"
#import "LoginViewController.h"
#import "SetViewController.h"
#import "ToolControl.h"
#import "ClassesView.h"
#import "LoginModel.h"
#import "YYModel.h"
#import "LoginBackModel.h"
#import "DataBaseManager.h"
#import "PostUPNetWork.h"
#import "HomePagePost.h"
#import "MBProgressHUD.h"
#import "ShiftModel.h"
#import "PickerViewController.h"
#import "TimeFromInternet.h"
#import "TaskPost.h"
#import "TimerPost.h"
#import "ScheduleModel.h"
#import "AllMapModel.h"
#import "BMapKit.h"
#import <GoogleMaps/GoogleMaps.h>
#import "ZCChinaLocation.h"
#import "TQLocationConverter.h"
#import "DevicePost.h"
#import "ChooseSchWithDevice.h"
#import "ProjectViewController.h"
#import "AllKindModel.h"
@interface HomePageViewController () <CLLocationManagerDelegate,BMKLocationServiceDelegate>
@property(nonatomic,strong) UIBarButtonItem * imageItem;
@property(nonatomic,strong) UIBarButtonItem * nameItem;
@property(nonatomic,strong) UIBarButtonItem * phoneItem;
@property(nonatomic,strong) UIBarButtonItem * setItem;
@property(nonatomic,strong) ClassesView * classes;
@property(nonatomic,strong) NSArray * shiftArray;
@property(nonatomic,strong) MBProgressHUD * hud;
@property(nonatomic,strong) HomePagePost * homepage;
@property(nonatomic,strong) NSTimer * timer;
@property(nonatomic,strong) NSDictionary * shiftDict;
@property(nonatomic,strong) TimeFromInternet * internetTime;
@property(nonatomic,strong) AllMapModel * mapmodel;
@property(nonatomic,strong) BMKMapManager* mapManager;
@property(nonatomic,strong) BMKLocationService * locService;
@property(nonatomic,strong) CLLocationManager * locationManager;
@property(nonatomic,strong) DevicePost * devicepost;
@property(nonatomic,strong) ChooseSchWithDevice * chooseView;
@end

@implementation HomePageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(checkBtnTextChange) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    //  导航栏背景色
//    [self.navigationController.navigationBar.layer insertSublayer:[ToolModel gradientLayer] above:nil];
    UIImage *image = [ToolModel drawLinearGradient];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    //   主页面view
    self.pageHome = [[HomePageView alloc]init];
    [self.view addSubview:self.pageHome];
    [self.pageHome makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(0);
        make.top.equalTo(self.view.top).offset(0);
        make.right.equalTo(self.view.right).offset(0);
        make.bottom.equalTo(self.view.bottom).offset(-44);
    }];
    
    //  导航栏左侧的两个item
    self.imageItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"user"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.imageItem.enabled = YES;
    self.nameItem = [[UIBarButtonItem alloc]initWithTitle:[USERDEFAULT valueForKey:NAMEING] style:UIBarButtonItemStylePlain target:self action:nil];
    if ([[USERDEFAULT valueForKey:CHECK_STATE] intValue] == 1) {
        self.nameItem.title = [NSString stringWithFormat:@"%@%@",[USERDEFAULT valueForKey:NAMEING],NSLocalizedString(@"Home_is_checkin",@"")];
    }else{
        self.nameItem.title = [NSString stringWithFormat:@"%@%@",[USERDEFAULT valueForKey:NAMEING],NSLocalizedString(@"Home_is_checkout",@"")];
    }
    self.imageItem.tintColor = [UIColor whiteColor];
    self.nameItem.tintColor = [UIColor whiteColor];
    NSArray * leftArray = @[self.imageItem,self.nameItem];
    self.navigationItem.leftBarButtonItems = leftArray;
    //  导航栏右侧的两个item
    self.phoneItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tel"] style:UIBarButtonItemStylePlain target:self action:@selector(homeTelPhoneCall)];
    self.setItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"set"] style:UIBarButtonItemStylePlain target:self action:@selector(pushSetViewController)];
    NSArray * rightArray = @[self.setItem,self.phoneItem];
    self.phoneItem.tintColor = [UIColor whiteColor];
    self.setItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItems = rightArray;
    
    //   上班下班
    [self.pageHome.checkBtn addTarget:self action:@selector(checkin:) forControlEvents:UIControlEventTouchUpInside];
    //   下载档案
    [self.pageHome.downBtn addTarget:self action:@selector(downLoad:) forControlEvents:UIControlEventTouchUpInside];
    //  记录
    [self.pageHome.recordBtn addTarget:self action:@selector(pushRecordController) forControlEvents:UIControlEventTouchUpInside];
    //   通知
    [self.pageHome.navitationBtn addTarget:self action:@selector(pushNoticeController) forControlEvents:UIControlEventTouchUpInside];
    //   退出
    [self.pageHome.logoutBtn addTarget:self action:@selector(popLoginViewController) forControlEvents:UIControlEventTouchUpInside];
    //  拍照防作弊完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cheatPhotoFinish:) name:@"CheckCheatPhotoFinish" object:nil];
    //   校时结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeFromInternet:) name:@"TimeFromInternetFinish" object:nil];
    
//   -------------------------------
    //   自动匹配点完成（匹配到点）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLocationDevice:) name:@"finish_location_device" object:nil];
    //   选择完匹配到的点
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isPushProjectController:) name:@"ChooseDeviceForLocation" object:nil];
    
    //   自动匹配点和行迹
    [self locationMakeOfAppdelegate];
    if ([LOGIN_BACK[@"map_type"] intValue] == 0) {
        [self baiduMapLocation];
    }
//    --------------------------------
}
// ------------------------------------------------------------------------------------
/**
 定位权限请求和设置   只请求了总是获取定位的权限
 */
-(void)locationMakeOfAppdelegate
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //定位管理器
    self.locationManager=[[CLLocationManager alloc]init];
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [self.locationManager requestAlwaysAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways){
        //设置代理
        self.locationManager.delegate=self;
        //设置定位精度
        [self.locationManager setAllowsBackgroundLocationUpdates:YES];
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.pausesLocationUpdatesAutomatically = NO;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10;
        self.locationManager.distanceFilter=distance;
        //启动跟踪定位
        [self.locationManager startUpdatingLocation];
    }
}
/**
 *  获取定位信息的方法
 *
 *  @param manager   定位
 *  @param locations 位置信息
 */
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *curLocation = [locations lastObject];
    //    通过location  或得到当前位置的经纬度3
    CLLocationCoordinate2D curCoordinate2D=curLocation.coordinate;
    if ([LOGIN_BACK[@"map_type"] intValue] != 0) {
        //   判断当前坐标是否在中国
        BOOL ischina = [[ZCChinaLocation shared] isInsideChina:(CLLocationCoordinate2D){curCoordinate2D.latitude,curCoordinate2D.longitude}];
        if (!ischina) {
            //   如果不在中国  不需要转换  直接保存
            [USERDEFAULT setDouble:curCoordinate2D.latitude forKey:MAP_LUAITNUM];
            [USERDEFAULT setDouble:curCoordinate2D.longitude forKey:MAP_LONGNUM];
            [USERDEFAULT setObject:[ToolModel achieveNowTime] forKey:MAP_TIME];
        }
        else{
            //   如果在中国  需要进行转换   然后保存
            curCoordinate2D = [TQLocationConverter transformFromWGSToGCJ:curCoordinate2D];
            [USERDEFAULT setDouble:curCoordinate2D.latitude forKey:MAP_LUAITNUM];
            [USERDEFAULT setDouble:curCoordinate2D.longitude forKey:MAP_LONGNUM];
            [USERDEFAULT setObject:[ToolModel achieveNowTime] forKey:MAP_TIME];
        }
        if ([[USERDEFAULT valueForKey:CHECK_STATE] intValue] == 1) {
            [self.mapmodel timerFromLocation:curLocation deviceDinate2D:curCoordinate2D];
        }
    }
}
/**
 *  注册定位    百度
 */
-(void)baiduMapLocation
{
    //    [USERDEFAULT removeObjectForKey:@"MAP_BIG"];
    self.locService=[[BMKLocationService alloc]init];
    self.locService.delegate=self;
    [self.locService startUserLocationService];//激活定位状态
    //    self.mapView.BDMapView.userTrackingMode = BMKUserTrackingModeFollow;//(跟随态)
    //    self.mapView.BDMapView.showsUserLocation = YES;//显示定位图层
}
/**
 *  定位自动执行的方法    百度
 *
 *  @param userLocation 定位信息
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if ([[USERDEFAULT valueForKey:CHECK_STATE] intValue] == 1) {
        [self.mapmodel timerFromLocation:userLocation.location deviceDinate2D:userLocation.location.coordinate];
    }
    [USERDEFAULT setDouble:userLocation.location.coordinate.latitude forKey:MAP_LUAITNUM];
    [USERDEFAULT setDouble:userLocation.location.coordinate.longitude forKey:MAP_LONGNUM];
    [USERDEFAULT setObject:[ToolModel achieveNowTime] forKey:MAP_TIME];
}

/**
 自动匹配点完成执行方法
 
 @param sender 匹配到的设备信息和所在的计划信息
 */
-(void)finishLocationDevice:(NSNotification *)sender
{
    NSArray * allArray = sender.userInfo[@"finishLocationDevice"];
    //  当前班次中只有一个计划包涵此设备   直接跳入巡检项页面
    if (allArray.count == 1) {
        if ([self.devicepost isPushProjectController:sender.userInfo[@"device_dict"] allDeviceArray:[self.devicepost deviceDidUser_sitedict:sender.userInfo[@"sch_dict"]] touchSchdict:sender.userInfo[@"sch_dict"]]) {
//            if ([self.devicepost isPushPickerViewController:sender.userInfo[@"device_dict"] schDict:sender.userInfo[@"sch_dict"]]) {
//                //  需要防作弊拍照
//                PickerViewController * picker = [[PickerViewController alloc]init];
//                picker.sourceType=UIImagePickerControllerSourceTypeCamera;
//                picker.isProject = NO;
//                picker.isCheat = 1;
//                [[UIApplication sharedApplication].keyWindow.rootViewController.navigationController presentViewController:picker animated:YES completion:nil];
//            }else{
            [RecordKeepModel recordKeep_recordType:@"PATROL"
                                           schDict:sender.userInfo[@"sch_dict"]
                                        deviceDict:sender.userInfo[@"device_dict"]
                                         itemsDict:nil
                                      generateType:2
                                         cheatDict:[RecordKeepModel cheat_mustPhoto:0 photoFlag:0 photoName:nil recordcontent:nil eventDeviceCode:nil]];
                //   不需要防作弊拍照
                ProjectViewController * project = [[ProjectViewController alloc]init];
                UINavigationController * nc = [[UINavigationController alloc]initWithRootViewController:project];
                nc.navigationBar.tintColor = [UIColor whiteColor];
                UIImage  * image = [ToolModel drawLinearGradient];
                [nc.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
                project.deviceDic = allArray[0][@"device_dict"];
                project.siteDict = allArray[0][@"sch_dict"];
                project.pre = 0;
                [UIApplication sharedApplication].keyWindow.rootViewController.hidesBottomBarWhenPushed = YES;
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nc animated:YES completion:nil];
                [UIApplication sharedApplication].keyWindow.rootViewController.hidesBottomBarWhenPushed = NO;
            
//            }
        }else{
            //   不可进行巡检
            return;
        }
    }else{//    当前班次中有多个计划包涵此设备   需要弹出选择
        [self.chooseView removeFromSuperview];
        self.chooseView = nil;
        self.chooseView = [[ChooseSchWithDevice alloc]initWithFrame:CGRectMake(0, 0, 0, 0) array:allArray where:1];
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self.chooseView];
        [self.chooseView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(window).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
}

/**
 是否可以跳转到项目界面
 
 @param sender 多个计划匹配时  被选择的设备信息
 */
-(void)isPushProjectController:(NSNotification *)sender
{
    [self.chooseView removeFromSuperview];
    self.chooseView = nil;
    if ([self.devicepost isPushProjectController:sender.userInfo[@"device_dict"] allDeviceArray:[self.devicepost deviceDidUser_sitedict:sender.userInfo[@"sch_dict"]] touchSchdict:sender.userInfo[@"sch_dict"]]) {
//        if ([self.devicepost isPushPickerViewController:sender.userInfo[@"device_dict"] schDict:sender.userInfo[@"sch_dict"]]) {
//            //  需要防作弊拍照
//            PickerViewController * picker = [[PickerViewController alloc]init];
//            picker.sourceType=UIImagePickerControllerSourceTypeCamera;
//            picker.isProject = NO;
//            picker.isCheat = 1;
//            [[UIApplication sharedApplication].keyWindow.rootViewController.navigationController presentViewController:picker animated:YES completion:nil];
//        }else{
        [RecordKeepModel recordKeep_recordType:@"PATROL"
                                       schDict:sender.userInfo[@"sch_dict"]
                                    deviceDict:sender.userInfo[@"device_dict"]
                                     itemsDict:nil
                                  generateType:2
                                     cheatDict:[RecordKeepModel cheat_mustPhoto:0 photoFlag:0 photoName:nil recordcontent:nil eventDeviceCode:nil]];
            //   不需要防作弊拍照
            ProjectViewController * project = [[ProjectViewController alloc]init];
            UINavigationController * nc = [[UINavigationController alloc]initWithRootViewController:project];
            nc.navigationBar.tintColor = [UIColor whiteColor];
            UIImage  * image = [ToolModel drawLinearGradient];
            [nc.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
            project.deviceDic = sender.userInfo[@"device_dict"];
            project.siteDict = sender.userInfo[@"sch_dict"];
            project.pre = 0;
            project.isLocationPush = 1;
            [UIApplication sharedApplication].keyWindow.rootViewController.hidesBottomBarWhenPushed = YES;
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nc animated:YES completion:nil];
            [UIApplication sharedApplication].keyWindow.rootViewController.hidesBottomBarWhenPushed = NO;
//        }
    }else{
        //   不可进行巡检
        return;
    }
}
// ------------------------------------------------------------------------------------
/**
 上班  下班

 @param sender <#sender description#>
 */
-(void)checkin:(UIButton *)sender
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    if ([[USERDEFAULT valueForKey:CHECK_STATE] intValue] == 1) {
        
        NSDictionary * shiftDict = [USERDEFAULT valueForKey:SHIFT_DICT];
        NSDictionary * shiftTimeDict = [USERDEFAULT valueForKey:[NSString stringWithFormat:@"shift%d",[shiftDict[@"shift_id"] intValue]]];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate * nowTimeDate = [ToolModel timeFromZone:[dateformatter dateFromString:[ToolModel achieveNowTime]]];
        NSString * alertTitle;
        if (shiftTimeDict[@"send_shift_end_time"] > nowTimeDate) {
            alertTitle = @"下班时间未到！是否确定下班？";
        }else{
            alertTitle = NSLocalizedString(@"Home_issure_chechout",@"");
        }
        //  检测是否有未完成的设备信息
        NSString * alertMessage;
        if ([db selectSomething:@"allkind_record" value:[NSString stringWithFormat:@"user_name = '%@' and record_state = 0 and patrol_state != 3 and record_category = 'PATROL'",[USERDEFAULT valueForKey:NAMEING]] keys:[ToolModel allPropertyNames:[AllKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[AllKindModel class]]].count != 0) {
            alertMessage = @"有未完成的巡检数据！将被删除！";
        }else{
            alertMessage = nil;
        }
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"All_sure",@"") style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self showDownLoad:NSLocalizedString(@"Home_checkout_seuccess",@"")];
            self.pageHome.logoutBtn.enabled = YES;
            self.nameItem.title = [NSString stringWithFormat:@"%@%@",[USERDEFAULT valueForKey:NAMEING],NSLocalizedString(@"Home_is_checkout",@"")];
            NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n   %@",NSLocalizedString(@"Home_sart_checkin",@""),[HomePagePost checkTextGet]]];
            [aString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14]range:NSMakeRange(4,self.pageHome.checkBtn.titleLabel.text.length-4)];
            [self.pageHome.checkBtn setAttributedTitle:aString forState:UIControlStateNormal];
            self.pageHome.checkBtn.backgroundColor=[UIColor colorWithRed:0.31 green:0.52 blue:0.97 alpha:1.00];
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.84, 0.89, 1.00, 1.00 });
            [self.pageHome.checkBtn.layer setBorderColor:colorref];
            sender.selected = !sender.selected;
            //   储存住记录信息
            [RecordKeepModel recordKeep_recordType:@"CHECKOUT"
                                           schDict:nil
                                        deviceDict:nil
                                         itemsDict:nil
                                      generateType:-1
                                         cheatDict:[RecordKeepModel cheat_mustPhoto:0 photoFlag:0 photoName:nil recordcontent:nil eventDeviceCode:nil]];
            //  发送所有未发送的数据
            [PostUPNetWork sameKindRecordPost];
            // 下班之后的数据处理
            [self.homepage checkoutRemoveModel];
            [self.mapmodel.deviceTimer invalidate];
            self.mapmodel.deviceTimer = nil;
            [self.mapmodel.keepLocationTimer invalidate];
            self.mapmodel.keepLocationTimer = nil;
            [self.mapmodel.sendLocationTimer invalidate];
            self.mapmodel.sendLocationTimer = nil;
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"All_cancel",@"") style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController: alert animated: YES completion: nil];
         
    }else{
        //   通过离线状态  判断是否需要校时
        if ([USERDEFAULT valueForKey:OFFLINE] == 0) {
            [self.internetTime getTimeFromInternet];
        }else{
            [self timeFromInternet:nil];
        }
    }
}

/**
 校时完成  执行上班操作

 @param sender <#sender description#>
 */
-(void)timeFromInternet:(NSNotification *)sender
{
    //   已经校时过了或者没有获取到网络时间   直接上班
    if (sender == nil) {
        if ([[USERDEFAULT valueForKey:CHECK_STATE] intValue] == 0) {
            DataBaseManager * db = [DataBaseManager shareInstance];
            if ([db selectAll:@"shift_record" keys:[ToolModel allPropertyNames:[ShiftModel class]] keysKinds:[ToolModel allPropertyAttributes:[ShiftModel class]]].count == 0) {
                //   无档案提示
                [self noArchives];
            }else{
                //   选择班次
                [self chooseClasses];
            }
            [db dbclose];
        }
    }else{
        //    校时结束
        //  校时成功
        if ([sender.userInfo[@"infokey"] intValue] == 1) {
            if ([[USERDEFAULT valueForKey:CHECK_STATE] intValue] == 0) {
                DataBaseManager * db = [DataBaseManager shareInstance];
                if ([db selectAll:@"shift_record" keys:[ToolModel allPropertyNames:[ShiftModel class]] keysKinds:[ToolModel allPropertyAttributes:[ShiftModel class]]].count == 0) {
                    //   无档案提示
                    [self noArchives];
                }else{
                    //   选择班次
                    [self chooseClasses];
                }
                [db dbclose];
            }
        }else{//   校时失败   不能进行上班操作
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"All_nettime_field",@"") message:NSLocalizedString(@"All_time_field_message",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"All_isknow",@"") otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}
/**
 无档案提示
 */
-(void)noArchives
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"All_alert_title",@"") message:NSLocalizedString(@"Home_alert_nothing",@"") preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Home_download",@"")
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [self downLoad:nil];
                                            }]];
    [self presentViewController:alert animated:true completion:nil];
}

/**
 选择班次
 */
-(void)chooseClasses
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishChooseClasses:) name:@"ChooseClasses" object:nil];
    DataBaseManager * db = [DataBaseManager shareInstance];
    self.shiftArray = [db selectAll:@"shift_record" keys:[ToolModel allPropertyNames:[ShiftModel class]] keysKinds:[ToolModel allPropertyAttributes:[ShiftModel class]]];
    //   计算时间获取当前可选择的班次
    self.shiftArray = [HomePagePost shiftArrayFromTime:self.shiftArray];
    
    //   弹出选择班次的视图
    self.classes = [[ClassesView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) array:self.shiftArray];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.classes];
    [self.classes makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

/**
 下载档案

 @param sender 按钮
 */
-(void)downLoad:(UIButton *)sender
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"是否要下载巡检档案？" message:@"更新档案后，将无法显示本班次已巡检的纪录！" preferredStyle:UIAlertControllerStyleAlert];
    //   取消下载
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        
    }];
    [alert addAction:cancleAction];
    //   确定下载
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"All_sure",@"") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self showLoading:NSLocalizedString(@"Home_alert_isloading",@"")];
        //    设备下载请求
        NSString * url = [NSString stringWithFormat:@"http://%@/%@",LOGIN_BACK[@"archives_address"],@"DOWNLOAD_TASK"];
        [PostUPNetWork requestWithRequestType:HTTPSRequestTypePost urlString:url paraments:nil completeBlock:^(NSDictionary *_Nullable paraments,NSDictionary * _Nullable object, NSError * _Nullable error) {
            if (error == nil) {
                if ([object[@"error_code"] intValue] == 0) {
                    //    项目下载请求
                    NSString * url1 = [NSString stringWithFormat:@"http://%@/%@",LOGIN_BACK[@"archives_address"],@"DOWNLOAD_ITEMS"];
                    [PostUPNetWork requestWithRequestType:HTTPSRequestTypePost urlString:url1 paraments:nil completeBlock:^(NSDictionary *_Nullable paraments,NSDictionary * _Nullable object1, NSError * _Nullable error) {
                        [self closeLoading];
                        if (error == nil) {
                            if ([object1[@"error_code"] intValue] == 0) {
                                [self showDownLoad:NSLocalizedString(@"Home_alert_down_success",@"")];
                                //   存入数据库
                                [HomePagePost downLoad_deviceDict:object itemDict:object1];
                                self.shiftArray = object[@"shift_record"];
                            }else{
                                [self closeLoading];
                                [self alertShow:NSLocalizedString(@"Home_alert_down_field",@"") message:nil];
                            }
                        }else{
                            [self closeLoading];
                            [self alertShow:NSLocalizedString(@"Home_alert_down_field",@"") message:NSLocalizedString(@"Home_alert_post_field",@"")];
                        }
                    }];
                }else{
                    [self closeLoading];
                    [self alertShow:NSLocalizedString(@"Home_alert_down_field",@"") message:nil];
                }
            }else{
                [self closeLoading];
                [self alertShow:NSLocalizedString(@"Home_alert_down_field",@"") message:NSLocalizedString(@"Home_alert_post_field",@"")];
            }
        }];
    }];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

/**
 选择班次  完成

 @param sender 选择的班次
 */
-(void)finishChooseClasses:(NSNotification *)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.classes removeFromSuperview];
    });
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChooseClasses" object:nil];
    self.shiftDict = sender.userInfo;
    //   将选择的班次时间转换为 添加年月日   （上传时使用）
    NSDate * shiftstart = [TaskPost hourMinToMonDay:self.shiftDict[@"working_hours"]];
    NSDate * shiftend = [TaskPost hourMinToMonDay:self.shiftDict[@"off_hours"]];
    //   如果结束时间小于开始时间   说明是垮台呢班次
    if (shiftend < shiftstart) {
        shiftend = [TaskPost isNotToday:shiftend];
    }
//    NSDateFormatter * input=[[NSDateFormatter alloc]init];
//    [input setDateFormat:@"YYYY-MM-dd HH:mm"];
    //   根据班次ID保存班次真实事件
    [USERDEFAULT setObject:@{@"send_shift_start_time":shiftstart,@"send_shift_end_time":shiftend} forKey:[NSString stringWithFormat:@"shift%d",[self.shiftDict[@"shift_id"] intValue]]];
    if ([HomePagePost photoRate]) {
        [USERDEFAULT setObject:self.shiftDict forKey:SHIFT_DICT];
        //  没事调用相机  先移除相机的通知（防止重复注册通知）
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CheckCheatPhotoFinish" object:nil];
        //   需要随机拍照
        PickerViewController * picker = [[PickerViewController alloc]init];
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        picker.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        picker.isProject = NO;
        picker.isCheat = 1;
        [self.tabBarController presentViewController:picker animated:YES completion:nil];
    }else{
        [USERDEFAULT setObject:self.shiftDict forKey:SHIFT_DICT];
        //   储存住记录信息
        [RecordKeepModel recordKeep_recordType:@"CHECKIN"
                                       schDict:nil
                                    deviceDict:nil
                                     itemsDict:nil
                                  generateType:-1
                                     cheatDict:[RecordKeepModel cheat_mustPhoto:0 photoFlag:0 photoName:nil recordcontent:nil eventDeviceCode:nil]];
        [self checkFinishChangeUI:sender.userInfo];
    }
}

/**
 防作弊拍照完成

 @param sender 照片内容
 */
-(void)cheatPhotoFinish:(NSNotification *)sender
{
    NSDictionary * dict = sender.userInfo;
    if (dict == nil) {
        //   储存住记录信息
        [RecordKeepModel recordKeep_recordType:@"CHECKIN"
                                       schDict:nil
                                    deviceDict:nil
                                     itemsDict:nil
                                  generateType:-1
                                     cheatDict:[RecordKeepModel cheat_mustPhoto:1 photoFlag:0 photoName:nil recordcontent:nil eventDeviceCode:nil]];

    }else{
        //   储存住记录信息
        NSDictionary * recordDikct = [RecordKeepModel recordKeep_recordType:@"CHECKIN"
                                       schDict:nil
                                    deviceDict:nil
                                     itemsDict:nil
                                  generateType:-1
                                     cheatDict:[RecordKeepModel cheat_mustPhoto:1 photoFlag:1 photoName:dict[@"file_name"] recordcontent:nil eventDeviceCode:nil]];
        //    储存防作弊流信息
        [RecordKeepModel cheat_cheatDict:dict recordDict:recordDikct];
    }
    [self checkFinishChangeUI:self.shiftDict];
}

/**
 上班改变界面和标示

 @param shiftDict 当前选择的班次
 */
-(void)checkFinishChangeUI:(NSDictionary *)shiftDict
{
    //   上班成功   查询出计划  并储存
    DataBaseManager * db = [DataBaseManager shareInstance];
    NSArray * array = [TaskPost getIsShiftTask:[db selectSomething:@"schedule_record" value:@"(other_has_start = 1 or sch_type = 0) order by site_id,start_time,sch_id,same_sch_seq" keys:[ToolModel allPropertyNames:[ScheduleModel class]] keysKinds:[ToolModel allPropertyAttributes:[ScheduleModel class]]] shift:self.shiftDict];
    //   符合班次和工作日的本班次计划
    array = [TaskPost taskWorkDay:array];
    //   将添加到当前任务的特殊任务   移到数组后面
    NSMutableArray * mulNowArray = [[NSMutableArray alloc]init];
    [mulNowArray addObjectsFromArray:array];
    for (NSMutableDictionary * schDict in array) {
        if ([schDict[@"other_has_start"] intValue] == 1) {
            [mulNowArray removeObject:schDict];
            NSDate * starttime = [TaskPost hourMinToMonDay:schDict[@"start_time"]];
            NSDate * endtime = [TaskPost hourMinToMonDay:schDict[@"end_time"]];
            //    如果是结束时间小于开始时间  说明是跨天计划
            if (endtime < starttime) {
                endtime = [TaskPost isNotToday:endtime];
            }
            [schDict setValue:starttime forKey:@"send_task_start_time"];
            [schDict setValue:endtime forKey:@"send_task_end_time"];
            [mulNowArray insertObject:schDict atIndex:mulNowArray.count];
        }
    }
    array = mulNowArray;
    [USERDEFAULT setObject:array forKey:SCH_SITE_DEVICE_ARRAY];
    //   打开闹钟
    [TimerPost timeArrayFromTask];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showDownLoad:NSLocalizedString(@"Home_alert_checkin_seccess",@"")];
        [USERDEFAULT setObject:@(1) forKey:CHECK_STATE];
        self.pageHome.logoutBtn.enabled = NO;
        self.nameItem.title = [NSString stringWithFormat:@"%@%@",[USERDEFAULT valueForKey:NAMEING],NSLocalizedString(@"Home_is_checkin",@"")];
        NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n   %@",NSLocalizedString(@"Home_will_checkout",@""),[HomePagePost checkTextGet]]];
        [aString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14]range:NSMakeRange(4,self.pageHome.checkBtn.titleLabel.text.length-4)];
        [self.pageHome.checkBtn setAttributedTitle:aString forState:UIControlStateNormal];
        self.pageHome.checkBtn.backgroundColor=[UIColor colorWithRed:0.20 green:0.73 blue:0.66 alpha:1.00];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.78, 0.91, 0.89, 1.00 });
        [self.pageHome.checkBtn.layer setBorderColor:colorref];
        self.pageHome.checkBtn.selected = !self.pageHome.checkBtn.selected;
    });
    [PostUPNetWork sameKindRecordPost];
}
/**
 通过计时器改变时间
 */
-(void)checkBtnTextChange
{
    if ([[USERDEFAULT valueForKey:CHECK_STATE] intValue] == 1) {
        NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n   %@",NSLocalizedString(@"Home_will_checkout",@""),[HomePagePost checkTextGet]]];
        [aString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14]range:NSMakeRange(4,self.pageHome.checkBtn.titleLabel.text.length-4)];
        [self.pageHome.checkBtn setAttributedTitle:aString forState:UIControlStateNormal];
    }else{
        NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n   %@",NSLocalizedString(@"Home_sart_checkin",@""),[HomePagePost checkTextGet]]];
        [aString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14]range:NSMakeRange(4,self.pageHome.checkBtn.titleLabel.text.length-4)];
        [self.pageHome.checkBtn setAttributedTitle:aString forState:UIControlStateNormal];
    }
}

/**
 拨打电话
 */
-(void)homeTelPhoneCall
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    NSArray * array = [db selectAll:@"emergency_contact_record" keys:@[@"emergency_contact_phone",@"emergency_contact"] keysKinds:@[@"NSString",@"NSString"]];
    if (array.count == 0) {
        [self showDownLoad:NSLocalizedString(@"Home_no_tel",@"")];
    }else{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Home_alert_tel_title",@"") message:[NSString stringWithFormat:@"%@:%@",array[0][@"emergency_contact"],array[0][@"emergency_contact_phone"]] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"All_sure",@"") style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",array[0][@"emergency_contact_phone"]];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }]];
        [alert addAction: [UIAlertAction actionWithTitle: NSLocalizedString(@"All_cancel",@"") style: UIAlertActionStyleCancel handler:nil]];
        [self presentViewController: alert animated: YES completion: nil];
    }
}
/**
 跳转    记录页面
 */
-(void)pushRecordController
{
    RecordViewController * record = [[RecordViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:record animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

/**
 跳转    通知页面
 */
-(void)pushNoticeController
{
    NoticeViewController * notice = [[NoticeViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:notice animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

/**
 跳转   设置页面
 */
-(void)pushSetViewController
{
    SetViewController * set = [[SetViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:set animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

//  退出登录
-(void)popLoginViewController
{
    [self showLoading:NSLocalizedString(@"Home_alert_logout_is",@"")];
    //   储存住记录信息
    [RecordKeepModel recordKeep_recordType:@"LOGOUT"
                                   schDict:nil
                                deviceDict:nil
                                 itemsDict:nil
                              generateType:-1
                                 cheatDict:[RecordKeepModel cheat_mustPhoto:0 photoFlag:0 photoName:nil recordcontent:nil eventDeviceCode:nil]];
    //   开始发送未发送信息
    [PostUPNetWork sameKindRecordPost];
    NSString * url = [NSString stringWithFormat:@"http://%@:8800/%@",[USERDEFAULT valueForKey:HOST_IPING],@"PATROL_LOGOUT"];
    [PostUPNetWork requestWithRequestType:HTTPSRequestTypePost urlString:url paraments:nil completeBlock:^(NSDictionary *_Nullable paraments, NSDictionary * _Nullable object, NSError * _Nullable error) {
        [self closeLoading];
        ///   清除登录状态标志
        [USERDEFAULT removeObjectForKey:IS_LOGINING];
        if (error == nil) {
            if ([object[@"error_code"] intValue] == 0){
                //    跳转页面
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PopLoginViewController" object:self userInfo:@{@"key":@(1)}];
            }else{
                switch ([object[@"error_code"] intValue]) {
                    case 102:
                        [self alertShow:NSLocalizedString(@"Login_name_error",@"") message:nil];
                        break;
                    case 6:
                        [self alertShow:NSLocalizedString(@"Home_alert_no_name",@"") message:nil];
                        break;
                    default:
                        break;
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PopLoginViewController" object:self userInfo:@{@"key":@(1)}];
            }
        }else{
            [self alertShow:NSLocalizedString(@"Home_alert_logout_field",@"") message:NSLocalizedString(@"Home_alert_post_field",@"")];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PopLoginViewController" object:self userInfo:@{@"key":@(1)}];
        }
    }];
}
//   错误提示
-(void)alertShow:(NSString *)title message:(NSString *)message
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:NSLocalizedString(@"All_sure",@"") otherButtonTitles:nil, nil];
    [alert show];
}
//   登录提示框
-(void)showLoading:(NSString *)msg
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = msg;
    self.hud.margin = 20.f;
    self.hud.yOffset = 0.f;
    self.hud.removeFromSuperViewOnHide = YES;
}
-(void)closeLoading{
    //    sleep(30);
    [self.hud hide:YES];
}
-(void)showDownLoad:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.xOffset = 0.1;
    hud.yOffset = MBProgressHUDModeText;
    [hud hide:YES afterDelay:2];

}
-(HomePagePost *)homepage
{
    if (_homepage == nil) {
        _homepage = [[HomePagePost alloc]init];
    }
    return _homepage;
}
-(TimeFromInternet *)internetTime
{
    if (_internetTime == nil) {
        _internetTime = [[TimeFromInternet alloc]init];
    }
    return _internetTime;
}
-(DevicePost *)devicepost
{
    if (_devicepost == nil) {
        _devicepost = [[DevicePost alloc]init];
    }
    return _devicepost;
}
-(AllMapModel *)mapmodel
{
    if (!_mapmodel) {
        _mapmodel = [[AllMapModel alloc]init];
    }
    return _mapmodel;
}

-(void)viewWillAppear:(BOOL)animated
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    int number = [db selectNumber:@"message_record" value:@"isread = 0"];
    self.pageHome.messageNumber.text = [NSString stringWithFormat:@"%d",number];
    if (number == 0) {
        self.pageHome.messageNumber.hidden = YES;
    }else{
        self.pageHome.messageNumber.hidden = NO;
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CheckCheatPhotoFinish" object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
