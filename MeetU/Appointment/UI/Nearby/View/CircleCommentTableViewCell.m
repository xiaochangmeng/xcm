//
//  CircleCommentTableViewCell.m
//  Appointment
//
//  Created by apple on 17/2/9.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "CircleCommentTableViewCell.h"
#import "NSString+MZYExtension.h"
#import "NSDate+MZYExtension.h"
#import "LXFileManager.h"
@implementation CircleCommentTableViewCell

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
    [self addSubview:self.nickLabel];
    [self addSubview:self.vipImageView];
    [self addSubview:self.timeLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.lineView];
    
}

#pragma mark 布局
- (void)makeConstraints
{
    WS(weakSelf);
    [_userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(weakSelf).offset(12);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    [_userMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(weakSelf).offset(12);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];

    
    [_nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.userImageView.mas_right).offset(6);
        make.centerY.mas_equalTo(weakSelf.userImageView);
    }];
    
    [_vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nickLabel.mas_right).offset(3);
        make.centerY.mas_equalTo(weakSelf.nickLabel);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];

    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf).offset(-15);
        make.top.mas_equalTo(weakSelf).offset(22);
    }];
    
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nickLabel.mas_left);
        make.top.mas_equalTo(weakSelf.userImageView.mas_bottom).offset(10);
        make.right.mas_equalTo(weakSelf).offset(-15);
        make.height.mas_equalTo(20);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.bottom.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 24, 1));
    }];

}
#pragma mark - Getters And Setters
/**
 头像
 */
- (UIImageView *)userImageView {
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.clipsToBounds = YES;
        _userImageView.contentMode = UIViewContentModeScaleAspectFill;
        _userImageView.image = LOADIMAGE(@"fate_headPlaceholder@2x", @"png");
    }
    return _userImageView;
}
- (UIImageView *)userMaskView {
    if (!_userMaskView) {
        _userMaskView = [[UIImageView alloc] init];
        _userMaskView.image = LOADIMAGE(@"circle_userMask@2x", @"png");
    }
    return _userMaskView;
}


/**
 昵称
 */
- (UILabel *)nickLabel {
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc] init];
        _nickLabel.font = [UIFont systemFontOfSize:kPercentIP6(14)];
        _nickLabel.textColor = Color16(0x727EB3);
        [_nickLabel sizeToFit];
//        _nickLabel.text = @"西门飘雪";
//        _nickLabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _nickLabel;
}


/**
 时间
 */
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:kPercentIP6(12)];
        _timeLabel.textColor = Color16(0xA4A7B3);
        [_timeLabel sizeToFit];
//        _timeLabel.text = @"20分钟前";
//        _timeLabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _timeLabel;
}


/**
 正文
 */
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:kPercentIP6(16)];
        _contentLabel.textColor = Color16(0x333333);
//        _contentLabel.backgroundColor = [UIColor lightGrayColor];
//        _contentLabel.text = @"老板我错了，你别开除我？？？";
    }
    return _contentLabel;
}

/**
 VIP标识
 */

- (UIImageView *)vipImageView {
    if (!_vipImageView) {
        _vipImageView = [[UIImageView alloc] init];
        _vipImageView.image =LOADIMAGE(@"fate_vip@2x", @"png");
        _vipImageView.hidden = YES;
    }
    return _vipImageView;
}

/**
 底部线条
 */

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = Color10(239, 239, 239, 1);
    }
    return _lineView;
}

/**
 modelset方法
 */
- (void)setModel:(CircleCommnetModel *)model{
    if (_model != model) {
        _model = model;
        //头像
        [_userImageView sd_setImageWithURL:[NSURL URLWithString:_model.avatar] placeholderImage:LOADIMAGE(@"fate_headPlaceholder@2x", @"png") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        
        //昵称
        _nickLabel.text = _model.nickname;
        
        // MARK: - 修改vip
        //vip
//        NSString *status = [LXFileManager readUserDataForKey:kAppIsCheckStatus];
//        if ([status intValue] != 0) {
            if ([_model.vip_grade integerValue] == 20 || [_model.vip_grade integerValue] == 30) {
                _vipImageView.hidden = NO;
                _vipImageView.image =LOADIMAGE(@"fate_vip@2x", @"png");
            } else if ([_model.vip_grade integerValue] == 80){
                _vipImageView.hidden = NO;
                _vipImageView.image =LOADIMAGE(@"circle_vip@2x", @"png");
            } else {
                _vipImageView.hidden = YES;
            }
//        } else {
//            //审核中
//            _vipImageView.hidden = YES;
//        }
        
        //时间
        NSString *time =  [NSDate dateString:_model.create_time dateFormatter:@"MM/dd hh:mm"];
        _timeLabel.text = time;
        
        //内容
        _contentLabel.text = _model.content;
        CGFloat height = [_model.content textHeightWithContentWidth:ScreenWidth - 72 font:_contentLabel.font = [UIFont systemFontOfSize:kPercentIP6(16)]];
        if (height > 90) {
            height = 90;
        }
        [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height + 2);
        }];
        
    }
}

@end
