//
//  FateDetailRechargeMaskView.m
//  Appointment
//
//  Created by apple on 16/9/26.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "FateDetailRechargeMaskView.h"
#import "MyFeedBackViewController.h"
@implementation FateDetailRechargeMaskView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
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
    MyFeedBackViewController *feed = [[MyFeedBackViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/iOS/Buy/write_v1",BaseUrl]];
    feed.titleStr = NSLocalizedString(@"写信包月", nil);
    feed.pushType = @"user-write";
    [self.viewController.navigationController pushViewController:feed animated:YES];
    [self removeFromSuperview];
}

/**
 点击打招呼按钮

 @param sender 打招呼按钮
 */
- (void)helloButtonHandle:(UIButton*)sender{
    self.fateDetailRechargeMaskViewHelloButton();
    [self removeFromSuperview];
}

/**
 添加试图
 */
- (void)setupView{
    [self addSubview:self.alphaView];
    [self addSubview:self.rechargeImageView];
    [self addSubview:self.rechargeButton];
    [self addSubview:self.helloButton];
    
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
        make.top.mas_equalTo(weakSelf).offset(kHeightIP6(118.5));
        make.width.mas_equalTo(kPercentIP6(300));
        make.height.mas_equalTo(kHeightIP6(378.5));
        make.centerX.mas_equalTo(weakSelf).offset(0);
    }];
    
    [_rechargeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf).offset(kHeightIP6(118.5));
        make.width.mas_equalTo(kPercentIP6(300));
        make.height.mas_equalTo(kHeightIP6(378.5));
        make.centerX.mas_equalTo(weakSelf).offset(0);
    }];
    
    [_rechargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.rechargeImageView.mas_bottom).offset(kHeightIP6(-51));
        make.width.mas_equalTo(kPercentIP6(242));
        make.height.mas_equalTo(kHeightIP6(36));
        make.centerX.mas_equalTo(weakSelf).offset(0);
    }];
    
    [_helloButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.rechargeImageView.mas_bottom).offset(kHeightIP6(-13));
        make.width.mas_equalTo(kPercentIP6(70));
        make.height.mas_equalTo(kHeightIP6(25));
        make.centerX.mas_equalTo(weakSelf).offset(0);
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
        UIImage* image = LOADIMAGE(NSLocalizedString(@"fate_datail_recharge_mask", nil), @"png");
        _rechargeImageView = [[UIImageView alloc]initWithImage:image];
        _rechargeImageView.userInteractionEnabled = YES;
    }
    return _rechargeImageView;
}

- (UIButton *)rechargeButton{
    if (_rechargeButton == nil) {
        _rechargeButton = [UIButton new];
        [_rechargeButton addTarget:self action:@selector(rechargeButtonHandle:) forControlEvents:UIControlEventTouchDown];
    }
    return _rechargeButton;
}

- (UIButton *)helloButton{
    if (_helloButton == nil) {
        _helloButton = [UIButton new];
        [_helloButton setTitle:NSLocalizedString(@"给Ta打招呼", nil) forState:UIControlStateNormal];
        [_helloButton setTitleColor:Color10(153, 153, 153, 1) forState:UIControlStateNormal];
        _helloButton.titleLabel.font = [UIFont systemFontOfSize:kPercentIP6(13)];
        [_helloButton addTarget:self action:@selector(helloButtonHandle:) forControlEvents:UIControlEventTouchDown];
    }
    return _helloButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
