//
//  TimerTableViewCell.h
//  OGP phone patrol
//
//  Created by 张建伟 on 17/5/6.
//  Copyright © 2017年 张建伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CellSwichDelegate
-(void)delegateTimer:(UITableViewCell *)cell;
@end
@interface TimerTableViewCell : UITableViewCell
@property(nonatomic,strong) UILabel * la1;
@property(nonatomic,strong) UILabel * la2;
@property(nonatomic,strong) UISwitch * swich;
@property(nonatomic,assign) id delegate;
@end
