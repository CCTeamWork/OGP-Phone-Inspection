//
//  ChooseSchWithDevice.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/19.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseTableCellTableViewCell.h"
@interface ChooseSchWithDevice : UIView <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIButton * closeBtn;
@property(nonatomic,strong) UILabel * titleLa;
@property(nonatomic,strong) UITableView * table;
@property(nonatomic,strong) UIView * lineView;
@property(nonatomic,strong) NSArray * tabArray;
@property(nonatomic,strong) UIView * bgview;
@property(nonatomic,strong) ChooseTableCellTableViewCell * cell;
//   是定位匹配的还是扫码匹配的   （0:扫码  1:定位）
@property(nonatomic,assign) int where;

-(instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array where:(int)where;
@end
