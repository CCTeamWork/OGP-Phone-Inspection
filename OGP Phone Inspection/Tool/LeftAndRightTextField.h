//
//  LeftAndRightTextField.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/3.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftAndRightTextField : UITextField

/**
 设置textfield

 @param frame 位置
 @param icon 左侧图片
 @param btn 右侧按钮
 @return <#return value description#>
 */
-(id)initWithFrame:(CGRect)frame
       drawingLeft:(UIImageView *)icon
      drawingRight:(UIButton *)btn;
@end
