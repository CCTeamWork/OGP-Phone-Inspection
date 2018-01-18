//
//  TaskFromChooseTableViewCell.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/9/12.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "TaskFromChooseTableViewCell.h"
#import "ToolControl.h"
#import "DataBaseManager.h"
#import "SiteModel.h"

@implementation TaskFromChooseTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier contentDic:(NSDictionary *)dict
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.startTime = [[UILabel alloc]init];
        if ([dict[@"sch_type"] intValue] == 1) {
            [ToolControl makeLabel:self.startTime text:[self changeIntToString:[dict[@"other_start_date"] intValue]] font:13];
        }else{
            [ToolControl makeLabel:self.startTime text:[NSString stringWithFormat:@"%@月%@日",[self timeFromMonth],dict[@"other_start_date"]] font:13];
        }
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
        if ([dict[@"sch_type"] intValue] == 1) {
            [ToolControl makeLabel:self.endTime text:[self changeIntToString:[dict[@"other_end_date"] intValue]] font:13];
        }else{
            [ToolControl makeLabel:self.endTime text:[NSString stringWithFormat:@"%@月%@日",[self timeFromMonth],dict[@"other_end_date"]] font:13];
        }
        [self.contentView addSubview:self.endTime];
        [self.endTime makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.startTime);
            make.top.equalTo(self.timeImage.bottom).offset(5);
        }];
        DataBaseManager * db = [DataBaseManager shareInstance];
        NSArray * array = [db selectSomething:@"site_record" value:[NSString stringWithFormat:@"site_id = %d",[dict[@"site_id"] intValue]] keys:[ToolModel allPropertyNames:[SiteModel class]] keysKinds:[ToolModel allPropertyAttributes:[SiteModel class]]];
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
        int k = [db selectNumber:@"other_task_status" value:[NSString stringWithFormat:@"sch_id = %d and patrol_flag = 1 and same_sch_seq = %d",[dict[@"sch_id"] intValue],[dict[@"same_sch_seq"] intValue]]];
        int j = [self selectDeviceFinishBumber:dict];
        [db dbclose];
        self.slider = [[UISlider alloc]init];
        self.slider.minimumValue = 0;
        self.slider.maximumValue = i;
        self.slider.value = k+j;
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
            make.width.equalTo(WIDTH/3);
            make.height.equalTo(5);
        }];
        
        self.thumbLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.thumbLa text:[NSString stringWithFormat:@"%d",(int)self.slider.value] font:12];
        [self.contentView addSubview:self.thumbLa];
        [self.thumbLa makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLa.bottom).offset(10);
            make.left.equalTo(self.slider.left).offset((WIDTH/2)/(self.slider.maximumValue)*self.slider.value);
        }];
        
        self.endLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.endLa text:[NSString stringWithFormat:@"%d",(int)self.slider.maximumValue] font:12];
        [self.contentView addSubview:self.endLa];
        [self.endLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.slider.right).offset(5);
            make.centerY.equalTo(self.slider);
        }];
        
        self.postBtn = [[UIButton alloc]init];
        [ToolControl makeButton:self.postBtn titleColor:[UIColor blackColor] title:NSLocalizedString(@"Task_othertask_btn_down",@"") btnImage:nil cornerRadius:10 font:12];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.88, 0.89, 0.89, 1.00 });
        self.postBtn.layer.borderWidth = 1.0;
        self.postBtn.layer.borderColor = colorref;
        [self.contentView addSubview:self.postBtn];
        [self.postBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.endLa.right).offset(10);
            make.centerY.equalTo(self.endLa);
            make.height.equalTo(30);
            make.width.equalTo((WIDTH-WIDTH/3-self.startTime.frame.size.width)/4);
        }];
        [self.postBtn addTarget:self action:@selector(getBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        self.endBtn = [[UIButton alloc]init];
        [ToolControl makeButton:self.endBtn titleColor:[UIColor blackColor] title:NSLocalizedString(@"Task_othertask_btn_finish",@"") btnImage:nil cornerRadius:10 font:12];
        self.endBtn.layer.borderColor = colorref;
        self.endBtn.layer.borderWidth = 1.0;
        [self.contentView addSubview:self.endBtn];
        [self.endBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.postBtn.right).offset(5);
            make.centerY.equalTo(self.postBtn);
            make.width.equalTo((WIDTH-WIDTH/3-self.startTime.frame.size.width)/4);
            make.height.equalTo(30);
        }];
        [self.endBtn addTarget:self action:@selector(finishBtnTouchs:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

/**
 同步按钮

 @param cell <#cell description#>
 */
-(void)getBtnTouch:(UITableViewCell *)cell
{
    if ([_delegate respondsToSelector:@selector(GetOtherTask:)]) {
        cell.tag = self.postBtn.tag;
        [_delegate GetOtherTask:cell];
    }
}

/**
 完成按钮

 @param cell <#cell description#>
 */
-(void)finishBtnTouchs:(UITableViewCell *)cell
{
    if ([_delegate respondsToSelector:@selector(FinishOtherTask:)]) {
        cell.tag = self.endBtn.tag;
        [_delegate FinishOtherTask:cell];
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
- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 10;
    frame.size.height -= 10;
    
    [super setFrame:frame];
}

/**
 将获取的整形转换为星期

 @param i <#i description#>
 */
-(NSString *)changeIntToString:(int)i
{
    if([[ToolModel currentLanguage] compare:@"zh-Hans-CN" options:NSCaseInsensitiveSearch]==NSOrderedSame || [[ToolModel currentLanguage] compare:@"zh-Hant-CN" options:NSCaseInsensitiveSearch]==NSOrderedSame)
    {
        
        switch (i) {
            case 0:
                return @"星期日";
                break;
            case 1:
                return @"星期一";
                break;
            case 2:
                return @"星期二";
                break;
            case 3:
                return @"星期三";
                break;
            case 4:
                return @"星期四";
                break;
            case 5:
                return @"星期五";
                break;
            case 6:
                return @"星期六";
                break;
            default:
                break;
        }
   
    }else{
        switch (i) {
            case 0:
                return @"Sunday";
                break;
            case 1:
                return @"Monday";
                break;
            case 2:
                return @"Tuesday";
                break;
            case 3:
                return @"Wednesday";
                break;
            case 4:
                return @"Thursday";
                break;
            case 5:
                return @"Friday";
                break;
            case 6:
                return @"Saturday";
                break;
            default:
                break;
        }
    }
    return nil;
}
-(NSString *)timeFromMonth
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"M"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
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
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
