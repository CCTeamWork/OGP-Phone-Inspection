//
//  ProjectView.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/7.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectView : UIView

@property(nonatomic,strong) UIImageView * image;
@property(nonatomic,strong) UILabel * nameLa;
@property(nonatomic,strong) UILabel * stateLa;
@property(nonatomic,strong) UILabel * titleLa;
@property(nonatomic,strong) UIView * lineView;

-(instancetype)initWithFrame:(CGRect)frame devicedic:(NSDictionary *)devicedict itemsdict:(NSDictionary *)itemdict;
@end
