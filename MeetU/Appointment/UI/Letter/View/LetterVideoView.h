//
//  LetterVideoView.h
//  Appointment
//
//  Created by feiwu on 2017/1/21.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^LetterVideoBlock)(NSString *type);

@interface LetterVideoView : UIView
/** 
 半透明背景 
 */
@property (strong, nonatomic) UIImageView *alphaView;

/** 
 头像 
 */
@property (strong, nonatomic) UIImageView *headImageView;

/**
 昵称
 */
@property (strong, nonatomic) UILabel *nickLabel;

/**
 提示
 */
@property (strong, nonatomic) UILabel *tipLabel;

/**
 拒绝button
 */
@property (strong, nonatomic) UIButton *noButton;

/**
 取消button
 */
@property (strong, nonatomic) UIButton *cancleButton;

/**
 接听button
 */
@property (strong, nonatomic) UIButton *yesButton;

@property (strong, nonatomic) AVAudioPlayer *player;

@property (copy, nonatomic) LetterVideoBlock letterVideoBlock;

/**
 初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame Type:(NSString *)type Mid:(NSString *)mid Nickname:(NSString *)name Img:(NSString *)img;

@end
