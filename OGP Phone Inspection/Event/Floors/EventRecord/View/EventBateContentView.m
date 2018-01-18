//
//  EventBateContentView.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/27.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "EventBateContentView.h"
#import "ChanceButton.h"
#import "ToolControl.h"
#import "PhotoButton.h"
#import "BigPhotoView.h"
//#import "AppDelegate.h"
@implementation EventBateContentView

-(instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array eventdict:(NSDictionary *)eventdict
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        //   遍历出文字信息
        for (NSDictionary * dict in array) {
            if ([dict[@"event_category"] isEqualToString:@"TEXT"]) {
                self.textLa = [[UILabel alloc]init];
                [ToolControl makeLabel:self.textLa text:dict[@"file_name"] font:16];
                NSAttributedString *attrText = [ToolControl makeAttribute:self.textLa.text firstLine:self.textLa.font.pointSize * 2 head:0.0 tail:0.0 lineSpacing:2.0];
                self.textLa.textColor = [UIColor grayColor];
                self.textLa.attributedText = attrText;
                self.textLa.numberOfLines = 0;
                [self addSubview:self.textLa];
                [self.textLa makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.left).offset(10);
                    make.top.equalTo(self.top).offset(10);
                    make.width.equalTo(WIDTH-30);
                }];
            }
        }
        //   如果没有文字信息   为图片增加一个相对位置
        if (self.textLa == nil) {
            self.textLa = [[UILabel alloc]init];
            [self addSubview:self.textLa];
            [self.textLa makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.left).offset(10);
                make.top.equalTo(self.top).offset(10);
                make.width.equalTo(WIDTH-30);
            }];
        }
        //   设备信息
        NSString * str = eventdict[@"event_device_code"];
        if (str.length != 0) {
            NSArray  * devicearray = [eventdict[@"event_device_code"] componentsSeparatedByString:@","];
            for (int i = 0; i < devicearray.count; i ++ ) {
                self.equipmentBtn  = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:devicearray[i] textFrame:CGRectMake(10, 0, 0, 0) image:@"设备2" imageFrame:CGRectMake(10, 10, 20, 20) font:14];
                CGSize equipmentSize = [ToolControl makeText:devicearray[i] font:14];

                self.equipmentBtn.backgroundColor = [UIColor whiteColor];
                [self addSubview:self.equipmentBtn];
                [self.equipmentBtn makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.left).offset(5);
                    make.top.equalTo(self.textLa.bottom).offset(10+(10*i)+(20*i));
                    make.width.equalTo(45+equipmentSize.width);
                }];
            }
        }
        //   如果没有设备信息   为图片增加一个相对位置
        if (self.equipmentBtn == nil) {
            self.equipmentBtn  = [[ChanceButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) text:@"" textFrame:CGRectMake(10, 0, 0, 0) image:nil imageFrame:CGRectMake(1, 1, 1, 1) font:14];
            [self addSubview:self.equipmentBtn];
            [self.equipmentBtn makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.left).offset(5);
                make.top.equalTo(self.textLa.bottom).offset(0);
                make.width.equalTo(10);
                make.height.equalTo(1);
            }];
        }
        //    遍历出图片信息
        int j = 0;
        for (int i=0; i<array.count; i++) {
            if ([array[i][@"event_category"] isEqualToString:@"PHOTO"]) {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",array[i][@"content_path"]]];   // 保存文件的名称
                UIImage * image = [UIImage imageWithContentsOfFile:filePath];
                self.photoImage = [[PhotoButton alloc]init];
                self.photoImage.dic = [self hadImageData:array[i]];
                self.photoImage.backgroundColor = [UIColor grayColor];
                [self.photoImage setImage:image forState:UIControlStateNormal];
                [self addSubview:self.photoImage];
                [self.photoImage makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.left).offset(10+(10*j)+(60*j));
                    make.top.equalTo(self.equipmentBtn.bottom).offset(20);
                    make.width.equalTo(60);
                    make.height.equalTo(60);
                }];
                [self.photoImage addTarget:self action:@selector(bigImageBtn:) forControlEvents:UIControlEventTouchUpInside];
                j ++;
            }
        }
        //   如果没有图片信息   为录音增加一个相对位置
        if (self.photoImage == nil) {
            self.photoImage = [[PhotoButton alloc]init];
            [self addSubview:self.photoImage];
            [self.photoImage makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.left).offset(5);
                make.top.equalTo(self.equipmentBtn.bottom).offset(0);
                make.width.equalTo(10);
                make.height.equalTo(1);
            }];
        }
        //   遍历出录音信息
        int k = 0;
        for (int i=0; i<array.count; i++) {
            if ([array[i][@"event_category"] isEqualToString:@"VOICE"]){
                NSDictionary * dict = [self hadSoundData:array[i]];
                self.soundshow = [[SoundShowView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) time:[dict[@"videoTime"] intValue]];
                self.soundshow.tag = i+100;
                self.soundshow.dict = dict;
                self.soundshow.soundBtn.dic = dict;
                [self addSubview:self.soundshow];
                [self.soundshow makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.left).offset(0);
                    make.top.equalTo(self.photoImage.bottom).offset(20+(10*k)+(30*k));
                    make.width.equalTo(WIDTH-60);
                    make.height.equalTo(30);
                }];
                k++;
            }
        }
//        self.soundImage = [[PhotoButton alloc]init];
//        [self.soundImage setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
//        [self.soundImage setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateSelected];
//        [self addSubview:self.soundImage];
//        [self.soundImage makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.left).offset(10);
//            make.top.equalTo(self.photoImage.bottom).offset(20);
//            make.width.equalTo(30);
//            make.height.equalTo(30);
//        }];
//        [self.soundImage addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
//
//        
//        //   进度条
//        //   进度条
//        self.progress = [[UISlider alloc]init];
//        self.progress.enabled = NO;
//        UIImage *image = [UIImage imageNamed:@"spot_red"];
//        //        [self OriginImage:[UIImage imageNamed:@"spot_red"] scaleToSize:CGSizeMake(5, 5)];
//        [self.progress setThumbImage:image forState:UIControlStateNormal];
//        [self.progress setThumbImage:image forState:UIControlStateHighlighted];
//        
//        self.progress.minimumTrackTintColor = [UIColor colorWithRed:0.80 green:0.09 blue:0.15 alpha:1.00];
//        self.progress.maximumTrackTintColor = [UIColor grayColor];
//        
//        [self.progress addTarget:self action:@selector(processChanged) forControlEvents:UIControlEventValueChanged];
//        [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(updateSliderValue) userInfo:nil repeats:YES];
//        [self addSubview:self.progress];
//        [self.progress makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.soundImage.right).offset(10);
//            make.centerY.equalTo(self.soundImage);
//            make.width.equalTo(WIDTH-120);
//            make.height.equalTo(2);
//        }];
//        
//        self.soundTimeLa = [[UILabel alloc]init];
//        [ToolControl makeLabel:self.soundTimeLa text:@"03:32" font:14];
//        self.soundTimeLa.textColor = [UIColor grayColor];
//        [self addSubview:self.soundTimeLa];
//        [self.soundTimeLa makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.progress.right).offset(10);
//            make.centerY.equalTo(self.progress);
//        }];
        
    }
    return self;
}
/**
 集成正常添加的字典  录音
 
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
/**
 集成正常添加的字典   图片
 
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
 图片放大

 @param sender 点击的图片按钮
 */
-(void)bigImageBtn:(PhotoButton *)sender
{
    NSData * imageData = sender.dic[@"PickerImage"];
    UIImage *image = [UIImage imageWithData: imageData];
    BigPhotoView * bigView = [[BigPhotoView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) image:image];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:bigView];
//    [self addSubview:bigView];
}

-(void)playVideo:(PhotoButton *)sender
{
    if ([self.player isPlaying]) {
        [self.player pause];
    }else{
        NSError *playError;
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:sender.dic[@"videoPath"]] error:&playError];
        self.player.delegate=self;
        if (self.player == nil) {
            UIAlertView *alertView=[[ UIAlertView alloc ] initWithTitle : @"语音文件丢失！"
                                                                message : nil
                                                               delegate : nil
                                                      cancelButtonTitle : NSLocalizedString(@"All_sure",@"")
                                                      otherButtonTitles : nil ];
            [alertView show];
            return;
        }
        [self.player play];
    }
    sender.selected = !sender.selected;
}

-(void)processChanged
{
    [self.player setCurrentTime:self.progress.value*self.player.duration];
}

-(void)updateSliderValue
{
    self.progress.value = self.player.currentTime/self.player.duration;
}
//当播放结束后调用这个方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.soundImage.selected = NO;
}
@end
