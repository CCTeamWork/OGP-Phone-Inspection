//
//  IPButtn.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/11.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "IPButtn.h"
#import "ToolControl.h"
@implementation IPButtn

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //  IP按钮的文字
        self.la = [[UILabel alloc]init];
        [ToolControl makeLabel:self.la text:NSLocalizedString(@"Host_ip_title",@"") font:18];
        self.la.textColor  =[UIColor whiteColor];
        [self addSubview:self.la];
        [self.la makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right).offset(0);
            make.centerY.equalTo(self);
        }];
        //   IP按钮的图片
        self.image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zj"]];
        [self addSubview:self.image];
        self.image.backgroundColor = [UIColor clearColor];
        [self.image makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top).offset(2);
            make.right.equalTo(self.la.left).offset(-5);
            make.bottom.equalTo(self.bottom).offset(2);
            make.width.equalTo(20);
        }];
        
    }
    return self;
}


@end
