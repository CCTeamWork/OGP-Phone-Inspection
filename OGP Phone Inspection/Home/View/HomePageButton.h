//
//  HomePageButton.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/4.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageButton : UIButton

@property(nonatomic,strong) UIImageView * image;
@property(nonatomic,strong) UILabel * la;

-(instancetype)initWithFrame:(CGRect)frame image:(NSString *)imageName title:(NSString *)title;
@end
