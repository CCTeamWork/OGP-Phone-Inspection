//
//  TaskNowTableViewCell.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/10.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanceButton.h"
#import "SiteModel.h"
@interface TaskNowTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel * startTime;
@property(nonatomic,strong) UILabel * endTime;
@property(nonatomic,strong) UIImageView * timeImage;
@property(nonatomic,strong) UILabel * nameLa;
@property(nonatomic,strong) ChanceButton * stateBtn;
@property(nonatomic,strong) UISlider * slider;
@property(nonatomic,strong) UILabel * thumbLa;
@property(nonatomic,strong) UILabel * endLa;
@property(nonatomic,strong) SiteModel * site;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier contentDic:(NSDictionary *)dict;
/**
 查询当前计划下已完成的设备书
 
 @param schdict 当前计划
 @return <#return value description#>
 */
-(int)selectDeviceFinishBumber:(NSDictionary *)schdict;


@end
