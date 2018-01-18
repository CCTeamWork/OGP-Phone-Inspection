//
//  EventBateView.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/25.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "EventBateView.h"
#import "ToolControl.h"
#import "DataBaseManager.h"
#import "ItemsKindModel.h"
#import "ItemsModel.h"
@implementation EventBateView

-(instancetype)initWithFrame:(CGRect)frame dictionary:(NSDictionary *)dictionary
{
    self = [super initWithFrame:frame];
    if (self) {
        DataBaseManager * db = [DataBaseManager shareInstance];
        NSString * titletext = dictionary[@"record_content"];
        if ([dictionary[@"items_uuid"] length] != 0) {
            NSArray * array = [db selectSomething:@"itemskind_record" value:[NSString stringWithFormat:@"items_uuid = '%@'",dictionary[@"items_uuid"]] keys:[ToolModel allPropertyNames:[ItemsKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[ItemsKindModel class]]];
            if (array.count != 0) {
                NSArray * arr = [db selectSomething:@"items_record" value:[NSString stringWithFormat:@"items_id = %d",[array[0][@"items_id"] intValue]] keys:[ToolModel allPropertyNames:[ItemsModel class]] keysKinds:[ToolModel allPropertyAttributes:[ItemsModel class]]];
                if (arr.count != 0) {
                    titletext = arr[0][@"items_name"];
                }
            }
        }

        self.titleLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.titleLa text:titletext font:18];
        [self addSubview:self.titleLa];
        [self.titleLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
            make.top.equalTo(self.top).offset(10);
        }];
        
        self.timeLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.timeLa text:dictionary[@"record_scantime"] font:14];
        self.timeLa.textColor = [UIColor grayColor];
        [self addSubview:self.timeLa];
        [self.timeLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
            make.top.equalTo(self.titleLa.bottom).offset(10);
        }];
        
//        for (int i = 0; i < 4; i++) {
//            self.contentImage = [[UIImageView alloc]init];
//            self.contentImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"kindImage%d",i]];
//            [self addSubview:self.contentImage];
//            [self.contentImage makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.left).offset(10 * (i + 1)+(20 * i));
//                make.top.equalTo(self.titleLa.bottom).offset(10);
//                make.width.equalTo(20);
//                make.height.equalTo(20);
//            }];
//        }
    }
    return self;
}

@end
