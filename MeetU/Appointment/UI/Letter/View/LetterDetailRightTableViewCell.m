//
//  PrivateLetterDetailRightTableViewCell.m
//  Appointment
//  私信详情右方Cell(聊天界面我的Cell)
//  Created by feiwu on 16/7/20.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "LetterDetailRightTableViewCell.h"
@implementation LetterDetailRightTableViewCell

#pragma mark - Life Cycle
//生命周期方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initView];
        [self makeConstraints];
    }
    return self;
}

#pragma mark - Private Methods
//私有方法
#pragma mark 初始化
- (void)initView
{
    self.backgroundColor = Color10(243, 245, 246, 1);
    [self addSubview:self.timeLabel];
    [self addSubview:self.timeImageView];
    [self addSubview:self.logoImageView];
    [self addSubview:self.logoMaskView];
    [self addSubview:self.bgButton];
    [self addSubview:self.detailLabel];
    [self addSubview:self.resendButton];
}

#pragma mark 布局
- (void)makeConstraints
{
    WS(weakSelf)
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf).offset(5);
        make.centerX.mas_equalTo(weakSelf);
    }];
    
    [self.timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.timeLabel.mas_left).offset(-5);
        make.centerY.mas_equalTo(weakSelf.timeLabel);
        make.size.mas_equalTo(CGSizeMake(10 , 10));
    }];

    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf).offset(30);
        make.right.equalTo(weakSelf.mas_right).offset(kPercentIP6(-20/2));
        make.size.mas_equalTo(CGSizeMake(80/2, 80/2));
    }];
    [self.logoMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf).offset(30);
        make.right.equalTo(weakSelf.mas_right).offset(kPercentIP6(-20/2));
        make.size.mas_equalTo(CGSizeMake(80/2, 80/2));
    }];

    
    [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.mas_equalTo(weakSelf).offset(30);
        make.right.equalTo(weakSelf.logoImageView.mas_left).offset(kPercentIP6(-12/2));
        make.width.mas_equalTo(weakSelf.textWidth + 33);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(kPercentIP6(-30/2));
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgButton).offset(30/2);
        make.left.equalTo(weakSelf.bgButton).offset(24/2);
        make.right.equalTo(weakSelf.bgButton.mas_right).offset(-36/2);
    }];
    
    [self.resendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.bgButton.mas_bottom);
        make.right.equalTo(weakSelf.bgButton.mas_left).offset(-12/2);
        make.size.mas_equalTo(CGSizeMake(46/2, 46/2));
    }];
    
}

#pragma mark - Public Methods
//公有方法
#pragma mark 选中方法
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Event Responses
//事件响应方法
- (void)clickResendButton:(UIButton *)sender
{
   
}

#pragma mark - "控件代理方法"
//控件代理方法

#pragma mark - Notification Responses
//通知响应方法

#pragma mark - Network Data
//网络请求处理方法

#pragma mark - Getters And Setters
//getter 和 setter 方法
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.textColor = Color10(153,153,153, 1);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = kFont12;
        [_timeLabel sizeToFit];
        _timeLabel.backgroundColor = [UIColor clearColor];
    }
    return _timeLabel;
}

- (UIImageView *)timeImageView {
    if (!_timeImageView) {
        _timeImageView = [[UIImageView alloc] init];
        _timeImageView.image = LOADIMAGE(@"letter_detail_time@2x", @"png");
    }
    return _timeImageView;
}

- (MZYImageView *)logoImageView
{
    if (!_logoImageView) {
        _logoImageView = [MZYImageView new];
        _logoImageView.clipsToBounds = YES;
        _logoImageView.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return _logoImageView;
}
- (UIImageView *)logoMaskView {
    if (!_logoMaskView) {
        _logoMaskView = [[UIImageView alloc] init];
        _logoMaskView.image = LOADIMAGE(@"letter_detailMask@2x", @"png");
    }
    return _logoMaskView;
}

- (UIButton *)bgButton
{
    if (!_bgButton) {
        _bgButton =[UIButton new];
        //Button文字
        [_bgButton setBackgroundImage:[UIImage imageNamed:@"letter_message_blue_bubble@2x" ImageType:@"png" withTop:20 andLeft:18] forState:UIControlStateNormal];
        [_bgButton setBackgroundImage:[UIImage imageNamed:@"letter_message_blue_bubble@2x" ImageType:@"png" withTop:20 andLeft:18] forState:UIControlStateHighlighted];
        //Button方法
    }
    return _bgButton;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.textColor = Color10(37, 38, 42, 1);
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.font = kFont16;
        _detailLabel.numberOfLines = 0;
//        _detailLabel.backgroundColor = [UIColor orangeColor];
    }
    return _detailLabel;
}

- (UIButton *)resendButton
{
    if (!_resendButton) {
        _resendButton =[UIButton new];
        //Button文字
        [_resendButton setImage: LOADIMAGE(@"profile_message_resend_default@2x", @"png") forState:UIControlStateNormal];
        [_resendButton setImage: LOADIMAGE(@"profile_message_resend_highlighted@2x", @"png") forState:UIControlStateHighlighted];
        //Button方法
        [_resendButton addTarget:self action:@selector(clickResendButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resendButton;
}

- (void)setTextWidth:(float)textWidth
{
    WS(weakSelf)
    _textWidth = textWidth;
    if (textWidth) {
        [self.bgButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(30);
            make.right.equalTo(weakSelf.logoImageView.mas_left).offset(kPercentIP6(-12/2));
            make.width.mas_equalTo(textWidth + 33);
            make.bottom.equalTo(weakSelf.mas_bottom).offset(kPercentIP6(-30/2));
        }];
        
        [self.detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.bgButton);
            make.left.equalTo(weakSelf.bgButton).offset(24/2);
            make.right.equalTo(weakSelf.bgButton.mas_right).offset(-36/2);
        }];
    }
}

@end
