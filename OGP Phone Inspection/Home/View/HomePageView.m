//
//  HomePageView.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/4.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "HomePageView.h"
#import "ToolControl.h"
#import "HomePageButton.h"
#import "HomePagePost.h"
#import "DataBaseManager.h"
#import "MessageModel.h"
@implementation HomePageView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect rectOfStatusbar = [[UIApplication sharedApplication] statusBarFrame];
        int h = 49+44+rectOfStatusbar.size.height;

        /**
         *  上班
         */
        self.checkBtn = [[UIButton alloc]init];
        if ([[USERDEFAULT valueForKey:CHECK_STATE] intValue] == 0) {
            [ToolControl makeButton:self.checkBtn titleColor:[UIColor whiteColor]
                              title:[NSString stringWithFormat:@"%@\n   %@",NSLocalizedString(@"Home_sart_checkin",@""),[HomePagePost checkTextGet]]
                           btnImage:@""
                       cornerRadius:(HEIGHT-h)/3*0.76/2
                               font:20];
            [self.checkBtn.layer setBorderWidth:5];
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.84, 0.89, 1.00, 1.00 });
            [self.checkBtn.layer setBorderColor:colorref];
            self.checkBtn.backgroundColor=[UIColor colorWithRed:0.31 green:0.52 blue:0.97 alpha:1.00];
        }else{
            [ToolControl makeButton:self.checkBtn titleColor:[UIColor whiteColor]
                              title:[NSString stringWithFormat:@"%@\n   %@",NSLocalizedString(@"Home_will_checkout",@""),[HomePagePost checkTextGet]]
                           btnImage:@""
                       cornerRadius:(HEIGHT-h)/3*0.76/2
                               font:20];
            [self.checkBtn.layer setBorderWidth:5];
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.78, 0.91, 0.89, 1.00 });
            [self.checkBtn.layer setBorderColor:colorref];
            self.checkBtn.backgroundColor=[UIColor colorWithRed:0.20 green:0.73 blue:0.66 alpha:1.00];
        }
        
        
        NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:self.checkBtn.titleLabel.text];
        [aString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14]range:NSMakeRange(4,self.checkBtn.titleLabel.text.length-4)];
        [self.checkBtn setAttributedTitle:aString forState:UIControlStateNormal];
        self.checkBtn.titleLabel.numberOfLines = 0;
        [self addSubview:self.checkBtn];
        [self.checkBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.top).offset((HEIGHT-h)/30);
            make.width.equalTo((HEIGHT-h)/3*0.76);
            make.height.equalTo((HEIGHT-h)/3*0.76);
        }];

        CGColorSpaceRef colorSpace1 = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref1 = CGColorCreate(colorSpace1,(CGFloat[]){ 0.88, 0.89, 0.89, 1.00 });
        
        /**
         *  下载
         */
        self.downBtn = [[HomePageButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) image:@"download" title:NSLocalizedString(@"Home_btn_download",@"")];
        [ToolControl makeButton:self.downBtn titleColor:[UIColor blackColor] title:nil btnImage:nil cornerRadius:0 font:14];
        [self.downBtn.layer setBorderWidth:1];
        [self.downBtn.layer setBorderColor:colorref1];

        [self addSubview:self.downBtn];
        [self.downBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(40);
            make.top.equalTo(self.top).offset((HEIGHT-h)/3);
            make.width.equalTo(WIDTH/2-40);
            make.height.equalTo((HEIGHT-h)/3*2/3*2/2);
        }];

        /**
         *  纪录
         */
        self.recordBtn = [[HomePageButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) image:@"jlu" title:NSLocalizedString(@"Home_btn_record",@"")];
        [ToolControl makeButton:self.recordBtn titleColor:[UIColor blackColor] title:nil btnImage:nil cornerRadius:0 font:14];
        [self.recordBtn.layer setBorderWidth:1];
        [self.recordBtn.layer setBorderColor:colorref1];
        [self addSubview:self.recordBtn];
        [self.recordBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right).offset(-40);
            make.top.equalTo(self.top).offset((HEIGHT-h)/3);
            make.width.equalTo(WIDTH/2-40);
            make.height.equalTo((HEIGHT-h)/3*2/3*2/2);
        }];
        /**
         *  通知
         */
        self.navitationBtn = [[HomePageButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) image:@"msg" title:NSLocalizedString(@"Home_btn_message",@"")];
        [ToolControl makeButton:self.navitationBtn titleColor:[UIColor blackColor] title:nil btnImage:nil cornerRadius:0 font:14];
        [self.navitationBtn.layer setBorderWidth:1];
        [self.navitationBtn.layer setBorderColor:colorref1];
        [self addSubview:self.navitationBtn];
        [self.navitationBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(40);
            make.top.equalTo(self.downBtn.bottom).offset(0);
            make.width.equalTo(WIDTH/2-40);
            make.height.equalTo((HEIGHT-h)/3*2/3*2/2);
        }];
        
        DataBaseManager * db = [DataBaseManager shareInstance];
        int number = [db selectNumber:@"message_record" value:[NSString stringWithFormat:@"isread = 0 and user_name = '%@'",[USERDEFAULT valueForKey:NAMEING]]];
        self.messageNumber = [[UILabel alloc]init];
        self.messageNumber.textAlignment = NSTextAlignmentCenter;
        [ToolControl makeLabel:self.messageNumber text:[NSString stringWithFormat:@"%d",number] font:10];
        self.messageNumber.backgroundColor = [UIColor colorWithRed:0.87 green:0.16 blue:0.24 alpha:1.00];
        [self.navitationBtn addSubview:self.messageNumber];
        [self.messageNumber makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.navitationBtn.image.right).offset(-10);
            make.bottom.equalTo(self.navitationBtn.image.top).offset(10);
            make.width.equalTo(20);
            make.height.equalTo(20);
        }];
        self.messageNumber.layer.masksToBounds = YES;
        self.messageNumber.layer.cornerRadius = 10;
        if (number == 0) {
            self.messageNumber.hidden = YES;
        }else{
            self.messageNumber.hidden = NO;
        }
        /**
         *  帮助
         */
        self.helpBtn = [[HomePageButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) image:@"help" title:NSLocalizedString(@"Home_btn_help",@"")];
        [ToolControl makeButton:self.helpBtn titleColor:[UIColor blackColor] title:nil btnImage:nil cornerRadius:0 font:14];
        [self.helpBtn.layer setBorderWidth:1];
        [self.helpBtn.layer setBorderColor:colorref1];
        [self addSubview:self.helpBtn];
        [self.helpBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right).offset(-40);
            make.top.equalTo(self.recordBtn.bottom).offset(0);
            make.width.equalTo(WIDTH/2-40);
            make.height.equalTo((HEIGHT-h)/3*2/3*2/2);
        }];
        /**
         *  退出
         */
        self.logoutBtn = [[UIButton alloc]init];
        if ([[USERDEFAULT valueForKey:CHECK_STATE] intValue] == 1){
            self.logoutBtn.enabled = NO;
        }
        [ToolControl makeButton:self.logoutBtn titleColor:[UIColor whiteColor] title:NSLocalizedString(@"Home_btn_logout",@"") btnImage:nil cornerRadius:0 font:16];
        self.logoutBtn.backgroundColor = [UIColor colorWithRed:0.87 green:0.16 blue:0.24 alpha:1.00];
        [self addSubview:self.logoutBtn];
        [self.logoutBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(self.navitationBtn.bottom).offset(((HEIGHT-h)-(HEIGHT-h)/3-(HEIGHT-h)/3*2/3*2)/3);
            make.width.equalTo(WIDTH-40);
            make.height.equalTo(((HEIGHT-h)-(HEIGHT-h)/3-(HEIGHT-h)/3*2/3*2)*0.38);
        }];
    }
    return self;
}

@end
