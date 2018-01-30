//
//  FateDetailVoiceButton.h
//  Appointment
//
//  Created by feiwu on 16/8/26.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FateUserModel.h"
typedef void(^FateDetailVoiceBlock)();
@interface FateDetailVoiceButton : UIButton
@property(nonatomic,strong)UIImageView *voiceImageView;//语音图标
@property(nonatomic,strong)UILabel *secondsLabel;//秒数

@property(nonatomic,strong)FateUserModel *fateUserModel;
@property(nonatomic,copy)FateDetailVoiceBlock voiceBlock;
@end
