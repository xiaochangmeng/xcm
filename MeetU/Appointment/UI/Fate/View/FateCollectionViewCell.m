//
//  FateCell.m
//  Appointment
//
//  Created by feiwu on 16/7/13.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "FateCollectionViewCell.h"
#import "FateHelloApi.h"
#import "FateViewController.h"
#import "FateHelloApi.h"

@implementation FateCollectionViewCell
#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

#pragma mark - Private Methods

- (void)initSubviews{
    WS(weakSelf);
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.userImageView];
    [self addSubview:self.maskImageView];
    [self addSubview:self.likeButton];
    [self addSubview:self.nameLabel];
    [self addSubview:self.hotImageView];
     [self addSubview:self.vipImageView];
    [_userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf);
        make.left.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf);
        make.right.mas_equalTo(weakSelf);
        
    }];
    
    [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-6.5);
        make.left.mas_equalTo(weakSelf.mas_left).offset(6);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-6.5);
        make.left.mas_equalTo(weakSelf.likeButton.mas_right).offset(kPercentIP6(7));
        make.right.mas_equalTo(weakSelf.mas_right).offset(kPercentIP6(-7));
        
    }];
    
    [_maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.likeButton.mas_top).offset(0);
        make.right.mas_equalTo(weakSelf).offset(0);
        make.left.mas_equalTo(weakSelf).offset(0);
        make.bottom.mas_equalTo(weakSelf).offset(0);
        
    }];

    [_hotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf).offset(5);
        make.left.mas_equalTo(weakSelf).offset(5);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(11);
    }];
    
    [_vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf).offset(5);
        make.right.mas_equalTo(weakSelf).offset(-5);
        make.width.mas_equalTo(24.5);
        make.height.mas_equalTo(11);
    }];
}

#pragma mark - Getters And Setters
- (UIImageView *)userImageView {
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.clipsToBounds = YES;
        _userImageView.contentMode = UIViewContentModeScaleAspectFill;
        _userImageView.image = LOADIMAGE(NSLocalizedString(@"fate_headPlaceholder", nil), @"png");
    }
    return _userImageView;
}
- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [[UIButton alloc] init];
         [_likeButton setImage:LOADIMAGE(@"fate_woman@2x", @"png") forState:UIControlStateNormal];
        
    }
    return _likeButton;
}

- (UILabel *)nameLabel{
    if (_nameLabel == nil) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:kPercentIP6(12)];
        _nameLabel.textColor =[UIColor whiteColor];
    }
    return _nameLabel;
}

- (UIImageView *)maskImageView{
    if (_maskImageView == nil) {
        _maskImageView = [[UIImageView alloc]initWithImage:LOADIMAGE(@"fate_mask@2x", @"png")];
        _maskImageView.alpha = 1.0f;
    }
    return _maskImageView;
}

- (UIImageView *)hotImageView{
    if (_hotImageView == nil) {
        _hotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sign_photo_hot"]];
    }
    return _hotImageView;
}

- (UIImageView *)vipImageView{
    if (_vipImageView == nil) {
        _vipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fate_vip"]];
        _vipImageView.hidden = YES;
    }
    return _vipImageView;
}


- (void)setModel:(FateModel *)model
{
    _model = model;
    //显示男女
    if ([_model.sex isEqualToString:@"0"]) {
        //女
        [_likeButton setImage:LOADIMAGE(@"fate_woman@2x", @"png") forState:UIControlStateNormal];
    } else {
        //男
        [_likeButton setImage:LOADIMAGE(@"fate_man@2x", @"png") forState:UIControlStateNormal];
    }
    
    //是否是vip
    if ([_model.flag_vip isEqualToString:@"0"]) {
        //不是vip
        _vipImageView.hidden = YES;
    } else if ([_model.flag_vip isEqualToString:@"1"]) {
        //是VIP
        _vipImageView.hidden = NO;
    } else {
        _vipImageView.hidden = YES;
    }
   }



@end
