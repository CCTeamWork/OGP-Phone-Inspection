//
//  TabBarView.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/7.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "TabBarView.h"
#import "ToolControl.h"
@implementation TabBarView

-(instancetype)initWithFrame:(CGRect)frame max:(int)max value:(int)value
{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxs = max;
        self.values = value;
        self.backgroundColor = [UIColor whiteColor];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.88, 0.89, 0.89, 1.00 });
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = colorref;
        
        
        self.lastBtn = [[UIButton alloc]init];
        [self.lastBtn setImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateNormal];
        [self addSubview:self.lastBtn];
        [self.lastBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(0);
            make.top.equalTo(self.top).offset(5);
            make.width.equalTo(40);
            make.height.equalTo(40);
        }];
        
        self.numberLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.numberLa text:[NSString stringWithFormat:@"%d/%d",value,max] font:14];
        [self addSubview:self.numberLa];
        [self.numberLa makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.height.equalTo(15);
        }];
        
        self.nextBtn = [[UIButton alloc]init];
        [self.nextBtn setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
        [self addSubview:self.nextBtn];
        [self.nextBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right).offset(0);
            make.centerY.equalTo(self.lastBtn);
            make.width.equalTo(40);
            make.height.equalTo(40);
        }];
    }
    return self;
}

/**
 翻页变换页书

 @param count <#count description#>
 */
-(void)itemNumberChange:(int)count
{
    self.numberLa.text = [NSString stringWithFormat:@"%d/%d",count,self.maxs];
}
@end
