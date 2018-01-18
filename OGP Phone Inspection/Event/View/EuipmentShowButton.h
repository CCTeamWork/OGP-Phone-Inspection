//
//  EuipmentShowButton.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/31.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EuipmentShowButton : UIButton
@property(nonatomic,strong) UIImageView * image;
@property(nonatomic,strong) UILabel * la;
@property(nonatomic,strong) NSDictionary * dic;

-(instancetype)initWithFrame:(CGRect)frame text:(NSString *)text textFrame:(CGRect)textFrame image:(NSString *)image imageFrame:(CGRect)imageFrame font:(int)font;
@end
