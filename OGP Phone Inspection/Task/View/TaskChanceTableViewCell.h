//
//  TaskChanceTableViewCell.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/31.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanceButton.h"
#import "SiteModel.h"
#import "PhotoButton.h"
#import "TaskFromChooseTableViewCell.h"
@protocol CellButtonAdd
-(void)AddOtherTask:(UIButton *)sender;
@end

@interface TaskChanceTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel * nameLa;
@property(nonatomic,strong) ChanceButton * timeBtn;
@property(nonatomic,strong) UILabel * stateLa;
@property(nonatomic,strong) PhotoButton * stateBtn;
@property(nonatomic,strong) NSDictionary * schDict;
@property(nonatomic,strong) SiteModel * site;
@property(assign,nonatomic)id delegate;
@property(nonatomic,strong) TaskFromChooseTableViewCell * chooseCell;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dictionary:(NSDictionary *)dictionary;
@end
