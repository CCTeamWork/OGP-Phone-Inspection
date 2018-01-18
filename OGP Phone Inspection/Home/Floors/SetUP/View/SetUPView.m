//
//  SetUPView.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/10.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "SetUPView.h"
#import "ToolControl.h"
@implementation SetUPView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.wifiLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.wifiLa text:NSLocalizedString(@"Set_photo_post_title",@"") font:16];
        [self addSubview:self.wifiLa];
        [self.wifiLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(self.top).offset(10);
        }];
        
        self.wifiBtn = [[UIButton alloc]init];
        [self.wifiBtn setImage:[UIImage imageNamed:@"unselecte"] forState:UIControlStateNormal];
        [self.wifiBtn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
        if ([LOGIN_BACK[@"wifi_upload_flow"] intValue] == 1) {
            self.wifiBtn.selected = YES;
        }
        self.wifiBtn.enabled = NO;
        [self addSubview:self.wifiBtn];
        [self.wifiBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right).offset(-10);
            make.centerY.equalTo(self.wifiLa);
            make.width.equalTo(20);
            make.height.equalTo(20);
        }];
//        [self.wifiBtn addTarget:self action:@selector(chiose:) forControlEvents:UIControlEventTouchUpInside];
        
        [self makeLineView:self.wifiLa];
        
        self.previewLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.previewLa text:NSLocalizedString(@"Set_items_prew_title",@"") font:16];
        [self addSubview:self.previewLa];
        [self.previewLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(self.wifiLa.bottom).offset(20);
        }];
        
        self.previewBtn = [[UIButton alloc]init];
        [self.previewBtn setImage:[UIImage imageNamed:@"unselecte"] forState:UIControlStateNormal];
        [self.previewBtn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
        if ([[USERDEFAULT valueForKey:@"ispreview"] intValue] == 0) {
            self.previewBtn.selected = YES;
        }
        [self addSubview:self.previewBtn];
        [self.previewBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right).offset(-10);
            make.centerY.equalTo(self.previewLa);
            make.width.equalTo(20);
            make.height.equalTo(20);
        }];
        [self.previewBtn addTarget:self action:@selector(chiose:) forControlEvents:UIControlEventTouchUpInside];
        
        [self makeLineView:self.previewLa];
        
        self.recordLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.recordLa text:NSLocalizedString(@"Set_record_time_title",@"") font:16];
        [self addSubview:self.recordLa];
        [self.recordLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(self.previewLa.bottom).offset(20);
        }];
        
        self.recordField = [[UITextField alloc]init];
        self.recordField.font = [UIFont systemFontOfSize:16];
        self.recordField.delegate = self;
        self.recordField.text = @"1";
        self.recordField.borderStyle = UITextBorderStyleBezel;
        self.recordField.clearButtonMode = UITextFieldViewModeNever;
        self.recordField.keyboardType=UIKeyboardTypeNumberPad;
        self.recordField.layer.masksToBounds = YES;
        self.recordField.layer.cornerRadius = 5.0f;
        [self addSubview:self.recordField];
        [self.recordField makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.recordLa.right).offset(10);
            make.centerY.equalTo(self.recordLa);
            make.width.equalTo(40);
            make.height.equalTo(30);
        }];
        
//        self.recordLa = [[UILabel alloc]init];
//        [ToolControl makeLabel:self.recordLa text:@"个月" font:16];
//        [self addSubview:self.recordLa];
//        [self.recordLa makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.recordField.right).offset(10);
//            make.centerY.equalTo(self.recordField);
//        }];
//        
        [self makeLineView:self.recordLa];
        
        self.offlineMapBtn = [[UIButton alloc]init];
        [ToolControl makeButton:self.offlineMapBtn titleColor:[UIColor blackColor] title:NSLocalizedString(@"Set_offlinemap_title",@"") btnImage:nil cornerRadius:0 font:16];
        self.offlineMapBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:self.offlineMapBtn];
        [self.offlineMapBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(self.recordLa.bottom).offset(10);
            make.width.equalTo(WIDTH-30);
            make.height.equalTo(40);
        }];
        
        [self makeLineView1:self.offlineMapBtn];
        
        self.timeBtn = [[UIButton alloc]init];
        [ToolControl makeButton:self.timeBtn titleColor:[UIColor blackColor] title:NSLocalizedString(@"Set_alarm_title",@"") btnImage:nil cornerRadius:0 font:16];
        self.timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:self.timeBtn];
        [self.timeBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(self.offlineMapBtn.bottom).offset(0);
            make.width.equalTo(WIDTH-30);
            make.height.equalTo(40);
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
-(void)makeLineView1:(UIButton *)btn
{
    self.lineview = [[UIView alloc]init];
    self.lineview.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.9 alpha:1.00];
    [self addSubview:self.lineview];
    [self.lineview makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(0);
        make.top.equalTo(btn.bottom).offset(0);
        make.width.equalTo(WIDTH);
        make.height.equalTo(1);
    }];
}
-(void)chiose:(UIButton *)sender
{
    if (sender.selected == NO) {
        [USERDEFAULT setObject:@(1) forKey:@"ispreview"];
    }else{
        [USERDEFAULT setObject:@(0) forKey:@"ispreview"];
    }
    sender.selected = !sender.selected;
}
/**
 保存修改的记录保存时间

 @param textField <#textField description#>
 */
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text intValue] > 24) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"All_alert_title",@"") message:NSLocalizedString(@"Set_alert_record_title_one",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"All_sure",@"") otherButtonTitles:nil, nil];
        [alert show];
        textField.text = nil;
    }else{
        if ([textField.text intValue] < [[USERDEFAULT valueForKey:RECORD_KEEP_TIME] intValue]) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"All_alert_title",@"") message:NSLocalizedString(@"Set_alert_record_title_two",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"All_cancel",@"") otherButtonTitles:NSLocalizedString(@"All_sure",@""), nil];
            [alert show];
            return;
        }
        [USERDEFAULT setObject:self.recordField.text forKey:RECORD_KEEP_TIME];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"取消修改");
    }else{
        [USERDEFAULT setObject:self.recordField.text forKey:RECORD_KEEP_TIME];
    }
}
@end
