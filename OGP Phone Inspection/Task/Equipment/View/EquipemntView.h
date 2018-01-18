//
//  EquipemntView.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/31.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanceButton.h"
#import "SiteModel.h"
#import "TaskFromChooseTableViewCell.h"
@interface EquipemntView : UIView


@property(nonatomic,strong) UILabel * nameLa;
@property(nonatomic,strong) ChanceButton * timeBtn;
@property(nonatomic,strong) ChanceButton * stateBtn;
@property(nonatomic,strong) UIView * promptView;
@property(nonatomic,strong) ChanceButton * promptBtn;
@property(nonatomic,strong) SiteModel * site;
@property(nonatomic,strong) TaskFromChooseTableViewCell * taskChooseCell;

-(instancetype)initWithFrame:(CGRect)frame sitedic:(NSDictionary *)sitedic;
@end
