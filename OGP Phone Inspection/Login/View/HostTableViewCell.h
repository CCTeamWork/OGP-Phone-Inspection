//
//  HostTableViewCell.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/14.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HostTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel * ipnameLa;
@property(nonatomic,strong) UILabel * ipcontentLa;
@property(nonatomic,strong) UILabel * hostnameLa;
@property(nonatomic,strong) UILabel * hostcontentLa;
@property(nonatomic,strong) UIView * lineview;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dictionary:(NSDictionary *)dictionary;
@end
