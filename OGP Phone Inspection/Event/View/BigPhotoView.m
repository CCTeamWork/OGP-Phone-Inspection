//
//  BigPhotoView.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/31.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "BigPhotoView.h"

@implementation BigPhotoView

-(instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0.3
                                                 green:0.3
                                                  blue:0.3
                                                 alpha:0.7]];
//        self.userInteractionEnabled=YES;
//        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBigImage:)];
//        [self addGestureRecognizer:tapGesture];
        UIImageView *imgView = [[UIImageView alloc] init];
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",image]];   // 保存文件的名称
//        UIImage *img = [UIImage imageWithContentsOfFile:filePath];
        imgView.image=image;
        [self addSubview:imgView];
        [imgView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(0);
            make.top.equalTo(self.top).offset(100);
            make.width.equalTo(WIDTH);
            make.height.equalTo(WIDTH);
        }];
        
        self.closeBtn = [[UIButton alloc]init];
        [self.closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [self addSubview:self.closeBtn];
        [self.closeBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(imgView.top).offset(-20);
            make.width.equalTo(40);
            make.height.equalTo(40);
        }];
        [self.closeBtn addTarget:self action:@selector(removeBigImage:) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}
-(void)removeBigImage:(UIImage *)image
{
    [self removeFromSuperview];
}
@end
