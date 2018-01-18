//
//  SoundShowView.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/28.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "SoundShowView.h"
#import "ToolControl.h"
@implementation SoundShowView

-(instancetype)initWithFrame:(CGRect)frame time:(int)time
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.soundBtn = [[PhotoButton alloc]init];
        [self.soundBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
        [self.soundBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateSelected];
        [self addSubview:self.soundBtn];
        [self.soundBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(10);
            make.top.equalTo(self.top).offset(0);
            make.width.equalTo(30);
            make.height.equalTo(30);
        }];
        [self.soundBtn addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
        
        //   进度条
        self.progress = [[UISlider alloc]init];
        self.progress.enabled = NO;
        UIImage *image = [UIImage imageNamed:@"spot_red"];
//        [self OriginImage:[UIImage imageNamed:@"spot_red"] scaleToSize:CGSizeMake(5, 5)];
        [self.progress setThumbImage:image forState:UIControlStateNormal];
        [self.progress setThumbImage:image forState:UIControlStateHighlighted];
        
        self.progress.minimumTrackTintColor = [UIColor colorWithRed:0.80 green:0.09 blue:0.15 alpha:1.00];
        self.progress.maximumTrackTintColor = [UIColor grayColor];
        
        [self.progress addTarget:self action:@selector(processChanged) forControlEvents:UIControlEventValueChanged];
        [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(updateSliderValue) userInfo:nil repeats:YES];
        [self addSubview:self.progress];
        [self.progress makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.soundBtn.right).offset(10);
            make.centerY.equalTo(self.soundBtn);
            make.width.equalTo(WIDTH-150);
            make.height.equalTo(3);
        }];
        
        int min = time/60;
        int sec = time%60;
        
        self.soundTimeLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.soundTimeLa text:[NSString stringWithFormat:@"%02d:%02d",min,sec] font:14];
        self.soundTimeLa.textColor = [UIColor grayColor];
        [self addSubview:self.soundTimeLa];
        [self.soundTimeLa makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.progress.right).offset(2);
            make.centerY.equalTo(self.progress);
        }];

    }
    return self;
}
-(void)playVideo:(PhotoButton *)sender
{
    if ([self.player isPlaying]) {
        [self.player pause];
    }else{
        NSError *playError;
        NSString * str = [sender.dic[@"videoPath"] substringToIndex:[sender.dic[@"videoPath"] length] - 4];
        NSString *mp3FilePath = [NSString stringWithFormat:@"%@.caf",str];
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:mp3FilePath] error:&playError];
        self.player.delegate=self;
        if (self.player == nil) {
            UIAlertView *alertView=[[ UIAlertView alloc ] initWithTitle :NSLocalizedString(@"Record_video_play_field",@"")
                                                                message :nil
                                                               delegate : nil
                                                      cancelButtonTitle : NSLocalizedString(@"All_sure",@"")
                                                      otherButtonTitles : nil ];
            [alertView show ];
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
    self.soundBtn.selected = NO;
}
-(UIImage*) OriginImage:(UIImage*)image scaleToSize:(CGSize)size

{
    UIGraphicsBeginImageContext(size);//size为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}
@end
