//
//  EventBateContentView.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/27.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SoundShowView.h"
@class ChanceButton;
@class PhotoButton;
@interface EventBateContentView : UIView <AVAudioPlayerDelegate>

@property(nonatomic,strong) UILabel * textLa;
@property(nonatomic,strong) ChanceButton * equipmentBtn;
@property(nonatomic,strong) PhotoButton * photoImage;
@property(nonatomic,strong) PhotoButton * soundImage;
@property(nonatomic,strong) UILabel * soundTimeLa;
@property(nonatomic,strong) UISlider * progress;
@property(nonatomic,strong) AVAudioPlayer * player;
@property(nonatomic,strong) SoundShowView * soundshow;

-(instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array eventdict:(NSDictionary *)eventdict;
@end
