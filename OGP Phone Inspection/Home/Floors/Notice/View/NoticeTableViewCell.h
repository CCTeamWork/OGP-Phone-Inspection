//
//  NoticeTableViewCell.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/21.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeTableViewCell : UITableViewCell
@property(nonatomic,strong) UIImageView * imageview;
@property(nonatomic,strong) UILabel * titleLa;
@property(nonatomic,strong) UILabel * whoLa;
@property(nonatomic,strong) UILabel * timeLa;
@property(nonatomic,strong) UILabel * contentLa;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dictionary:(NSDictionary *)dictionary;
@end
