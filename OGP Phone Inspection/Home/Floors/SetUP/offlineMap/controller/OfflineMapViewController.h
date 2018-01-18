//
//  OfflineMapViewController.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/21.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
@interface OfflineMapViewController : UIViewController<BMKMapViewDelegate>{
    BMKMapView* _mapView;
}
@property (nonatomic, assign) int cityId;
@property (nonatomic, strong) BMKOfflineMap* offlineServiceOfMapview;


@end
