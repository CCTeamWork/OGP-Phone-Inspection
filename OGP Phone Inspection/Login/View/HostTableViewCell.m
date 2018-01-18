//
//  HostTableViewCell.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/14.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "HostTableViewCell.h"
#import "ToolControl.h"
@implementation HostTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dictionary:(NSDictionary *)dictionary
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.ipnameLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.ipnameLa text:@"IP" font:16];
        [self addSubview:self.ipnameLa];
        [self.ipnameLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(self.top).offset(10);
        }];
        
        self.ipcontentLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.ipcontentLa text:dictionary[@"ip"] font:16];
        [self addSubview:self.ipcontentLa];
        [self.ipcontentLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.ipnameLa.right).offset(50);
            make.top.equalTo(self.top).offset(10);
        }];
        
        self.hostnameLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.hostnameLa text:NSLocalizedString(@"Host_name_title",@"") font:16];
        [self addSubview:self.hostnameLa];
        [self.hostnameLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(self.ipnameLa.bottom).offset(20);
        }];
        
        self.hostcontentLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.hostcontentLa text:dictionary[@"name"] font:16];
        [self addSubview:self.hostcontentLa];
        [self.hostcontentLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.ipcontentLa.left).offset(0);
            make.centerY.equalTo(self.hostnameLa);
            make.width.equalTo(WIDTH/3*2);
        }];
        
        self.lineview = [[UIView alloc]init];
        self.lineview.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
        [self addSubview:self.lineview];
        [self.lineview makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(0);
            make.top.equalTo(self.hostnameLa.bottom).offset(20);
            make.width.equalTo(WIDTH);
            make.height.equalTo(1);
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
