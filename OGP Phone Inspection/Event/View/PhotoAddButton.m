//
//  PhotoAddButton.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/27.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "PhotoAddButton.h"

@implementation PhotoAddButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.lineView];
        [self.lineView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.width.equalTo(2.0);
            make.height.equalTo(40);
        }];
        
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.lineView];
        [self.lineView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.width.equalTo(40);
            make.height.equalTo(2.0);
        }];
        
        [self setBackgroundImage:[self imageWithSize:CGSizeMake(60, 60) borderColor:[UIColor grayColor] borderWidth:1.0] forState:UIControlStateNormal];
    }
    return self;
}
- (UIImage *)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [[UIColor clearColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGFloat lengths[] = { 3, 1 };
    CGContextSetLineDash(context, 0, lengths, 1);
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, size.width, 0.0);
    CGContextAddLineToPoint(context, size.width, size.height);
    CGContextAddLineToPoint(context, 0, size.height);
    CGContextAddLineToPoint(context, 0.0, 0.0);
    CGContextStrokePath(context);
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}
@end
