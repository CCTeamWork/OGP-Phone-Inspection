//
//  IPView.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/14.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "IPView.h"

@implementation IPView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.89 green:0.15 blue:0.23 alpha:1.00];
        
        self.backBtn = [[UIButton alloc]init];
        [self.backBtn setImage:[UIImage imageNamed:@"returnback"] forState:UIControlStateNormal];
        [self addSubview:self.backBtn];
        [self.backBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
            make.top.equalTo(self.top).offset(35);
            make.width.equalTo(20);
            make.height.equalTo(20);
        }];
        
        self.addBtn = [[UIButton alloc]init];
        [self.addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [self addSubview:self.addBtn];
        [self.addBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right).offset(-10);
            make.top.equalTo(self.top).offset(35);
            make.width.equalTo(20);
            make.height.equalTo(20);
        }];
    }
    return self;
}
@end
