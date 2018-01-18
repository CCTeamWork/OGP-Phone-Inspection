//
//  TimerTableViewCell.m
//  OGP phone patrol
//
//  Created by 张建伟 on 17/5/6.
//  Copyright © 2017年 张建伟. All rights reserved.
//

#import "TimerTableViewCell.h"

@implementation TimerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.la1=[[UILabel alloc]initWithFrame:CGRectMake(20, 15, WIDTH/2, 50)];
        self.la1.font=[UIFont systemFontOfSize:34];
        [self.contentView addSubview:self.la1];
        
        self.la2=[[UILabel alloc]init];
        self.la2.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.la2];
        [self.la2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(self.la1.bottom).offset(10);
            make.height.equalTo(10);
            make.width.equalTo(WIDTH);
        }];
        
        self.swich=[[UISwitch alloc]init];
        self.swich.transform = CGAffineTransformMakeScale(1.2, 1.2);
        [self.swich addTarget:self action:@selector(OpenOrNo:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:self.swich];
        [self.swich makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right).offset(-50);
            make.top.equalTo(self.top).offset(30);
            make.height.equalTo(20);
            make.width.equalTo(40);
        }];
    }
    return self;
}
-(void)OpenOrNo:(UITableViewCell *)cell
{
    if ([_delegate respondsToSelector:@selector(delegateTimer:)]) {
        cell.tag = self.swich.tag;
        [_delegate delegateTimer:cell];
    }
}
@end
