//
//  ChooseTableCellTableViewCell.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/19.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "ChooseTableCellTableViewCell.h"
#import "ToolControl.h"
#import "DataBaseManager.h"
#import "SiteModel.h"
@implementation ChooseTableCellTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dict:(NSDictionary *)dic
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        NSDictionary * dictionary = dic[@"sch_dict"];
        
        DataBaseManager * db = [DataBaseManager shareInstance];
        NSArray * array = [db selectSomething:@"site_record" value:[NSString stringWithFormat:@"site_id = %@",dictionary[@"site_id"]] keys:[ToolModel allPropertyNames:[SiteModel class]] keysKinds:[ToolModel allPropertyAttributes:[SiteModel class]]];
        NSString * str;
        if (array.count == 0) {
            str = dictionary[@"site_id"];
        }else{
            str = array[0][@"site_name"];
        }
        self.nameLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.nameLa text:str font:16];
        self.nameLa.textColor = [UIColor colorWithRed:0.56 green:0.75 blue:1.00 alpha:1.00];
        [self.contentView addSubview:self.nameLa];
        [self.nameLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
            make.top.equalTo(self.top).offset(10);
        }];
        
        self.timeLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.timeLa text:[NSString stringWithFormat:@"计划时间：%@ -- %@",dictionary[@"start_time"],dictionary[@"end_time"]] font:14];
        self.timeLa.textColor = [UIColor grayColor];
        [self addSubview:self.timeLa];
        [self.timeLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
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
