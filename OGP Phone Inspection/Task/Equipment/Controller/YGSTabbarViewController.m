//
//  YGSTabbarViewController.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/17.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "YGSTabbarViewController.h"
#import "EquipmentViewController.h"
#import "MapViewController.h"
#import "ScanCodeViewController.h"
#import "TaskViewController.h"
@interface YGSTabbarViewController ()
@property(nonatomic,strong) UIBarButtonItem * leftItem;
@end

@implementation YGSTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSMutableArray * array = [[NSMutableArray alloc]init];
    
    EquipmentViewController * equipment = [[EquipmentViewController alloc]init];
    equipment.sitedict = self.sitedict;
    UINavigationController * nc1 = [[UINavigationController alloc]initWithRootViewController:equipment];
    equipment.tabBarItem = [self itemSelectedImage:@"sbei_foot_active" image:@"sbei_foot" title:NSLocalizedString(@"Device_device_title",@"")];
    equipment.title = NSLocalizedString(@"Device_device_title_text",@"");
    self.leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backbtn"] style:UIBarButtonItemStylePlain target:self action:@selector(popTaskController)];
    equipment.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    equipment.navigationItem.leftBarButtonItem = self.leftItem;
    
    UIImage *image = [ToolModel drawLinearGradient];
    [equipment.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [array addObject:nc1];
    
    MapViewController * map = [[MapViewController alloc]init];
    UINavigationController * nc2 = [[UINavigationController alloc]initWithRootViewController:map];
    map.tabBarItem = [self itemSelectedImage:@"map_foot_active" image:@"map_foot" title:NSLocalizedString(@"Device_map_title",@"")];
    map.title = NSLocalizedString(@"Device_map_title",@"");
    self.leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backbtn"] style:UIBarButtonItemStylePlain target:self action:@selector(popTaskController)];
    map.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    map.navigationItem.leftBarButtonItem = self.leftItem;
    
    [map.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [array addObject:nc2];
    
    ScanCodeViewController * scanCode = [[ScanCodeViewController alloc]init];
//    scanCode.schdict = self.sitedict;
    UINavigationController * nc3 = [[UINavigationController alloc]initWithRootViewController:scanCode];
    scanCode.tabBarItem = [self itemSelectedImage:@"code_foot_active" image:@"code_foot" title:NSLocalizedString(@"All_scan_title",@"")];
    scanCode.title = NSLocalizedString(@"All_scan_title",@"");
    self.leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backbtn"] style:UIBarButtonItemStylePlain target:self action:@selector(popTaskController)];
    scanCode.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    scanCode.navigationItem.leftBarButtonItem = self.leftItem;
    
    [scanCode.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [array addObject:nc3];
    
    [self setViewControllers:array];

}
-(UITabBarItem *)itemSelectedImage:(NSString *)selectImage image:(NSString *)image title:(NSString *)title{
    UIImage * img = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * imgs = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem * item = [[UITabBarItem alloc]initWithTitle:title image:img
                                               selectedImage:imgs];
    return item;
}
-(void)popTaskController
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[TaskViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self.selectedViewController beginAppearanceTransition: YES animated: animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [self.selectedViewController beginAppearanceTransition: NO animated: animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationItem setHidesBackButton:YES];
    
}
-(void) viewDidAppear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}
-(void) viewDidDisappear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
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
