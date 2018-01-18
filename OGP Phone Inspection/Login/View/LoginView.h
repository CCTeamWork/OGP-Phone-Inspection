//
//  LoginView.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/6/29.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftAndRightTextField.h"
#import "ToolControl.h"
#import "IPButtn.h"
@interface LoginView : UIView

@property(nonatomic,strong) LeftAndRightTextField * companyTextField;
@property(nonatomic,strong) LeftAndRightTextField * nameTextField;
@property(nonatomic,strong) LeftAndRightTextField * passTextField;
@property(nonatomic,strong) UIButton * changeBtn;
@property(nonatomic,strong) LeftAndRightTextField * changeTextField;
@property(nonatomic,strong) UIButton * remeberBtn;
@property(nonatomic,strong) UIButton * accordBtn;
@property(nonatomic,strong) UIButton * loginBtn;
@property(nonatomic,strong) IPButtn * ipBtn;
@property(nonatomic,strong) UILabel * remeberLa;
@property(nonatomic,strong) UILabel * accordLa;

-(instancetype)initWithFrame:(CGRect)frame dictionary:(NSDictionary *)dict;

@end
