//
//  ChanceButton.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/20.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "ChanceButton.h"
#import "ToolControl.h"
@implementation ChanceButton


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
        if (image != nil && image.length != 0) {
            self.image.image = [UIImage imageNamed:image];
        }
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

/**
 自定义   搜索按钮

 @param frame <#frame description#>
 @param image 图片
 @param text 文字
 @return <#return value description#>
 */
-(instancetype)initWithFrame:(CGRect)frame image:(NSString *)image text:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [[UIImageView alloc]init];
        if (image != nil && image.length != 0) {
            self.image.image = [UIImage imageNamed:image];
        }
        [self addSubview:self.image];
        [self.image makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
            make.top.equalTo(self.top).offset(15);
            make.width.equalTo(20);
            make.height.equalTo(20);
        }];
        
        self.la = [[UILabel alloc]init];
        [ToolControl makeLabel:self.la text:text font:16];
        self.la.textColor = [UIColor whiteColor];
        [self addSubview:self.la];
        [self.la makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.image.right).offset(10);
            make.centerY.equalTo(self.image);
        }];
    }
    return self;
}
/**
 自定义   未发送按钮
 
 @param frame <#frame description#>
 @param image 图片
 @param text 文字
 @return <#return value description#>
 */
-(instancetype)initWithFrame:(CGRect)frame image1:(NSString *)image text1:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [[UIImageView alloc]init];
        if (image != nil && image.length != 0) {
            self.image.image = [UIImage imageNamed:image];
        }
        [self addSubview:self.image];
        [self.image makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(0);
            make.top.equalTo(self.top).offset(0);
            make.width.equalTo(20);
            make.height.equalTo(20);
        }];
        
        self.la = [[UILabel alloc]init];
        [ToolControl makeLabel:self.la text:text font:14];
        self.la.textColor = [UIColor redColor];
        [self addSubview:self.la];
        [self.la makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.image.right).offset(5);
            make.centerY.equalTo(self.image);
        }];
    }
    return self;

}

/**
 自定义   录音按钮
 
 @param frame <#frame description#>
 @param image 图片
 @param text 文字
 @return <#return value description#>
 */
-(instancetype)initWithFrame:(CGRect)frame imageSound:(NSString *)image text:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (self) {
        self.la = [[UILabel alloc]init];
        [ToolControl makeLabel:self.la text:text font:14];
        self.la.textColor = [UIColor grayColor];
        [self addSubview:self.la];
        [self.la makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.left).offset((WIDTH-80)/2+15);
            make.centerY.equalTo(self);
        }];
        
        self.image = [[UIImageView alloc]init];
        if (image != nil && image.length != 0) {
            self.image.image = [UIImage imageNamed:image];
        }
        [self addSubview:self.image];
        [self.image makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.la.left).offset(-10);
            make.top.equalTo(self.top).offset(5);
            make.width.equalTo(30);
            make.height.equalTo(30);
        }];
    }
    return self;
}
@end
