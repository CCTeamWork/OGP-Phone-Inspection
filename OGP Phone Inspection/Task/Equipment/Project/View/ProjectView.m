//
//  ProjectView.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/7.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "ProjectView.h"
#import "ToolControl.h"
#import "DataBaseManager.h"
#import "ItemsModel.h"
@implementation ProjectView

-(instancetype)initWithFrame:(CGRect)frame devicedic:(NSDictionary *)devicedict itemsdict:(NSDictionary *)itemdict
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.image = [[UIImageView alloc]init];
        self.image.image = [UIImage imageNamed:@"sbei_on"];
        if ([devicedict[@"device_state"] isEqualToString:@"disable"]) {
            self.image.image = [UIImage imageNamed:@"sbei_off"];
        }
        [self addSubview:self.image];
        [self.image makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
            make.top.equalTo(self.top).offset(10);
            make.width.equalTo(40);
            make.height.equalTo(40);
        }];
        
        self.nameLa = [[UILabel alloc]init];
        if ([devicedict[@"device_name"] length] == 0) {
            [ToolControl makeLabel:self.nameLa text:devicedict[@"record_device_name"] font:18];
        }else{
            [ToolControl makeLabel:self.nameLa text:devicedict[@"device_name"] font:18];
        }
        self.nameLa.textAlignment = NSTextAlignmentCenter;
        self.nameLa.numberOfLines = 0;
        [self addSubview:self.nameLa];
        [self.nameLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(0);
            make.top.equalTo(self.top).offset(10);
            make.width.equalTo(WIDTH);
        }];
        
        self.stateLa = [[UILabel alloc]init];
        if ([devicedict[@"device_state"] isEqualToString:@"normal"]) {
            [ToolControl makeLabel:self.stateLa text:@"状态：正常" font:14];
        }else{
            [ToolControl makeLabel:self.stateLa text:@"状态：停用" font:14];
        }
        self.stateLa.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.stateLa];
        [self.stateLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(0);
            make.top.equalTo(self.nameLa.bottom).offset(10);
            make.width.equalTo(WIDTH);
        }];
        
//        self.lineView = [[UIView alloc]init];
//        self.lineView.backgroundColor = [UIColor grayColor];
//        [self addSubview:self.lineView];
//        [self.lineView makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.left).offset(0);
//            make.top.equalTo(self.stateLa.bottom).offset(9);
//            make.width.equalTo(WIDTH);
//            make.height.equalTo(1);
//        }];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.70, 0.70, 0.70, 1.00 });
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = colorref;
        
        
//        NSString * titletext = itemdict[@"items_name"];
//        if ([itemdict[@"items_name"] length] == 0) {
//            DataBaseManager * db = [DataBaseManager shareInstance];
//            NSArray * array = [db selectSomething:@"items_record" value:[NSString stringWithFormat:@"items_id = %d",[itemdict[@"items_id"] intValue]] keys:[ToolModel allPropertyNames:[ItemsModel class]] keysKinds:[ToolModel allPropertyAttributes:[ItemsModel class]]];
//            if (array.count != 0) {
//                titletext = array[0][@"items_name"];
//            }
//        }
//        self.titleLa = [[UILabel alloc]init];
//        [ToolControl makeLabel:self.titleLa text:titletext font:18];
//        self.titleLa.numberOfLines = 0;
//        [self addSubview:self.titleLa];
//        [self.titleLa makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.left).offset(10);
//            make.top.equalTo(self.lineView.bottom).offset(10);
//            make.width.equalTo(WIDTH-20);
//        }];
    }
    return self;
}
@end
