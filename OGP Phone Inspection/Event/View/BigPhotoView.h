//
//  BigPhotoView.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/31.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigPhotoView : UIView
@property(nonatomic,strong) UIButton * closeBtn;

-(instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;
@end
