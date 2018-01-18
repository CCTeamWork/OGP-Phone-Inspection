//
//  SignNavView.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/8.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "SignNavView.h"
#import "ToolControl.h"
@implementation SignNavView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.87 green:0.15 blue:0.23 alpha:1.00];
        
        self.leftBtn = [[UIButton alloc]init];
        [self.leftBtn setTitle:NSLocalizedString(@"All_cancel",@"") forState:UIControlStateNormal];
        self.leftBtn.titleLabel.font = [UIFont systemFontOfSize: 16];
        [self addSubview:self.leftBtn];
        [self.leftBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
            make.top.equalTo(self.top).offset(35);
            make.width.equalTo(40);
            make.height.equalTo(18);
        }];
        
        self.titleLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.titleLa text:@"新增签名" font:18];
        [self addSubview:self.titleLa];
        [self.titleLa makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.top).offset(35);
        }];
        
        self.rightBtn = [[UIButton alloc]init];
        [self.rightBtn setTitle:NSLocalizedString(@"All_keep",@"") forState:UIControlStateNormal];
        self.rightBtn.titleLabel.font = [UIFont systemFontOfSize: 16];
        [self addSubview:self.rightBtn];
        [self.rightBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right).offset(-10);
            make.centerY.equalTo(self.leftBtn);
            make.width.equalTo(40);
            make.height.equalTo(18);
        }];
    }
    return self;
}

@end
