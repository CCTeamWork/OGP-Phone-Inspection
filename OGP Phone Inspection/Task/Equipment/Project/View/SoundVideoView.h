//
//  SoundVideoView.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/8.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoView.h"
#import "VideoRecordModel.h"
@interface SoundVideoView : UIView
@property(nonatomic,copy) void(^videoBlock)(NSDictionary * dict);
@property(nonatomic,strong) VideoView * showview;
@property(nonatomic,strong) UIView * videoview;
@property(nonatomic,strong) UIButton * videoBtn;
@property(nonatomic,strong) UILabel * videoLa;
@property(nonatomic,strong) VideoRecordModel * videoModel;
@end
