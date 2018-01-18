//
//  GMapView.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/11.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
@interface GMapView : UIView


@property(nonatomic,strong) GMSMapView * GGMapView;
@property(nonatomic,strong) UIButton * GGlocationBtn;
@property(nonatomic,strong) UIButton * GGtrailBtn;
@end
