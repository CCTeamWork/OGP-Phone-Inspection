//
//  SoundShowView.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/28.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PhotoButton.h"
@interface SoundShowView : UIView <AVAudioPlayerDelegate>
@property(nonatomic,strong) PhotoButton * soundBtn;;
@property(nonatomic,strong) UILabel * soundTimeLa;
@property(nonatomic,strong) UISlider * progress;
@property(nonatomic,strong) NSDictionary * dict;
@property(nonatomic,strong) AVAudioPlayer * player;

-(instancetype)initWithFrame:(CGRect)frame time:(int)time;
@end
