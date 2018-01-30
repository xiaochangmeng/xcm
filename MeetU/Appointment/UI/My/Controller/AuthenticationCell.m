//
//  AuthenticationCell.m
//  Appointment
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "AuthenticationCell.h"
#import "AuthenticationIdentityController.h"
#import "AuthenticationPhoneController.h"
#import "MyInfoViewController.h"
@interface AuthenticationCell()
/**图片 */
@property (strong, nonatomic) UIImageView* authenticationImageView;
/**认证类型 */
@property (strong, nonatomic) UILabel* authenticationTypeLabel;
/**可获得的星星数量 */
@property (strong, nonatomic) UILabel* authenticationStarCountLabel;
/**按钮 */
@property (strong, nonatomic) UIButton* authenticationButton;
@end
@implementation AuthenticationCell

- (void)authenticationButtonHandle:(UIButton*)sender{
    self.buttonClick(self.tag);
   
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setupCell];
}

- (void)setupCell{
    [self setBackgroundColor:[UIColor whiteColor]];
    
    [self addSubview:self.authenticationImageView];
    
    [self addSubview:self.authenticationTypeLabel];
    
    [self addSubview:self.authenticationStarCountLabel];
    
    [self addSubview:self.authenticationButton];
    
    [self setupConstaraints];
}

- (void)setupConstaraints{
    WS(weakSelf);
    [_authenticationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf).offset(kHeightIP6(28));
        make.centerX.mas_equalTo(weakSelf).offset(0);
        make.width.mas_equalTo(kPercentIP6(39));
        make.height.mas_equalTo(kHeightIP6(42));
    }];
    
    [_authenticationTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(weakSelf.authenticationImageView.mas_bottom).offset(kHeightIP6(10));
        make.height.mas_equalTo(kHeightIP6(20));
    }];
    
    [_authenticationStarCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(weakSelf.authenticationTypeLabel.mas_bottom).offset(kHeightIP6(3));
        make.height.mas_equalTo(kHeightIP6(20));
    }];
    
    [_authenticationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.authenticationStarCountLabel.mas_bottom).offset(kHeightIP6(22));
        make.centerX.mas_equalTo(weakSelf.mas_centerX).offset(0);
        make.width.mas_equalTo(kPercentIP6(137));
        make.height.mas_equalTo(kHeightIP6(30));
    }];


}

- (UIImageView *)authenticationImageView{
    if (_authenticationImageView == nil) {
        _authenticationImageView = [UIImageView new];
        _authenticationImageView.image = LOADIMAGE(self.authenticationEntity.authenticationImageViewName, @"png");
    }
    return _authenticationImageView;
}

- (UILabel *)authenticationTypeLabel{
    if (_authenticationTypeLabel == nil) {
        _authenticationTypeLabel = [UILabel new];
        _authenticationTypeLabel.text = self.authenticationEntity.authenticationTypeTitle;
        _authenticationTypeLabel.textAlignment = NSTextAlignmentCenter;
        _authenticationTypeLabel.textColor = Color10(51, 51, 51, 1);
        _authenticationTypeLabel.font = [UIFont systemFontOfSize:kPercentIP6(14)];
    }
    return _authenticationTypeLabel;
}

- (UILabel *)authenticationStarCountLabel{
    if (_authenticationStarCountLabel == nil) {
        _authenticationStarCountLabel = [UILabel new];
        _authenticationStarCountLabel.attributedText = self.authenticationEntity.authenticationStarCount;
        _authenticationStarCountLabel.textAlignment = NSTextAlignmentCenter;
        _authenticationStarCountLabel.font = [UIFont systemFontOfSize:kPercentIP6(14)];
    }
    return _authenticationStarCountLabel;
}

- (UIButton *)authenticationButton{
    if (_authenticationButton == nil) {
        _authenticationButton = [UIButton new];
        [_authenticationButton setTitle:self.authenticationEntity.authenticationButtonTitle forState:UIControlStateNormal];
        _authenticationButton.layer.borderColor = Color10(51, 51, 51, 1).CGColor;
        [_authenticationButton setTitleColor:Color10(51, 51, 51, 1) forState:UIControlStateNormal];
        _authenticationButton.titleLabel.font = [UIFont systemFontOfSize:kPercentIP6(14)];
        _authenticationButton.layer.borderWidth = 1.0f;
        [_authenticationButton addTarget:self action:@selector(authenticationButtonHandle:) forControlEvents:UIControlEventTouchDown];
    }
    return _authenticationButton;
}

@end
