//
//  EventRecordTableViewCell.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/24.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChanceButton;
@interface EventRecordTableViewCell : UITableViewCell
@property(nonatomic,strong) UILabel * titleLa;
@property(nonatomic,strong) UILabel * timeLa;
@property(nonatomic,strong) ChanceButton * kindBtn;
@property(nonatomic,strong) UIImageView * contentImage;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dictionary:(NSDictionary *)dictionary;
@end
