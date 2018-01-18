//
//  VideoView.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/28.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "VideoView.h"
#import "ToolControl.h"
@implementation VideoView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0.3
                                                 green:0.3
                                                  blue:0.3
                                                 alpha:0.7]];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8.0;
        
        self.videoImage = [[UIImageView alloc]init];
        self.videoImage.image = [UIImage imageNamed:@"语音2"];
        [self addSubview:self.videoImage];
        [self.videoImage makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.top).offset(10);
            make.width.equalTo(80);
            make.height.equalTo(80);
        }];
        
        self.videoLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.videoLa text:@"手指上滑取消发送" font:16];
        self.videoLa.textColor = [UIColor whiteColor];
        [self addSubview:self.videoLa];
        [self.videoLa makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.videoImage.bottom).offset(10);
        }];
        
    }
    return self;
}

@end
