//
//  ChooseButton.m/Users/zhangjianwei/Desktop/OGP Phone Inspection/Task/Equipment/Project/View/ChooseButton.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/8.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "ChooseButton.h"
#import "ToolControl.h"
#import "DataBaseManager.h"
@implementation ChooseButton

-(instancetype)initWithFrame:(CGRect)frame dictionary:(NSDictionary *)dict isend:(BOOL)isend number:(int)number
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.numberLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.numberLa text:[NSString stringWithFormat:@"%d.",number+1] font:16];
        [self addSubview:self.numberLa];
        [self.numberLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(25);
            make.top.equalTo(self.top).offset(15);
        }];
        
        //  检查项名
        self.optionid = [NSString stringWithFormat:@"%@" ,dict[@"option_id"]];
        self.la = [[UILabel alloc]init];
        [ToolControl makeLabel:self.la text:dict[@"option_name"] font:16];
        self.la.numberOfLines = 0;
        [self addSubview:self.la];
        [self.la makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.numberLa.right).offset(10);
            make.top.equalTo(self.top).offset(15);
            make.width.equalTo((WIDTH-30)/3*2);
        }];
        
        self.image = [[UIImageView alloc]init];
        [self addSubview:self.image];
        [self.image makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right).offset(-10);
            make.centerY.equalTo(self.la);
            make.width.equalTo(20);
            make.height.equalTo(20);
        }];
        
        self.errorBtn = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:@"项目异常" textFrame:CGRectMake(5, 0, 0, 0) image:@"" imageFrame:CGRectMake(0, 0, 20, 20) font:12];
        self.errorBtn.la.text=@"";
        [self addSubview:self.errorBtn];
        [self.errorBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.image.left).offset(-10);
            make.centerY.equalTo(self.la);
            make.width.equalTo(80);
            make.height.equalTo(20);
        }];
        
        if (!isend) {
            self.lineView = [[UIView alloc]init];
            self.lineView.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
            [self addSubview:self.lineView];
            [self.lineView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.left).offset(10);
                make.top.equalTo(self.la.bottom).offset(14);
                make.width.equalTo(WIDTH-10);
                make.height.equalTo(1);
            }];
        }
    }
    return self;
}
@end
