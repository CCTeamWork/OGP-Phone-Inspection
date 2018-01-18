
//
//  RecordView.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/19.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "RecordView.h"
#import "ToolControl.h"
@implementation RecordView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.88, 0.89, 0.89, 1.00 });

        //   全部按钮
        self.allBtn = [[UIButton alloc]init];
        [ToolControl makeButton:self.allBtn titleColor:[UIColor blackColor] title:NSLocalizedString(@"Record_record_all",@"") btnImage:nil cornerRadius:0 font:18];
        self.allBtn.selected = YES;
        [self.allBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        self.allBtn.tag = 0;
        self.allBtn.layer.borderWidth = 1.0;
        self.allBtn.layer.borderColor = colorref;
        [self addSubview:self.allBtn];
        [self.allBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(0);
            make.top.equalTo(self.top).offset(0);
            make.width.equalTo((WIDTH-50)/2);
            make.height.equalTo(50);
        }];
        [self.allBtn addTarget:self action:@selector(allBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        //   未发送按钮
        self.noSendBtn = [[UIButton alloc]init];
        [ToolControl makeButton:self.noSendBtn titleColor:[UIColor blackColor] title:NSLocalizedString(@"Record_record_unsend",@"") btnImage:nil cornerRadius:0 font:18];
        [self.noSendBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        self.noSendBtn.tag = 1;
        self.noSendBtn.layer.borderWidth = 1.0;
        self.noSendBtn.layer.borderColor = colorref;
        [self addSubview:self.noSendBtn];
        [self.noSendBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.allBtn.right).offset(0);
            make.top.equalTo(self.top).offset(0);
            make.width.equalTo((WIDTH-50)/2);
            make.height.equalTo(50);
        }];
        [self.noSendBtn addTarget:self action:@selector(nosendBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        //   移动的红线
        self.redView = [[DrawRectRedView alloc]initWithFrame:CGRectMake(0, 45, (WIDTH-50)/2, 6)];
//        self.redView.backgroundColor = [UIColor redColor];
        [self addSubview:self.redView];
        
        //   筛选按钮
        self.chanceBtn = [[UIButton alloc]init];
        [ToolControl makeButton:self.chanceBtn titleColor:nil title:nil btnImage:@"filter" cornerRadius:0 font:0];
        self.chanceBtn.layer.borderWidth = 1.0;
        self.chanceBtn.layer.borderColor = colorref;
        [self addSubview:self.chanceBtn];
        [self.chanceBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.noSendBtn.right).offset(0);
            make.top.equalTo(self.top).offset(0);
            make.width.equalTo(50);
            make.height.equalTo(50);
        }];
    }
    return self;
}
-(void)allBtn:(UIButton *)sender
{
    sender.selected = YES;
    self.noSendBtn.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.redView.frame = CGRectMake(0, 45, (WIDTH-50)/2, 6);
    }];
}
-(void)nosendBtn:(UIButton *)sender
{
    sender.selected = YES;
    self.allBtn.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.redView.frame = CGRectMake((WIDTH-50)/2, 45, (WIDTH-50)/2, 6);
    }];
}
@end
