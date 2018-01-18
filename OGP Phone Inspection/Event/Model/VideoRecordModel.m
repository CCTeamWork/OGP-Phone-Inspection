//
//  VideoRecordModel.m
//  OGP Phone Inspection
//
//  Created by 张建伟 on 17/7/28.
//  Copyright © 2017年 张国洋. All rights reserved.
//

#import "VideoRecordModel.h"
#include "lame.h"
@implementation VideoRecordModel
//   录音
-(NSDictionary *)startRecordVideo:(BOOL)record
{
    if (!record) {
        self.session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        [self.session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        //判断后台有没有播放
        if (self.session == nil) {
            NSLog(@"Error creating sessing:%@", [sessionError description]);
        } else {
            [self.session setActive:YES error:nil];
        }
        self.timeStr = 1;
        self.soundTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(addTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.soundTimer forMode:NSRunLoopCommonModes];

        //设置录音音质
//        NSMutableDictionary * recordSetting = [NSMutableDictionary dictionary];
//        [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];//
//        [recordSetting setValue:[NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];//采样率
//        [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];//声音通道，这里必须为双通道
//        [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityLow] forKey:AVEncoderAudioQualityKey];//音频质量
        NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithInt:AVAudioQualityMin],
                                 AVEncoderAudioQualityKey,
                                 [NSNumber numberWithInt:16],
                                 AVEncoderBitRateKey,
                                 [NSNumber numberWithInt:2],
                                 AVNumberOfChannelsKey,
                                 [NSNumber numberWithFloat:44100.0],
                                 AVSampleRateKey,
                                 nil];
        self.timeForPath=[self makeNowTimeForPath];
        self.strPathCaf=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",self.timeForPath]];
        NSURL * url=[NSURL URLWithString:self.strPathCaf];
        self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:nil];
        [self.recorder record];
        
        return nil;
    }
    else{
        [self.soundTimer invalidate];
        self.soundTimer = nil;
        //  恢复session   否则音量会变小
        self.session = [AVAudioSession sharedInstance];
        [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        [self.recorder stop];
        self.recorder = nil;
        NSString * cafPath = self.strPathCaf;
        //   转换成mp3格式
        [self changePath:self.strPathCaf];
        NSDictionary * videoDic = @{@"videoTime":[NSNumber numberWithInt:self.timeStr],@"videoPath":cafPath,@"content_path":self.strPathMp3,@"data_record_show":[NSString stringWithFormat:@"%d",self.timeStr],@"file_name":[NSString stringWithFormat:@"%@.mp3",[ToolModel uuid]]};
        if (self.timeStr<2) {
            [self deleteSound:self.strPathCaf];
            return nil;
        }
        return videoDic;
    }
}
-(void)addTime
{
    self.timeStr++;
}
//   将录音变为mp3格式
-(void)changePath:(NSString *)timePath
{
    NSString *cafFilePath = timePath;
    
    NSString * str = [timePath substringToIndex:timePath.length - 4];
    NSString *mp3FilePath = [NSString stringWithFormat:@"%@.mp3",str];
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_num_channels(lame,1);//设置1为单通道，默认为2双通道
        lame_set_in_samplerate(lame, 44100.0);
        lame_set_VBR(lame, vbr_default);
        
        lame_set_brate(lame,8);
        
//        lame_set_mode(lame,3);
        
        lame_set_quality(lame,2);
        
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        self.strPathMp3 = mp3FilePath;
    }
}
-(NSString *)makeNowTimeForPath
{
    //创建临时文件来存放录音文件
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyyMMddhhmmss"];
    NSString * str=[dateformatter stringFromDate:senddate];
    return str;
}
//   删除沙盒里的录音
-(void)deleteSound:(NSString *)path
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!blHave) {
        NSLog(@"没有可以删除的文件");
        return ;
    }else {
        BOOL blDele= [fileManager removeItemAtPath:path error:nil];
        if (blDele) {
            NSLog(@"删除成功");
        }else {
            NSLog(@"删除失败");
        }
    }
}

@end
