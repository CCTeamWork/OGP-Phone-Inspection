//
//  FieldAlertView.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 2017/12/14.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "FieldAlertView.h"

@implementation FieldAlertView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.fieldLa = [[UILabel alloc]init];
        self.fieldLa.backgroundColor = [UIColor whiteColor];
        self.fieldLa.font = [UIFont systemFontOfSize:32];
        self.fieldLa.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.fieldLa];
        [self.fieldLa makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.width.equalTo(WIDTH-120);
            make.height.equalTo(80);
        }];
    }
    
    self.backgroundColor = [UIColor colorWithRed:0.3
                                           green:0.3
                                            blue:0.3
                                           alpha:0.7];
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
