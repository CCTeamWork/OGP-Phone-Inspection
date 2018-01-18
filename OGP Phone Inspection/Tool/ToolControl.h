//
//  ToolControl.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/3.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToolControl : UIView




/**
 制作button
 
 @param button 需要被制作的按钮
 @param title 按钮上的文字
 @param image 按钮上的图片
 @param Radius 按钮的圆角
 @param font 按钮的文字大小
 @return <#return value description#>
 */
+(UIButton *)makeButton:(UIButton *)button
             titleColor:(UIColor *)titleColor
                  title:(NSString *)title
               btnImage:(NSString *)image
           cornerRadius:(float)Radius
                   font:(int)font;


/**
 制作label
 
 @param label 需要被制作的文字
 @param text 文字内容
 @param font 文字大小
 @return <#return value description#>
 */
+(UILabel *)makeLabel:(UILabel *)label
                 text:(NSString *)text
                 font:(int)font;


/**
 制作输入框

 @param textField 需要被制作的输入框
 @param text 提示文字
 @param Radius 圆角半径
 @return <#return value description#>
 */
+(UITextField *)maketextField:(UITextField *)textField
                         text:(NSString *)text
                 cornerRadius:(float)Radius;

/**
 计算文字的高度和宽度
 
 @param text 文字
 @param font 字体大小
 @return 数值
 */
+(CGSize)makeText:(NSString *)text font:(int)font;

/**
 设置文本缩进和行间距
 
 @param text 文本
 @param fistLine 首行
 @param head 每行首
 @param tail 每行尾
 @param lineSpacing 行间距
 */
+(NSAttributedString *)makeAttribute:(NSString *)text
                       firstLine:(float)fistLine
                            head:(float)head
                            tail:(float)tail
                         lineSpacing:(float)lineSpacing;
@end
