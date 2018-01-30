//
//  CircleDaliyFreeView.m
//  Appointment
//
//  Created by feiwu on 2017/3/2.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "CircleDaliyFreeView.h"
#import "NSDate+MZYExtension.h"
#import "LXFileManager.h"
@implementation CircleDaliyFreeView
{
    NSString *_index;
}
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame Index:(NSString *)index {
    if (self = [super initWithFrame:frame]) {
        _index = index;
        [self initView];
    }
    return self;
}


#pragma mark - Private Methods
/**
 添加试图
 */
- (void)initView{
    [self addSubview:self.alphaView];
    [self addSubview:self.loginImageView];
     [self addSubview:self.cancleButton];
    [self addSubview:self.getKeyButton];
    
    [self setupConstraints];
}

/**
 约束
 */
- (void)setupConstraints{
    WS(weakSelf);
    [_alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf).offset(0);
        make.left.mas_equalTo(weakSelf).offset(0);
        make.bottom.mas_equalTo(weakSelf).offset(0);
        make.right.mas_equalTo(weakSelf).offset(0);
    }];
    
    [_loginImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf).offset(0);
        make.width.mas_equalTo(kPercentIP6(282));
        make.height.mas_equalTo(kHeightIP6(277));
        make.centerX.mas_equalTo(weakSelf).offset(0);
    }];
    
    [_cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.loginImageView.mas_bottom).offset(-kHeightIP6(23));
        make.centerX.mas_equalTo(weakSelf).offset(-kPercentIP6(60));
        make.width.mas_equalTo(kPercentIP6(90));
        make.height.mas_equalTo(kHeightIP6(40));
    }];

    [_getKeyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.loginImageView.mas_bottom).offset(-kHeightIP6(23));
        make.centerX.mas_equalTo(weakSelf).offset(kPercentIP6(60));
        make.width.mas_equalTo(kPercentIP6(90));
        make.height.mas_equalTo(kHeightIP6(40));
    }];
    
}

#pragma mark - Event Responses

/**
 点击半透明背景视图  移除
 
 @param tapGestureRecognizer 点击事件
 */
- (void)tapGestureRecognizerHandle:(UITapGestureRecognizer*)tapGestureRecognizer{
    
    [self removeFromSuperview];
}

/**
 点击使用钥匙button
 
 @param sender 使用key按钮
 */
- (void)getKeyAction:(UIButton*)sender{
    NSString *currentDate = [NSDate getDate:[NSDate date] dateFormatter:@"yyyyMMdd"];
    NSString *circlePhotoKey = [NSString stringWithFormat:@"%@%@CirclePhotoKey",currentDate,[FWUserInformation sharedInstance].mid];
    [LXFileManager saveUserData:@"0" forKey:circlePhotoKey];
    if (_seePhotoBlock) {
        _seePhotoBlock(_index);
    }
    [self removeFromSuperview];
}
/**
 点击取消button
 
 @param sender 取消按钮
 */
- (void)cancleAction:(UIButton*)sender{
    [self removeFromSuperview];
}

#pragma mark - Getters And Setters
- (UIView *)alphaView{
    if (_alphaView == nil) {
        _alphaView = [UIView new];
        _alphaView.backgroundColor = Color10(0, 0, 0, 0.75f);
        UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerHandle:)];
        [_alphaView addGestureRecognizer:tapGestureRecognizer];
    }
    return _alphaView;
}

- (UIImageView *)loginImageView{
    if (!_loginImageView ) {
        UIImage* image = LOADIMAGE(@"circle_daliyOnce@2x", @"png");
        _loginImageView = [[UIImageView alloc]initWithImage:image];
        _loginImageView.userInteractionEnabled = YES;
    }
    return _loginImageView;
}

- (UIButton *)getKeyButton{
    if (!_getKeyButton) {
        _getKeyButton = [UIButton new];
        [_getKeyButton addTarget:self action:@selector(getKeyAction:) forControlEvents:UIControlEventTouchDown];
//        _getKeyButton.backgroundColor = [UIColor orangeColor];
    }
    return _getKeyButton;
}

- (UIButton *)cancleButton{
    if (!_cancleButton) {
        _cancleButton = [UIButton new];
        [_cancleButton addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchDown];
//        _cancleButton.backgroundColor = [UIColor lightGrayColor];
    }
    return _cancleButton;
}


@end
