//
//  TaskNowTableViewCell.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/10.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "TaskNowTableViewCell.h"
#import "ToolControl.h"
#import "DataBaseManager.h"
#import "YYModel.h"
@implementation TaskNowTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier contentDic:(NSDictionary *)dict
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.startTime = [[UILabel alloc]init];
        [ToolControl makeLabel:self.startTime text:dict[@"start_time"] font:13];
        [self.contentView addSubview:self.startTime];
        [self.startTime makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(5);
            make.top.equalTo(self.top).offset(10);
        }];
        
        self.timeImage = [[UIImageView alloc]init];
        self.timeImage.image = [UIImage imageNamed:@"downarrow_black"];
        [self.contentView addSubview:self.timeImage];
        [self.timeImage makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.startTime);;
            make.top.equalTo(self.startTime.bottom).offset(5);
            make.width.equalTo(10);
            make.height.equalTo(15);
        }];
        
        self.endTime = [[UILabel alloc]init];
        [ToolControl makeLabel:self.endTime text:dict[@"end_time"] font:13];
        [self.contentView addSubview:self.endTime];
        [self.endTime makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.startTime);
            make.top.equalTo(self.timeImage.bottom).offset(5);
        }];
        
        DataBaseManager * db = [DataBaseManager shareInstance];
        NSArray * array = [db selectSomething:@"site_record" value:[NSString stringWithFormat:@"site_id = %@",dict[@"site_id"]] keys:[ToolModel allPropertyNames:[SiteModel class]] keysKinds:[ToolModel allPropertyAttributes:[SiteModel class]]];
        self.nameLa = [[UILabel alloc]init];
        
        NSString * str;
        if (array.count == 0) {
            str = dict[@"site_id"];
        }else{
            str = array[0][@"site_name"];
        }
        [ToolControl makeLabel:self.nameLa text:str font:16];
        [self.contentView addSubview:self.nameLa];
        [self.nameLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.startTime.right).offset(20);
            make.top.equalTo(self.top).offset(15);
            make.width.equalTo(WIDTH-150);
        }];
        
        
        self.stateBtn = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:NSLocalizedString(@"Task_patrol_state_one",@"") textFrame:CGRectMake(5, 0, 0, 0) image:@"spot_blue" imageFrame:CGRectMake(0, 0, 5, 5) font:12];
        switch ([dict[@"sch_state"] intValue]) {
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
        if ([self schIsHadFinish:dict]) {
            self.stateBtn.la.text = NSLocalizedString(@"Task_patrol_state_four",@"");
            self.stateBtn.image.image = [UIImage imageNamed:@"spot_green"];
        }
        [self.contentView addSubview:self.stateBtn];
        [self.stateBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right).offset(-10);
            make.top.equalTo(self.top).offset(20);
            make.width.equalTo(60);
            make.height.equalTo(14);
        }];
        
        int i = [db selectNumber:@"sch_device_record" value:[NSString stringWithFormat:@"sch_id = %d and same_sch_seq = %d",[dict[@"sch_id"] intValue],[dict[@"same_sch_seq"] intValue]]];
        [db dbclose];
        self.slider = [[UISlider alloc]init];
        self.slider.minimumValue = 0;
        self.slider.maximumValue = i;
        
        self.slider.value = [self selectDeviceFinishBumber:dict];;
         UIImage *image = [UIImage imageNamed:@"spot_red"];
//        UIImage *image = [self OriginImage:[UIImage imageNamed:@"spot_red"] scaleToSize:CGSizeMake(5, 5)];
        [self.slider setThumbImage:image forState:UIControlStateNormal];
        [self.slider setThumbImage:image forState:UIControlStateHighlighted];
        
        self.slider.minimumTrackTintColor = [UIColor colorWithRed:0.80 green:0.09 blue:0.15 alpha:1.00];
        self.slider.maximumTrackTintColor = [UIColor grayColor];
        [self.contentView addSubview:self.slider];
        [self.slider makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLa.left).offset(0);
            make.top.equalTo(self.nameLa.bottom).offset(25);
            make.width.equalTo(WIDTH-100);
            make.height.equalTo(5);
        }];
        
        self.thumbLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.thumbLa text:[NSString stringWithFormat:@"%d",(int)self.slider.value] font:12];
        [self.contentView addSubview:self.thumbLa];
        if (i == 0) {
            [self.thumbLa makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.nameLa.bottom).offset(10);
                make.left.equalTo(self.slider.left).offset(0);
            }];
        }else{
            [self.thumbLa makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.nameLa.bottom).offset(10);
                make.left.equalTo(self.slider.left).offset((WIDTH-100)/i*(int)self.slider.value);
            }];
        }
        
        self.endLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.endLa text:[NSString stringWithFormat:@"%d",i] font:12];
        [self.contentView addSubview:self.endLa];
        [self.endLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.slider.right).offset(5);
            make.centerY.equalTo(self.slider);
        }];
        [self updateTime:self.startTime.text endTime:self.endTime.text dict:dict];
    }
    return self;
}

-(void)updateTime:(NSString *)startTime endTime:(NSString *)endTime dict:(NSDictionary *)dict
{
    NSDate * senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSDate * nowtime = [ToolModel timeFromZone:[dateformatter dateFromString:locationString]];
    NSDate * starttime = [ToolModel timeFromZone:[dateformatter dateFromString:startTime]];
    NSDate * endtime = [ToolModel timeFromZone:[dateformatter dateFromString:endTime]];
    
    NSComparisonResult result = [starttime compare:nowtime];
    NSComparisonResult result1 = [endtime compare:nowtime];
    if ((result1 == NSOrderedDescending && result == NSOrderedAscending) || result == NSOrderedSame || result1 == NSOrderedSame) {
        //   时间内
        self.startTime.textColor = [UIColor blackColor];
        self.endTime.textColor = [UIColor blackColor];
        self.timeImage.image = [UIImage imageNamed:@"downarrow_black"];
    }else{
        if (result == NSOrderedDescending) {
            //   时间未到
            self.startTime.textColor = [UIColor grayColor];
            self.endTime.textColor = [UIColor grayColor];
            self.timeImage.image = [UIImage imageNamed:@"downarrow"];

        }else{
            if ([dict[@"sch_state"] intValue] != 3 && result1 == NSOrderedAscending) {
                //   超时
                self.startTime.textColor = [UIColor redColor];
                self.endTime.textColor = [UIColor redColor];
                self.timeImage.image = [UIImage imageNamed:@"downarrow_red"];
            }else{
                //   已经完成的超时
                self.startTime.textColor = [UIColor blackColor];
                self.endTime.textColor = [UIColor blackColor];
                self.timeImage.image = [UIImage imageNamed:@"downarrow_black"];
            }
        }
    }
    


}
-(UIImage*) OriginImage:(UIImage*)image scaleToSize:(CGSize)size

{
    UIGraphicsBeginImageContext(size);//size为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

/**
 查询当前计划下已完成的设备书

 @param schdict 当前计划
 @return <#return value description#>
 */
-(int)selectDeviceFinishBumber:(NSDictionary *)schdict
{
    int count = 0;
    NSArray * schArray = [USERDEFAULT valueForKey:SCH_SITE_DEVICE_ARRAY];
    for (NSDictionary * dict in schArray) {
        //  当前计划
        if ([dict[@"sch_id"] intValue] == [schdict[@"sch_id"] intValue] && [dict[@"same_sch_seq"] intValue] == [schdict[@"same_sch_seq"] intValue] && [dict[@"sch_shift_id"] intValue] == [schdict[@"sch_shift_id"] intValue]) {
            NSArray * deviceArray = dict[@"device_array"];
            for (NSDictionary * devicedict in deviceArray) {
                if ([devicedict[@"patrol_state"] intValue] == 3) {
                    count ++;
                }
            }
        }
    }
    return count;
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
- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 10;
    frame.size.height -= 10;
    
    [super setFrame:frame];
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
