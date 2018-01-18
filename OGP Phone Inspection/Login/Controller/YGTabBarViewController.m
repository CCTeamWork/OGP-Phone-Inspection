//
//  YGTabBarViewController.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/4.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "YGTabBarViewController.h"
#import "HomePageViewController.h"
#import "TaskViewController.h"
#import "EventRecordViewController.h"
#import "ScanCodeViewController.h"
@interface YGTabBarViewController ()
@property(nonatomic,strong) HomePageViewController * homePage;
@property(nonatomic,strong) TaskViewController * task;
@property(nonatomic,strong) EventRecordViewController * event;
@property(nonatomic,strong) ScanCodeViewController * scanCode;
@end

@implementation YGTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton=YES;
    [self setControllers];
}
-(void)setControllers{
    self.homePage = [[HomePageViewController alloc]init];
    UINavigationController * nc1 = [[UINavigationController alloc]initWithRootViewController:self.homePage];
    self.homePage.tabBarItem = [self itemSelectedImage:@"homeactive" image:@"home" title:NSLocalizedString(@"All_home_title",@"")];
    
    self.task = [[TaskViewController alloc]init];
    UINavigationController * nc2 = [[UINavigationController alloc]initWithRootViewController:self.task];
    self.task.tabBarItem = [self itemSelectedImage:@"missionactive" image:@"mission" title:NSLocalizedString(@"All_task_title",@"")];
    
    self.event = [[EventRecordViewController alloc]init];
    UINavigationController * nc3 = [[UINavigationController alloc]initWithRootViewController:self.event];
    self.event.title = NSLocalizedString(@"All_event_record",@"");
    self.event.tabBarItem = [self itemSelectedImage:@"projectactive" image:@"project" title:NSLocalizedString(@"All_event_title",@"")];
    
    self.scanCode = [[ScanCodeViewController alloc]init];
    self.scanCode.type = 1;
    UINavigationController * nc4 = [[UINavigationController alloc]initWithRootViewController:self.scanCode];
    self.scanCode.title = NSLocalizedString(@"All_scan_title",@"");
    self.scanCode.tabBarItem = [self itemSelectedImage:@"phonecodeactive" image:@"phonecode" title:NSLocalizedString(@"All_scan_title",@"")];
    
    self.viewControllers = @[nc1,nc2,nc3,nc4];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
//    self.tabBar.tintColor = [UIColor grayColor];
//    self.tabBar.barTintColor = [UIColor whiteColor];
}

-(UITabBarItem *)itemSelectedImage:(NSString *)selectImage image:(NSString *)image title:(NSString *)title{
    UIImage * img = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * imgs = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem * item = [[UITabBarItem alloc]initWithTitle:title image:img
                                               selectedImage:imgs];
    
    return item;
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
