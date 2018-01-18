//
//  EventView.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/5.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "EventView.h"
#import "ToolControl.h"
#import "BigPhotoView.h"
#import "DataBaseManager.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "AllKindModel.h"
#import "DataModel.h"
#import "DeviceModel.h"
@implementation EventView

-(instancetype)initWithFrame:(CGRect)frame dictionary:(NSDictionary *)dictionary
{
    self = [super initWithFrame:frame];
    if (self) {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.88, 0.89, 0.89, 1.00 });
        
        DataBaseManager * db = [DataBaseManager shareInstance];
        self.eventArray = [db selectAll:@"event_record" keys:@[@"event_mark",@"event_name"] keysKinds:@[@"int",@"NSString"]];
        
        self.rightBtn = [[UIButton alloc]init];
        [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
        self.rightBtn.frame=CGRectMake(0, 0, 20, 20);
        self.rightBtn.adjustsImageWhenHighlighted=NO;
        [self.rightBtn addTarget:self action:@selector(eventRecordShow:) forControlEvents:UIControlEventTouchUpInside];
        
        self.titleField = [[LeftAndRightTextField alloc]initWithFrame:CGRectMake(0, 0, 0, 0) drawingLeft:nil drawingRight:self.rightBtn];
        self.titleField.font = [UIFont systemFontOfSize:18];
        self.titleField.placeholder = @"请输入事件标题";
        self.titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.titleField.textAlignment  = NSTextAlignmentCenter;
        [self addSubview:self.titleField];
        [self.titleField makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
            make.top.equalTo(self.top).offset(0);
            make.width.equalTo(WIDTH-20);
            make.height.equalTo(50);
        }];
        
        self.textView = [[UITextView alloc]init];
        self.textView.textColor = [UIColor grayColor];
        self.textView.delegate = self;
        [self addSubview:self.textView];
        [self.textView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
            make.top.equalTo(self.titleField.bottom).offset(0);
            make.width.equalTo(WIDTH-20);
            make.height.equalTo(HEIGHT/5);
        }];
        self.textView.layer.borderWidth = 1.0;
        self.textView.layer.borderColor = colorref;
        
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.text = @"请输入事件描述";
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = [UIColor lightGrayColor];
        [placeHolderLabel sizeToFit];
        [self.textView addSubview:placeHolderLabel];
        // same font
        self.textView.font = [UIFont systemFontOfSize:15];
        placeHolderLabel.font = [UIFont systemFontOfSize:15];
        [self.textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
        
        
        
        self.photoAddBtn = [[PhotoAddButton alloc]init];
        self.photoAddBtn.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.photoAddBtn];
        [self.photoAddBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
            make.top.equalTo(self.textView.bottom).offset(10);
            make.width.equalTo(60);
            make.height.equalTo(60);
        }];
        
        self.equipmentBtn = [[UIButton alloc]init];
        [ToolControl makeButton:self.equipmentBtn titleColor:nil title:nil btnImage:@"设备" cornerRadius:20 font:0];
        self.equipmentBtn.layer.borderWidth = 1.0;
        self.equipmentBtn.layer.borderColor = colorref;
        [self addSubview:self.equipmentBtn];
        [self.equipmentBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
            make.bottom.equalTo(self.bottom).offset(-10);
            make.width.equalTo(40);
            make.height.equalTo(40);
        }];
        
        self.soundBtn = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) imageSound:@"语音" text:@"按住录音"];
        self.soundBtn.layer.borderWidth = 1.0;
        self.soundBtn.layer.borderColor = colorref;
        [self addSubview:self.soundBtn];
        [self.soundBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(70);
            make.bottom.equalTo(self.bottom).offset(-10);
            make.width.equalTo(WIDTH-80);
            make.height.equalTo(40);
        }];

        
        //开始监听用户的语音
        [self.soundBtn addTarget:self action:@selector(touchSpeak:) forControlEvents:UIControlEventTouchDown];
        //开始停止监听 并处理用户的输入
        [self.soundBtn addTarget:self action:@selector(stopSpeak:) forControlEvents:UIControlEventTouchUpInside];
        //取消这一次的监听4
        [self.soundBtn addTarget:self action:@selector(cancelSpeak:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        //   从项目进入  并且有数据
        if (dictionary != nil) {
            DataBaseManager * db = [DataBaseManager shareInstance];
            //   先查询出跟此项目相关联的事件住记录
            NSArray * eventArray = [db selectSomething:@"allkind_record" value:[NSString stringWithFormat:@"items_uuid = '%@'",dictionary[@"items_uuid"]] keys:[ToolModel allPropertyNames:[AllKindModel class]] keysKinds:[ToolModel allPropertyAttributes:[AllKindModel class]]];
            //   根据事件的住记录data  查询出流数据
            NSArray * dataArray;
            if (eventArray.count != 0) {
                dataArray = [db selectSomething:@"data_record" value:[NSString stringWithFormat:@"data_uuid = '%@'",eventArray[0][@"data_uuid"]] keys:[ToolModel allPropertyNames:[DataModel class]] keysKinds:[ToolModel allPropertyAttributes:[DataModel class]]];
            }
            NSMutableArray * photoArr = [[NSMutableArray alloc]init];
            NSMutableArray * soundArr = [[NSMutableArray alloc]init];
            NSString * word = [[NSString alloc]init];
            for (NSDictionary * datadict in dataArray) {
                //   判断流记录类型  并使用查询出来的数据  集成正常可以显示的数据
                if ([datadict[@"event_category"] isEqualToString:@"PHOTO"]) {
                    NSDictionary * dict = [self hadImageData:datadict];
                    [photoArr addObject:dict];
                }else if ([datadict[@"event_category"] isEqualToString:@"VOICE"]){
                    NSDictionary * dict = [self hadSoundData:datadict];
                    [soundArr addObject:dict];
                }else if ([datadict[@"event_category"] isEqualToString:@"TEXT"]){
                    word = [self hadWordData:datadict];
                }
            }
            //   将所有信息集成在一起
            NSMutableDictionary * muldict = [[NSMutableDictionary alloc]init];
            if (photoArr.count != 0) {
                [muldict setObject:photoArr forKey:@"photo"];
            }
            if (soundArr.count != 0) {
                [muldict setObject:soundArr forKey:@"sound"];
            }
            if (word.length != 0) {
                [muldict setObject:word forKey:@"word"];
            }
            [self projectAddEvent:muldict];
        }
        
    }
    return self;
}
/**
 集成正常添加的字典
 
 @param dict 流记录表字典
 */
-(NSDictionary *)hadImageData:(NSDictionary *)dict
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",dict[@"content_path"]]];   // 保存文件的名称
    UIImage * image = [UIImage imageWithContentsOfFile:filePath];
    NSData *data=UIImageJPEGRepresentation(image, 1.0);
    if (data.length == 0) {
        return nil;
    }
    NSMutableDictionary * muldict = [[NSMutableDictionary alloc]init];
    [muldict setObject:data forKey:@"PickerImage"];
    [muldict setObject:dict[@"content_path"] forKey:@"content_path"];
    [muldict setObject:dict[@"data_record_show"] forKey:@"data_record_show"];
    [muldict setObject:dict[@"file_name"] forKey:@"file_name"];
    
    return muldict;
}
/**
 集成正常添加的字典
 
 @param dict 流记录表字典
 */
-(NSDictionary *)hadSoundData:(NSDictionary *)dict
{
    NSString * str = dict[@"content_path"];
    if (str.length == 0) {
        return nil;
    }
    NSMutableDictionary * muldict = [[NSMutableDictionary alloc]init];
    [muldict setObject:@([dict[@"data_record_show"] intValue]) forKey:@"videoTime"];
    [muldict setObject:dict[@"content_path"] forKey:@"videoPath"];
    [muldict setObject:dict[@"content_path"] forKey:@"content_path"];
    [muldict setObject:dict[@"data_record_show"] forKey:@"data_record_show"];
    [muldict setObject:dict[@"file_name"] forKey:@"file_name"];
    
    return muldict;
}
-(NSString *)hadWordData:(NSDictionary *)dict
{
    NSString * word = dict[@"file_name"];
    if (word.length == 0) {
        return nil;
    }
    
    return word;
}

/**
 点开预置事件表

 @param sender 点击的按钮
 */
-(void)eventRecordShow:(UIButton *)sender
{
    if (sender.selected == NO) {
        [UIView animateWithDuration:0.1f animations:^{
            sender.transform = CGAffineTransformMakeRotation(-90 * M_PI/180.0);
            if (self.eventArray.count > 0) {
                self.eventTable = [[UITableView alloc]init];
                self.eventTable.delegate = self;
                self.eventTable.dataSource = self;
                self.eventTable.alpha = 0.8;
                self.eventTable.layer.masksToBounds = YES;
                self.eventTable.layer.cornerRadius = 12;
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.70, 0.70, 0.70, 1.00 });
                self.eventTable.layer.borderWidth = 1.0;
                self.eventTable.layer.borderColor = colorref;
                [self addSubview:self.eventTable];
                [self.eventTable makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.right).offset(-10);
                    make.top.equalTo(self.titleField.bottom).offset(0);
                    make.width.equalTo(WIDTH/3);
                    make.height.equalTo(self.eventArray.count*40);
                }];
            }
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:0.5f animations:^{
            //        复原
            sender.transform = CGAffineTransformIdentity;
            if (self.eventTable != nil) {
                [self.eventTable removeFromSuperview];
                self.eventTable = nil;
            }
            
        } completion:^(BOOL finished) {
            
        }];
    }
    sender.selected = !sender.selected;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.eventArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //优化内存  表格的复用
    static NSString * identity=@"cell";
    self.self.cell=[tableView dequeueReusableCellWithIdentifier:identity];
    if (self.cell==nil) {
        self.cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identity];
    }
    NSDictionary * namedic=[self.eventArray objectAtIndex:indexPath.row];
    self.cell.textLabel.text=namedic[@"event_name"];
    return self.cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return  40.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * namedic=[self.eventArray objectAtIndex:indexPath.row];
    self.titleField.text = namedic[@"event_name"];
    [UIView animateWithDuration:0.5f animations:^{
        //        复原
        self.rightBtn.transform = CGAffineTransformIdentity;
        if (self.eventTable != nil) {
            [self.eventTable removeFromSuperview];
            self.eventTable = nil;
        }
    } completion:^(BOOL finished) {
        
    }];
}
/**
 将项目中的数据  加到事件页面

 @param dict 数据
 */
-(void)projectAddEvent:(NSDictionary *)dict
{
    ///    添加文字
    self.textView.text = dict[@"word"];
    
    ///   添加照片
    NSArray * imageArray = dict[@"photo"];
    for (int j = 0; j<imageArray.count; j++) {
        [self photoAdd:imageArray[j]];
        }
    
    //    添加录音
    NSArray * videoArraay = dict[@"sound"];
    for (int j = 0; j<videoArraay.count; j++) {
        [self.soundArray addObject:videoArraay[j]];
        int i = (int)self.soundArray.count-1;
        
        self.soundView = [[SoundShowView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) time:[videoArraay[j][@"videoTime"] intValue]];
        self.soundView.tag = i+100;
        self.soundView.dict = videoArraay[j];
        self.soundView.soundBtn.dic =videoArraay[j];
        [self addSubview:self.soundView];
        [self.soundView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(0);
            make.top.equalTo(self.photoAddBtn.bottom).offset(20+(10*i)+(30*i));
            make.width.equalTo(WIDTH-60);
            make.height.equalTo(30);
        }];
        
        self.deleteBtn  = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:@"删除" textFrame:CGRectMake(5, 0, 0, 0) image:@"删除" imageFrame:CGRectMake(0, 0, 20, 20) font:14];
        self.deleteBtn.tag = i+100;
        self.deleteBtn.dic = videoArraay[j];
        [self addSubview:self.deleteBtn];
        [self.deleteBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.soundView.right).offset(0);
            make.centerY.equalTo(self.soundView);
            make.width.equalTo(55);
            make.height.equalTo(20);
        }];
        [self.deleteBtn addTarget:self action:@selector(deleteSoundShow:) forControlEvents:UIControlEventTouchUpInside];
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        }];

    }
}
//   文字
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView == self.textView) {
        if ([textView.text isEqualToString:@"请输入事件描述"]) {
            textView.text = nil;
        }
    }
    return YES;
}
/**
 增加设备

 @param dic 设备码
 */
-(void)equipmentAdd:(NSDictionary *)dic
{
    if ([self.equipmentArray containsObject:dic]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"该设备已经被添加！" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"All_sure",@"") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self.equipmentArray addObject:dic];
    int i = (int)self.equipmentArray.count-1;
    
    //   根据二维码查询出设备名称显示  如果没有设备显示二维码号
    CGSize eqSize ;
    if ([dic[@"scanCode"] length] > 10) {
        NSString * deviceNameCode = [dic[@"scanCode"] substringToIndex:10];
        DataBaseManager * db = [DataBaseManager shareInstance];
        NSArray * allDeviceArr = [db selectAll:@"device_record" keys:[ToolModel allPropertyNames:[DeviceModel class]] keysKinds:[ToolModel allPropertyAttributes:[DeviceModel class]]];
        for (NSDictionary * deviceDict in allDeviceArr) {
            NSArray * hadQrArr = [deviceDict[@"device_number_qr"] componentsSeparatedByString:@","];
            if ([hadQrArr containsObject:deviceNameCode]) {
                eqSize = [ToolControl makeText:deviceDict[@"device_name"] font:14];
            }
        }
    }
    if (eqSize.width == 0) {
        eqSize = [ToolControl makeText:dic[@"scanCode"] font:14];
    }
    
    self.equipmentShowBtn  = [[EuipmentShowButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:dic[@"scanCode"] textFrame:CGRectMake(10, 0, 0, 0) image:@"设备2" imageFrame:CGRectMake(0, 0, 30, 30) font:14];
    self.equipmentShowBtn.tag = i+1000;
    self.equipmentShowBtn.dic = dic;
    [self addSubview:self.equipmentShowBtn];
    [self.equipmentShowBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(10);
        make.top.equalTo(self.textView.bottom).offset(10+(10*i)+(30*i));
        make.height.equalTo(30);
        make.width.equalTo(eqSize.width+50);
    }];
    
    self.deleteBtn  = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:@"删除" textFrame:CGRectMake(10, 0, 0, 0) image:@"删除" imageFrame:CGRectMake(0, 0, 20, 20) font:14];
    self.deleteBtn.tag = i+1000;
    self.deleteBtn.dic = dic;
    [self addSubview:self.deleteBtn];
    [self.deleteBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.equipmentShowBtn.right).offset(0);
        make.centerY.equalTo(self.equipmentShowBtn);
        make.width.equalTo(55);
        make.height.equalTo(20);
    }];
    [self.deleteBtn addTarget:self action:@selector(deleteEquipmentShow:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.photoAddBtn updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(10+(10*self.pickerImageArray.count)+(60*self.pickerImageArray.count));
        make.top.equalTo(self.textView.bottom).offset(10+(10*self.equipmentArray.count)+(30*self.equipmentArray.count));
        make.width.equalTo(60);
        make.height.equalTo(60);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

/**
 删除绑定的设备

 @param sender 点击的删除按钮
 */
-(void)deleteEquipmentShow:(ChanceButton *)sender
{

    for (EuipmentShowButton * obj in self.subviews) {
        if ([obj isKindOfClass:[EuipmentShowButton class]]) {
            if (obj.tag == sender.tag) {
                [obj removeFromSuperview];
                [sender removeFromSuperview];
                [self.equipmentArray removeObject:sender.dic];
                break;
            }
        }
    }

    for (EuipmentShowButton * obj in self.subviews) {
        if ([obj isKindOfClass:[EuipmentShowButton class]]) {
            for (int k = 0; k<self.equipmentArray.count; k++) {
                if (obj.dic == self.equipmentArray[k]) {
                    [obj updateConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.textView.bottom).offset(10+(10*k)+(30*k));
                    }];
                }
            }
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}
/**
 添加照片

 @param dic 照片
 */
-(void)photoAdd:(NSDictionary *)dic
{
    if (dic == nil) {
        return;
    }
    NSData * imageData = dic[@"PickerImage"];
    [self.pickerImageArray addObject:dic];
    UIImage *image = [UIImage imageWithData: imageData];
    int i = (int)self.pickerImageArray.count-1;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.photoAddBtn updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10+(10*self.pickerImageArray.count)+(60*self.pickerImageArray.count));
            make.top.equalTo(self.textView.bottom).offset(10+(10*self.equipmentArray.count)+(30*self.equipmentArray.count));
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
            make.centerY.equalTo(self.photoAddBtn);
            make.width.equalTo(60);
            make.height.equalTo(60);
        }];
        [self.imageBtn addTarget:self action:@selector(changeBigImage:) forControlEvents:UIControlEventTouchUpInside];
        
        self.photoDeleteBtn = [[PhotoButton alloc]init];
        [self.photoDeleteBtn setBackgroundImage:[UIImage imageNamed:@"删除2"] forState:UIControlStateNormal];
        self.photoDeleteBtn.dic = dic;
        self.photoDeleteBtn.tag = i + 10000;
        [self.imageBtn addSubview:self.photoDeleteBtn];
        [self.photoDeleteBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.imageBtn.right).offset(0);
            make.top.equalTo(self.imageBtn.top).offset(0);
            make.width.equalTo(20);
            make.height.equalTo(20);
        }];
        [self.photoDeleteBtn addTarget:self action:@selector(deletePhotoShow:) forControlEvents:UIControlEventTouchUpInside];
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        }];
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
    [self.photoAddBtn updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(10+(10*self.pickerImageArray.count)+(60*self.pickerImageArray.count));
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}
/**
 添加录音
 */
//  开始录音
-(void)touchSpeak:(UIButton *)sender
{
     dispatch_async(dispatch_get_main_queue(), ^{
         sender.backgroundColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.00];
         [self.video makeConstraints:^(MASConstraintMaker *make) {
             make.centerX.equalTo(self);
             make.centerY.equalTo(self);
             make.width.equalTo(140);
             make.height.equalTo(140);
         }];
     });
    [self.videoModel startRecordVideo:NO];
}
//  完成录音  将录音排列在view中
-(void)stopSpeak:(UIButton *)sender
{
    sender.backgroundColor = [UIColor whiteColor];
    [self.video removeFromSuperview];
    self.video = nil;
    NSDictionary * dict = [self.videoModel startRecordVideo:YES];
    if (dict == nil) {
        NSLog(@"录音时间太短！");
        return;
    }
    [self.soundArray addObject:dict];
    int i = (int)self.soundArray.count-1;
    
    self.soundView = [[SoundShowView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) time:[dict[@"videoTime"] intValue]];
    self.soundView.tag = i+100;
    self.soundView.dict = dict;
    self.soundView.soundBtn.dic =dict;
    [self addSubview:self.soundView];
    [self.soundView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(0);
        make.top.equalTo(self.photoAddBtn.bottom).offset(20+(10*i)+(30*i));
        make.width.equalTo(WIDTH-60);
        make.height.equalTo(30);
    }];
    
    self.deleteBtn  = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:@"删除" textFrame:CGRectMake(5, 0, 0, 0) image:@"删除" imageFrame:CGRectMake(0, 0, 20, 20) font:14];
    self.deleteBtn.tag = i+100;
    self.deleteBtn.dic = dict;
    [self addSubview:self.deleteBtn];
    [self.deleteBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.soundView.right).offset(0);
        make.centerY.equalTo(self.soundView);
        make.width.equalTo(55);
        make.height.equalTo(20);
    }];
    [self.deleteBtn addTarget:self action:@selector(deleteSoundShow:) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
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
                        make.top.equalTo(self.photoAddBtn.bottom).offset(20+(10*k)+(30*k));
                    }];
                }
            }
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}
//   取消录音
-(void)cancelSpeak:(UIButton *)sender
{
    sender.backgroundColor = [UIColor whiteColor];
    NSDictionary * dict = [self.videoModel startRecordVideo:YES];
    [self.videoModel deleteSound:dict[@"videoPath"]];
    [self.video removeFromSuperview];
    self.video = nil;
}
-(NSMutableArray *)equipmentArray
{
    if (_equipmentArray == nil) {
        _equipmentArray = [[NSMutableArray alloc]init];
    }
    return _equipmentArray;
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
-(VideoView *)video
{
    if (_video == nil) {
        _video = [[VideoView alloc]init];
        [self addSubview:_video];
    }
    return _video;
}
@end
