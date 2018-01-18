//
//  EuipmentShowButton.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/31.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "EuipmentShowButton.h"
#import "ToolControl.h"
@implementation EuipmentShowButton

/**
 自定义   筛选按钮
 
 @param frame <#frame description#>
 @param text 文字
 @param image 图片
 @return <#return value description#>
 */
-(instancetype)initWithFrame:(CGRect)frame text:(NSString *)text textFrame:(CGRect)textFrame image:(NSString *)image imageFrame:(CGRect)imageFrame font:(int)font
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [[UIImageView alloc]init];
        self.image.image = [UIImage imageNamed:image];
        [self addSubview:self.image];
        [self.image makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(imageFrame.origin.x);
            make.top.equalTo(self.top).offset(imageFrame.origin.y);
            make.width.equalTo(imageFrame.size.width);
            make.height.equalTo(imageFrame.size.width);
        }];
        
        self.la = [[UILabel alloc]init];
        [ToolControl makeLabel:self.la text:text font:font];
        [self addSubview:self.la];
        [self.la makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.image.right).offset(textFrame.origin.x);
            make.centerY.equalTo(self.image);
        }];
    }
    return self;
}

@end
