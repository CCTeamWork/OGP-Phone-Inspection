//
//  TaskHeadView.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/31.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawRectRedView.h"
@interface TaskHeadView : UIView

@property(nonatomic,strong) UIButton * nowTaskBtn;
@property(nonatomic,strong) UIButton * chanceTaskBtn;
@property(nonatomic,strong) DrawRectRedView * redView;
@end
