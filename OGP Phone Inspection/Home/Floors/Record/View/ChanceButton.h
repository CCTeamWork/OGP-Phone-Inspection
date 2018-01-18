//
//  ChanceButton.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/20.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChanceButton : UIButton
@property(nonatomic,strong) UIImageView * image;
@property(nonatomic,strong) UILabel * la;
@property(nonatomic,strong) NSDictionary * dic;

-(instancetype)initWithFrame:(CGRect)frame text:(NSString *)text textFrame:(CGRect)textFrame image:(NSString *)image imageFrame:(CGRect)imageFrame font:(int)font;
-(instancetype)initWithFrame:(CGRect)frame imageSound:(NSString *)image text:(NSString *)text;
@end
