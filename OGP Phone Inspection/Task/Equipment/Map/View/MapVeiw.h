//
//  MapVeiw.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/17.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMKMapView.h"
@interface MapVeiw : UIView  <BMKMapViewDelegate>

@property(nonatomic,strong) BMKMapView * BDMapView;
@property(nonatomic,strong) UIButton * BDlocationBtn;
@property(nonatomic,strong) UIButton * BDtrailBtn;

@end
