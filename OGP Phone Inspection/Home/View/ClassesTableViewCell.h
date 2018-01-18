//
//  ClassesTableViewCell.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/15.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassesTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel * nameLa;
@property(nonatomic,strong) UILabel * timeLa;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dict:(NSDictionary *)dict;
@end
