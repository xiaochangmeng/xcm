//
//  RecordView.h
//  Appointment
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
typedef enum{
    RECORDVIEWSTATUS_NORAML,           //正常
    RECORDVIEWSTATUS_RECORDING,      //录音中
    RECORDVIEWSTATUS_CANCEL,           //手指离开录音触点
    RECORDVIEWSTATUS_UPLOADING,       //上传中
    RECORDVIEWSTATUS_PLAY,               //播放
    RECORDVIEWSTATUS_PAUSE             //暂停
}RecordViewStatus;

@protocol RecordViewDelegate

@required
/**录音结束 */
- (void)recordViewStopRecord:(NSData*)voiceData duration:(NSUInteger)duration;
/**录音时长计算 */
- (void)recordViewCalculateRecordDuration:(NSUInteger)duration;
/**recordView状态切换 */
- (void)recordViewStatusSwitch:(RecordViewStatus)status;
@end
@interface RecordView : UIView

@property (weak, nonatomic) id<RecordViewDelegate> delegate;
///**音乐播放 */
@property (strong, nonatomic) AVAudioPlayer* audioPlayer;
/**当前recordView状态 */
@property (assign, nonatomic) RecordViewStatus status;

/**恢复recordView样式 */
- (void)resetView:(RecordViewStatus)status;
@end
