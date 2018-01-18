//
//  SearchView.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/20.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChanceButton;
@interface SearchView : UIView <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITextField * textField;
@property(nonatomic,strong) ChanceButton * searchBtn;
@property(nonatomic,strong) UITableView * table;
@property(nonatomic,strong) UIButton * closeBtn;
@property(nonatomic,strong) UITableViewCell * cell;
@end
