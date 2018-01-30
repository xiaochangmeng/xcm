//
//  AudioRecorderManager.m
//  Appointment
//
//  Created by apple on 16/8/25.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "AudioRecorderManager.h"
#import "lame.h"


@interface AudioRecorderManager()


/**录音调整 */
@property (nonatomic, strong) AVAudioSession *audioSession;
/**录音时长 */
@property (assign, nonatomic) NSUInteger duration;
/**计时器 */
@property (strong, nonatomic) NSTimer* timer;



@end

@implementation AudioRecorderManager

+ (instancetype)sharedInstance{
    static AudioRecorderManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc ] init];
        [_sharedInstance activeAudioSession];
    });
    
    return _sharedInstance;
}

/**
 *  开启始终以扬声器模式播放声音
 */
- (void)activeAudioSession{
    self.audioSession = [AVAudioSession sharedInstance];
    NSError *sessionError = nil;
    [self.audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    AudioSessionSetProperty (
                             kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride
                             );
#pragma clang diagnostic pop
    if(self.audioSession) {
        [self.audioSession setActive:YES error:nil];
    }
}

- (BOOL)initRecord{
        NSError *recorderSetupError = nil;
        NSURL *url = [NSURL fileURLWithPath:[self cafPath]];
        NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
        //录音格式 无法使用
        [settings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
        //采样率
        [settings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];//44100.0
        //通道数
        [settings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
        //音频质量,采样质量
        [settings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url
                                                     settings:settings
                                                        error:&recorderSetupError];
        if (recorderSetupError) {
            NSLog(@"%@",recorderSetupError);
        }
        
        //开启音量检测
        _audioRecorder.meteringEnabled = YES;
        
        if ([self.audioRecorder prepareToRecord]){
            return YES;
        }
        return NO;

}

/**
 *  开始录音
 *
 *  @param startRecord 开启录音成功
 */
- (void)startRecord:(StartRecordSuccess)startRecord{
    [self initRecord];
    if ([self.audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [self.audioSession requestRecordPermission:^(BOOL granted) {
            if (granted) {//已经获得了麦克风权限
                //录音前  录音时长重置为0
                self.duration = 0;
                //开始计时
                self.timer = [[NSTimer alloc]initWithFireDate:[NSDate new] interval:1 target:self selector:@selector(calculateTimeHandle) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
                
                [self.audioRecorder record];//开始录音
                
                startRecord();
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"无法录音", nil) message:NSLocalizedString(@"请在“设置-隐私-麦克风”中允许访问麦克风。", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil] show];
                });
            }
        }];
    }
}

/**
 *  录音计时
 */
- (void)calculateTimeHandle{
    self.duration++;
    [self.delegate calculateTimeHandle:self.duration];
}

/**
 *  停止录音
 *
 *  @param conver     是否转换成Mp3
 *  @param conversion 转换结果
 */
- (void)stopRecord:(StopRecordResult)stopRecordResult{
    [self.timer invalidate];
    self.timer = nil;
    [self.audioRecorder stop];
    [self audio_PCMtoMP3:stopRecordResult];
    
}

/**
 *  转换成mp3
 *
 *  @param stopRecordResult 转换结束block调用
 */
- (void)audio_PCMtoMP3:(StopRecordResult)stopRecordResult{
    NSString *cafFilePath = [self cafPath];
    NSString *mp3FilePath = [self mp3Path];

    [self deleteMp3Cache];
    NSLog(@"MP3转换开始");
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
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
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
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
    }
    
    [self deleteCafCache];
    NSLog(@"MP3转换结束");
    NSData *voiceData = [NSData dataWithContentsOfFile:[self mp3Path]];
    stopRecordResult(voiceData,self.duration);
    
    self.audioSession = nil;
}
- (void)deleteMp3Cache{
    [self deleteFileWithPath:[self mp3Path]];
}

- (void)deleteCafCache{
    [self deleteFileWithPath:[self cafPath]];
}



/**
 *  录音存储路径
 *
 *  @return 存储路径
 */
- (NSString*)cafPath{
    NSString* path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.caf"];
    return path;
}

/**
 *  MP3存储路径
 *
 *  @return 存储路径
 */
- (NSString*)mp3Path{
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"mp3.caf"];
    return path;
}

/**
 *  删除录音文件
 *
 *  @param path 录音文件路径  caf 或者 mp3
 */
- (void)deleteFileWithPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager removeItemAtPath:path error:nil]){
        //        NSLog(@"删除以前的mp3文件");
    }
}

- (void)deleteMp3File{
    [self deleteFileWithPath:[self mp3Path]];
}

/**
 *  懒加载 AVAudioSession 录音或者播放的后台模式
 *
 *  @return 初始化之后的 AVAudioSession
 */
- (AVAudioSession *)audioSession{
    if (_audioSession == nil) {
        _audioSession = [AVAudioSession sharedInstance];
        NSError *sessionError;
        [_audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        
        if(_audioSession == nil){
            NSLog(@"Error creating session: %@", [sessionError description]);
        }
        else{
            [_audioSession setActive:YES error:nil];
        }
    }
    return _audioSession;
}

@end
