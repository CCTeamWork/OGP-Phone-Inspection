//
//  HomePageButton.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/4.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "HomePageButton.h"
#import "ToolControl.h"
@implementation HomePageButton

-(instancetype)initWithFrame:(CGRect)frame image:(NSString *)imageName title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //   图片
        self.image = [[UIImageView alloc]init];
        self.image.image = [UIImage imageNamed:imageName];
        [self addSubview:self.image];
        [self.image makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.top).offset(HEIGHT/3*2/3*2/2/6);
            make.width.equalTo(HEIGHT/3*2/3*2/2/3);
            make.height.equalTo(HEIGHT/3*2/3*2/2/3);
        }];
        //  文字
        self.la = [[UILabel alloc]init];
        [ToolControl makeLabel:self.la text:title font:15];
        self.la.textAlignment = NSTextAlignmentCenter;
        self.la.textColor = [UIColor blackColor];
        [self addSubview:self.la];
        [self.la makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.image.bottom).offset(5);
        }];
    }
    return self;
}

@end
