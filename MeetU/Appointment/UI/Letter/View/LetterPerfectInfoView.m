//
//  LetterPerfectInfoView.m
//  Appointment
//
//  Created by feiwu on 16/7/14.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "LetterPerfectInfoView.h"

@implementation LetterPerfectInfoView
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
- (void)initView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction:)];
    [self addGestureRecognizer:tap];
    
    [self addSubview:self.perfectImageView];
    [self addSubview:self.perfectLabel];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.lineView];
}

- (void)makeConstraints
{
    WS(weakSelf)
    [_perfectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(15);
        make.centerY.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [_perfectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.perfectImageView.mas_right).offset(15);
        make.centerY.mas_equalTo(weakSelf.perfectImageView);
    }];
    
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf).offset(-10);
        make.centerY.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(8, 13));
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 1));
    }];

 
}
#pragma mark - Public Methods
//公有方法

#pragma mark - Event Responses
- (void)handleTapAction:(UITapGestureRecognizer *)tap
{
    if (_perfectBlock) {
        _perfectBlock();
    }
    
}

#pragma mark - Getters And Setters
- (UIImageView *)perfectImageView {
	if (!_perfectImageView) {
		_perfectImageView = [[UIImageView alloc] init];
        _perfectImageView.image = LOADIMAGE(@"letter_perfectInfo@2x", @"png");
	}
	return _perfectImageView;
}

- (UILabel *)perfectLabel {
	if (!_perfectLabel) {
		_perfectLabel = [[UILabel alloc] init];
        _perfectLabel.text = NSLocalizedString(@"完善档案更容易收到异性来信", nil);
        _perfectLabel.font = kFont14;
        _perfectLabel.textColor = [UIColor whiteColor];
        [_perfectLabel sizeToFit];
        _perfectLabel.textAlignment = NSTextAlignmentLeft;
//        _perfectLabel.backgroundColor = [UIColor yellowColor];
	}
	return _perfectLabel;
}

- (UIImageView *)arrowImageView {
	if (!_arrowImageView) {
		_arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = LOADIMAGE(@"letter_arrow@2x", @"png");
//        _arrowImageView.backgroundColor = [UIColor orangeColor];

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
