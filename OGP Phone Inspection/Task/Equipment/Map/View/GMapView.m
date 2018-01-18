//
//  GMapView.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/11.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "GMapView.h"

@implementation GMapView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.GGMapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, 0, 0) camera:nil];
        self.GGMapView.settings.compassButton = YES;
        [self addSubview:self.GGMapView];
        [self.GGMapView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        self.GGlocationBtn = [[UIButton alloc]init];
        [self.GGlocationBtn setImage:[UIImage imageNamed:@"weizhi"] forState:UIControlStateNormal];
        [self.GGMapView addSubview:self.GGlocationBtn];
        [self.GGlocationBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.GGMapView.right).offset(-10);
            make.bottom.equalTo(self.GGMapView.bottom).offset(-20);
            make.width.equalTo(40);
            make.height.equalTo(40);
        }];
        
        self.GGtrailBtn = [[UIButton alloc]init];
        [self.GGtrailBtn setImage:[UIImage imageNamed:@"lujing"] forState:UIControlStateNormal];
        [self.GGtrailBtn setImage:[UIImage imageNamed:@"lujing_checked"] forState:UIControlStateSelected];
        if ([[USERDEFAULT valueForKey:MAP_LINE_IS] intValue] == 1) {
            //  显示状态
            self.GGtrailBtn.selected = YES;
        }
        [self.GGMapView addSubview:self.GGtrailBtn];
        [self.GGtrailBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.GGMapView.right).offset(-10);
            make.bottom.equalTo(self.GGMapView.top).offset(-20);
            make.width.equalTo(40);
            make.height.equalTo(40);
        }];
    }
    return self;
}
@end
