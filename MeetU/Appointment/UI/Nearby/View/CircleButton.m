//
//  CircleButton.m
//  Appointment
//
//  Created by feiwu on 2017/2/5.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "CircleButton.h"

@implementation CircleButton
{
    NSString *_title;
    NSString *_typeimage;
}

- (id)initWithTitle:(NSString *)title TypeImage:(NSString *)typeimage
{
    self = [super init];
    if (self) {
        _title = title;
        _typeimage = typeimage;
        [self initView];
        [self makeConstraints];
    }
    return self;
}

#pragma mark - Private Methods
- (void)initView
{
    [self addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.typeImageView];
    [self addSubview:self.contentLabel];
}

- (void)makeConstraints
{
    WS(weakSelf)
    [_typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf);
        make.left.mas_equalTo(weakSelf).offset(0);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.typeImageView.mas_right).offset(5);
        make.centerY.mas_equalTo(weakSelf);
        make.height.mas_equalTo(16);
    }];
}
#pragma mark - Public Methods
//公有方法

#pragma mark - Event Responses
- (void)handleAction:(UIButton *)button
{
    if (_circleBlock) {
        _circleBlock();
    }
}
#pragma mark - Getters And Setters
- (UIImageView *)typeImageView {
    if (!_typeImageView) {
        _typeImageView = [[UIImageView alloc] init];
        _typeImageView.image = LOADIMAGE(_typeimage, @"png");
//        _typeImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _typeImageView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:kPercentIP6(14)];
        _contentLabel.textColor = Color16(0x868A9B);
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.text = _title;
//        _contentLabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _contentLabel;
}

@end
