//
//  EquipmentTableViewCell.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/31.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanceButton.h"
@interface EquipmentTableViewCell : UITableViewCell


@property(nonatomic,strong) UIImageView * stateImage;
@property(nonatomic,strong) UILabel * nameLa;
@property(nonatomic,strong) UILabel * stateLa;
@property(nonatomic,strong) UILabel * numberLa;
@property(nonatomic,strong) ChanceButton * stateBtn;
@property(nonatomic,strong) UISlider * slider;
@property(nonatomic,strong) UILabel * thumbLa;
@property(nonatomic,strong) UILabel * maxLa;


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dictionary:(NSDictionary *)dictionary;
@end
