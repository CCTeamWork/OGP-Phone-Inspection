//
//  DetailView.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/21.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "DetailView.h"
#import "ToolControl.h"
@implementation DetailView

-(instancetype)initWithFrame:(CGRect)frame dictionary:(NSDictionary *)dictionary
{
    self = [super initWithFrame:frame];
    if (self) {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.88, 0.89, 0.89, 1.00 });
        
        //   详细界面的头视图
        self.headerView = [[UIView alloc]init];
        self.headerView.backgroundColor = [UIColor whiteColor];
        self.headerView.layer.masksToBounds = YES;
        self.headerView.layer.borderWidth = 1.0;
        self.headerView.layer.borderColor = colorref;
        [self addSubview:self.headerView];
        [self.headerView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(0);
            make.top.equalTo(self.top).offset(0);
            make.width.equalTo(WIDTH);
            make.height.equalTo(HEIGHT/6);
        }];
        
        //   设备名
        self.nameLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.nameLa text:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Record_datil_device_name",@""),dictionary[@"record_device_name"]] font:18];
        NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:self.nameLa.text];
        [aString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor]range:NSMakeRange(0,5)];
        self.nameLa.attributedText = aString;
        [self.headerView addSubview:self.nameLa];
        [self.nameLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerView.left).offset(5);
            make.top.equalTo(self.headerView.top).offset(10);
        }];
        
        //  保存时间
        self.keepTimeLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.keepTimeLa text:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Record_datil_keep_time",@""),dictionary[@"record_scantime"]] font:18];
        NSMutableAttributedString *bString = [[NSMutableAttributedString alloc]initWithString:self.keepTimeLa.text];
        [bString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor]range:NSMakeRange(0,5)];
        self.keepTimeLa.attributedText = bString;
        [self.headerView addSubview:self.keepTimeLa];
        [self.keepTimeLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerView.left).offset(5);
            make.top.equalTo(self.nameLa.bottom).offset(10);
        }];
        
        //   发送时间
        self.sendTimeLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.sendTimeLa text:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Record_datil_send_time",@""),dictionary[@"record_sendtime"]] font:18];
        if (dictionary[@"record_sendtime"] == nil) {
            self.sendTimeLa.text = [NSString stringWithFormat:NSLocalizedString(@"Record_datil_send_time_no",@"")];
        }
        NSMutableAttributedString *cString = [[NSMutableAttributedString alloc]initWithString:self.sendTimeLa.text];
        [cString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor]range:NSMakeRange(0,5)];
        self.sendTimeLa.attributedText = cString;
        [self.headerView addSubview:self.sendTimeLa];
        [self.sendTimeLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerView.left).offset(5);
            make.top.equalTo(self.keepTimeLa.bottom).offset(10);
        }];
        
    }
    return self;
}
@end
