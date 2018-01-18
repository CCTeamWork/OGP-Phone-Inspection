//
//  RecordTableViewCell.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/19.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "RecordTableViewCell.h"
#import "ToolControl.h"
#import "DataBaseManager.h"
#import "ItemsKindModel.h"
#import "RecordPost.h"
@implementation RecordTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dict:(NSDictionary *)dict
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //   设备名
        self.nameLa = [[UILabel alloc]init];
        if ([dict[@"record_category"] isEqualToString:@"PATROL"]) {
            [ToolControl makeLabel:self.nameLa text:dict[@"record_device_name"] font:17];
        }else{
            [ToolControl makeLabel:self.nameLa text:[RecordPost recordTypeString:dict[@"record_category"]] font:17];
        }
        [self.contentView addSubview:self.nameLa];
        [self.nameLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(5);
            make.top.equalTo(self.top).offset(10);
        }];
        
        DataBaseManager * db = [DataBaseManager shareInstance];
        int count = [db selectNumber:@"itemskind_record" value:[NSString stringWithFormat:@"record_uuid = '%@'",dict[@"record_uuid"]]];
        //   项目数
        self.numberLa = [[UILabel alloc]init];
        if ([dict[@"record_category"] isEqualToString:@"PATROL"]) {
            [ToolControl makeLabel:self.numberLa text:[NSString stringWithFormat:@"%d%@",count,NSLocalizedString(@"Record_has_items_number",@"")] font:12];
        }else{
            [ToolControl makeLabel:self.numberLa text:[USERDEFAULT valueForKey:NAMEING] font:12];
        }
        self.numberLa.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.numberLa];
        [self.numberLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(5);
            make.top.equalTo(self.nameLa.bottom).offset(10);
        }];
        
        //   记录种类
        self.kindLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.kindLa text:[RecordPost recordTypeString:dict[@"record_category"]] font:12];
        self.kindLa.textColor = [UIColor whiteColor];
        self.kindLa.textAlignment = NSTextAlignmentCenter;
        self.kindLa.layer.masksToBounds = YES;
        self.kindLa.layer.cornerRadius = 2;
        self.kindLa.backgroundColor = [RecordPost recordTypeColor:dict[@"record_category"]];
        [self.contentView addSubview:self.kindLa];
        [self.kindLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.numberLa.right).offset(5);
            make.top.equalTo(self.nameLa.bottom).offset(10);
        }];

        //   时间
        self.timeLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.timeLa text:dict[@"record_scantime"] font:12];
        self.timeLa.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.timeLa];
        [self.timeLa makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right).offset(-5);
            make.top.equalTo(self.nameLa.bottom).offset(10);
        }];
    }
    return self;
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
