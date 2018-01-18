//
//  DetailTableViewCell.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/21.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemsModel.h"
#import "DataModel.h"
#import "SoundShowView.h"
#import "PhotoButton.h"


@protocol CellChangeRecord
-(void)changeCellRecord:(UITableViewCell *)cell;
@end
@interface DetailTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel * titleLa;
@property(nonatomic,strong) UILabel * contentLa;
@property(nonatomic,strong) UIView * lineView;
@property(nonatomic,strong) ItemsModel * items;
@property(nonatomic,strong) DataModel * data;
//   图片
@property(nonatomic,strong) PhotoButton * photoBtn;
//   录音
@property(nonatomic,strong) SoundShowView * soundview;
//   签名
@property(nonatomic,strong) PhotoButton * signBtn;
//   预览修改按钮
@property(nonatomic,strong) PhotoButton * changeBtn;

@property(nonatomic,assign) id delegate;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dictionary:(NSDictionary *)dictionary record:(int)record;
@end
