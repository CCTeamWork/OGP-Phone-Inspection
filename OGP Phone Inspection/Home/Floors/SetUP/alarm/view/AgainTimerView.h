//
//  AgainTimerView.h
//  OGP phone patrol
//
//  Created by 张建伟 on 17/5/9.
//  Copyright © 2017年 张建伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgainTimerView : UIView <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView * talView;
@property(nonatomic,strong) UITableViewCell * cell1;
@property(nonatomic,strong) NSArray * array;
@property(nonatomic,strong) NSMutableArray * mutArray;
@property(nonatomic,strong) NSMutableArray * dayArr;
@end
