//
//  FateDetailHeadView.h
//  Appointment
//
//  Created by feiwu on 16/7/21.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZYImageView.h"
#import "FateUserModel.h"
#import <AVFoundation/AVFoundation.h>
#import "FateDetailVoiceButton.h"
#import "FateDetailInfoView.h"
#import "FateDetailVipMaskView.h"
@class FateDetailViewController;
@interface FateDetailHeadView : UIView<UIScrollViewDelegate>
@property(nonatomic,strong)UIImageView *bottomView;//底部视图

@property(nonatomic,strong)UIImageView *backgroundImageView;//头像

@property(nonatomic,strong)UILabel *nickLabel;//用户昵称
@property(nonatomic,strong)UIImageView *vipImageView;//vip

@property(nonatomic,strong)UILabel *ageLabel;//年龄、身高、省份

@property(nonatomic,strong)FateDetailVoiceButton *voiceButton;//介绍button
@property(nonatomic,strong)AVPlayer *player;


@property(nonatomic,strong)FateDetailInfoView *userPhotoButton;//用户相册

@property(nonatomic,strong)FateDetailInfoView *userAddentionButton;//用户关注


@property(nonatomic,strong)FateDetailVipMaskView *vipMaskView;//vip视图



@property(nonatomic, strong)FateUserModel *fateUserModel;

@end
