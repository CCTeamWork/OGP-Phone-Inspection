//
//  chanceView.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/20.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "chanceView.h"
#import "ToolControl.h"
@implementation chanceView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.88, 0.89, 0.89, 1.00 });
        
        //   时间筛选
        self.timeBtn  = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:NSLocalizedString(@"Record_search_time_btn",@"") textFrame:CGRectMake(10, 0, 0, 0) image:@"time" imageFrame:CGRectMake(10, 10, 30, 30) font:16];
        [ToolControl makeButton:self.timeBtn titleColor:nil title:nil btnImage:nil cornerRadius:0 font:0];
        self.timeBtn.layer.borderWidth = 1.0;
        self.timeBtn.layer.borderColor = colorref;
        [self addSubview:self.timeBtn];
        [self.timeBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(0);
            make.top.equalTo(self.top).offset(0);
            make.width.equalTo((WIDTH-100)/2);
            make.height.equalTo(50);
        }];
        
        //   设备筛选
        self.equipmentBtn  = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:NSLocalizedString(@"Record_search_device_btn",@"") textFrame:CGRectMake(10, 0, 0, 0) image:@"list" imageFrame:CGRectMake(10, 10, 30, 30) font:16];
        [ToolControl makeButton:self.equipmentBtn titleColor:nil title:nil btnImage:nil cornerRadius:0 font:0];
        self.equipmentBtn.layer.borderWidth = 1.0;
        self.equipmentBtn.layer.borderColor = colorref;
        [self addSubview:self.equipmentBtn];
        [self.equipmentBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(0);
            make.top.equalTo(self.timeBtn.bottom).offset(0);
            make.width.equalTo((WIDTH-100)/2);
            make.height.equalTo(50);
        }];
    }
    return self;
}

@end
