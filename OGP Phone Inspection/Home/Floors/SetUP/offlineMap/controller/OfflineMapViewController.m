//
//  OfflineMapViewController.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/21.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "OfflineMapViewController.h"

@interface OfflineMapViewController ()
{
    BMKOLUpdateElement* localMapInfo;
}

@end

@implementation OfflineMapViewController

@synthesize cityId;
@synthesize offlineServiceOfMapview;
- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化右边的更新按钮
    UIBarButtonItem *customRightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"All_upgrad",@"") style:UIBarButtonItemStylePlain target:self action:@selector(update)];
    customRightBarButtonItem.title = NSLocalizedString(@"All_upgrad",@"");
    self.navigationItem.rightBarButtonItem = customRightBarButtonItem;
    
    //显示当前某地的离线地图
    _mapView = [[BMKMapView alloc]init];
    _mapView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    [self.view addSubview:_mapView];
    _mapView.showMapScaleBar=YES;
    _mapView.scrollEnabled=YES;
    
    localMapInfo = [offlineServiceOfMapview getUpdateInfo:cityId];
    [_mapView setCenterCoordinate:localMapInfo.pt];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}
- (void)update
{
    if (localMapInfo.update==YES) {
        [offlineServiceOfMapview update:cityId];
    }
    else{
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Map_had_best_new",@"")
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"All_sure",@"")
                                            otherButtonTitles:nil, nil];
        [alert show];
    }
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
