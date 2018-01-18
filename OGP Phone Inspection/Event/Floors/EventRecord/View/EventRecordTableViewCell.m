//
//  EventRecordTableViewCell.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/24.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "EventRecordTableViewCell.h"
#import "ToolControl.h"
#import "ChanceButton.h"
#import "DataModel.h"
#import "DataBaseManager.h"
#import "ItemsKindModel.h"
#import "ItemsModel.h"
@implementation EventRecordTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dictionary:(NSDictionary *)dictionary
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
        [self.contentView addSubview:self.titleLa];
        [self.titleLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
            make.top.equalTo(self.top).offset(10);
        }];
        
        if ([dictionary[@"record_state"] intValue] == 0) {
            self.kindBtn  = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:NSLocalizedString(@"Record_record_unsend",@"") textFrame:CGRectMake(5, 0, 0, 0) image:@"thips" imageFrame:CGRectMake(0, 0, 15, 15) font:14];
            self.kindBtn.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:self.kindBtn];
            [self.kindBtn makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.right).offset(-10);
                make.top.equalTo(self.top).offset(10);
                make.width.equalTo(80);
                make.height.equalTo(20);
            }];
        }
        
        self.timeLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.timeLa text:dictionary[@"record_scantime"] font:14];
        self.timeLa.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.timeLa];
        [self.timeLa makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right).offset(-10);
            make.top.equalTo(self.titleLa.bottom).offset(10);
        }];
        
        NSArray * arr = [self dataKind:dictionary];
        for (int i = 0; i < arr.count; i++) {
            self.contentImage = [[UIImageView alloc]init];
            switch ([arr[i] intValue]) {
                case 0:
                    self.contentImage.image = [UIImage imageNamed:@"kindImage3"];
                    break;
                case 1:
                    self.contentImage.image = [UIImage imageNamed:@"kindImage1"];
                    break;
                case 2:
                    self.contentImage.image = [UIImage imageNamed:@"kindImage2"];
                    break;
                case 3:
                    self.contentImage.image = [UIImage imageNamed:@"kindImage0"];
                    break;
                default:
                    break;
            }
            [self.contentView addSubview:self.contentImage];
            [self.contentImage makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.left).offset(10 * (i + 1)+(20 * i));
                make.top.equalTo(self.titleLa.bottom).offset(10);
                make.width.equalTo(20);
                make.height.equalTo(20);
            }];
        }
    }
    return self;
}

/**
 判断事件中包含的数据类型

 @param dic 时间信息数据
 @return 类型数组 （1234）
 */
-(NSArray *)dataKind:(NSDictionary *)dic
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    NSArray * dataarray = [db selectSomething:@"data_record" value:[NSString stringWithFormat:@"data_uuid = '%@'",dic[@"data_uuid"]] keys:[ToolModel allPropertyNames:[DataModel class]] keysKinds:[ToolModel allPropertyAttributes:[DataModel class]]];
    [db dbclose];
    NSMutableArray * kindmul = [[NSMutableArray alloc]init];
    for (NSDictionary * dict in dataarray) {
        if ([dict[@"event_category"] isEqualToString:@"TEXT"]) {
            if (![kindmul containsObject:@(0)]) {
                [kindmul addObject:@(0)];
            }
        }
        if ([dict[@"event_category"] isEqualToString:@"PHOTO"]) {
            if (![kindmul containsObject:@(1)]) {
                [kindmul addObject:@(1)];
            }
        }
        if ([dict[@"event_category"] isEqualToString:@"VOICE"]) {
            if (![kindmul containsObject:@(2)]) {
                [kindmul addObject:@(2)];
            }
        }
        //   绑定了设备或项目
        if (dict[@"items_uuid"] != nil || [dic[@"event_device_code"] length]!= 0) {
            if (![kindmul containsObject:@(3)]) {
                [kindmul addObject:@(3)];
            }
        }
    }
    return kindmul;

}
- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 10;
    frame.size.height -= 10;
    
    [super setFrame:frame];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
