//
//  VoiceIntroducedController.h
//  Appointment
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordView.h"
#import "CustomViewController.h"
@interface VoiceIntroducedController : CustomViewController
/**是否上传过自我介绍 */
@property (assign, nonatomic) RecordViewStatus status;

@property (assign, nonatomic) NSUInteger duration;
@end
