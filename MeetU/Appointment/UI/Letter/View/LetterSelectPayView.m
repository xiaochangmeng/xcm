//
//  LetterSelectPayView.m
//  Appointment
//
//  Created by feiwu on 16/10/9.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "LetterSelectPayView.h"

@implementation LetterSelectPayView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _productIndex = 0;
        [self setupView];
    }
    return self;
}


/**
 点击半透明背景视图  移除
 
 @param tapGestureRecognizer 点击事件
 */
- (void)tapGestureRecognizerHandle:(UITapGestureRecognizer*)tapGestureRecognizer{
    [self removeFromSuperview];
}

/**
 点击充值按钮
 
 @param sender 充值按钮
 */
- (void)rechargeButtonHandle:(UIButton*)sender{
    self.LetterSelectPayBlock(_productIndex);
    [self removeFromSuperview];
}



/**
 点击包月选项
 
 @param sender 套餐按钮
 */
- (void)selectTypeHandle:(UIButton*)sender{
    
    NSInteger index = sender.tag - 10000;
    switch (index) {
        case 1:
        {
            //包年
              [_writerYearButton setBackgroundImage:LOADIMAGE(NSLocalizedString(@"letter_selectedYear", nil), @"png") forState:UIControlStateNormal];
            [_writerThreeMonButton setBackgroundImage:LOADIMAGE(NSLocalizedString(@"letter_noSelectThreeMon", nil), @"png") forState:UIControlStateNormal];
              [_writerOneMonButton setBackgroundImage:LOADIMAGE(NSLocalizedString(@"letter_noSelectOneMon", nil), @"png") forState:UIControlStateNormal];
            _productIndex = 0;
        }
            break;
        case 2:
        {
            //包三月
            [_writerYearButton setBackgroundImage:LOADIMAGE(NSLocalizedString(@"letter_noSelectYear", nil), @"png") forState:UIControlStateNormal];
            [_writerThreeMonButton setBackgroundImage:LOADIMAGE(NSLocalizedString(@"letter_selectThreeMon", nil), @"png") forState:UIControlStateNormal];
            [_writerOneMonButton setBackgroundImage:LOADIMAGE(NSLocalizedString(@"letter_noSelectOneMon", nil), @"png") forState:UIControlStateNormal];
            _productIndex = 1;

        }
            break;

        case 3:
        {
            //包一个月
            [_writerYearButton setBackgroundImage:LOADIMAGE(NSLocalizedString(@"letter_noSelectYear", nil), @"png") forState:UIControlStateNormal];
            [_writerThreeMonButton setBackgroundImage:LOADIMAGE(NSLocalizedString(@"letter_noSelectThreeMon", nil), @"png") forState:UIControlStateNormal];
            [_writerOneMonButton setBackgroundImage:LOADIMAGE(NSLocalizedString(@"letter_selectOneMon", nil), @"png") forState:UIControlStateNormal];
            _productIndex = 2;

        }
            break;

        default:
            break;
    }
    
}

/**
 添加试图
 */
- (void)setupView{
    [self addSubview:self.alphaView];
    [self addSubview:self.backgroundImageView];
    
    [self addSubview:self.writerYearButton];
    [self addSubview:self.writerThreeMonButton];
    [self addSubview:self.writerOneMonButton];
    [self addSubview:self.payButton];
    
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
    
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(0);
        make.right.mas_equalTo(weakSelf).offset(0);
        make.bottom.mas_equalTo(weakSelf).offset(-64);
        make.height.mas_equalTo(kHeightIP6(371));
    }];
    
    [_writerYearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.backgroundImageView).offset(kHeightIP6(97));
        make.right.mas_equalTo(weakSelf.backgroundImageView.mas_right).offset(0);
        make.height.mas_equalTo(kHeightIP6(71));
        make.left.mas_equalTo(weakSelf.backgroundImageView.mas_left).offset(0);
    }];
    [_writerThreeMonButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.writerYearButton.mas_bottom).offset(0);
        make.right.mas_equalTo(weakSelf.backgroundImageView.mas_right).offset(0);
        make.height.mas_equalTo(kHeightIP6(71));
        make.left.mas_equalTo(weakSelf.backgroundImageView.mas_left).offset(0);
    }];

    [_writerOneMonButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.writerThreeMonButton.mas_bottom).offset(0);
        make.right.mas_equalTo(weakSelf.backgroundImageView.mas_right).offset(0);
        make.height.mas_equalTo(kHeightIP6(71));
        make.left.mas_equalTo(weakSelf.backgroundImageView.mas_left).offset(0);
    }];

 
    [_payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.backgroundImageView.mas_bottom).offset(0);
        make.right.mas_equalTo(weakSelf.backgroundImageView.mas_right).offset(0);
        make.height.mas_equalTo(kHeightIP6(50));
        make.left.mas_equalTo(weakSelf.backgroundImageView.mas_left).offset(0);
    }];
}

- (UIView *)alphaView{
    if (_alphaView == nil) {
        _alphaView = [UIView new];
        _alphaView.backgroundColor = Color10(0, 0, 0, 0.75f);
        UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerHandle:)];
        [_alphaView addGestureRecognizer:tapGestureRecognizer];
    }
    return _alphaView;
}

- (UIImageView *)backgroundImageView{
    if (_backgroundImageView == nil) {
        UIImage* image = LOADIMAGE(NSLocalizedString(@"letter_datail_recharge_mask", nil), @"png");
        _backgroundImageView = [[UIImageView alloc]initWithImage:image];
        _backgroundImageView.userInteractionEnabled = YES;
    }
    return _backgroundImageView;
}

- (UIButton *)writerYearButton{
    if (_writerYearButton == nil) {
        _writerYearButton = [UIButton new];
        _writerYearButton.tag = 10001;
        [_writerYearButton addTarget:self action:@selector(selectTypeHandle:) forControlEvents:UIControlEventTouchUpInside];
        [_writerYearButton setBackgroundImage:LOADIMAGE(NSLocalizedString(@"letter_selectedYear", nil), @"png") forState:UIControlStateNormal];
    }
    return _writerYearButton;
}
- (UIButton *)writerThreeMonButton{
    if (_writerThreeMonButton == nil) {
        _writerThreeMonButton = [UIButton new];
        _writerThreeMonButton.tag = 10002;
        [_writerThreeMonButton addTarget:self action:@selector(selectTypeHandle:) forControlEvents:UIControlEventTouchUpInside];
          [_writerThreeMonButton setBackgroundImage:LOADIMAGE(NSLocalizedString(@"letter_noSelectThreeMon", nil), @"png") forState:UIControlStateNormal];
    }
    return _writerThreeMonButton;
}
- (UIButton *)writerOneMonButton{
    if (_writerOneMonButton == nil) {
        _writerOneMonButton = [UIButton new];
        _writerOneMonButton.tag = 10003;
        [_writerOneMonButton addTarget:self action:@selector(selectTypeHandle:) forControlEvents:UIControlEventTouchUpInside];
           [_writerOneMonButton setBackgroundImage:LOADIMAGE(NSLocalizedString(@"letter_noSelectOneMon", nil), @"png") forState:UIControlStateNormal];
    }
    return _writerOneMonButton;
}



- (UIButton *)payButton{
    if (_payButton == nil) {
        _payButton = [UIButton new];
        [_payButton addTarget:self action:@selector(rechargeButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
//        _payButton.backgroundColor = [UIColor lightGrayColor];
    }
    return _payButton;
}

@end
