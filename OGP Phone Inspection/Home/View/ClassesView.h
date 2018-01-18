//
//  ClassesView.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/15.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassesTableViewCell.h"
@interface ClassesView : UIView <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView * table;
@property(nonatomic,strong) UILabel * titleLa;
@property(nonatomic,strong) UIView * lineview;
@property(nonatomic,strong) NSArray * array;
@property(nonatomic,strong) ClassesTableViewCell * cell;
@property(nonatomic,strong) UIView * bgview;
@property(nonatomic,strong) UIButton * closeBtn;

-(instancetype)initWithFrame:(CGRect)frame array:(NSArray *)arr;
@end
