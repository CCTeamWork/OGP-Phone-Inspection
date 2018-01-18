//
//  VideoRecordModel.h
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/28.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
@interface VideoRecordModel : NSObject <AVAudioRecorderDelegate,AVAudioPlayerDelegate>

@property (nonatomic, strong)AVAudioRecorder *recorder;
////播放
//@property (nonatomic, strong)AVAudioPlayer *player;

@property(nonatomic,strong) AVAudioSession *session;

@property(nonatomic,strong) NSString * timeForPath;

@property(nonatomic,copy) NSString * strPathCaf;

@property(nonatomic,copy) NSString * strPathMp3;

@property(nonatomic,assign) int timeStr;
@property(nonatomic,strong) NSTimer * soundTimer;

-(NSDictionary *)startRecordVideo:(BOOL)record;
-(void)deleteSound:(NSString *)path;
@end
