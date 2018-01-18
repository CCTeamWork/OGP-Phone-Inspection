//
//  EventBateView.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/25.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventBateView : UIView
@property(nonatomic,strong) UILabel * titleLa;
@property(nonatomic,strong) UILabel * timeLa;
@property(nonatomic,strong) UIImageView * contentImage;

-(instancetype)initWithFrame:(CGRect)frame dictionary:(NSDictionary *)dictionary;
@end
