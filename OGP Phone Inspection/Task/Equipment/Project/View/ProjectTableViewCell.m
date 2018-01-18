//
//  ProjectTableViewCell.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/7.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "ProjectTableViewCell.h"
#import "ToolControl.h"
#import "BigPhotoView.h"
#import "DataBaseManager.h"
#import "YYModel.h"
#import "ItemsModel.h"
#import "ProjectPost.h"
#import "MBProgressHUD.h"
@implementation ProjectTableViewCell

/**
 <#Description#>

 @param style <#style description#>
 @param reuseIdentifier <#reuseIdentifier description#>
 @param dicionary 项目数据 （如果是预览进入 是项目记录数据  否则是项目数据）
 @param deviceDict 设备数据  （非纪录）
 @param pre 是否是巡检  （0:否    1:是）
 @return <#return value description#>
 */
-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
                  dictionary:(NSDictionary *)dicionary
                  deviceDict:(NSDictionary *)deviceDict
                         pre:(int)pre
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isPre = pre;
        self.finishi = 1;
         DataBaseManager * db = [DataBaseManager shareInstance];
        //   不是预览进入
        if (pre == 0) {
            self.projectDic = dicionary;
            //   查询出项目记录表中的内容
            NSArray * array = [db selectSomething:@"itemskind_record" value:[NSString stringWithFormat:@"record_uuid = '%@' and items_id = %d",deviceDict[@"record_uuid"],[dicionary[@"items_id"] intValue]] keys:[ToolModel allPropertyNames:[ItemsKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[ItemsKindModel class]]];
            if (array.count != 0) {
                self.projectRecordDic = array[0];
            }
        }else{
            //   是预览进入
            self.projectRecordDic = dicionary;
            //   查询出项目表中的内容
            NSArray * array = [db selectSomething:@"items_record" value:[NSString stringWithFormat:@"items_id = %d",[dicionary[@"items_id"] intValue]] keys:[ToolModel allPropertyNames:[ItemsModel class]] keysKinds:[ToolModel allPropertyAttributes:[ItemsModel class]]];
            if (array.count != 0) {
                self.projectDic = array[0];
                dicionary = self.projectDic;
            }
        }
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.70, 0.70, 0.70, 1.00 });
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = colorref;
        
        NSString * titletext = dicionary[@"items_name"];
        if ([dicionary[@"items_name"] length] == 0) {
            DataBaseManager * db = [DataBaseManager shareInstance];
            NSArray * array = [db selectSomething:@"items_record" value:[NSString stringWithFormat:@"items_id = %d",[dicionary[@"items_id"] intValue]] keys:[ToolModel allPropertyNames:[ItemsModel class]] keysKinds:[ToolModel allPropertyAttributes:[ItemsModel class]]];
            if (array.count != 0) {
                titletext = array[0][@"items_name"];
            }
        }
        self.nameLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.nameLa text:titletext font:18];
        self.nameLa.numberOfLines = 0;
        [self.contentView addSubview:self.nameLa];
        [self.nameLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
            make.top.equalTo(self.top).offset(10);
        }];
        

        
//        //   标题
//        self.nameLa = [[UILabel alloc]init];
//        [ToolControl makeLabel:self.nameLa text:@"时间空间都叫啊叫啊" font:16];
//        [self.contentView addSubview:self.nameLa];
//        [self.nameLa makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.left).offset(10);
//            make.top.equalTo(self.top).offset(10);
//        }];
        //   分割线
        [[self makeLineView] makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(0);
            make.top.equalTo(self.nameLa.bottom).offset(10);
            make.width.equalTo(WIDTH);
            make.height.equalTo(1);
        }];
        
        self.k = [dicionary[@"category"] intValue];
        switch (self.k) {
            case 2:
                //                单选
                [self choose:dicionary];
//                self.nameLa.text=@"请选择：";
                break;
            case 5:
                //                图片
                [self photo:dicionary];
//                self.nameLa.text=@"点击拍照：";
                break;
            case 7:
                //                签名
                [self signature:dicionary];
//                self.nameLa.text=@"点击前往签名：";
                break;
            case 1:
                //                文字
                [self text:dicionary];
//                self.nameLa.text=@"请输入：";
                break;
            case 6:
                //                录音
                [self sound:dicionary];
//                self.nameLa.text=@"点击录音：";
                break;
            case 0:
                //                数值
                [self numberValue:dicionary];
//                self.nameLa.text=@"请输入数值：";
                break;
            case 4:
                //                时间
                [self time:dicionary];
//                self.nameLa.text=@"点击选择时间：";
                break;
            case 3:
                //                多选
                [self choose:dicionary];
//                self.nameLa.text=@"请选择：";
                break;

            case 9:
                //                日期
                [self time:dicionary];
//                self.nameLa.text=@"点击选择日期：";
                break;
            case 10:
                //               日期＋时间
                [self time:dicionary];
//                self.nameLa.text=@"点击选择日期和时间：";
                break;
            default:
                break;
        }
    }
    return self;
}
#pragma mark 选择
//   选择
-(void)choose:(NSDictionary *)dic
{
    DataBaseManager * db = [DataBaseManager shareInstance];
    //   查询出选择的数量
    NSArray * array = [db selectSomething:@"options_record" value:[NSString stringWithFormat:@"options_group_id = %d",[dic[@"options_group_id"] intValue]] keys:@[@"options_group_id",@"option_id",@"option_name"] keysKinds:@[@"int",@"int",@"NSString"]];
    int sum = 0;
    BOOL Y = NO;
    //   遍历选择数组  添加到检查项中
    for (int i = 0; i < array.count; i++) {
        NSDictionary * dict = array[i];
        //  判断还有没有下一项  如果有  加入分割线
        if (i == array.count-1) {
            Y = YES;
        }
        //   添加选择按钮
        self.contentBtn = [[ChooseButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) dictionary:dict isend:Y number:i];
        self.contentBtn.tag = 100 + i;
        //   计算该选项的高度和宽度   并设置选择按钮
        CGSize contentSize = [ToolControl makeText:self.contentBtn.la.text font:16];
        int k = contentSize.width/((WIDTH-10)/3*2);
        if (k<1) {
            k++;
        }
        [self.contentView addSubview:self.contentBtn];
        [self.contentBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(0);
            make.top.equalTo(self.nameLa.bottom).offset(sum+15);
            make.width.equalTo(WIDTH-10);
            make.height.equalTo(50*k);
        }];
        //   每一项的上面距离检查项名称的高度
        sum = sum + 50*k;
        //   判断多选还是单选
        if ([dic[@"category"] intValue] == 2) {
            [self.contentBtn addTarget:self action:@selector(chooseOneBtn:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [self.contentBtn addTarget:self action:@selector(chooseMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    //   是否巡检过未上传
    if (self.projectRecordDic != nil) {
        if ([dic[@"category"] intValue] == 2) {
            [self hadChooseOne:self.projectRecordDic];
        }else{
            [self hadChooseMore:self.projectRecordDic];
        }
    }
    
}

/**
 已经巡检过的未传数据  单选

 @param itemsdict 数据
 */
-(void)hadChooseOne:(NSDictionary *)itemsdict
{
    //   查询出检查项内容
    NSString * str = itemsdict[@"items_value"];
    if (str.length == 0) {
        return;
    }
    NSString * finstr;
    DataBaseManager * db = [DataBaseManager shareInstance];
    NSArray * array = [db selectSomething:@"items_record" value:[NSString stringWithFormat:@"items_id = %d",[itemsdict[@"items_id"] intValue]] keys:[ToolModel allPropertyNames:[ItemsModel class]] keysKinds:[ToolModel allPropertyAttributes:[ItemsModel class]]];
    if (array.count != 0) {
         NSArray * array1 = [db selectSomething:@"options_record" value:[NSString stringWithFormat:@"options_group_id = %d",[array[0][@"options_group_id"] intValue]] keys:@[@"options_group_id",@"option_id",@"option_name"] keysKinds:@[@"int",@"int",@"NSString"]];
        for (NSDictionary * dict in array1) {
            if ([dict[@"option_id"] intValue] == [str intValue]) {
                finstr = dict[@"option_name"];
            }
        }
    }
    //   将结果显示
    for (ChooseButton * obj in self.contentView.subviews) {
        if ([obj isKindOfClass:[ChooseButton class]]) {
            if ([obj.la.text isEqualToString:finstr]) {
                obj.la.textColor = [UIColor colorWithRed:0.87 green:0.15 blue:0.23 alpha:1.00];
                if (![self isErrorOption:obj.optionid]) {
                    obj.errorBtn.la.text = @"项目异常";
                    obj.errorBtn.image.image = [UIImage imageNamed:@"thips"];
                }
                self.finishStr = obj.optionid;
                obj.image.image = [UIImage imageNamed:@"project_checked"];
            }
        }
    }
}

/**
 已经巡检过的未穿数据   多选

 @param itemsdict 数据
 */
-(void)hadChooseMore:(NSDictionary *)itemsdict
{
    NSArray * array = [itemsdict[@"items_value"] componentsSeparatedByString:@","];
    for (NSString * str in array) {
        
        NSString * finstr;
        DataBaseManager * db = [DataBaseManager shareInstance];
        NSArray * array = [db selectSomething:@"items_record" value:[NSString stringWithFormat:@"items_id = %d",[itemsdict[@"items_id"] intValue]] keys:[ToolModel allPropertyNames:[ItemsModel class]] keysKinds:[ToolModel allPropertyAttributes:[ItemsModel class]]];
        if (array.count != 0) {
            NSArray * array1 = [db selectSomething:@"options_record" value:[NSString stringWithFormat:@"options_group_id = %d",[array[0][@"options_group_id"] intValue]] keys:@[@"options_group_id",@"option_id",@"option_name"] keysKinds:@[@"int",@"int",@"NSString"]];
            for (NSDictionary * dict in array1) {
                if ([dict[@"option_id"] intValue] == [str intValue]) {
                    finstr = dict[@"option_name"];
                }
            }
        }
        for (ChooseButton * obj in self.contentView.subviews) {
            if ([obj isKindOfClass:[ChooseButton class]]) {
                if ([obj.la.text isEqualToString:finstr]) {
                    obj.la.textColor = [UIColor colorWithRed:0.87 green:0.15 blue:0.23 alpha:1.00];
                    if (![self isErrorOption:obj.optionid]) {
                        obj.errorBtn.la.text = @"项目异常";
                        obj.errorBtn.image.image = [UIImage imageNamed:@"thips"];
                    }
                    self.finishStr = obj.optionid;
                    obj.image.image = [UIImage imageNamed:@"project_checked"];
                    obj.selected = !obj.selected;
                }
            }
        }
        
    }
}
//   单选   需要加是否有异常的判断
-(void)chooseOneBtn:(ChooseButton *)sender
{
    if ([[ProjectPost isChangeItmesValue:self.projectDic] length] == 0 || self.isPre == 1) {
        for (ChooseButton * obj in self.contentView.subviews) {
            if ([obj isKindOfClass:[ChooseButton class]]) {
                if (obj.tag == sender.tag) {
                    obj.la.textColor = [UIColor colorWithRed:0.87 green:0.15 blue:0.23 alpha:1.00];
                    self.finishi = 1;
                    if (![self isErrorOption:obj.optionid]) {
                        obj.errorBtn.la.text = @"项目异常";
                        obj.errorBtn.image.image = [UIImage imageNamed:@"thips"];
                        self.finishi = 0;
                    }
                    self.finishStr = obj.optionid;
                    obj.image.image = [UIImage imageNamed:@"project_checked"];
                }else{
                    obj.la.textColor = [UIColor blackColor];
                    obj.errorBtn.la.text = @"";
                    obj.errorBtn.image.image = nil;
                    obj.image.image = nil;
                }
            }
        }
    }else{
        [self isLongTimeAlertShow:[ProjectPost isChangeItmesValue:self.projectDic]];
    }
}

/**
 判断是否是标准值

 @param str 选项id
 @return <#return value description#>
 */
-(BOOL)isErrorOption:(NSString *)str
{
    NSArray  *array = [self.projectDic[@"standar_value_option"] componentsSeparatedByString:@","];
    for (NSString * option in array) {
        if ([str isEqualToString:option]) {
            return YES;
        }
    }
    return NO;
}
//    多选
-(void)chooseMoreBtn:(ChooseButton *)sender
{
    if ([[ProjectPost isChangeItmesValue:self.projectDic] length] == 0 || self.isPre == 1) {
        if (sender.selected == NO) {
            sender.la.textColor =[UIColor colorWithRed:0.87 green:0.15 blue:0.23 alpha:1.00];
            self.finishi = 1;
            if (![self isErrorOption:sender.optionid]) {
                sender.errorBtn.la.text = @"项目异常";
                sender.errorBtn.image.image = [UIImage imageNamed:@"thips"];
                self.finishi = 0;
            }
            sender.image.image = [UIImage imageNamed:@"project_checked"];
        }else{
            sender.la.textColor = [UIColor blackColor];
            sender.image.image = nil;
            sender.errorBtn.la.text = @"";
            sender.errorBtn.image.image = nil;
        }
        [self addMoreChoose:sender.optionid];
        sender.selected = !sender.selected;
    }else{
         [self isLongTimeAlertShow:[ProjectPost isChangeItmesValue:self.projectDic]];
    }
}
-(void)addMoreChoose:(NSString *)str
{
    if ([self.chaooseArray containsObject:str]) {
        [self.chaooseArray removeObject:str];
    }else{
        [self.chaooseArray addObject:str];
    }
    self.finishStr = [self.chaooseArray componentsJoinedByString:@","];
}
#pragma mark 照片
//  图片
-(void)photo:(NSDictionary *)dic
{
    self.addImageBtn = [[PhotoAddButton alloc]init];
    self.addImageBtn.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.addImageBtn];
    [self.addImageBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(10);
        make.top.equalTo(self.nameLa.bottom).offset(20);
        make.width.equalTo(60);
        make.height.equalTo(60);
    }];
    
    self.errorBtn = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:@"项目异常" textFrame:CGRectMake(5, 0, 0, 0) image:@"unselecte" imageFrame:CGRectMake(0, 0, 25, 25) font:14];
    [self.contentView addSubview:self.errorBtn];
    [self.errorBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(15);
        make.top.equalTo(self.addImageBtn.bottom).offset(15);
        make.width.equalTo(90); 
        make.height.equalTo(25);
    }];
    [self.errorBtn addTarget:self action:@selector(chooseError:) forControlEvents:UIControlEventTouchUpInside];
    if (self.projectRecordDic != nil) {
        //   巡检结果是否正常
        if ([self.projectRecordDic[@"items_value_status"] intValue] == 0) {
            self.errorBtn.selected = YES;
        }
        NSString * uuidStr = self.projectRecordDic[@"data_uuid"];
        if (uuidStr.length != 0) {
            //   当前项目信息记录表
            DataBaseManager * db = [DataBaseManager shareInstance];
            NSArray * array = [db selectSomething:@"data_record" value:[NSString stringWithFormat:@"data_uuid = '%@'",uuidStr] keys:[ToolModel allPropertyNames:[DataModel class]] keysKinds:[ToolModel allPropertyAttributes:[DataModel class]]];
            [db dbclose];
            //   有数据  开始遍历添加
            for (NSDictionary * dict in array) {
                [self hadImageData:dict];
            }
        }
    }
}

/**
 集成正常添加的字典

 @param dict 流记录表字典
 */
-(void)hadImageData:(NSDictionary *)dict
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",dict[@"content_path"]]];   // 保存文件的名称
    UIImage * image = [UIImage imageWithContentsOfFile:filePath];
    NSData *data=UIImageJPEGRepresentation(image, 1.0);
    if (data.length == 0) {
        return;
    }
    NSMutableDictionary * muldict = [[NSMutableDictionary alloc]init];
    [muldict setObject:data forKey:@"PickerImage"];
    [muldict setObject:dict[@"content_path"] forKey:@"content_path"];
    [muldict setObject:dict[@"data_record_show"] forKey:@"data_record_show"];
    [muldict setObject:dict[@"file_name"] forKey:@"file_name"];
    [self photoProjectAdd:muldict];
}
/**
 添加照片
 
 @param dic 照片
 */
-(void)photoProjectAdd:(NSDictionary *)dic
{
    if (dic == nil) {
        return;
    }
    NSData * imageData = dic[@"PickerImage"];
    [self.pickerImageArray addObject:dic];
    UIImage *image = [UIImage imageWithData: imageData];
    int i = (int)self.pickerImageArray.count-1;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.addImageBtn updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10+(10*self.pickerImageArray.count)+(60*self.pickerImageArray.count));
            make.top.equalTo(self.nameLa.bottom).offset(20);
            make.width.equalTo(60);
            make.height.equalTo(60);
        }];
        self.imageBtn = [[PhotoButton alloc]init];
        [self.imageBtn setImage:image forState:UIControlStateNormal];
        self.imageBtn.dic = dic;
        self.imageBtn.tag = i + 10000;
        [self addSubview:self.imageBtn];
        [self.imageBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10+(10*i)+(60*i));
            make.centerY.equalTo(self.addImageBtn);
            make.width.equalTo(60);
            make.height.equalTo(60);
        }];
        [self.imageBtn addTarget:self action:@selector(changeBigImage:) forControlEvents:UIControlEventTouchUpInside];
        
        self.deleteImageBtn = [[PhotoButton alloc]init];
        [self.deleteImageBtn setBackgroundImage:[UIImage imageNamed:@"删除2"] forState:UIControlStateNormal];
        self.deleteImageBtn.dic = dic;
        self.deleteImageBtn.tag = i + 10000;
        [self.imageBtn addSubview:self.deleteImageBtn];
        [self.deleteImageBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.imageBtn.right).offset(0);
            make.top.equalTo(self.imageBtn.top).offset(0);
            make.width.equalTo(20);
            make.height.equalTo(20);
        }];
        [self.deleteImageBtn addTarget:self action:@selector(deletePhotoShow:) forControlEvents:UIControlEventTouchUpInside];
        if (self.projectRecordDic != nil) {
            dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(defaultQueue, ^{
                sleep(0.1);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.3 animations:^{
                        [self layoutIfNeeded];
                    }];
                });
            });
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                [self layoutIfNeeded];
            }];
        }
    });
}
/**
 点击图片放大
 
 @param sender 点击的照片
 */
-(void)changeBigImage:(PhotoButton *)sender
{
    NSData * imageData = sender.dic[@"PickerImage"];
    UIImage *image = [UIImage imageWithData: imageData];
    BigPhotoView * bigView = [[BigPhotoView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) image:image];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:bigView];
//    [self addSubview:bigView];
}
/**
 删除照片
 
 @param sender 点击的删除按钮
 */
-(void)deletePhotoShow:(PhotoButton *)sender
{
    for (PhotoButton * obj in self.subviews) {
        if ([obj isKindOfClass:[PhotoButton class]]) {
            if (obj.tag == sender.tag) {
                [obj removeFromSuperview];
                [sender removeFromSuperview];
                [self.pickerImageArray removeObject:sender.dic];
                [ToolModel deleteFile:sender.dic[@"content_path"]];
                break;
            }
        }
    }
    for (PhotoButton * obj in self.subviews) {
        if ([obj isKindOfClass:[PhotoButton class]]) {
            for (int k = 0; k<self.pickerImageArray.count; k++) {
                if (obj.dic == self.pickerImageArray[k]) {
                    [obj updateConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.left).offset(10+(10*k)+(60*k));
                    }];
                }
            }
        }
    }
    [self.addImageBtn updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(10+(10*self.pickerImageArray.count)+(60*self.pickerImageArray.count));
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}
#pragma mark 签名
//   签名
-(void)signature:(NSDictionary *)dic
{
    self.signatureBtn = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:@"点击签名" textFrame:CGRectMake(5, 0, 0, 0) image:@"qianming" imageFrame:CGRectMake(WIDTH/3-40, 10, 20, 20) font:14];
    self.signatureBtn.la.textColor  =[UIColor whiteColor];
    self.signatureBtn.backgroundColor = [UIColor colorWithRed:0.87 green:0.15 blue:0.23 alpha:1.00];
    [self addSubview:self.signatureBtn];
    [self.signatureBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(10);
        make.top.equalTo(self.nameLa.bottom).offset(20);
        make.width.equalTo(WIDTH/3*2);
        make.height.equalTo(40);
    }];
    
    self.errorBtn = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:@"项目异常" textFrame:CGRectMake(5, 0, 0, 0) image:@"unselecte" imageFrame:CGRectMake(0, 0, 25, 25) font:14];
    [self addSubview:self.errorBtn];
    [self.errorBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-10);
        make.centerY.equalTo(self.signatureBtn);
        make.width.equalTo(80);
        make.height.equalTo(25);
    }];
    [self.errorBtn addTarget:self action:@selector(chooseError:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.projectRecordDic != nil) {
        NSString * uuidStr = self.projectRecordDic[@"data_uuid"];
        if (uuidStr.length != 0) {
            //   当前项目信息记录表
            DataBaseManager * db = [DataBaseManager shareInstance];
            NSArray * array = [db selectSomething:@"data_record" value:[NSString stringWithFormat:@"data_uuid = '%@'",uuidStr] keys:[ToolModel allPropertyNames:[DataModel class]] keysKinds:[ToolModel allPropertyAttributes:[DataModel class]]];
            [db dbclose];
            //   有数据  开始遍历添加
            for (NSDictionary * dict in array) {
                [self hadSignData:dict];
            }
        }
    }
}
/**
 集成正常添加的字典
 
 @param dict 流记录表字典
 */
-(void)hadSignData:(NSDictionary *)dict
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",dict[@"content_path"]]];   // 保存文件的名称
    UIImage * image = [UIImage imageWithContentsOfFile:filePath];
    NSData *data=UIImageJPEGRepresentation(image, 1.0);
    if (data.length == 0) {
        return;
    }
    NSMutableDictionary * muldict = [[NSMutableDictionary alloc]init];
    [muldict setObject:data forKey:@"signimage"];
    [muldict setObject:dict[@"content_path"] forKey:@"content_path"];
    [muldict setObject:dict[@"data_record_show"] forKey:@"data_record_show"];
    [muldict setObject:dict[@"file_name"] forKey:@"file_name"];
    [self addSignImage:muldict];
}
/**
 增加签名

 @param dict 签名图片
 */
-(void)addSignImage:(NSDictionary *)dict
{
    [self.signatureImage removeFromSuperview];
    [self.deleteSignatureBtn removeFromSuperview];
    [self.signMulArray removeAllObjects];
    
    [self.signMulArray addObject:dict];
    NSData * imageData = dict[@"signimage"];
    UIImage *image = [UIImage imageWithData: imageData];
    self.signatureImage = [[UIImageView alloc]init];
    self.signatureImage.image = image;
    [self.contentView addSubview:self.signatureImage];
    [self.signatureImage makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(10);
        make.top.equalTo(self.nameLa.bottom).offset(20);
        make.width.equalTo(100);
        make.height.equalTo(100);
    }];
    
    self.deleteSignatureBtn = [[UIButton alloc]init];
    [ToolControl makeButton:self.deleteSignatureBtn titleColor:[UIColor colorWithRed:0.87 green:0.15 blue:0.23 alpha:1.00] title:@"删除" btnImage:nil cornerRadius:0 font:14];
    [self.contentView addSubview:self.deleteSignatureBtn];
    [self.deleteSignatureBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-10);
        make.centerY.equalTo(self.signatureImage);
        make.width.equalTo(30);
        make.height.equalTo(15);
    }];
    [self.deleteSignatureBtn addTarget:self action:@selector(deleteSign:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.signatureBtn updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLa.bottom).offset(130);
    }];
    if (self.projectRecordDic != nil) {
        dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(defaultQueue, ^{
            sleep(0.1);
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.3 animations:^{
                    [self layoutIfNeeded];
                }];
            });
        });
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        }];
    }
}

/**
 删除签名

 @param sender 点击的删除按钮
 */
-(void)deleteSign:(UIButton *)sender
{
    [self.signatureImage removeFromSuperview];
    [self.deleteSignatureBtn removeFromSuperview];
    for (NSDictionary * dict in self.signMulArray) {
        [ToolModel deleteFile:dict[@"content_path"]];
    }
    [self.signatureBtn updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLa.bottom).offset(20);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PROGRCT_TABLE_RELOAD" object:nil];
}
#pragma mark 文字
//   文字
-(void)text:(NSDictionary *)dic
{
    self.textview = [[UITextView alloc]init];
//    self.textview.text = @"请输入文字描述";
    self.textview.font = [UIFont systemFontOfSize:16];
    self.textview.textColor = [UIColor grayColor];
    self.textview.delegate = self;
    [self addSubview:self.textview];
    [self.textview makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(15);
        make.top.equalTo(self.nameLa.bottom).offset(20);
        make.width.equalTo(WIDTH-20);
        make.height.equalTo(HEIGHT/5);
    }];
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"请输入事件描述";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [placeHolderLabel sizeToFit];
    [self.textview addSubview:placeHolderLabel];
    // same font
    self.textview.font = [UIFont systemFontOfSize:16];
    placeHolderLabel.font = [UIFont systemFontOfSize:16];
    [self.textview setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    
    self.errorBtn = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:@"项目异常" textFrame:CGRectMake(5, 0, 0, 0) image:@"unselecte" imageFrame:CGRectMake(0, 0, 25, 25) font:14];
    [self.contentView addSubview:self.errorBtn];
    [self.errorBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(15);
        make.top.equalTo(self.textview.bottom).offset(10);
        make.width.equalTo(80);
        make.height.equalTo(25);
    }];
    [self.errorBtn addTarget:self action:@selector(chooseError:) forControlEvents:UIControlEventTouchUpInside];
    //   已经巡检过的数据
    if (self.projectRecordDic != nil) {
        if ([self.projectRecordDic[@"items_value_status"] intValue] == 0) {
            self.errorBtn.selected = YES;
        }
        NSString * str = self.projectRecordDic[@"items_value"];
        if (str.length != 0) {
            self.textview.text = str;
        }
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([[ProjectPost isChangeItmesValue:self.projectDic] length] == 0 || self.isPre == 1){
        if ([textView.text isEqualToString:@"请输入文字描述"]) {
            textView.text = nil;
        }
        return YES;
    }else{
         [self isLongTimeAlertShow:[ProjectPost isChangeItmesValue:self.projectDic]];
        return NO;
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    self.finishStr = textView.text;
}
#pragma mark 录音
//   录音
-(void)sound:(NSDictionary *)dic
{
    self.soundBtn = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:@"新增录音" textFrame:CGRectMake(5, 0, 0, 0) image:@"yuyin" imageFrame:CGRectMake(WIDTH/3-40, 10, 20, 20) font:14];
    self.soundBtn.la.textColor  =[UIColor whiteColor];
//    self.soundBtn.layer.masksToBounds = YES;
//    self.soundBtn.layer.cornerRadius = 4.0f;
    self.soundBtn.backgroundColor = [UIColor colorWithRed:0.87 green:0.15 blue:0.23 alpha:1.00];
    [self.contentView addSubview:self.soundBtn];
    [self.soundBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(10);
        make.top.equalTo(self.nameLa.bottom).offset(20);
        make.width.equalTo(WIDTH/3*2);
        make.height.equalTo(40);
    }];
    
    self.errorBtn = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:@"项目异常" textFrame:CGRectMake(5, 0, 0, 0) image:@"unselecte" imageFrame:CGRectMake(0, 0, 25, 25) font:14];
    [self.contentView addSubview:self.errorBtn];
    [self.errorBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-10);
        make.centerY.equalTo(self.soundBtn);
        make.width.equalTo(90);
        make.height.equalTo(25);
    }];
    [self.errorBtn addTarget:self action:@selector(chooseError:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.projectRecordDic != nil) {
        if ([self.projectRecordDic[@"items_value_status"] intValue] == 0) {
            self.errorBtn.selected = YES;
        }
        NSString * uuidStr = self.projectRecordDic[@"data_uuid"];
        if (uuidStr.length != 0) {
            //   当前项目信息记录表
            DataBaseManager * db = [DataBaseManager shareInstance];
            NSArray * array = [db selectSomething:@"data_record" value:[NSString stringWithFormat:@"data_uuid = '%@'",uuidStr] keys:[ToolModel allPropertyNames:[DataModel class]] keysKinds:[ToolModel allPropertyAttributes:[DataModel class]]];
            [db dbclose];
            //   有数据  开始遍历添加
            for (NSDictionary * dict in array) {
                [self hadSoundData:dict];
            }
        }
    }
}
/**
 集成正常添加的字典
 
 @param dict 流记录表字典
 */
-(void)hadSoundData:(NSDictionary *)dict
{
    NSString * str = dict[@"content_path"];
    if (str.length == 0) {
        return;
    }
    NSMutableDictionary * muldict = [[NSMutableDictionary alloc]init];
    [muldict setObject:@([dict[@"data_record_show"] intValue]) forKey:@"videoTime"];
    [muldict setObject:dict[@"content_path"] forKey:@"videoPath"];
    [muldict setObject:dict[@"content_path"] forKey:@"content_path"];
    [muldict setObject:dict[@"data_record_show"] forKey:@"data_record_show"];
    [muldict setObject:dict[@"file_name"] forKey:@"file_name"];
    [self addSound:muldict];
}
//   添加录音
/**
 添加录音

 @param dic 录音路径  时间
 */
-(void)addSound:(NSDictionary *)dic
{
    [self.soundArray addObject:dic];
    int i = (int)self.soundArray.count-1;
    self.soundshowview = [[SoundShowView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) time:[dic[@"videoTime"] intValue]];
    self.soundshowview.tag = i+100;
    self.soundshowview.dict = dic;
    self.soundshowview.soundBtn.dic =dic;
    [self addSubview:self.soundshowview];
    [self.soundshowview makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(0);
        make.top.equalTo(self.nameLa.bottom).offset(20+(10*i)+(30*i));
        make.width.equalTo(WIDTH-60);
        make.height.equalTo(30);
    }];
    
    self.deletesoundBtn  = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:@"删除" textFrame:CGRectMake(5, 0, 0, 0) image:@"删除" imageFrame:CGRectMake(0, 0, 20, 20) font:14];
    self.deletesoundBtn.tag = i+100;
    self.deletesoundBtn.dic = dic;
    [self addSubview:self.deletesoundBtn];
    [self.deletesoundBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.soundshowview.right).offset(0);
        make.centerY.equalTo(self.soundshowview);
        make.width.equalTo(55);
        make.height.equalTo(20);
    }];
    [self.deletesoundBtn addTarget:self action:@selector(deleteSoundShow:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.soundBtn updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLa.bottom).offset(20+(10*self.soundArray.count)+(30*self.soundArray.count));
    }];
    if (self.projectRecordDic != nil) {
        __weak typeof(self) weakSelf = self;
        dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(defaultQueue, ^{
            sleep(0.1);
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.3 animations:^{
                    [self layoutIfNeeded];
                }];
                if (weakSelf.soundArrayCount) {
                    weakSelf.soundArrayCount(self.soundArray);
                }
            });
        });
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        }];
        if (self.soundArrayCount) {
            self.soundArrayCount(self.soundArray);
        }
    }
}
/**
 删除列表中的录音
 
 @param sender 点击的删除按钮
 */
-(void)deleteSoundShow:(ChanceButton *)sender
{
    
    for (SoundShowView * obj in self.subviews) {
        if ([obj isKindOfClass:[SoundShowView class]]) {
            if (obj.tag == sender.tag) {
                [obj removeFromSuperview];
                [sender removeFromSuperview];
                [self.soundArray removeObject:sender.dic];
                [self.videoModel deleteSound:sender.dic[@"videoPath"]];
                break;
            }
        }
    }
    for (SoundShowView * obj in self.subviews) {
        if ([obj isKindOfClass:[SoundShowView class]]) {
            for (int k = 0; k<self.soundArray.count; k++) {
                if (obj.dict == self.soundArray[k]) {
                    [obj updateConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.nameLa.bottom).offset(20+(10*k)+(30*k));
                    }];
                }
            }
        }
    }
    [self.soundBtn updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLa.bottom).offset(20+(10*self.soundArray.count)+(30*self.soundArray.count));
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
    if (self.soundArrayCount) {
        self.soundArrayCount(self.soundArray);
    }
}
#pragma mark 数值
-(void)numberValue:(NSDictionary *)dict
{
    self.numberField = [[UITextField alloc]init];
    self.numberField.delegate = self;
    self.numberField.font = [UIFont systemFontOfSize:16];
    self.numberField.placeholder = @"请输入检查结果";
    self.numberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.numberField.keyboardType=UIKeyboardTypeDecimalPad;
    [self.contentView addSubview:self.numberField];
    [self.numberField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(10);
        make.top.equalTo(self.nameLa.bottom).offset(20);
        make.width.equalTo(WIDTH/2);
        make.height.equalTo(40);
    }];

    DataBaseManager * db = [DataBaseManager shareInstance];
    NSArray * array = [db selectSomething:@"unit_record" value:[NSString stringWithFormat:@"unit_id = %d",[dict[@"unit_id"] intValue]] keys:@[@"unit_id",@"unit_name"] keysKinds:@[@"int",@"NSString"]];
    [db dbclose];
    self.numberLa = [[UILabel alloc]init];
    [ToolControl makeLabel:self.numberLa text:@"单位" font:14];
    if (array.count == 0) {
        self.numberLa.text = @"";
    }else{
        self.numberLa.text = array[0][@"unit_name"];
    }
    [self.contentView addSubview:self.numberLa];
    [self.numberLa makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberField.right).offset(10);
        make.centerY.equalTo(self.numberField);
    }];
    //   已经巡检过的数据
    if (self.projectRecordDic != nil) {
        NSString * str = self.projectRecordDic[@"items_value"];
        if (str.length != 0) {
            self.numberField.text = str;
            double text = [str doubleValue];
            double start = [self.projectDic[@"standar_value_number_start"] doubleValue];
            double end = [self.projectDic[@"standar_value_number_end"] doubleValue];
            if (text < start || text > end) {
                //   不符合标准
                self.numberField.textColor = [UIColor colorWithRed:0.87 green:0.16 blue:0.24 alpha:1.00];
            }else{
                self.numberField.textColor = [UIColor blackColor];
            }
        }
    }
}
//   开始输入数值
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([[ProjectPost isChangeItmesValue:self.projectDic] length] == 0 || self.isPre == 1){
        
        //   弹出输入的窗口
        if (self.fieldAlert == nil) {
            self.fieldAlert = [[FieldAlertView alloc]init];
            UIWindow * window = [UIApplication sharedApplication].keyWindow;
            [window addSubview:self.fieldAlert];
            [self.fieldAlert makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.left).offset(0);
                make.top.equalTo(window.top).offset(0);
                make.width.equalTo(WIDTH);
                make.height.equalTo(HEIGHT);
            }];
        }else{
            self.fieldAlert.hidden = NO;
        }
        return YES;
    }else{
         [self isLongTimeAlertShow:[ProjectPost isChangeItmesValue:self.projectDic]];
        return NO;
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //   判断是否是删除
//    if (string.length == 0) {
//        return YES;
//    }
    double text = [[NSString stringWithFormat:@"%@%@",textField.text,string] doubleValue];
    double start = [self.projectDic[@"standar_value_number_start"] doubleValue];
    double end = [self.projectDic[@"standar_value_number_end"] doubleValue];
    //   判断数值是否符合标准
    if (text < start || text > end) {
        //   不符合标准
        textField.textColor = [UIColor colorWithRed:0.87 green:0.16 blue:0.24 alpha:1.00];
    }else{
        textField.textColor = [UIColor blackColor];
    }
    BOOL kind = NO;
    kind = [self makeNumber:textField.text rangeStr:string];
    if (kind) {
        if (string.length == 0) {
            if ([textField.text length] != 0) {
                self.fieldAlert.fieldLa.text = [textField.text substringToIndex:[textField.text length]-1];
            }
        }else{
            self.fieldAlert.fieldLa.text = [NSString stringWithFormat:@"%@%@",textField.text,string];
        }
    }
    //   判断是否符合规则
    return kind;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.fieldAlert.fieldLa.text = textField.text;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    double text = [textField.text doubleValue];
    double start = [self.projectDic[@"standar_value_number_start"] doubleValue];
    double end = [self.projectDic[@"standar_value_number_end"] doubleValue];
    //   判断数值是否符合标准
    if (text < start || text > end) {
        self.finishi = 0;
        //   不符合标准
        textField.textColor = [UIColor colorWithRed:0.87 green:0.16 blue:0.24 alpha:1.00];
    }else{
        self.finishi = 1;
        textField.textColor = [UIColor blackColor];
    }
    self.finishStr = textField.text;
    
    // 结束输入  隐藏提示框
    self.fieldAlert.hidden = YES;
}
/**
 生成控制数值的正则表达式
 */
-(BOOL)makeNumber:(NSString *)textStr rangeStr:(NSString *)rangeStr
{
    NSString * allStr = [NSString stringWithFormat:@"%@%@",textStr,rangeStr];
    if ([self.projectDic[@"standar_value_format"] length] == 0) {
        return YES;
    }
    NSArray  *array = [self.projectDic[@"standar_value_format"] componentsSeparatedByString:@","];
    if (array.count == 0) {
        return YES;
    }
    //   小数点前
    int i = [array[0] intValue];
    //   小数点后
    int j = [array[1] intValue];
    NSString * numStr;
    if (j == 0) {
        numStr = [NSString stringWithFormat:@"^(\\-)?\\d{0,%d}$",i];
    }else{
        numStr = [NSString stringWithFormat:@"^(\\-)?\\d{0,%d}+(\\.\\d{0,%d})?$",i,j];
    }
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numStr];
    if ([regexPredicate evaluateWithObject:allStr]) {
        return YES;
    }
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"输入错误!" message:[NSString stringWithFormat:@"可以输入%d位整数和%d位小数",i,j] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    return NO;
}
#pragma mark 时间
-(void)time:(NSDictionary *)dict
{
    self.timeBtn = [[TimeButton alloc]init];
    self.timeBtn.dict = self.projectDic;
    if ([dict[@"category"] intValue] == 4) {
        [ToolControl makeButton:self.timeBtn titleColor:[UIColor grayColor] title:@"请点击选择时间" btnImage:nil cornerRadius:4 font:18];
    }else if ([dict[@"category"] intValue] == 9){
        [ToolControl makeButton:self.timeBtn titleColor:[UIColor grayColor] title:@"请点击选择日期" btnImage:nil cornerRadius:4 font:18];
    }else{
        [ToolControl makeButton:self.timeBtn titleColor:[UIColor grayColor] title:@"请点击选择日期和时间" btnImage:nil cornerRadius:4 font:18];
    }
    [self.contentView addSubview:self.timeBtn];
    [self.timeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(10);
        make.top.equalTo(self.nameLa.bottom).offset(25);
        make.width.equalTo(WIDTH-20);
        make.height.equalTo(50);
    }];
    //   已经巡检过的数据
    if (self.projectRecordDic != nil) {
        NSString * str = self.projectRecordDic[@"items_value"];
        if (str.length != 0) {
            [self.timeBtn setTitle:str forState:UIControlStateNormal];
        }
    }
    self.finishi = 1;
}

/**
 添加时间

 @param timeStr 获取的时间
 */
-(void)timeAdd:(NSString *)timeStr
{
    [self.timeBtn setTitle:timeStr forState:UIControlStateNormal];
    self.finishStr = timeStr;
}

/**
 项目异常

 @param sendr <#sendr description#>
 */
-(void)chooseError:(ChanceButton *)sendr
{
    if ([[ProjectPost isChangeItmesValue:self.projectDic] length] == 0 || self.isPre == 1) {
        if (sendr.selected == NO) {
            self.finishi = 0;
            sendr.image.image = [UIImage imageNamed:@"checked"];
            [self showDownLoad:@"检查项异常！"];
        }else{
            self.finishi = 1;
            sendr.image.image = [UIImage imageNamed:@"unselecte"];
        }
        sendr.selected = !sendr.selected;
    }else{
        [self isLongTimeAlertShow:[ProjectPost isChangeItmesValue:self.projectDic]];
    }
}
-(void)showDownLoad:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.xOffset = 0.1;
    hud.yOffset = MBProgressHUDModeText;
    [hud hide:YES afterDelay:2];
    
}
/**
 时间过长不允许更改提示
 */
-(void)isLongTimeAlertShow:(NSString *)title
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:title message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
}
-(UIView *)makeLineView
{
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    [self.contentView addSubview:self.lineView];
    return self.lineView;
}
- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 10;
    frame.size.height -= 10;
    
    [super setFrame:frame];
}
-(NSMutableArray *)pickerImageArray
{
    if (_pickerImageArray == nil) {
        _pickerImageArray = [[NSMutableArray alloc]init];
    }
    return _pickerImageArray;
}
-(NSMutableArray *)soundArray
{
    if (_soundArray == nil) {
        _soundArray = [[NSMutableArray alloc]init];
    }
    return _soundArray;
}
-(VideoRecordModel *)videoModel
{
    if (_videoModel == nil) {
        _videoModel = [[VideoRecordModel alloc]init];
    }
    return _videoModel;
}
-(NSMutableArray *)chaooseArray
{
    if (_chaooseArray == nil) {
        _chaooseArray = [[NSMutableArray alloc]init];
    }
    return _chaooseArray;
}
-(NSMutableArray *)signMulArray
{
    if (_signMulArray == nil) {
        _signMulArray = [[NSMutableArray alloc]init];
    }
    return _signMulArray;
}
-(NSString *)finishStr
{
    if (_finishStr == nil) {
        _finishStr = [[NSString alloc]init];
    }
    return _finishStr;
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
