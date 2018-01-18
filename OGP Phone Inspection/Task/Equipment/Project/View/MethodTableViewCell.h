//
//  MethodTableViewCell.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/7.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanceButton.h"
@interface MethodTableViewCell : UITableViewCell
@property(nonatomic,strong) UILabel * nameLa;
@property(nonatomic,strong) UILabel * contentLa;
@property(nonatomic,strong) ChanceButton * showBtn;
@property(nonatomic,strong) UIView * lineView;
@property(nonatomic,copy) void(^showAllTextBlock)(float height);

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dictionary:(NSDictionary *)dictionary;
@end
