//
//  DrawRectRedView.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/24.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "DrawRectRedView.h"

@implementation DrawRectRedView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
#pragma mark 绘制三角形
- (void)drawRect:(CGRect)rect {
    // 设置背景色
    [[UIColor whiteColor] set];
    //拿到当前视图准备好的画板
    
    CGContextRef  context = UIGraphicsGetCurrentContext();
    
    //利用path进行绘制三角形
    
    CGContextBeginPath(context);//标记
//    CGFloat location = [UIScreen mainScreen].bounds.size.width-55;
    CGContextMoveToPoint(context,
                         0, self.frame.size.height/10*9);//设置起点
    
    CGContextAddLineToPoint(context,
                            self.frame.size.width/2-5, self.frame.size.height/10*9);
    
    CGContextAddLineToPoint(context,
                            self.frame.size.width/2, 0);
    CGContextAddLineToPoint(context,
                            self.frame.size.width/2+5, self.frame.size.height/10*9);

    CGContextAddLineToPoint(context,
                            self.frame.size.width, self.frame.size.height/10*9);
    CGContextAddLineToPoint(context,
                            self.frame.size.width, self.frame.size.height);
    CGContextAddLineToPoint(context,
                            0, self.frame.size.height);

    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    [[UIColor redColor] setFill];  //设置填充色
    
    [[UIColor redColor] setStroke]; //设置边框颜色
    
    CGContextDrawPath(context,
                      kCGPathFillStroke);//绘制路径path
    
}

@end
