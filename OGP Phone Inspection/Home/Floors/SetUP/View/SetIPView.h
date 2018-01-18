//
//  SetIPView.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/10.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetIPView : UIView

@property(nonatomic,strong) UILabel * IPLa;
@property(nonatomic,strong) UILabel * IPcontentLa;
@property(nonatomic,strong) UILabel * nameLa;
@property(nonatomic,strong) UILabel * namecontentLa;
@property(nonatomic,strong) UIView * lineview;
-(instancetype)initWithFrame:(CGRect)frame dict:(NSDictionary *)dict;
@end
