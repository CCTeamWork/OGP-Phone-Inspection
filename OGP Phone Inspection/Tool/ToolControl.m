//
//  ToolControl.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/3.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "ToolControl.h"

@implementation ToolControl

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
                   font:(int)font
{
    [button setTitle:title forState:UIControlStateNormal];
    if (image != nil && image.length != 0) {
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.layer.masksToBounds=YES;
    button.layer.cornerRadius=Radius;
    button.titleLabel.font=[UIFont systemFontOfSize:font];
    return button;
}

/**
 制作label
 
 @param label 需要被制作的文字
 @param text 文字内容
 @param font 文字大小
 @return <#return value description#>
 */
+(UILabel *)makeLabel:(UILabel *)label
                 text:(NSString *)text
                 font:(int)font
{
    label.text=text;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    label.frame.size = CGSizeMake(textSize.width, textSize.height);
    label.font = [UIFont systemFontOfSize:font];
    return label;
}

/**
 制作输入框
 
 @param textField 需要被制作的输入框
 @param text 提示文字
 @param Radius 圆角半径
 @return <#return value description#>
 */
+(UITextField *)maketextField:(UITextField *)textField
                         text:(NSString *)text
                 cornerRadius:(float)Radius
{
    textField.placeholder=text;
    textField.borderStyle=UITextBorderStyleRoundedRect;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.layer.masksToBounds=YES;
    textField.layer.cornerRadius=Radius;
    return textField;
}

/**
 计算文字的高度和宽度

 @param text 文字
 @param font 字体大小
 @return 数值
 */
+(CGSize)makeText:(NSString *)text font:(int)font
{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    return textSize;
}

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
                         lineSpacing:(float)lineSpacing
{
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.alignment = NSTextAlignmentLeft;  //对齐
    paraStyle01.headIndent = head;//行首缩进
    paraStyle01.firstLineHeadIndent = fistLine;//首行缩进
    paraStyle01.tailIndent = tail;//行尾缩进
    paraStyle01.lineSpacing = lineSpacing;//行间距
    
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
    return attrText;
}
@end
