//
//  DetailView.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/21.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailView : UIView

@property(nonatomic,strong) UIView * headerView;
@property(nonatomic,strong) UILabel * nameLa;
@property(nonatomic,strong) UILabel * keepTimeLa;
@property(nonatomic,strong) UILabel * sendTimeLa;
//@property(nonatomic,strong) UILabel * titleLa;
//@property(nonatomic,strong) UILabel * contentLa;
//@property(nonatomic,strong) UIView * contentView;
//@property(nonatomic,strong) UIView * lineView;
-(instancetype)initWithFrame:(CGRect)frame dictionary:(NSDictionary *)dictionary;
@end
