//
//  ConditionButton.m
//  Appointment
//
//  Created by feiwu on 16/7/14.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "ConditionButton.h"

@implementation ConditionButton
- (id)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        _title = title;
        
        [self initView];
        [self makeConstraints];
    }
    return self;
}

#pragma mark - Private Methods
- (void)initView
{
    [self addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.typeLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.lineView];
}

- (void)makeConstraints
{
    WS(weakSelf)
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(10);
        make.centerY.mas_equalTo(weakSelf);
    }];
    
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf).offset(-15);
        make.centerY.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(6, 10));
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.arrowImageView.mas_left).offset(-15);
        make.left.mas_equalTo(weakSelf.typeLabel.mas_right).offset(15);
        make.centerY.mas_equalTo(weakSelf);
        make.height.mas_equalTo(16);
    }];

    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(weakSelf);
        make.height.mas_equalTo(1);
    }];
}
#pragma mark - Public Methods
//公有方法

#pragma mark - Event Responses
- (void)handleAction:(UIButton *)button
{
    if (_conditionBlock) {
        _conditionBlock();
    }
}
#pragma mark - Getters And Setters
- (UILabel *)typeLabel {
	if (!_typeLabel) {
		_typeLabel = [[UILabel alloc] init];
        _typeLabel.text = _title;
        _typeLabel.font = kFont15;
        _typeLabel.textColor =Color10(51, 51, 51, 1);
        [_typeLabel sizeToFit];
//        _typeLabel.backgroundColor = [UIColor orangeColor];
	}
	return _typeLabel;
}

- (UILabel *)contentLabel {
	if (!_contentLabel) {
		_contentLabel = [[UILabel alloc] init];
        _contentLabel.font = kFont15;
        _contentLabel.textColor =Color10(153, 153, 153, 1);
        _contentLabel.textAlignment = NSTextAlignmentRight;
//        _contentLabel.backgroundColor = [UIColor orangeColor];
	}
	return _contentLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = LOADIMAGE(@"common_arrow@2x", @"png");
//        _arrowImageView.backgroundColor = [UIColor lightGrayColor];
        
    }
    return _arrowImageView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = Color10(239, 239, 239, 1);
    }
    return _lineView;
}

@end
