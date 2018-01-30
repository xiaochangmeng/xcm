//
//  FateDetailVoiceButton.m
//  Appointment
//
//  Created by feiwu on 16/8/26.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "FateDetailVoiceButton.h"

@implementation FateDetailVoiceButton
#pragma mark - Life Cycle
//生命周期方法
- (id)init
{
    self = [super init];
    if (self) {
        [self initView];
        [self makeConstraints];
    }
    return self;
    
}

#pragma mark - Private Methods
//私有方法
- (void)initView
{
    [self addTarget:self action:@selector(handleVoicePlay:) forControlEvents:UIControlEventTouchUpInside];
    //语音图标
    [self addSubview:self.voiceImageView];
    //秒数
    [self addSubview:self.secondsLabel];

}

- (void)makeConstraints
{
    WS(weakSelf)
    [_voiceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(21);
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(weakSelf);
    }];
    
    [_secondsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(weakSelf.voiceImageView.mas_right).offset(0);
        make.centerY.mas_equalTo(weakSelf);
    }];

}

#pragma mark - Event Responses
//事件响应方法
- (void)handleVoicePlay:(UIButton *)sender
{
    if (_voiceBlock) {
        _voiceBlock();
    }
}

#pragma mark - Getters And Setters
- (UIImageView *)voiceImageView {
	if (!_voiceImageView) {
		_voiceImageView = [[UIImageView alloc] init];
        _voiceImageView.image = LOADIMAGE(@"fate_detail_voice3@2x", @"png");
	}
	return _voiceImageView;
}

- (UILabel *)secondsLabel {
	if (!_secondsLabel) {
		_secondsLabel = [[UILabel alloc] init];
        _secondsLabel.text = @"";
        _secondsLabel.textAlignment = NSTextAlignmentCenter;
        _secondsLabel.textColor =Color16(0x8A71CC);
        _secondsLabel.font = kFont13;
	}
	return _secondsLabel;
}

- (void)setFateUserModel:(FateUserModel *)fateUserModel
{
    _fateUserModel = fateUserModel;
    _secondsLabel.text = [NSString stringWithFormat:@"%@S",_fateUserModel.voice_length];

}
@end
