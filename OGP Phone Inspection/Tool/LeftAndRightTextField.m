
//
//  LeftAndRightTextField.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/3.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "LeftAndRightTextField.h"

@implementation LeftAndRightTextField

/**
 <#Description#>

 @param frame <#frame description#>
 @param icon 左侧的图片
 @param btn 右侧的按钮
 @return <#return value description#>
 */
-(id)initWithFrame:(CGRect)frame drawingLeft:(UIImageView *)icon drawingRight:(UIButton *)btn{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftView = icon;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.rightView= btn;
        self.rightViewMode=UITextFieldViewModeAlways;
    }
    return self;
}

/**
 左侧

 @param bounds 左偏距离
 @return <#return value description#>
 */
-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 10;// 右偏10
    return iconRect;
}

/**
 右侧

 @param bounds 右偏距离
 @return <#return value description#>
 */
-(CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGRect burect=[super rightViewRectForBounds:bounds];
    burect.origin.x += -10;
    return burect;
}

@end
