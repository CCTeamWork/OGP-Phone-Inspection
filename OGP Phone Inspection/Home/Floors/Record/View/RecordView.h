//
//  RecordView.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/19.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawRectRedView.h"
@interface RecordView : UIView

@property(nonatomic,strong) UIButton * allBtn;
@property(nonatomic,strong) UIButton * noSendBtn;
@property(nonatomic,strong) UIButton * chanceBtn;
@property(nonatomic,strong) DrawRectRedView * redView;
@end
