//
//  MethodTableViewCell.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/7.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "MethodTableViewCell.h"
#import "ToolControl.h"
@implementation MethodTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dictionary:(NSDictionary *)dictionary
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.nameLa text:@"巡检方法及标准" font:18];
        [self.contentView addSubview:self.nameLa];
        [self.nameLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
            make.top.equalTo(self.top).offset(10);
        }];
        
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
        [self.contentView addSubview:self.lineView];
        [self.lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(0);
            make.top.equalTo(self.nameLa.bottom).offset(10);
            make.width.equalTo(WIDTH);
            make.height.equalTo(1);
        }];
        
        self.contentLa = [[UILabel alloc]init];
        NSString * contentStr;
        if (dictionary[@"comments"] != nil && dictionary[@"standard"] != nil) {
            contentStr =[NSString stringWithFormat:@"%@\n%@",dictionary[@"comments"],dictionary[@"standard"]];
        }
        if (dictionary[@"comments"] != nil && dictionary[@"standard"] == nil) {
            contentStr =[NSString stringWithFormat:@"%@",dictionary[@"comments"]];
        }
        if (dictionary[@"comments"] == nil && dictionary[@"standard"] != nil) {
            contentStr =[NSString stringWithFormat:@"%@",dictionary[@"standard"]];
        }
        [ToolControl makeLabel:self.contentLa text:contentStr font:15];
        self.contentLa.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.contentLa];
        [self.contentLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
            make.top.equalTo(self.lineView.bottom).offset(10);
            make.width.equalTo(WIDTH-20);
        }];
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAllContent)];
        // 2. 将点击事件添加到label上
        [self.contentLa addGestureRecognizer:labelTapGestureRecognizer];
        self.contentLa.userInteractionEnabled = YES; // 可以理解为设置label可被点击

        CGSize contentSize = [ToolControl makeText:self.contentLa.text font:15];
        int i = contentSize.width/(WIDTH-20);
        if (i<1) {
            i++;
        }
        if (contentSize.height>50) {
            self.showBtn = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:@"展开全文" textFrame:CGRectMake(5, 0, 0, 0) image:@"down_arrow" imageFrame:CGRectMake(0, 0, 10, 10) font:14];
            self.showBtn.la.textColor = [UIColor redColor];
            [self.contentView addSubview:self.showBtn];
            [self.showBtn makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self.contentLa.bottom).offset(10);
                make.width.equalTo(100);
                make.height.equalTo(14);
            }];
            [self.showBtn addTarget:self action:@selector(showAllContent) forControlEvents:UIControlEventTouchUpInside];
        }else{
            self.contentLa.numberOfLines = 0;
        }
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.70, 0.70, 0.70, 1.00 });
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = colorref;
    }
    return self;
}

/**
 查看全文
 */
-(void)showAllContent
{
    CGSize contentSize = [ToolControl makeText:self.contentLa.text font:15];
    int i = contentSize.width/(WIDTH-20);
    if (i<1) {
        i++;
    }
    if (self.showBtn.selected == NO) {
        self.contentLa.numberOfLines = 0;
        if (self.showAllTextBlock) {
            self.showAllTextBlock(contentSize.height * i);
        }
        self.showBtn.la.text = @"收回全文";
        self.showBtn.image.image = [UIImage imageNamed:@"up_arrow"];
    }else{
        self.contentLa.numberOfLines = 1;
        if (self.showAllTextBlock) {
            self.showAllTextBlock(contentSize.height);
        }
        self.showBtn.la.text = @"展开全文";
        self.showBtn.image.image = [UIImage imageNamed:@"down_arrow"];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
    self.showBtn.selected = !self.showBtn.selected;
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
