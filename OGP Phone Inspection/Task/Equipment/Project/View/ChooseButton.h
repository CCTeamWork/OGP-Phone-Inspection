//
//  ChooseButton.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/8.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanceButton.h"
@interface ChooseButton : UIButton

@property(nonatomic,strong) UILabel * numberLa;
@property(nonatomic,strong) UILabel * la;
@property(nonatomic,strong) ChanceButton * errorBtn;
@property(nonatomic,strong) UIImageView * image;
@property(nonatomic,strong) UIView * lineView;
@property(nonatomic,strong) NSString * optionid;

-(instancetype)initWithFrame:(CGRect)frame dictionary:(NSDictionary *)dict isend:(BOOL)isend number:(int)number;
@end
