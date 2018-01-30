//
//  LetterCell.m
//  Appointment
//
//  Created by feiwu on 16/7/14.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "LetterTableViewCell.h"
#import "NSString+MZYExtension.h"
#import "LetterViewController.h"
#import "FateDetailViewController.h"
@implementation LetterTableViewCell
#pragma mark - Life Cycle
//生命周期方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [self addSubview:self.userImageView];
    [self addSubview:self.userMaskView];
    [self.userMaskView addSubview:self.statusView];
    [self addSubview:self.visitorNumber];
    [self addSubview:self.nickLabel];
    [self addSubview:self.vipImageView];
    [self addSubview:self.messageLabel];
    [self addSubview:self.likeImageView];
    [self addSubview:self.likeLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.viewImageView];
    [self addSubview:self.lineView];
}

#pragma mark 布局
- (void)makeConstraints
{
    WS(weakSelf);
    [_userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [_userMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [_statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-6);
        make.top.mas_equalTo(6);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    
    
    [_visitorNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.userImageView.mas_top).offset(2);
        make.right.mas_equalTo(weakSelf.userImageView.mas_right).offset(-2);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(18);
    }];
    
    
    [_nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.userImageView.mas_right).offset(10);
        make.width.mas_equalTo(0);
        make.top.mas_equalTo(weakSelf.userImageView.mas_top).offset(15);
        make.height.mas_equalTo(16);
    }];
    
    [_vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nickLabel.mas_right).offset(3);
        make.centerY.mas_equalTo(weakSelf.nickLabel);
        make.size.mas_equalTo(CGSizeMake(27, 12));
    }];
    
    
    [_likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf).offset(-3);
        make.left.mas_equalTo(weakSelf.userImageView.mas_right).offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];
    
    [_likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.likeImageView.mas_right).offset(0);
        make.right.mas_equalTo(weakSelf).offset(-20);
        make.centerY.mas_equalTo(weakSelf.likeImageView).offset(4);
        make.height.mas_equalTo(16);
    }];
    
    
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.userImageView.mas_right).offset(10);
        make.right.mas_equalTo(weakSelf.viewImageView.mas_left).offset(-10);
        make.top.mas_equalTo(weakSelf.nickLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(16);
    }];
    
    [_viewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf).offset(-13);
        make.centerY.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(75, 24));
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.viewImageView);
        make.top.mas_equalTo(weakSelf.userImageView.mas_top).offset(0);
        make.size.mas_equalTo(CGSizeMake(80, 16));
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 1));
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

#pragma mark - "控件代理方法"
//控件代理方法

#pragma mark - Notification Responses
//通知响应方法

#pragma mark - Network Data
//网络请求处理方法

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

- (MZYImageView *)userMaskView {
    if (!_userMaskView) {
        _userMaskView = [[MZYImageView alloc] init];
        _userMaskView.image = LOADIMAGE(@"letter_userMask@2x", @"png");
        WS(weakSelf);
        _userMaskView.touchBlock = ^(){
            if (weakSelf.model.send_id ) {
                if (![weakSelf.model.send_id isEqualToString:@"1000000"]) {
                    LetterViewController *letter = (LetterViewController *)weakSelf.viewController;
                    FateDetailViewController *detail = [[FateDetailViewController alloc] init];
                    weakSelf.model.user_id = weakSelf.model.send_id;
                    detail.fateModel = weakSelf.model;
                    [letter.navigationController pushViewController:detail animated:YES];
                    
                }
            } else {
                //最近访客
                [[NSNotificationCenter defaultCenter] postNotificationName:@"clickVisitorHeadImage" object:nil];
            }
        };
    }
    return _userMaskView;
}

- (UILabel *)nickLabel {
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc] init];
        //        _nickLabel.backgroundColor = [UIColor lightGrayColor];
        _nickLabel.font = kFont16;
        
    }
    return _nickLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        //        _ageLabel.backgroundColor = [UIColor lightGrayColor];
        _messageLabel.font = kFont14;
        _messageLabel.textColor = [UIColor lightGrayColor];
        
    }
    return _messageLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        //                _timeLabel.backgroundColor = [UIColor orangeColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = kFont12;
        _timeLabel.textColor = Color10(153, 153, 153, 1);
        
    }
    return _timeLabel;
}

- (UIImageView *)viewImageView {
    if (!_viewImageView) {
        _viewImageView = [[UIImageView alloc] init];
        _viewImageView.contentMode = UIViewContentModeScaleToFill;
        _viewImageView.image = LOADIMAGE(NSLocalizedString(@"letter_immediately_look", nil), @"png");
    }
    return _viewImageView;
}

- (UIImageView *)likeImageView {
    if (!_likeImageView) {
        _likeImageView = [[UIImageView alloc] init];
        _likeImageView.contentMode = UIViewContentModeScaleToFill;
        _likeImageView.animationImages = @[LOADIMAGE(@"letter_likeOne@2x", @"png"),LOADIMAGE(@"letter_likeTwo@2x", @"png")];
        _likeImageView.animationDuration = 1;
        _likeImageView.animationRepeatCount = 10000;
        
    }
    return _likeImageView;
}
- (UILabel *)likeLabel {
    if (!_likeLabel) {
        _likeLabel = [[UILabel alloc] init];
        _likeLabel.textAlignment = NSTextAlignmentLeft;
        _likeLabel.font = [UIFont boldSystemFontOfSize:12];
        _likeLabel.textColor = [UIColor orangeColor];
        _likeLabel.text = @"她距离你最近";
        //        _likeLabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _likeLabel;
}
- (UIButton *)visitorNumber {
    if (!_visitorNumber) {
        _visitorNumber = [[UIButton alloc] init];
        _visitorNumber.titleLabel.font = kFont10;
        [_visitorNumber setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_visitorNumber setBackgroundImage:LOADIMAGE(@"letter_visitorBackground@2x", @"png") forState:UIControlStateNormal];
    }
    return _visitorNumber;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = Color10(239, 239, 239, 1);
    }
    return _lineView;
}
- (UIImageView *)vipImageView {
    if (!_vipImageView) {
        _vipImageView = [[UIImageView alloc] init];
        _vipImageView.image =LOADIMAGE(@"select_vip@2x", @"png");
        _vipImageView.hidden = YES;
    }
    return _vipImageView;
}

- (UIImageView *)statusView {
    if (!_statusView) {
        _statusView = [[UIImageView alloc] init];
        _statusView.image = LOADIMAGE(@"letter_status@2x", @"png");
        _statusView.hidden = YES;
    }
    return _statusView;
}


- (void)setModel:(FateModel *)model
{
    _model = model;
    WS(weakSelf);
    _nickLabel.text = _model.name;
    
    CGFloat ageWidth = [_model.name textWidthWithContentHeight:20 font:kFont16] + 2;
    if (ageWidth > ScreenWidth - 240) {
        ageWidth = ScreenWidth - 240;
    }
    [_nickLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ageWidth);
    }];
    
    
    
    if ([_model.flag_vip isEqualToString:@"0"]) {
        //不是vip
        _vipImageView.hidden = YES;
    } else if ([_model.flag_vip isEqualToString:@"1"]) {
        //是VIP
        _vipImageView.hidden = NO;
    } else {
        _vipImageView.hidden = YES;
    }
    
    
    _messageLabel.text = _model.content;
    _timeLabel.text = _model.time;
    
    if (_indexPath.row == 0) {
        //最近访客
        _userImageView.image = LOADIMAGE(@"letter_visitor@2x", @"png");
        if ([_model.visitor_num intValue] > 0) {
            _visitorNumber.hidden = NO;
            [_visitorNumber setTitle:_model.visitor_num forState:UIControlStateNormal];
        } else {
            _visitorNumber.hidden = YES;//访客数目
        }
        _viewImageView.hidden = YES;//查看按钮
        _statusView.hidden = YES;//状态红点
        
    } else {
        //非最近访客
        
        [_userImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:LOADIMAGE(NSLocalizedString(@"fate_headPlaceholder", nil), @"png")];
        _visitorNumber.hidden = YES;
        
        if ([_model.status integerValue] == 0) {
            _viewImageView.hidden = NO;
            _statusView.hidden = NO;
            [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(weakSelf.userImageView.mas_top).offset(0);
            }];
            [_messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(weakSelf.userImageView.mas_right).offset(10);
                make.right.mas_equalTo(weakSelf.viewImageView.mas_left).offset(-10);
                make.top.mas_equalTo(weakSelf.nickLabel.mas_bottom).offset(20);
                make.height.mas_equalTo(16);
            }];
            
        } else {
            _viewImageView.hidden = YES;
            _statusView.hidden = YES;
            [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(weakSelf.userImageView.mas_top).offset(30);
            }];
            [_messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(weakSelf.userImageView.mas_right).offset(10);
                make.right.mas_equalTo(weakSelf).offset(-kPercentIP6(70));
                make.top.mas_equalTo(weakSelf.nickLabel.mas_bottom).offset(20);
                make.height.mas_equalTo(16);
            }];
            
        }
        
    }
    
    //心形动画
    if (![_model.highlight isEqualToString:@""] && _model.height != nil) {
        //显示心形动画
        _likeImageView.hidden = NO;
        _likeLabel.hidden = NO;
        [_likeImageView startAnimating];
    } else {
        //不显示
        _likeImageView.hidden = YES;
        _likeLabel.hidden = YES;
        //        [_likeImageView stopAnimating];
    }
    
    
    
}

@end
