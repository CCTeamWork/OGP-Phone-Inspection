//
//  TaskFromChooseTableViewCell.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/12.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanceButton.h"
#import "TaskPost.h"
@protocol CellButtonFinish
-(void)FinishOtherTask:(UITableViewCell *)cell;
-(void)GetOtherTask:(UITableViewCell *)cell;
@end
@interface TaskFromChooseTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel * startTime;
@property(nonatomic,strong) UILabel * endTime;
@property(nonatomic,strong) UIImageView * timeImage;
@property(nonatomic,strong) UILabel * nameLa;
@property(nonatomic,strong) ChanceButton * stateBtn;
@property(nonatomic,strong) UISlider * slider;
@property(nonatomic,strong) UILabel * thumbLa;
@property(nonatomic,strong) UILabel * endLa;
@property(nonatomic,strong) UIButton * postBtn;
@property(nonatomic,strong) UIButton * endBtn;
@property(nonatomic,assign) id delegate;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier contentDic:(NSDictionary *)dict;


/**
 将获取的整形转换为星期
 
 @param i <#i description#>
 */
-(NSString *)changeIntToString:(int)i;

/**
 获取当前月

 @return <#return value description#>
 */
-(NSString *)timeFromMonth;
@end
