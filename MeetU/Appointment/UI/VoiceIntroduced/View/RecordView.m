//
//  RecordView.m
//  Appointment
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "RecordView.h"
#import "lame.h"
#import "VoiceIntroducedApi.h"
#define isJailBreak [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]
#import "AudioRecorderManager.h"

/**录音最小时长 */
#define RECORD_MIN_DURATION 3

@interface RecordView()<AudioRecorderManagerDelegate,AVAudioPlayerDelegate>

/**录音时长 */
@property (assign, nonatomic) NSUInteger duration;
/**recordView状态图片 */
@property (strong, nonatomic) IBOutlet UIImageView* recordViewStatusImageView;
/**recordView状态文字 */
@property (strong, nonatomic) IBOutlet UILabel* recordViewStatusLabel;

@end
@implementation RecordView

- (void)awakeFromNib{
    [super awakeFromNib];
    NSLog(@"%d",isJailBreak);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    WS(weakSelf);
    if (self.status == RECORDVIEWSTATUS_NORAML) {
        //开始录音
        [[AudioRecorderManager sharedInstance] startRecord:^{
            //计时
            [AudioRecorderManager sharedInstance].delegate = weakSelf;
            
            [weakSelf resetView:RECORDVIEWSTATUS_RECORDING];
        }];
    }else if (self.status == RECORDVIEWSTATUS_PLAY){
        //播放音乐
        [self.audioPlayer play];
        [self resetView:RECORDVIEWSTATUS_PAUSE];
    }else if (self.status == RECORDVIEWSTATUS_PAUSE){
        //暂停音乐
        [self.audioPlayer stop];
        [self resetView:RECORDVIEWSTATUS_PLAY];
    }
}

/**
 *  计算当前录制了几秒
 *
 *  @param duration 时长
 */
- (void)calculateTimeHandle:(NSUInteger)duration{
    self.duration++;
    [self.delegate recordViewCalculateRecordDuration:duration];
}

#pragma mark - touchesMoved
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    //手指触点
    CGPoint point = [touch locationInView:self];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    BOOL isValid = CGRectContainsPoint(CGRectMake(0, 0, width, height), point) ? YES : NO;
    
    
    if (!(self.status == RECORDVIEWSTATUS_PLAY || self.status == RECORDVIEWSTATUS_PAUSE)) {
        [self resetView:isValid ? RECORDVIEWSTATUS_RECORDING : RECORDVIEWSTATUS_CANCEL];
    }
    
}

#pragma mark - touchesEnded
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //结束录音
    if (!(self.status == RECORDVIEWSTATUS_PLAY || self.status == RECORDVIEWSTATUS_PAUSE)) {
        [[AudioRecorderManager sharedInstance] stopRecord:^(NSData *data, NSUInteger duration) {
            
            if (duration > RECORD_MIN_DURATION) {//上传
                if (self.status != RECORDVIEWSTATUS_CANCEL) {
                    [self resetView:RECORDVIEWSTATUS_UPLOADING];
                    
                    [self.delegate recordViewStopRecord:data duration:duration];
                }else{
                    [self resetView:RECORDVIEWSTATUS_NORAML];
                }
            }else{
                [self resetView:RECORDVIEWSTATUS_NORAML];
                NSString* content = [NSString stringWithFormat:@"錄音不能小於%d秒",RECORD_MIN_DURATION];
                [self showAlertView:content];
            }
            [self cacheMusicData:data];
            self.duration = 0;
        }];
    }
}


/**
 *  懒加载
 *
 *  @return 初始化之后的播放器
 */
- (AVAudioPlayer *)audioPlayer{

        NSUserDefaults* us = [NSUserDefaults standardUserDefaults];
        NSData* data = [us objectForKey:@"voiceData"];
    
        _audioPlayer = [[AVAudioPlayer alloc]initWithData:data error:nil];
        _audioPlayer.delegate = self;
        [_audioPlayer prepareToPlay];

    return _audioPlayer;
}

/**
 *  播放结束
 *
 *  @param player player
 *  @param flag   flag
 */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self resetView:RECORDVIEWSTATUS_PLAY];
}

/**
 *  缓存到本地
 *
 *  @param voiceData 要缓存的声音数据
 */
- (void)cacheMusicData:(NSData*)voiceData{
    NSUserDefaults* us = [NSUserDefaults standardUserDefaults];
    [us setObject:voiceData forKey:@"voiceData"];
    [us synchronize];
}




- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([[AudioRecorderManager sharedInstance].audioRecorder isRecording]) {
        [[AudioRecorderManager sharedInstance].audioRecorder stop];
    }
}


/**
 *  设置recordView试图样式
 *
 *  @param status recordView状态
 */
- (void)resetView:(RecordViewStatus)status{
    NSString* content = nil;
    NSString* imageName = nil;
    if (status == RECORDVIEWSTATUS_NORAML) {//按下录音状态
        content = NSLocalizedString(@"按下录音", nil);
        imageName = @"voice_microphone@2x";
    }else if (status == RECORDVIEWSTATUS_RECORDING){//录音中状态
        content = NSLocalizedString(@"录音中...", nil);
        imageName = @"voice_microphone@2x";
    }else if (status == RECORDVIEWSTATUS_CANCEL){//取消录音状态
        content = NSLocalizedString(@"松开取消录音", nil);
        imageName = @"voice_microphone@2x";
    }else if (status == RECORDVIEWSTATUS_UPLOADING){//上传中状态
        content = NSLocalizedString(@"上载中...", nil);
        imageName = @"voice_upload@2x";
    }else if (status == RECORDVIEWSTATUS_PLAY){//点击播放状态
        content = NSLocalizedString(@"点击播放", nil);
        imageName = @"voice_play@2x";
    }else if (status == RECORDVIEWSTATUS_PAUSE){
        content = NSLocalizedString(@"点击暂停", nil);
        imageName = @"voice_pause@2x";
    }
    self.status = status;
    self.recordViewStatusLabel.text = content;
    self.recordViewStatusImageView.image = LOADIMAGE(imageName, @"png");
    [self.delegate recordViewStatusSwitch:self.status];
}



#pragma mark - showAlertView
- (void)showAlertView:(NSString*)content{
    UIView* view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD* HUD =  [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.animationType = MBProgressHUDAnimationZoom;
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = content;
    [HUD show:YES];
    [HUD hide:YES afterDelay:2];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
