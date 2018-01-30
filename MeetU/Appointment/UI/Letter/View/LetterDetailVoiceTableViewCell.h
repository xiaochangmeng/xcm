//
//  LetterDetailVoiceTableViewCell.h
//  Appointment
//
//  Created by feiwu on 16/7/20.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZYImageView.h"
#import "LetterRecordModel.h"
#import "FateDetailVoiceButton.h"
#import "MWPhotoBrowser.h"
@class LetterDetailViewController;
@interface LetterDetailVoiceTableViewCell : UITableViewCell<MWPhotoBrowserDelegate>
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UIImageView *timeImageView;
@property (nonatomic, strong) MZYImageView *logoImageView;
@property (nonatomic, strong) UIImageView *logoMaskView;
@property (nonatomic, strong) UIButton *bgButton;
@property(nonatomic,strong)FateDetailVoiceButton *voiceButton;//介绍button
@property (nonatomic, strong) UILabel *voiceLabel;
@property (nonatomic, strong) MZYImageView *contentImageView;
@property (nonatomic, strong) LetterRecordModel *model;
@end
