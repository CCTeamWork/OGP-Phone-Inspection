//
//  SoundVideoView.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/8/8.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "SoundVideoView.h"
#import "ToolControl.h"
@implementation SoundVideoView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0.3
                                                 green:0.3
                                                  blue:0.3
                                                 alpha:0.7]];
        
        self.videoview = [[UIView alloc]init];
        self.videoview.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.videoview];
        [self.videoview makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(0);
            make.bottom.equalTo(self.bottom).offset(-64);
            make.width.equalTo(WIDTH);
            make.height.equalTo(HEIGHT/5);
        }];
        
        
        self.videoBtn = [[UIButton alloc]init];
        [self.videoBtn setImage:[UIImage imageNamed:@"send_yuyin"] forState:UIControlStateNormal];
        [self.videoview addSubview:self.videoBtn];
        [self.videoBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.videoview);
            make.top.equalTo(self.videoview.top).offset(20);
            make.width.equalTo(60);
            make.height.equalTo(60);
        }];
        //开始监听用户的语音
        [self.videoBtn addTarget:self action:@selector(touchSpeak:) forControlEvents:UIControlEventTouchDown];
        //开始停止监听 并处理用户的输入
        [self.videoBtn addTarget:self action:@selector(stopSpeak:) forControlEvents:UIControlEventTouchUpInside];
        //取消这一次的监听4
        [self.videoBtn addTarget:self action:@selector(cancelSpeak:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];

        
        self.videoLa = [[UILabel alloc]init];
        [ToolControl makeLabel:self.videoLa text:@"按住录音" font:14];
        [self.videoview addSubview:self.videoLa];
        [self.videoLa makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.videoview);
            make.top.equalTo(self.videoBtn.bottom).offset(20);
        }];
        self.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBigImage)];
        [self addGestureRecognizer:tapGesture];

    }
    return self;
}

//  开始录音
-(void)touchSpeak:(UIButton *)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        sender.backgroundColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.00];
        self.showview = [[VideoView alloc]init];
        [self addSubview:self.showview];
        [self.showview makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.bottom).offset(-HEIGHT/2);
            make.width.equalTo(140);
            make.height.equalTo(140);
        }];
    });
    [self.videoModel startRecordVideo:NO];
}
//  完成录音
-(void)stopSpeak:(UIButton *)sender
{
    sender.backgroundColor = [UIColor whiteColor];
    [self.showview removeFromSuperview];
    self.showview = nil;
    NSDictionary * dict = [self.videoModel startRecordVideo:YES];
    if (dict == nil) {
        NSLog(@"录音时间太短！");
        return;
    }
    if (self.videoBlock) {
        self.videoBlock(dict);
    }
}

//   取消录音
-(void)cancelSpeak:(UIButton *)sender
{
    sender.backgroundColor = [UIColor whiteColor];
    NSDictionary * dict = [self.videoModel startRecordVideo:YES];
    [self.videoModel deleteSound:dict[@"videoPath"]];
    [self.showview removeFromSuperview];
    self.showview = nil;
}
-(void)removeBigImage
{
    [self removeFromSuperview];
}
-(VideoRecordModel *)videoModel
{
    if (_videoModel == nil) {
        _videoModel = [[VideoRecordModel alloc]init];
    }
    return _videoModel;
}
@end
