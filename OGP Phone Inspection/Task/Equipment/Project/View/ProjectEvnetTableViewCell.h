//
//  ProjectEvnetTableViewCell.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/7.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoButton.h"
#import "SoundShowView.h"
@interface ProjectEvnetTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel * titleLa;
@property(nonatomic,strong) UILabel * textLa;
@property(nonatomic,strong) PhotoButton * imgaeBtn;
@property(nonatomic,strong) SoundShowView * soundView;
@property(nonatomic,strong) UIView * lineView;
@property(nonatomic,copy) void(^eventHeightBlock)(float evnetHeight);

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier itemsDict:(NSDictionary *)itemsDict;
/**
 事件添加完成
 
 @param dict 事件内容
 */
-(void)addEvent:(NSDictionary *)dict type:(int)type;
@end
