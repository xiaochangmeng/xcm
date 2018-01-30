//
//  VoiceIntroducedApi.h
//  Appointment
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "BaseRequest.h"

@interface VoiceIntroducedApi : BaseRequest
/**
 *  实例化
 *
 *  @param data     需要上传的data
 *  @param duration 声音时长
 *
 *  @return 实例化
 */
- (instancetype)initWithVoiceData:(NSData *)data duration:(NSUInteger)duration;
@end
