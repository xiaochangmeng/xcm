//
//  FateDetailBottomButtonView.m
//  Appointment
//
//  Created by apple on 16/9/26.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "FateDetailBottomButtonView.h"

@implementation FateDetailBottomButtonView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}


/**
 初始化视图
 */
- (void)setupView{
    [self addSubview:self.bottomImageView];
    [self addSubview:self.sendMessageButton];
    [self addSubview:self.helloButton];
    [self addSubview:self.nextButton];
    
    [self setupConstraints];
}

/**
 设置约束
 */
- (void)setupConstraints{
    WS(weakSelf);
    
    [_bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf);
        make.bottom.mas_equalTo(weakSelf);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(kPercentIP6(48));
    }];
    
    [_sendMessageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(kPercentIP6(50));
        make.centerY.mas_equalTo(weakSelf);
        make.width.mas_equalTo(kPercentIP6(60));
        make.height.mas_equalTo(kPercentIP6(60));
    }];
    
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.mas_right).offset(kPercentIP6(-50));
        make.centerY.mas_equalTo(weakSelf);
        make.width.mas_equalTo(kPercentIP6(60));
        make.height.mas_equalTo(kPercentIP6(60));
    }];
    
    [_helloButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf);
        make.centerX.mas_equalTo(weakSelf);
        make.width.mas_equalTo(kPercentIP6(60));
        make.height.mas_equalTo(kPercentIP6(60));
    }];
}

- (void)clickButtonHandle:(UIButton*)sender{
    self.buttonHandle(sender.tag);
}

- (UIImageView *)bottomImageView
{
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc] init];
        _bottomImageView.userInteractionEnabled = YES;
        _bottomImageView.image = LOADIMAGE(@"fate_detail_bottomImage@2x", @"png");
    }
    return _bottomImageView;
}
- (UIButton *)sendMessageButton{
    if (_sendMessageButton == nil) {
        _sendMessageButton = [UIButton new];
        _sendMessageButton.tag = 0;
        [_sendMessageButton setImage:LOADIMAGE(NSLocalizedString(@"fate_detail_send", nil), @"png") forState:UIControlStateNormal];
        [_sendMessageButton setImage:LOADIMAGE(NSLocalizedString(@"fate_detail_send_highlighted", nil), @"png") forState:UIControlStateHighlighted];
        [_sendMessageButton addTarget:self action:@selector(clickButtonHandle:) forControlEvents:UIControlEventTouchDown];
    }
    return _sendMessageButton;
}

- (UIButton *)helloButton{
    if (_helloButton == nil) {
        _helloButton = [UIButton new];
        _helloButton.tag = 1;
        [_helloButton setImage:LOADIMAGE(NSLocalizedString(@"fate_detail_sayhello", nil), @"png") forState:UIControlStateNormal];
        [_helloButton setImage:LOADIMAGE(NSLocalizedString(@"fate_detail_sayhello_already", nil), @"png") forState:UIControlStateSelected];
        [_helloButton addTarget:self action:@selector(clickButtonHandle:) forControlEvents:UIControlEventTouchDown];
    }
    
    return _helloButton;
}

- (UIButton *)nextButton{
    if (_nextButton == nil) {
        _nextButton = [UIButton new];
        _nextButton.tag = 2;
        [_nextButton setImage:LOADIMAGE(NSLocalizedString(@"fate_detail_next", nil), @"png") forState:UIControlStateNormal];
        [_nextButton setImage:LOADIMAGE(NSLocalizedString(@"fate_detail_next_highlighted", nil), @"png") forState:UIControlStateHighlighted];
        [_nextButton addTarget:self action:@selector(clickButtonHandle:) forControlEvents:UIControlEventTouchDown];
        
    }
    return _nextButton;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
