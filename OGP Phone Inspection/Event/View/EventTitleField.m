//
//  EventTitleField.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/16.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "EventTitleField.h"

@implementation EventTitleField

/**
 <#Description#>
 
 @param frame <#frame description#>
 @param btn 右侧的按钮
 @return <#return value description#>
 */
-(id)initWithFrame:(CGRect)frame drawingRight:(UIButton *)btn{
    self = [super initWithFrame:frame];
    if (self) {
        self.rightView= btn;
        self.rightViewMode=UITextFieldViewModeAlways;
    }
    return self;
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
