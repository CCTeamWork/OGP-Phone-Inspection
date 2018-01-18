//
//  TaskChanceTableViewCell.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/31.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "TaskChanceTableViewCell.h"
#import "ToolControl.h"
#import "DataBaseManager.h"
#import "YYModel.h"

@implementation TaskChanceTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dictionary:(NSDictionary *)dictionary
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.schDict = dictionary;
        DataBaseManager * db = [DataBaseManager shareInstance];
        NSArray * array = [db selectSomething:@"site_record" value:[NSString stringWithFormat:@"site_id = %d",[dictionary[@"site_id"] intValue]] keys:[ToolModel allPropertyNames:[SiteModel class]] keysKinds:[ToolModel allPropertyAttributes:[SiteModel class]]];
        [db dbclose];
        self.nameLa = [[UILabel alloc]init];
        NSString * str;
        if (array.count == 0) {
            str = dictionary[@"site_id"];
        }else{
            str = array[0][@"site_name"];
        }

        self.nameLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.nameLa text:str font:16];
        [self.contentView addSubview:self.nameLa];
        [self.nameLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
            make.top.equalTo(self.top).offset(10);
        }];
        
        if ([dictionary[@"sch_type"] intValue] == 1) {
            self.timeBtn = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:[NSString stringWithFormat:@"%@ - %@",[self.chooseCell changeIntToString:[dictionary[@"other_start_date"] intValue]],[self.chooseCell changeIntToString:[dictionary[@"other_end_date"] intValue]]] textFrame:CGRectMake(5, 0, 0, 0) image:@"time" imageFrame:CGRectMake(0, 0, 20, 20) font:12];
        }else{
            NSString * startStr =  [NSString stringWithFormat:@"%@月%@日",[self.chooseCell timeFromMonth],dictionary[@"other_start_date"]];
            NSString * endStr = [NSString stringWithFormat:@"%@月%@日",[self.chooseCell timeFromMonth],dictionary[@"other_end_date"]];
             self.timeBtn = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:[NSString stringWithFormat:@"%@ - %@",startStr,endStr] textFrame:CGRectMake(5, 0, 0, 0) image:@"time" imageFrame:CGRectMake(0, 0, 20, 20) font:12];
        }
        self.timeBtn.la.textColor = [UIColor grayColor];
        CGSize timeSize = [ToolControl makeText:self.timeBtn.la.text font:12];
        [self.contentView addSubview:self.timeBtn];
        [self.timeBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
            make.top.equalTo(self.nameLa.bottom).offset(15);
            make.width.equalTo(timeSize.width+30);
            make.height.equalTo(20);
        }];
        
        self.stateLa = [[UILabel alloc]init];
        if ([self dateState:dictionary]) {
            [ToolControl makeLabel:self.stateLa text:NSLocalizedString(@"Task_othertask_istime",@"") font:12];
        }else{
            [ToolControl makeLabel:self.stateLa text:NSLocalizedString(@"Task_othertask_notime",@"") font:12];
        }
        self.stateLa.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.stateLa];
        [self.stateLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeBtn.right).offset(5);
            make.centerY.equalTo(self.timeBtn);
        }];
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.88, 0.09, 0.15, 1.00 });
        self.stateBtn = [[PhotoButton alloc]init];
        [ToolControl makeButton:self.stateBtn titleColor:[UIColor colorWithRed:0.90 green:0.09 blue:0.15 alpha:1.00] title:NSLocalizedString(@"Task_other_btn_on",@"") btnImage:nil cornerRadius:0 font:14];
        [self.stateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        [self.stateBtn setTitle:NSLocalizedString(@"Task_other_btn_hason",@"") forState:UIControlStateSelected];
        self.stateBtn.layer.borderWidth = 1.0;
        self.stateBtn.dic = dictionary;
         self.stateBtn.layer.borderColor = colorref;
        if ([dictionary[@"other_has_start"] intValue] == 1) {
            self.stateBtn.selected = YES;
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.65, 0.65, 0.65, 1.00 });
            self.stateBtn.layer.borderColor = colorref;
            self.stateBtn.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1.00];
        }
        [self.contentView addSubview:self.stateBtn];
        [self.stateBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.right).offset(-10);
            make.width.equalTo(100);
            make.height.equalTo(30);
        }];
        [self.stateBtn addTarget:self action:@selector(stateBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

/**
 点击开启按钮的判断   开启之后更新数据库数据

 @param sender 通过按钮的tag传递计划id
 */
-(void)stateBtnTouch:(PhotoButton *)sender
{
    if (sender.selected == NO) {
        if ([self dateState:sender.dic]) {
            sender.selected = YES;
            DataBaseManager * db = [DataBaseManager shareInstance];
            [db updateSomething:@"schedule_record" key:@"other_has_start" value:@"1" sql:[NSString stringWithFormat:@"sch_id = %d and same_sch_seq = %d",[sender.dic[@"sch_id"] intValue],[sender.dic[@"same_sch_seq"] intValue]]];
            [db dbclose];
        }else{
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"不在任务时间内，无法开启！" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"All_sure",@"") otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Task_alert_other_hason",@"") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"All_sure",@"") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(AddOtherTask:)]) {
        sender.tag = sender.tag;
        [_delegate AddOtherTask:sender];
    }
}

/**
 对比时间   判断状态

 @param dict 计划字典
 */
-(BOOL)dateState:(NSDictionary *)dict
{
    //   周计划
    if ([dict[@"sch_type"] intValue] == 1) {
        int i = [self changeStringToInt]-1;
        if (i<0) {
            i=6;
        }
        int j = [dict[@"other_start_date"] intValue];
        int k = [dict[@"other_end_date"] intValue];
        if ((i>j || i==j) && (i<k || i==k)) {
            return [self isInTime:dict];
        }else{
            return NO;
        }
    }else{
        NSDate * senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"dd"];
        NSString *  locationString=[dateformatter stringFromDate:senddate];
        int i = [locationString intValue];
        int j = [dict[@"other_start_date"] intValue];
        int k = [dict[@"other_end_date"] intValue];
        if (i >= j || i <= k) {
            return [self isInTime:dict];
        }else{
            return NO;
        }
    }
}
-(BOOL)isInTime:(NSDictionary *)dict
{
    NSDate * senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSDate * nowtime = [ToolModel timeFromZone:[dateformatter dateFromString:locationString]];
    NSDate * starttime = [ToolModel timeFromZone:[dateformatter dateFromString:dict[@"start_time"]]];
    NSDate * endtime = [ToolModel timeFromZone:[dateformatter dateFromString:dict[@"end_time"]]];
    
    NSComparisonResult result = [starttime compare:nowtime];
    NSComparisonResult result1 = [endtime compare:nowtime];
    if ((result1 == NSOrderedDescending && result == NSOrderedAscending) || result == NSOrderedSame || result1 == NSOrderedSame) {
        //   时间内
        return YES;
    }else{
        //   时间外
        return NO;
    }
}
//   将获取的兴起转换为int
-(int)changeStringToInt
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate *now = [NSDate date];
    NSDateComponents *comps;
    comps = [calendar components:unitFlags fromDate:now];
    //NSInteger week = [comps week]; // 今年的第几周
    NSInteger weekday = [comps weekday];
    return (int)weekday;
}
- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 10;
    frame.size.height -= 10;
    
    [super setFrame:frame];
}
-(TaskFromChooseTableViewCell *)chooseCell
{
    if (_chooseCell == nil) {
        _chooseCell = [[TaskFromChooseTableViewCell alloc]init];
    }
    return _chooseCell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
