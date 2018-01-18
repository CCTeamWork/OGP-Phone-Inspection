//
//  ProjectSimleTableViewCell.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 2017/12/27.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "ProjectSimleTableViewCell.h"
#import "ToolControl.h"
@implementation ProjectSimleTableViewCell

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
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //  检查项题目
        self.titleLa = [[UILabel alloc]init];
        self.titleLa.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:self.titleLa];
        //   检查项状态
        self.imageState = [[UIImageView alloc]init];
        [self.contentView addSubview:self.imageState];
    }
    return self;
}

-(void)projectSimleCell_itemsDict:(NSDictionary *)itemsDict deviceDict:(NSDictionary *)deviceDict number:(int)number
{
    [ToolControl makeLabel:self.titleLa text:[NSString stringWithFormat:@"%d.%@",number+1,itemsDict[@"items_name"]] font:18];
    self.titleLa.numberOfLines = 0;
    [self.titleLa makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(10);
        make.centerY.equalTo(self);
        make.width.equalTo(WIDTH-50);
    }];
    
    [self.imageState makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-40);
        make.centerY.equalTo(self.titleLa);
    }];
    if ([itemsDict[@"items_finish_state"] intValue] == 0) {
        self.imageState.image = [UIImage imageNamed:@"spot_red"];
        self.imageState.frame.size = CGSizeMake(10, 10);
    }else if ([itemsDict[@"items_finish_state"] intValue] == 1){
        self.imageState.image = [UIImage imageNamed:@"spot_green"];
        self.imageState.frame.size = CGSizeMake(10, 10);
    }else if ([itemsDict[@"items_value_status"] intValue] == 0){
        self.imageState.image = [UIImage imageNamed:@"thips"];
        self.imageState.frame.size = CGSizeMake(10, 10);
    }
}
- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 10;
    frame.size.height -= 10;
    
    [super setFrame:frame];
}
@end
