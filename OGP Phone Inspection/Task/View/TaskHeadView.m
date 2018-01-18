//
//  TaskHeadView.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/31.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "TaskHeadView.h"
#import "ToolControl.h"
@implementation TaskHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.nowTaskBtn = [[UIButton alloc]init];
        [ToolControl makeButton:self.nowTaskBtn titleColor:[UIColor blackColor] title:NSLocalizedString(@"Task_nowtask_title",@"") btnImage:nil cornerRadius:0 font:18];
        self.nowTaskBtn.tag = 0;
        [self.nowTaskBtn setTitleColor:[UIColor colorWithRed:0.90 green:0.09 blue:0.15 alpha:1.00] forState:UIControlStateSelected];
        self.nowTaskBtn.selected = YES;
        [self addSubview:self.nowTaskBtn];
        [self.nowTaskBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(0);
            make.top.equalTo(self.top).offset(0);
            make.width.equalTo(WIDTH/2);
            make.height.equalTo(45);
        }];
        [self.nowTaskBtn addTarget:self action:@selector(nowBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.chanceTaskBtn = [[UIButton alloc]init];
        [ToolControl makeButton:self.chanceTaskBtn titleColor:[UIColor blackColor] title:NSLocalizedString(@"Task_othertask_title",@"")  btnImage:nil cornerRadius:0 font:18];
        self.chanceTaskBtn.tag = 1;
        [self.chanceTaskBtn setTitleColor:[UIColor colorWithRed:0.90 green:0.09 blue:0.15 alpha:1.00] forState:UIControlStateSelected];
        [self addSubview:self.chanceTaskBtn];
        [self.chanceTaskBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nowTaskBtn.right).offset(0);
            make.top.equalTo(self.top).offset(0);
            make.width.equalTo(WIDTH/2);
            make.height.equalTo(45);
        }];
        [self.chanceTaskBtn addTarget:self action:@selector(chanceBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        self.redView = [[DrawRectRedView alloc]initWithFrame:CGRectMake(0, 39, WIDTH/2, 6)];
        [self addSubview:self.redView];
    }
    return self;
}

-(void)nowBtn:(UIButton *)sender
{
    sender.selected = YES;
    self.chanceTaskBtn.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.redView.frame = CGRectMake(0, 39, WIDTH/2, 6);
    }];
}
-(void)chanceBtn:(UIButton *)sender
{
    sender.selected = YES;
    self.nowTaskBtn.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.redView.frame = CGRectMake(WIDTH/2, 39, WIDTH/2, 6);
    }];
}
@end
