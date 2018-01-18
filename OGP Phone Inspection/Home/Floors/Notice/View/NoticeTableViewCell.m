//
//  NoticeTableViewCell.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/21.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "NoticeTableViewCell.h"
#import "ToolControl.h"
@implementation NoticeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dictionary:(NSDictionary *)dictionary
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.titleLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.titleLa text:dictionary[@"message_title"] font:16];
        [self.contentView addSubview:self.titleLa];
        [self.titleLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(self.top).offset(10);
            make.width.equalTo(WIDTH-50);
        }];
        
        if ([dictionary[@"isread"] intValue] == 0) {
            self.imageview = [[UIImageView alloc]init];
            self.imageview.image = [UIImage imageNamed:@"spot_red"];
            [self.contentView addSubview:self.imageview];
            [self.imageview makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.right).offset(-20);
                make.centerY.equalTo(self.titleLa);
                make.width.equalTo(5);
                make.height.equalTo(5);
            }];
        }
    
        self.timeLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.timeLa text:dictionary[@"msg_time"] font:14];
        [self.contentView addSubview:self.timeLa];
        [self.timeLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(self.titleLa.bottom).offset(10);
        }];
        
//        self.timeLa = [[UILabel alloc]init];
//        [ToolControl makeLabel:self.timeLa text:dictionary[@"msg_time"] font:14];
//        [self.contentView addSubview:self.timeLa];
//        [self.timeLa makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.right).offset(-5);
//            make.top.equalTo(self.titleLa.bottom).offset(10);
//        }];
        
        self.contentLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.contentLa text:dictionary[@"content"] font:14];
        self.contentLa.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.contentLa];
        [self.contentLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(self.timeLa.bottom).offset(10);
            make.width.equalTo(WIDTH-20);
        }];
    }
    return self;
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
