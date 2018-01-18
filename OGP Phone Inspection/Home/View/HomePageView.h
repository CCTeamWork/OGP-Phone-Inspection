//
//  HomePageView.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/4.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageButton.h"
@interface HomePageView : UIView

@property(nonatomic,strong) UILabel * checkLa;
@property(nonatomic,strong) UILabel * dataLa;
@property(nonatomic,strong) UIButton * checkBtn;
@property(nonatomic,strong) HomePageButton * downBtn;
@property(nonatomic,strong) HomePageButton * recordBtn;
@property(nonatomic,strong) HomePageButton * navitationBtn;
@property(nonatomic,strong) HomePageButton * helpBtn;
@property(nonatomic,strong) UIButton * logoutBtn;

@property(nonatomic,strong) UILabel * messageNumber;
@end
