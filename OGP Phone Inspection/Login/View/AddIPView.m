//
//  AddIPView.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/14.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "AddIPView.h"
#import "ToolControl.h"
@implementation AddIPView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0.3
                                                 green:0.3
                                                  blue:0.3
                                                 alpha:0.7]];

        
        self.bgview = [[UIView alloc]init];
        self.bgview.layer.masksToBounds = YES;
        self.bgview.layer.cornerRadius = 4;
        self.bgview.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgview];
        [self.bgview makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.width.equalTo(WIDTH-80);
            make.height.equalTo(220);
        }];
        
        self.titleLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.titleLa text:NSLocalizedString(@"Host_add_ip",@"") font:16];
        [self.bgview addSubview:self.titleLa];
        [self.titleLa makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgview);
            make.top.equalTo(self.bgview.top).offset(20);
        }];
        
        self.ipField = [[UITextField alloc]init];
        [ToolControl maketextField:self.ipField text:NSLocalizedString(@"Host_write_ip",@"") cornerRadius:0];
        [self.bgview addSubview:self.ipField];
        [self.ipField makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgview.left).offset(20);
            make.right.equalTo(self.bgview.right).offset(-20);
            make.top.equalTo(self.titleLa.bottom).offset(20);
            make.height.equalTo(40);
        }];
        
        self.nameField = [[UITextField alloc]init];
        [ToolControl maketextField:self.nameField text:NSLocalizedString(@"Host_write_name",@"") cornerRadius:0];
        [self.bgview addSubview:self.nameField];
        [self.nameField makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgview.left).offset(20);
            make.right.equalTo(self.bgview.right).offset(-20);
            make.top.equalTo(self.ipField.bottom).offset(20);
            make.height.equalTo(40);
        }];
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.88, 0.89, 0.89, 1.00 });
        
        self.cancleBtn = [[UIButton alloc]init];
        [self.cancleBtn setTitle:NSLocalizedString(@"Host_cancel_add",@"") forState:UIControlStateNormal];
        [self.cancleBtn setTitleColor:[UIColor colorWithRed:0.25 green:0.54 blue:0.93 alpha:1.00] forState:UIControlStateNormal];
        self.cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        self.cancleBtn.layer.borderWidth = 1.0;
        self.cancleBtn.layer.borderColor = colorref;
        [self.bgview addSubview:self.cancleBtn];
        [self.cancleBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgview.left).offset(0);
            make.bottom.equalTo(self.bgview.bottom).offset(0);
            make.width.equalTo((WIDTH-80)/2);
            make.height.equalTo(40);
        }];
        [self.cancleBtn addTarget:self action:@selector(cancleBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        self.finishBtn = [[UIButton alloc]init];
        [self.finishBtn setTitle:NSLocalizedString(@"Host_sure_add",@"") forState:UIControlStateNormal];
        [self.finishBtn setTitleColor:[UIColor colorWithRed:0.25 green:0.54 blue:0.93 alpha:1.00] forState:UIControlStateNormal];
        self.finishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        self.finishBtn.layer.borderWidth = 1.0;
        self.finishBtn.layer.borderColor = colorref;
        [self.bgview addSubview:self.finishBtn];
        [self.finishBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cancleBtn.right).offset(0);
            make.bottom.equalTo(self.bgview.bottom).offset(0);
            make.width.equalTo((WIDTH-80)/2);
            make.height.equalTo(40);
        }];
    }
    return self;
}
-(void)cancleBtnTouch:(UIButton *)sender
{
    [self removeFromSuperview];
}
@end
