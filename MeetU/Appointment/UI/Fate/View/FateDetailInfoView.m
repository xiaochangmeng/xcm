//
//  FateDetailInfoButton.m
//  Appointment
//
//  Created by feiwu on 16/10/9.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "FateDetailInfoView.h"

@implementation FateDetailInfoView

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
    //语音图标
    [self addSubview:self.contentButton];
    //秒数
    [self addSubview:self.contentLabel];
    
}

- (void)makeConstraints
{
    WS(weakSelf)
    [_contentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(weakSelf).offset(-30);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(weakSelf).offset(-16);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(14);
    }];
    
}

#pragma mark - Event Responses

#pragma mark - Getters And Setters
- (UIButton *)contentButton {
    if (!_contentButton) {
        _contentButton = [[UIButton alloc] init];
    }
    return _contentButton;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor =Color16(0x999999);
        _contentLabel.font = kFont14;
    }
    return _contentLabel;
}

@end
