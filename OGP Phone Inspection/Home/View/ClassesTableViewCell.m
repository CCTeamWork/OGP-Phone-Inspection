//
//  ClassesTableViewCell.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/15.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "ClassesTableViewCell.h"
#import "ToolControl.h"
#import "DataBaseManager.h"
#import "ShiftModel.h"
@implementation ClassesTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dict:(NSDictionary *)dict
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.nameLa text:dict[@"shift_name"] font:16];
        self.nameLa.textColor = [UIColor colorWithRed:0.36 green:0.25 blue:1.00 alpha:1.00];
        [self.contentView addSubview:self.nameLa];
        [self.nameLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
            make.top.equalTo(self.top).offset(10);
        }];
        
        DataBaseManager * db = [DataBaseManager shareInstance];
        NSArray * shiftarray = [db selectSomething:@"shift_record" value:[NSString stringWithFormat:@"shift_id = %d",[dict[@"shift_id"] intValue]] keys:[ToolModel allPropertyNames:[ShiftModel class]] keysKinds:[ToolModel allPropertyAttributes:[ShiftModel class]]];
        if (shiftarray.count != 0) {
            dict = shiftarray[0];
            self.timeLa = [[UILabel alloc]init];
            [ToolControl makeLabel:self.timeLa text:[NSString stringWithFormat:@"工作时间：%@ -- %@",dict[@"working_hours"],dict[@"off_hours"]] font:14];
            self.timeLa.textColor = [UIColor grayColor];
            [self addSubview:self.timeLa];
            [self.timeLa makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.left).offset(10);
                make.top.equalTo(self.nameLa.bottom).offset(10);
            }];
        }
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
