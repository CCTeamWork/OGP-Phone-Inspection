//
//  TabBarView.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/7.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarView : UIView

@property(nonatomic,strong) UIButton * lastBtn;
@property(nonatomic,strong) UIButton * nextBtn;
@property(nonatomic,strong) UILabel * numberLa;
@property(nonatomic,assign) int maxs;
@property(nonatomic,assign) int values;

-(instancetype)initWithFrame:(CGRect)frame max:(int)max value:(int)value;

/**
 翻页变换页书
 
 @param count <#count description#>
 */
-(void)itemNumberChange:(int)count;
@end
