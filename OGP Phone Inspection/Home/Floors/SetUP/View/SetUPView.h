//
//  SetUPView.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/10.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetUPView : UIView <UITextFieldDelegate,UIAlertViewDelegate>

@property(nonatomic,strong) UIView * lineview;
@property(nonatomic,strong) UILabel * wifiLa;
@property(nonatomic,strong) UIButton * wifiBtn;
@property(nonatomic,strong) UILabel * previewLa;
@property(nonatomic,strong) UIButton * previewBtn;
@property(nonatomic,strong) UILabel * recordLa;
@property(nonatomic,strong) UITextField * recordField;
@property(nonatomic,strong) UIButton * offlineMapBtn;
@property(nonatomic,strong) UIButton * timeBtn;
@end
