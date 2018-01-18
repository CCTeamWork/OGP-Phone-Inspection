//
//  SetIPView.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/10.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "SetIPView.h"
#import "ToolControl.h"
@implementation SetIPView

-(instancetype)initWithFrame:(CGRect)frame dict:(NSDictionary *)dict
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        self.IPLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.IPLa text:@"IP" font:16];
        [self addSubview:self.IPLa];
        [self.IPLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(self.top).offset(10);
        }];
        
        self.IPcontentLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.IPcontentLa text:dict[@"ip"] font:16];
        self.IPcontentLa.textColor = [UIColor grayColor];
        [self addSubview:self.IPcontentLa];
        [self.IPcontentLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(WIDTH/2);
            make.centerY.equalTo(self.IPLa);
        }];
        
        self.nameLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.nameLa text:NSLocalizedString(@"Host_name_title",@"") font:16];
        [self addSubview:self.nameLa];
        [self.nameLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(self.IPLa.bottom).offset(20);
        }];
        
        self.namecontentLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.namecontentLa text:dict[@"name"] font:16];
        self.namecontentLa.textColor = [UIColor grayColor];
        [self addSubview:self.namecontentLa];
        [self.namecontentLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.IPcontentLa.left).offset(0);
            make.centerY.equalTo(self.nameLa);
        }];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.88, 0.89, 0.89, 1.00 });
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = colorref;
    }
    return self;
}
-(void)makeLineView:(UILabel *)la
{
    self.lineview = [[UIView alloc]init];
    self.lineview.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.9 alpha:1.00];
    [self addSubview:self.lineview];
    [self.lineview makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(0);
        make.top.equalTo(la.bottom).offset(10);
        make.width.equalTo(WIDTH);
        make.height.equalTo(1);
    }];
}
@end
