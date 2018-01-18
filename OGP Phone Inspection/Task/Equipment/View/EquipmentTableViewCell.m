//
//  EquipmentTableViewCell.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/31.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "EquipmentTableViewCell.h"
#import "ToolControl.h"
#import "DataBaseManager.h"
@implementation EquipmentTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dictionary:(NSDictionary *)dictionary
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.stateImage = [[UIImageView alloc]init];
        self.stateImage.image = [UIImage imageNamed:@"sbei_on"];
        if ([dictionary[@"device_state"] isEqualToString:@"disable"]) {
            self.stateImage.image = [UIImage imageNamed:@"sbei_off"];
        }
        [self.contentView addSubview:self.stateImage];
        [self.stateImage makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
            make.top.equalTo(self.top).offset(10);
            make.width.equalTo(40);
            make.height.equalTo(40);
        }];
        
        self.nameLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.nameLa text:dictionary[@"device_name"] font:16];
        [self.contentView addSubview:self.nameLa];
        [self.nameLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.stateImage.right).offset(10);
            make.top.equalTo(self.top).offset(10);
        }];
        
        self.stateLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.stateLa text:NSLocalizedString(@"Device_device_state_on",@"") font:14];
        if ([dictionary[@"device_state"] isEqualToString:@"disable"]) {
            self.stateLa.text = NSLocalizedString(@"Device_device_state_off",@"");
        }
        NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:self.stateLa.text];
        [aString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,2)];
        self.stateLa.attributedText = aString;
        [self addSubview:self.stateLa];
        [self.stateLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.stateImage.right).offset(10);
            make.top.equalTo(self.nameLa.bottom).offset(10);
        }];
        
        self.numberLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.numberLa text:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Device_device_mark_title",@""),dictionary[@"sequence"]] font:14];
        NSMutableAttributedString *bString = [[NSMutableAttributedString alloc]initWithString:self.numberLa.text];
        [bString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,2)];
        self.numberLa.attributedText = bString;
        [self.contentView addSubview:self.numberLa];
        [self.numberLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.stateLa.right).offset(20);
            make.top.equalTo(self.nameLa.bottom).offset(10);
        }];
        
        
        self.stateBtn = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:NSLocalizedString(@"Task_patrol_state_two",@"") textFrame:CGRectMake(5, 0, 0, 0) image:@"spot_blue" imageFrame:CGRectMake(0, 0, 5, 5) font:12];
        switch ([dictionary[@"patrol_state"] intValue]) {
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
        CGSize stateSize = [ToolControl makeText:self.stateBtn.la.text font:12];
//        self.stateBtn.la.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.stateBtn];
        [self.stateBtn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLa.bottom).offset(10);
            make.right.equalTo(self.right).offset(-10);
            make.width.equalTo(15+stateSize.width);
            make.height.equalTo(15);
        }];
        
        NSDictionary * touchSchdict = [USERDEFAULT valueForKey:SCH_NOW_TOUCH];

        int i = [self itemsCount:dictionary];
        self.slider = [[UISlider alloc]init];
        self.slider.minimumValue = 0;
        self.slider.maximumValue = i;
        DataBaseManager * db = [DataBaseManager shareInstance];
        self.slider.value = [db selectNumber:@"itemskind_record" value:[NSString stringWithFormat:@"record_uuid = '%@'",dictionary[@"record_uuid"]]];;
        UIImage *image = [self OriginImage:[UIImage imageNamed:@"spot_red"] scaleToSize:CGSizeMake(5, 5)];
        [self.slider setThumbImage:image forState:UIControlStateNormal];
        [self.slider setThumbImage:image forState:UIControlStateHighlighted];
        self.slider.minimumTrackTintColor = [UIColor colorWithRed:0.80 green:0.09 blue:0.15 alpha:1.00];
        self.slider.maximumTrackTintColor = [UIColor grayColor];
        [self.contentView addSubview:self.slider];
        [self.slider makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20);
            make.top.equalTo(self.stateLa.bottom).offset(20);
            make.width.equalTo(WIDTH-60);
            make.height.equalTo(5);
        }];
        
        //   判断是不是特殊计划  如果是  判断是否已经巡检过
        if ([touchSchdict[@"sch_type"] intValue] != 0) {
            DataBaseManager * db = [DataBaseManager shareInstance];
            NSArray * finishArray = [db selectSomething:@"other_task_status" value:[NSString stringWithFormat:@"sch_id = %d and same_sch_seq = %d",[touchSchdict[@"sch_id"] intValue],[touchSchdict[@"same_sch_seq"] intValue]] keys:@[@"sch_id",@"site_device_id",@"patrol_flag",@"same_sch_seq"] keysKinds:@[@"int",@"int",@"int",@"int"]];
            for (NSDictionary * dic in finishArray) {
                if ([dic[@"sch_id"] intValue] == [dictionary[@"sch_id"] intValue]) {
                    self.stateBtn.la.text = NSLocalizedString(@"Task_patrol_state_four",@"");
                    self.stateBtn.image.image = [UIImage imageNamed:@"spot_green"];
                    self.slider.value = self.slider.maximumValue;
                }
            }
        }
        
        self.thumbLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.thumbLa text:[NSString stringWithFormat:@"%d",(int)self.slider.value] font:12];
        [self.contentView addSubview:self.thumbLa];
        if (i == 0) {
            [self.thumbLa makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.stateLa.bottom).offset(5);
                make.centerX.equalTo(self.slider.left).offset(0);
            }];
        }else{
            [self.thumbLa makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.stateLa.bottom).offset(5);
                make.centerX.equalTo(self.slider.left).offset((WIDTH-60)/(self.slider.maximumValue)*self.slider.value);
            }];
        }

        self.maxLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.maxLa text:[NSString stringWithFormat:@"%d",(int)self.slider.maximumValue] font:12];
        [self.contentView addSubview:self.maxLa];
        [self.maxLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.slider.right).offset(5);
            make.centerY.equalTo(self.slider);
        }];
        

    }
    return self;
}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//    [self dealDeleteButton];
//}
//- (void)dealDeleteButton{
//    if (NSFoundationVersionNumber10_10_Max) {
//
//    }else{
//        for (UIView *subView in self.subviews) {
//
//            if ([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
//
//                for (UIButton *button in subView.subviews) {
//
//                    if ([button isKindOfClass:[UIButton class]]) {
//
//                        button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sbei_gb"]];
//                        button.titleLabel.font = [UIFont systemFontOfSize:0];
//
//                    }
//                }
//            }
//        }
//    }
//}
-(UIImage*) OriginImage:(UIImage*)image scaleToSize:(CGSize)size

{
    UIGraphicsBeginImageContext(size);//size为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}
//   查询设备对应项目数量
-(int)itemsCount:(NSDictionary *)dict
{
    if ([dict[@"modify_flag"] intValue] == 1) {
        NSArray * array = [dict[@"items_ids"] componentsSeparatedByString:@","];
        return (int)array.count;
    }else{
        DataBaseManager * db = [DataBaseManager shareInstance];
        int i = [db selectNumber:@"device_items_record" value:[NSString stringWithFormat:@"site_device_id = %@ and device_status_code like '%%%@%%'",dict[@"site_device_id"],dict[@"device_state"]]];
        [db dbclose];
        return i;
    }
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
