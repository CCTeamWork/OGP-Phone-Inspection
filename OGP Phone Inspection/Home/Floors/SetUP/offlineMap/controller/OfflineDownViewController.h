//
//  OfflineDownViewController.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/21.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
@interface OfflineDownViewController : UIViewController
{
//    IBOutlet BMKMapView* _mapView;//.xib里要有BMKMapView类用于初始化数据驱动
    BMKOfflineMap* _offlineMap;
    IBOutlet UIButton* downLoadBtn;
    IBOutlet UIButton* scanBtn;
    IBOutlet UIButton* stopBtn;
    IBOutlet UIButton* removeBtn;
    IBOutlet UIButton* searchBtn;
    IBOutlet UITextField* cityName;
    IBOutlet UILabel* cityId;
    IBOutlet UILabel* downloadratio;
    IBOutlet UISegmentedControl* tableviewChangeCtrl;
    IBOutlet UITableView* groupTableView;
    IBOutlet UITableView* plainTableView;
    NSArray* _arrayHotCityData;//热门城市
    NSArray* _arrayOfflineCityData;//全国支持离线地图的城市
    NSMutableArray * _arraylocalDownLoadMapInfo;//本地下载的离线地图
}

@end
