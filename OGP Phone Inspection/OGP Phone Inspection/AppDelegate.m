//
//  AppDelegate.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/6/22.
//  Copyright © 2017年 张国洋. All rights reserved.
//
/**
 *　　　　　　　 ┏┓       ┏┓+ +
 *　　　　　　　┏┛┻━━━━━━━┛┻┓ + +
 *　　　　　　　┃　　　　　　 ┃
 *　　　　　　　┃　　　━　　　┃ ++ + + +
 *　　　　　　 █████━█████  ┃+
 *　　　　　　　┃　　　　　　 ┃ +
 *　　　　　　　┃　　　┻　　　┃
 *　　　　　　　┃　　　　　　 ┃ + +
 *　　　　　　　┗━━┓　　　 ┏━┛
 *               ┃　　  ┃
 *　　　　　　　　　┃　　  ┃ + + + +
 *　　　　　　　　　┃　　　┃　Code is far away from     bug with the animal protecting
 *　　　　　　　　　┃　　　┃ + 　　　　         神兽保佑,代码无bug
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃　　+
 *　　　　　　　　　┃　 　 ┗━━━┓ + +
 *　　　　　　　　　┃ 　　　　　┣┓
 *　　　　　　　　　┃ 　　　　　┏┛
 *　　　　　　　　　┗┓┓┏━━━┳┓┏┛ + + + +
 *　　　　　　　　　 ┃┫┫　 ┃┫┫
 *　　　　　　　　　 ┗┻┛　 ┗┻┛+ + + +
 */

#import "AppDelegate.h"
#import "BMapKit.h"
#import <GoogleMaps/GoogleMaps.h>
#import "LoginViewController.h"
#import "YGTabBarViewController.h"
#import "MessagePost.h"
#import "DataBaseManager.h"
#import "Reachability.h"
#import "TimeFromInternet.h"
#import "PickerViewController.h"
#import "VersionPost.h"
#import "AllKindModel.h"
#import <AVFoundation/AVFoundation.h>
#import "YGSTabbarViewController.h"
#import "DeviceModel.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
@interface AppDelegate () <UNUserNotificationCenterDelegate,CLLocationManagerDelegate,BMKLocationServiceDelegate>
@property(nonatomic,strong) BMKMapManager* mapManager;
@property(nonatomic,strong) MessagePost * message;
@property(nonatomic,strong) Reachability *reachability;
@property(nonatomic,strong) TimeFromInternet * internetTime;
@property(nonatomic,strong) UIAlertView * timeAlert;
@property(nonatomic,strong) CLLocationManager * locationManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [USERDEFAULT removeObjectForKey:[NSString stringWithFormat:@"%@location_track", [USERDEFAULT valueForKey:NAMEING]]];
    // Override point for customization after application launch.
    DataBaseManager * db = [DataBaseManager shareInstance];
    
    
    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    self.reachability =[Reachability reachabilityWithHostName:@"www.apple.com"];//可以以多种形式初始化
    [self.reachability startNotifier];
    [USERDEFAULT setObject:@(0) forKey:OFFLINE];
    //设置百度地图
    self.mapManager=[[BMKMapManager alloc]init];
    [self.mapManager start:@"0cjPsLcSEftgDCLHISQdxaVfiNaQz2LQ" generalDelegate:nil];
    //实现谷歌地图
    [GMSServices provideAPIKey:@"AIzaSyBL0f7TvsY0f32QOsd7SnM0fcqwWAp2nY8"];
    
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    self.window.backgroundColor = [UIColor colorWithRed:0.89 green:0.15 blue:0.23 alpha:1.00];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10特有
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        // 必须写代理，不然无法监听通知的接收与点击
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // 点击允许
                NSLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    
                }];
            } else {
                // 点击不允许
                NSLog(@"注册失败");
            }
        }];
    }else {
        //iOS8 - iOS10
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
    }
    //判断是否由远程消息通知触发应用程序启动
    if (launchOptions) {
        //获取应用程序消息通知标记数（即小红圈中的数字）
        NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        if (badge>0) {
            //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
            badge--;
            //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
        }
    }
    if ([USERDEFAULT valueForKey:@"first11"] == nil) {
        [USERDEFAULT setObject:@"00" forKey:@"first11"];
        [USERDEFAULT setObject:@(1) forKey:RECORD_KEEP_TIME];
        [USERDEFAULT setObject:@(1) forKey:MAP_LINE_IS];
        //   储存默认IP地址
        [ToolModel firstAddHost];
    }
    
    //    建表
    [db createSqlite];
    //   拉取通知消息
    [self.message messagePost];
    //   退出登录执行的方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PopLoginViewController:) name:@"PopLoginViewController" object:nil];
    //   更改了设置中的时间按钮状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceTimeIsChanged:) name:NSSystemClockDidChangeNotification object:nil];
    
    if ([USERDEFAULT valueForKey:IS_LOGINING] == nil) {
        LoginViewController * login = [[LoginViewController alloc]init];
        self.window.rootViewController=login;
    }else{
        YGTabBarViewController * tabbar = [[YGTabBarViewController alloc]init];
        self.window.rootViewController=tabbar;
    }
    //   版本控制提示框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isNeedShowVersonUp:) name:@"VersionNeedUp" object:nil];
    //   版本控制请求
    if ([[USERDEFAULT valueForKey:IS_LOGINING] intValue] == 1) {
        [VersionPost postVersion];
    }
    //  为了事件页面不卡顿
    UITextView * text = [[UITextView alloc]init];
    text.text = nil;
    
    return YES;
}

/**
 退出登录  重新设备登陆页面为rootviewcontroller

 @param sender <#sender description#>
 */
-(void)PopLoginViewController:(NSNotification *)sender
{
    NSDictionary * dict = sender.userInfo;
    LoginViewController* login = [[LoginViewController alloc]init];
    login.isBack = [dict[@"key"] intValue];
    self.window.rootViewController=login;
}
//获得token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [USERDEFAULT setObject:token forKey:@"token"];
    NSLog(@"获取token＝＝＝＝＝%@",token);
    return;
}
// iOS 10收到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"收到通知");
        //   拉取通知消息
        if ([[USERDEFAULT valueForKey:IS_LOGINING] intValue] == 1) {
            [self.message messagePost];
        }
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}
// 当app正在前台运行
- (void)application:(UIApplication *)application didReceiveRemoteNotification
                   :(NSDictionary *)userInfo fetchCompletionHandler
                   :(void (^)(UIBackgroundFetchResult))completionHandler {
//    [application setApplicationIconBadgeNumber:0];
    
    completionHandler(UIBackgroundFetchResultNewData);
    if ([[USERDEFAULT valueForKey:IS_LOGINING] intValue] == 1) {
        // 应用正处理前台状态下
        if (application.applicationState == UIApplicationStateActive) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收到通知消息"
                                                            message:userInfo[@"aps"][@"alert"][@"title"]
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedString(@"All_sure",@""),nil];
            [alert show];
            if (userInfo) {
                //   拉取通知消息
                [self.message messagePost];
            }
        }else{
            if (userInfo) {
                //   拉取通知消息
                [self.message messagePost];
            }
        }
    }
}
//   实时监听网络状态
- (void)reachabilityChanged:(NSNotification *)notification
{
    Reachability* curReach = [notification object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}
//   网络变化 监听结果
- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if (reachability == _reachability)
    {
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        switch (netStatus)
        {
            case NotReachable:   {
                NSLog(@"没有网络！");
                [USERDEFAULT setObject:@(0) forKey:NET_STATE];
                break;
            }
            case ReachableViaWWAN: {
                NSLog(@"4G/3G");
                [USERDEFAULT setObject:@(1) forKey:NET_STATE];
                if ([[USERDEFAULT valueForKey:CHECK_STATE] intValue] == 1) {
                    if ([USERDEFAULT valueForKey:OFFLINE] == 0) {
                        [self.internetTime getTimeFromInternet];
                    }
                }
                break;
            }
            case ReachableViaWiFi: {
                NSLog(@"WiFi");
                [USERDEFAULT setObject:@(2) forKey:NET_STATE];
                if ([[USERDEFAULT valueForKey:CHECK_STATE] intValue] == 1) {
                    if ([USERDEFAULT valueForKey:OFFLINE] == 0) {
                        [self.internetTime getTimeFromInternet];
                    }
                }
                break;
            }
        }
    }
}

/**
 修改了设置中的时间按钮

 @param sender <#sender description#>
 */
-(void)deviceTimeIsChanged:(NSNotification *)sender
{
    //   已经校对时间后  改变按钮状态  说明是关闭了   提示打开
    if ([[USERDEFAULT valueForKey:OFFLINE] intValue] == 1) {
        [USERDEFAULT setObject:@"00" forKey:@"isclosetime"];
        self.timeAlert = [[UIAlertView alloc]initWithTitle:@"请打开自动获取时间按钮！" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [self.timeAlert show];
    }else if ([USERDEFAULT valueForKey:@"isclosetime"] != nil){
        [USERDEFAULT removeObjectForKey:@"isclosetime"];
        [self.timeAlert dismissWithClickedButtonIndex:0 animated:YES];
    }
}

/**
 版本控制提示框出现

 @param sender 控制信息
 */
-(void)isNeedShowVersonUp:(NSNotification *)sender
{
    NSDictionary * versonDict = sender.userInfo;
    if ([versonDict[@"force_update"] intValue] == 0) {//   建议升级
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"请在%@前升级版本，否则将影响您的使用！",versonDict[@"dealine"]]
                                                                      message:nil
                                                               preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"以后再说"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:@"立即升级" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            NSString * url=@"https://itunes.apple.com/us/app/id1118831486";
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }];
        [alert addAction:destructiveAction];
        if ([destructiveAction valueForKey:@"titleTextColor"]) {
            [destructiveAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
        }
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:true completion:nil];
    }else{//   必须升级
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"请前往升级版本，否则将无法继续使用！"
                                                                      message:nil
                                                               preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:@"立即升级" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            NSString * url=@"https://itunes.apple.com/us/app/id1118831486";
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }];
        [alert addAction:destructiveAction];
        if ([destructiveAction valueForKey:@"titleTextColor"]) {
            [destructiveAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
        }
    }
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    NSDictionary* dict = [notification userInfo];
    if (application.applicationState == UIApplicationStateActive && dict[@"timer_name"]!=nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"巡检时间到！"
                                                        message:dict[@"timer_name"]
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"All_sure",@""),nil];
        [alert show];
    }
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(MessagePost *)message
{
    if (_message == nil) {
        _message = [[MessagePost alloc]init];
    }
    return _message;
}
-(TimeFromInternet *)internetTime
{
    if (_internetTime == nil) {
        _internetTime = [[TimeFromInternet alloc]init];
    }
    return _internetTime;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
 

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
//    if (application.applicationIconBadgeNumber>0) {  //badge number 不为0，说明程序有那个圈圈图标
        if ([[USERDEFAULT valueForKey:IS_LOGINING] intValue] == 1) {
            [self.message messagePost];
        }
        [application setApplicationIconBadgeNumber:0];   //将图标清零。
//    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
