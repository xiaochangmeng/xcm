//
//  FateDetailVipMaskView.m
//  Appointment
//
//  Created by feiwu on 2016/11/1.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "FateDetailVipMaskView.h"
#import "MyFeedBackViewController.h"
@implementation FateDetailVipMaskView

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        _title = title;
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
    
    MyFeedBackViewController *feed = [[MyFeedBackViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/iOS/Buy/vip_v1",BaseUrl]];
    feed.titleStr = NSLocalizedString(@"VIP会员", nil);
    feed.pushType = @"user-vip";
    [self.viewController.navigationController pushViewController:feed animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.viewController.navigationController setNavigationBarHidden:NO animated:NO];
    [self removeFromSuperview];
}


/**
 添加试图
 */
- (void)setupView{
    [self addSubview:self.alphaView];
    [self addSubview:self.rechargeImageView];
    [self.rechargeImageView addSubview:self.titleLabel];
    [self addSubview:self.rechargeButton];
    
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
    
    [_rechargeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf).offset(0);
        make.width.mas_equalTo(kPercentIP6(300));
        make.height.mas_equalTo(kHeightIP6(230));
        make.centerX.mas_equalTo(weakSelf).offset(0);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.rechargeImageView).offset(20);
        make.left.mas_equalTo(weakSelf.rechargeImageView).offset(17);
        make.right.mas_equalTo(weakSelf.rechargeImageView).offset(-17);
    }];
    
    
    [_rechargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.rechargeImageView.mas_bottom).offset(kHeightIP6(-10));
        make.left.mas_equalTo(weakSelf.rechargeImageView).offset(16);
        make.width.mas_equalTo(kPercentIP6(265));
        make.height.mas_equalTo(kHeightIP6(35));
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

- (UIImageView *)rechargeImageView{
    if (_rechargeImageView == nil) {
        UIImage* image = LOADIMAGE(NSLocalizedString(@"common_pay_feedback@2x", nil), @"png");
        _rechargeImageView = [[UIImageView alloc]initWithImage:image];
        _rechargeImageView.userInteractionEnabled = YES;
    }
    return _rechargeImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kPercentIP6(14)];
        _titleLabel.textColor = Color16(0x999999);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = _title;
    }
    return _titleLabel;
}

- (UIButton *)rechargeButton{
    if (_rechargeButton == nil) {
        _rechargeButton = [UIButton new];
        [_rechargeButton addTarget:self action:@selector(rechargeButtonHandle:) forControlEvents:UIControlEventTouchDown];
        //               _rechargeButton.backgroundColor = [UIColor lightGrayColor];
    }
    return _rechargeButton;
}

@end
