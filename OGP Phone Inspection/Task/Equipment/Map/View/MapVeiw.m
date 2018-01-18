//
//  MapVeiw.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/17.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "MapVeiw.h"
@implementation MapVeiw 

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.BDMapView = [[BMKMapView alloc]init];
        self.BDMapView.showMapScaleBar = YES;
        [self.BDMapView setMapType:BMKMapTypeStandard];
        [self addSubview:self.BDMapView];
        [self.BDMapView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        self.BDlocationBtn = [[UIButton alloc]init];
        [self.BDlocationBtn setImage:[UIImage imageNamed:@"weizhi"] forState:UIControlStateNormal];
        [self.BDMapView addSubview:self.BDlocationBtn];
        [self.BDlocationBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.BDMapView.right).offset(-10);
            make.bottom.equalTo(self.BDMapView.bottom).offset(-20);
            make.width.equalTo(40);
            make.height.equalTo(40);
        }];
        
        self.BDtrailBtn = [[UIButton alloc]init];
        [self.BDtrailBtn setImage:[UIImage imageNamed:@"lujing"] forState:UIControlStateNormal];
        [self.BDtrailBtn setImage:[UIImage imageNamed:@"lujing_checked"] forState:UIControlStateSelected];
        if ([[USERDEFAULT valueForKey:MAP_LINE_IS] intValue] == 1) {
            //  显示状态
            self.BDtrailBtn.selected = YES;
        }
        [self.BDMapView addSubview:self.BDtrailBtn];
        [self.BDtrailBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.BDMapView.right).offset(-10);
            make.bottom.equalTo(self.BDlocationBtn.top).offset(-20);
            make.width.equalTo(40);
            make.height.equalTo(40);
        }];
    }
    return self;
}

@end
