//
//  CirclePhotoPayMaskView.m
//  Appointment
//
//  Created by feiwu on 2017/2/13.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "CirclePhotoPayMaskView.h"
#import "MyFeedBackViewController.h"
#import "CustomNavigationController.h"

@implementation CirclePhotoPayMaskView
{
    CircleModel *_model;
    NSIndexPath *_indexPath;//点击的indexpath
    NSString *_paytype;//1.微信 2.支付宝
    NSString * _index;//点击图片下标
}

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame  CircleModel:(CircleModel *)model IndexPath:(NSIndexPath *)indexPath Index:(NSString *)index{
    if (self = [super initWithFrame:frame]) {
        _model = model;
        _indexPath = indexPath;
        _index = index;
        _paytype = @"1";
        [self setupView];
    }
    return self;
}
/**
 添加试图
 */
- (void)setupView{
    [self addSubview:self.alphaView];
    [self addSubview:self.rechargeImageView];
    [self.rechargeImageView addSubview:self.cancleButton];
    [self.rechargeImageView addSubview:self.userImageView];
    [self.rechargeImageView addSubview:self.priceLabel];
    [self.rechargeImageView addSubview:self.weixinButton];
    [self.rechargeImageView addSubview:self.alipayButton];
    [self.rechargeImageView addSubview:self.payButton];
    [self.rechargeImageView addSubview:self.vipButton];
    
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
        make.width.mas_equalTo(kPercentIP6(283));
        make.height.mas_equalTo(kHeightIP6(384));
        make.centerX.mas_equalTo(weakSelf).offset(0);
    }];
    
    
    [_cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.rechargeImageView).offset(5);
        make.left.equalTo(weakSelf.rechargeImageView).offset(5);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(35);
    }];
    
    [_userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.rechargeImageView).offset(kHeightIP6(62));
         make.centerX.mas_equalTo(weakSelf.rechargeImageView).offset(0);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];

    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.rechargeImageView).offset(0);
        make.top.mas_equalTo(weakSelf.userImageView.mas_bottom).offset(kHeightIP6(18));
    }];


    [_weixinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.payButton.mas_top).offset(-kHeightIP6(15.5));
        make.left.equalTo(weakSelf.rechargeImageView).offset(kPercentIP6(23.5));
        make.height.mas_equalTo(kHeightIP6(31));
        make.right.mas_equalTo(weakSelf.rechargeImageView.mas_centerX).offset(-kPercentIP6(7));
    }];
    
    [_alipayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.payButton.mas_top).offset(-kHeightIP6(15.5));
        make.right.equalTo(weakSelf.rechargeImageView).offset(-kPercentIP6(23.5));
        make.height.mas_equalTo(kHeightIP6(31));
        make.left.mas_equalTo(weakSelf.rechargeImageView.mas_centerX).offset(kPercentIP6(7));
    }];

    
    [_payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.rechargeImageView.mas_bottom).offset(-kHeightIP6(68));
        make.left.mas_equalTo(weakSelf.rechargeImageView).offset(kPercentIP6(23.5));
        make.right.mas_equalTo(weakSelf.rechargeImageView).offset(-kPercentIP6(23.5));
        make.height.mas_equalTo(kHeightIP6(45));
    }];
    [_vipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.rechargeImageView.mas_bottom).offset(-kHeightIP6(15));
        make.left.mas_equalTo(weakSelf.rechargeImageView).offset(kPercentIP6(23.5));
        make.right.mas_equalTo(weakSelf.rechargeImageView).offset(-kPercentIP6(23.5));
        make.height.mas_equalTo(kHeightIP6(45));
    }];

}

#pragma mark - Event Responses
/**
 点击取消按钮
 */
- (void)clickCancleButton:(UIButton *)sender
{
    [self removeFromSuperview];
}

/**
 点击微信支付按钮
 */
- (void)clickWeixXinButton:(UIButton *)sender
{
    [_weixinButton setBackgroundImage:LOADIMAGE(@"nearby_wechat_code_s", @"png") forState:UIControlStateNormal];
    [_alipayButton setBackgroundImage:LOADIMAGE(@"circle_alipay_noselected@2x", @"png") forState:UIControlStateNormal];
    _paytype = @"1";
}
/**
 点击支付宝支付按钮
 */
- (void)clickAlipayButton:(UIButton *)sender
{
    [_weixinButton setBackgroundImage:LOADIMAGE(@"circle_weixin_noselected@2x", @"png") forState:UIControlStateNormal];
    [_alipayButton setBackgroundImage:LOADIMAGE(@"circle_alipay_selected@2x", @"png") forState:UIControlStateNormal];
    _paytype = @"2";
}
/**
 点击立即支付按钮
 */
- (void)clickPayButton:(UIButton *)sender
{
    NSString *mid = _model.publish_id;
    NSString *comment_id = _model.comment_id;
    NSDictionary *picDic  = [_model.pics_url objectAtIndex:[_index integerValue]];
    NSString *price = [picDic objectForKey:@"price"];
     NSString *simg_id = [picDic objectForKey:@"id"];
    NSLog(@"图片id是多少:%@",simg_id);
    NSDictionary *dic = @{@"price" : price, @"paytype" : _paytype , @"smid" : mid, @"comment_id" : comment_id, @"indexPath" : _indexPath ,@"simg_id" : simg_id, @"picDic" : picDic ,@"index" : _index};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CircleAwardPay" object:dic];
    [self removeFromSuperview];
}

/**
 钻石VIP查看
 */
- (void)clickVipButton:(UIButton *)sender
{
    FWUserInformation *info = [FWUserInformation sharedInstance];
    if ([info.vip_grade integerValue] == 80) {
        NSString *mid = _model.publish_id;
        NSString *comment_id = _model.comment_id;
        NSDictionary *picDic  = [_model.pics_url objectAtIndex:[_index integerValue]];
        NSString *price = [picDic objectForKey:@"price"];
        NSString *simg_id = [picDic objectForKey:@"id"];
        NSDictionary *dic = @{@"price" : price, @"paytype" : _paytype , @"smid" : mid, @"comment_id" : comment_id, @"indexPath" : _indexPath ,@"simg_id" : simg_id, @"picDic" : picDic ,@"index" : _index};
        if (_vipBlock) {
            _vipBlock(dic);
        }
    } else {
        MyFeedBackViewController *feed = [[MyFeedBackViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/WebApi/Buy/apple_vip_v3.html",BaseUrl]];
        feed.titleStr = @"VIP会员";
        feed.pushType = @"circle-masking-combination";
        CustomNavigationController *navigation = (CustomNavigationController *)self.viewController;
        [navigation pushViewController:feed animated:YES];
    }
    [self removeFromSuperview];
}

#pragma mark - Getters And Setters
/**
 底部黑色背景
 */
- (UIView *)alphaView{
    if (_alphaView == nil) {
        _alphaView = [UIView new];
        _alphaView.backgroundColor = Color10(0, 0, 0, 0.75f);
    }
    return _alphaView;
}

/**
 支付背景
 */
- (UIImageView *)rechargeImageView{
    if (_rechargeImageView == nil) {
        UIImage* image = LOADIMAGE(@"circle_photoPayMask@2x", @"png");
        _rechargeImageView = [[UIImageView alloc]initWithImage:image];
        _rechargeImageView.userInteractionEnabled = YES;
    }
    return _rechargeImageView;
}

/**
 取消button
 */
- (UIButton *)cancleButton
{
    if (!_cancleButton) {
        _cancleButton = [UIButton new];
        [_cancleButton addTarget:self action:@selector(clickCancleButton:) forControlEvents:UIControlEventTouchUpInside];
//        _cancleButton.backgroundColor = [UIColor lightGrayColor];
    }
    return _cancleButton;
}

/**
 头像
 */
- (UIImageView *)userImageView {
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.clipsToBounds = YES;
        _userImageView.contentMode = UIViewContentModeScaleAspectFill;
        _userImageView.layer.masksToBounds = YES;
        _userImageView.layer.cornerRadius = 25.0;
//        NSDictionary *user = _model.author;
        NSString *img = _model.avatar;
        [_userImageView sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:LOADIMAGE(@"fate_headPlaceholder@2x", @"png") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];

    }
    return _userImageView;
}


/**
 价格视图
 */
- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:kPercentIP6(35)];
        _priceLabel.textColor = Color16(0xFFECBE);
        _priceLabel.textAlignment = NSTextAlignmentCenter;
//        _priceLabel.text = _price;
        NSDictionary *picDic  = [_model.pics_url objectAtIndex:[_index integerValue]];
        NSString *price = [picDic objectForKey:@"price"];
        _priceLabel.attributedText = [self changeFont:[UIFont systemFontOfSize:kPercentIP6(18)] TotalString:[NSString stringWithFormat:@"%@ 元",price] SubStringArray:@[@"元"]];
        [_priceLabel sizeToFit];
//                _priceLabel.backgroundColor = [UIColor orangeColor];
    }
    return _priceLabel;
}


/**
 微信支付button
 */
- (UIButton *)weixinButton
{
    if (!_weixinButton) {
        _weixinButton = [UIButton new];
        [_weixinButton setBackgroundImage:LOADIMAGE(@"circle_weixin_selected@2x", @"png") forState:UIControlStateNormal];
        [_weixinButton addTarget:self action:@selector(clickWeixXinButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weixinButton;
}

/**
 支付宝支付button
 */
- (UIButton *)alipayButton
{
    if (!_alipayButton) {
        _alipayButton = [UIButton new];
        [_alipayButton setBackgroundImage:LOADIMAGE(@"circle_alipay_noselected@2x", @"png") forState:UIControlStateNormal];
        [_alipayButton addTarget:self action:@selector(clickAlipayButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _alipayButton;
}

/**
 打赏buton
 */
- (UIButton *)payButton{
    if (_payButton == nil) {
        _payButton = [UIButton new];
        [_payButton addTarget:self action:@selector(clickPayButton:) forControlEvents:UIControlEventTouchDown];
//        _payButton.backgroundColor = [UIColor lightGrayColor];
    }
    return _payButton;
}

/**
 钻石VIPbuton
 */
- (UIButton *)vipButton{
    if (_vipButton == nil) {
        _vipButton = [UIButton new];
        [_vipButton addTarget:self action:@selector(clickVipButton:) forControlEvents:UIControlEventTouchDown];
//        _vipButton.backgroundColor = [UIColor orangeColor];
    }
    return _vipButton;
}


/**
 *  单纯改变一句话中的某些字的颜色
 *
 *  @param color    需要改变成的颜色
 *  @param totalStr 总的字符串
 *  @param subArray 需要改变颜色的文字数组
 *
 *  @return 生成的富文本
 */
- (NSMutableAttributedString *)changeFont:(UIFont *)font TotalString:(NSString *)totalStr SubStringArray:(NSArray *)subArray {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    for (NSString *rangeStr in subArray) {
        NSRange range = [totalStr rangeOfString:rangeStr options:NSBackwardsSearch];
        [attributedStr addAttribute:NSFontAttributeName value:font range:range];
    }
    return attributedStr;
    
}


@end
