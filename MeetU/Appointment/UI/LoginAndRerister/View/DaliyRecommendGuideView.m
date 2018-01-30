//
//  DaliyRecommendGuideView.m
//  Appointment
//
//  Created by feiwu on 16/8/22.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "DaliyRecommendGuideView.h"

@implementation DaliyRecommendGuideView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCancel:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
    [self addSubview:self.dislikeView];
    [self addSubview:self.likeView];
    [self addSubview:self.leftImageView];
    [self addSubview:self.leftTipLabel];
    [self addSubview:self.rightImageView];
    [self addSubview:self.rightTipLabel];
    [self addSubview:self.cancalLabel];
    
}

- (void)makeConstraints
{
    WS(weakSelf)
    [_dislikeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(70.5);
        make.height.mas_equalTo(70.5);
        make.left.mas_equalTo(40.5);
        make.top.mas_equalTo(kPercentIP6(180));
    }];
    
    [_likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(68);
        make.height.mas_equalTo(73);
        make.right.mas_equalTo(-40.5);
        make.top.mas_equalTo(kPercentIP6(180));
    }];
    
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(21.5);
        make.height.mas_equalTo(19);
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(weakSelf.dislikeView.mas_bottom).offset(19.5);
    }];
    
    [_leftTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.leftImageView.mas_right).offset(5.5);
        make.top.mas_equalTo(weakSelf.dislikeView.mas_bottom).offset(18);
    }];
    
    
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20.5);
        make.height.mas_equalTo(18.5);
        make.right.mas_equalTo(weakSelf).offset(-40);
        make.top.mas_equalTo(weakSelf.dislikeView.mas_bottom).offset(19.5);
    }];
    
    [_rightTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.rightImageView.mas_left).offset(-5.5);
        make.top.mas_equalTo(weakSelf.dislikeView.mas_bottom).offset(18);
    }];
    
    [_cancalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(165);
        make.height.mas_equalTo(50);
        make.centerX.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf.rightTipLabel.mas_bottom).offset(kPercentIP6(80));
    }];
    
    
}

#pragma mark - Event Responses
//事件响应方法
- (void)handleCancel:(UITapGestureRecognizer *)sender
{
    if (_daliyGuideBlock) {
        _daliyGuideBlock();
    }
}

#pragma mark - Getters And Setters

- (UIImageView *)likeView {
    if (!_likeView) {
        _likeView = [[UIImageView alloc] init];
        _likeView.image = LOADIMAGE(@"daliy_right@2x", @"png");
    }
    return _likeView;
}

- (UIImageView *)dislikeView {
    if (!_dislikeView) {
        _dislikeView = [[UIImageView alloc] init];
        _dislikeView.image = LOADIMAGE(@"daliy_left@2x", @"png");
    }
    return _dislikeView;
}
- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.image = LOADIMAGE(@"daliy_dislike@2x", @"png");
    }
    return _leftImageView;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.image = LOADIMAGE(@"daliy_like@2x", @"png");
    }
    return _rightImageView;
}

- (UILabel *)leftTipLabel {
    if (!_leftTipLabel) {
        _leftTipLabel = [[UILabel alloc] init];
        _leftTipLabel.text = NSLocalizedString(@"不喜欢左划", nil);
        _leftTipLabel.font = [UIFont systemFontOfSize:kPercentIP6(19)];
        _leftTipLabel.textColor = [UIColor whiteColor];
        [_leftTipLabel sizeToFit];
    }
    return _leftTipLabel;
}

- (UILabel *)rightTipLabel {
    if (!_rightTipLabel) {
        _rightTipLabel = [[UILabel alloc] init];
        _rightTipLabel.text = NSLocalizedString(@"喜欢右划", nil);
        _rightTipLabel.font = [UIFont systemFontOfSize:kPercentIP6(19)];
        _rightTipLabel.textColor = [UIColor whiteColor];
        [_rightTipLabel sizeToFit];
    }
    return _rightTipLabel;
}
- (UILabel *)cancalLabel {
    if (!_cancalLabel) {
        _cancalLabel = [[UILabel alloc] init];
        _cancalLabel.text = NSLocalizedString(@"我知道了", nil);
        _cancalLabel.font = kFont20;
        _cancalLabel.textAlignment = NSTextAlignmentCenter;
        _cancalLabel.textColor = [UIColor whiteColor];
        _cancalLabel.layer.borderWidth = 1;
        _cancalLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _cancalLabel;
}


@end
