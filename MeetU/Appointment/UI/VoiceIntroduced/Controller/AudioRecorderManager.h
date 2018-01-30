//
//  AudioRecorderManager.h
//  Appointment
//
//  Created by apple on 16/8/25.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@protocol AudioRecorderManagerDelegate

@required
- (void)calculateTimeHandle:(NSUInteger)duration;

@end


typedef void (^StopRecordResult)(NSData* data, NSUInteger duration);
typedef void (^StartRecordSuccess)();
@interface AudioRecorderManager : NSObject

@property (weak, nonatomic) id<AudioRecorderManagerDelegate> delegate;
/**录音机 */
@property (strong, nonatomic) AVAudioRecorder* audioRecorder;

+ (instancetype)sharedInstance;

/**
 *  开启录音
 *
 *  @param startRecord 开启录音成功回调
 */
- (void)startRecord:(StartRecordSuccess)startRecord;
/**
 *  停止录音
 *
 *  @param conver 是否转换成mp3
 */
- (void)stopRecord:(StopRecordResult)stopRecordResult;


@end
