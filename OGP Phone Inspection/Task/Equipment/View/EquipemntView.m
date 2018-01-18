//
//  EquipemntView.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/31.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "EquipemntView.h"
#import "ToolControl.h"
#import "DataBaseManager.h"
#import "YYModel.h"
#import "TaskFromChooseTableViewCell.h"
@implementation EquipemntView

-(instancetype)initWithFrame:(CGRect)frame sitedic:(NSDictionary *)sitedic
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        DataBaseManager * db = [DataBaseManager shareInstance];
        NSArray * array = [db selectSomething:@"site_record" value:[NSString stringWithFormat:@"site_id = %d",[sitedic[@"site_id"] intValue]] keys:[ToolModel allPropertyNames:[SiteModel class]] keysKinds:[ToolModel allPropertyAttributes:[SiteModel class]]];
        [db dbclose];
        self.nameLa = [[UILabel alloc]init];
        NSString * str;
        if (array.count == 0) {
            str = sitedic[@"site_id"];
        }else{
            str = array[0][@"site_name"];
        }
        self.nameLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.nameLa text:str font:16];
        [self addSubview:self.nameLa];
        [self.nameLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
            make.top.equalTo(self.top).offset(10);
        }];
        
        if ([sitedic[@"sch_type"] intValue] == 0) {
            self.timeBtn = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:[NSString stringWithFormat:@"%@ - %@",sitedic[@"start_time"],sitedic[@"end_time"]] textFrame:CGRectMake(10, 0, 0, 0) image:@"time" imageFrame:CGRectMake(0, 0, 20, 20) font:14];
        }else{
            if ([sitedic[@"sch_type"] intValue] == 1) {
                self.timeBtn = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:[NSString stringWithFormat:@"%@ - %@",[self.taskChooseCell changeIntToString:[sitedic[@"other_start_date"] intValue]],[self.taskChooseCell changeIntToString:[sitedic[@"other_end_date"] intValue]]] textFrame:CGRectMake(10, 0, 0, 0) image:@"time" imageFrame:CGRectMake(0, 0, 20, 20) font:14];
            }else{
                self.timeBtn = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:[NSString stringWithFormat:@"%@月%@日- %@月%@日",[self timeFromMonth],sitedic[@"other_start_date"],[self timeFromMonth],sitedic[@"other_end_date"]] textFrame:CGRectMake(10, 0, 0, 0) image:@"time" imageFrame:CGRectMake(0, 0, 20, 20) font:14];
            }
        }
        self.timeBtn.la.textColor = [UIColor grayColor];
        CGSize timeSize = [ToolControl makeText:self.timeBtn.la.text font:14];
        [self addSubview:self.timeBtn];
        [self.timeBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
            make.top.equalTo(self.nameLa.bottom).offset(10);
            make.height.equalTo(20);
            make.width.equalTo(35+timeSize.width);
        }];
        
        self.stateBtn = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:NSLocalizedString(@"Task_patrol_state_one",@"") textFrame:CGRectMake(5, 0, 0, 0) image:@"spot_blue" imageFrame:CGRectMake(0, 0, 5, 5) font:12];
        switch ([sitedic[@"sch_state"] intValue]) {
            case 0:
                self.stateBtn.la.text = NSLocalizedString(@"Task_patrol_state_two",@"");
                self.stateBtn.image.image = [UIImage imageNamed:@"spot_gary"];
                break;
            case 1:
                self.stateBtn.la.text = NSLocalizedString(@"Task_patrol_state_one",@"");
                self.stateBtn.image.image = [UIImage imageNamed:@"spot_blue"];
                break;
            case 2:
                self.stateBtn.la.text = NSLocalizedString(@"Task_patrol_state_three",@"");
                self.stateBtn.image.image = [UIImage imageNamed:@"spot_yellow"];
                break;
            case 3:
                self.stateBtn.la.text = NSLocalizedString(@"Task_patrol_state_four",@"");
                self.stateBtn.image.image = [UIImage imageNamed:@"spot_green"];
                break;
            default:
                break;
        }
        //   如果已经完成
        if ([self schIsHadFinish:sitedic]) {
            self.stateBtn.la.text = NSLocalizedString(@"Task_patrol_state_four",@"");
            self.stateBtn.image.image = [UIImage imageNamed:@"spot_green"];
        }
//        self.stateBtn.la.textColor = [UIColor grayColor];
        CGSize stateSize = [ToolControl makeText:self.stateBtn.la.text font:12];
        [self addSubview:self.stateBtn];
        [self.stateBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right).offset(-10);
            make.top.equalTo(self.nameLa.bottom).offset(10);
            make.height.equalTo(15);
            make.width.equalTo(15+stateSize.width);
        }];
        
        self.promptView = [[UIView alloc]init];
        self.promptView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
        [self addSubview:self.promptView];
        [self.promptView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(0);
            make.top.equalTo(self.timeBtn.bottom).offset(10);
            make.width.equalTo(WIDTH);
            make.height.equalTo(30);
        }];
        
        self.promptBtn = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:NSLocalizedString(@"Device_title_left",@"") textFrame:CGRectMake(5, 0, 0, 0) image:@"tips" imageFrame:CGRectMake(0, 0, 15, 15) font:12];
        CGSize promptSize = [ToolControl makeText:self.promptBtn.la.text font:12];
        self.promptBtn.la.textColor = [UIColor grayColor];
        [self.promptView addSubview:self.promptBtn];
        [self.promptBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.promptView);
            make.top.equalTo(self.promptView.top).offset(10);
            make.width.equalTo(promptSize.width+30);
            make.height.equalTo(20);
        }];
    }
    return self;
}
/**
 判断此计划是否已经完成
 
 @param schdict 计划字典
 @return <#return value description#>
 */
-(BOOL)schIsHadFinish:(NSDictionary *)schdict
{
    int count = 0;
    int allCount = -1;
    NSArray * schArray = [USERDEFAULT valueForKey:SCH_SITE_DEVICE_ARRAY];
    for (NSDictionary * dict in schArray) {
        //  当前计划
        if ([dict[@"sch_id"] intValue] == [schdict[@"sch_id"] intValue] && [dict[@"same_sch_seq"] intValue] == [schdict[@"same_sch_seq"] intValue] && [dict[@"sch_shift_id"] intValue] == [schdict[@"sch_shift_id"] intValue]) {
            NSArray * deviceArray = dict[@"device_array"];
            if (deviceArray.count != 0) {
                allCount = (int)deviceArray.count;
            }
            for (NSDictionary * devicedict in deviceArray) {
                if ([devicedict[@"patrol_state"] intValue] == 3) {
                    count ++;
                }
            }
        }
    }
    if (allCount == count) {
        return YES;
    }
    return NO;
}
-(NSString *)timeFromMonth
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"M"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}
-(TaskFromChooseTableViewCell *)taskChooseCell
{
    if (_taskChooseCell == nil) {
        _taskChooseCell = [[TaskFromChooseTableViewCell alloc]init];
    }
    return _taskChooseCell;
}
@end
