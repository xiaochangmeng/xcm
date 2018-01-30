//
//  LetterDetailVoiceTableViewCell.m
//  Appointment
//
//  Created by feiwu on 16/7/20.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "LetterDetailVoiceTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "LetterDetailViewController.h"
#import "FateDetailViewController.h"
@implementation LetterDetailVoiceTableViewCell
{
    AVPlayer *_player;
}

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
    [self addSubview:self.voiceButton];
    [self addSubview:self.voiceLabel];
    [self addSubview:self.contentImageView];
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
        make.left.equalTo(weakSelf).offset(kPercentIP6(24/2));
        make.size.mas_equalTo(CGSizeMake(80/2, 80/2));
    }];
    
    [self.logoMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf).offset(30);
        make.left.equalTo(weakSelf).offset(kPercentIP6(24/2));
        make.size.mas_equalTo(CGSizeMake(80/2, 80/2));
    }];

    
    [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf).offset(30);
        make.left.equalTo(weakSelf.logoImageView.mas_right).offset(kPercentIP6(12/2));
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(50);
    }];
    
    [self.voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgButton).offset(10);
        make.left.equalTo(weakSelf.logoImageView.mas_right).offset(kPercentIP6(12/2) + 5);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    
    
    [self.voiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.bgButton);
        make.left.equalTo(weakSelf.bgButton.mas_right).offset(2);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgButton.mas_left).offset(10);
        make.right.equalTo(weakSelf.bgButton.mas_right).offset(-5);
        make.top.equalTo(weakSelf.bgButton.mas_top).offset(5);
        make.bottom.equalTo(weakSelf.bgButton.mas_bottom).offset(-5);
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
- (void)handleVoice:(UIButton *)button
{
    NSURL * url  = [NSURL URLWithString:_model.content];
    AVPlayerItem * playItem = [[AVPlayerItem alloc]initWithURL:url];
    LogYellow(@"播放声音:%@",url);
    _player = [[AVPlayer alloc] init];
    [_player replaceCurrentItemWithPlayerItem:playItem];
    [_player play];
    
    self.voiceButton.voiceImageView.animationImages = @[LOADIMAGE(@"fate_detail_voice1@2x", @"png"),LOADIMAGE(@"fate_detail_voice2@2x", @"png"),LOADIMAGE(@"fate_detail_voice3@2x", @"png")];
    self.voiceButton.voiceImageView.animationDuration = 1;
    self.voiceButton.voiceImageView.animationRepeatCount = 4;
    [self.voiceButton.voiceImageView startAnimating];

    
}


#pragma mark - "控件代理方法"
//控件代理方法

#pragma mark - Notification Responses
//通知响应方法

#pragma mark - Network Data
//网络请求处理方法
#pragma mark 封装图片数据
- (void)photoData:(NSString *)index
{
    // Browser
    BOOL displayActionButton = NO;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    BOOL autoPlayOnAppear = NO;
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = autoPlayOnAppear;
    
    [browser setCurrentPhotoIndex:[index integerValue]];//设置全屏图片默认
      LetterDetailViewController *letter = (LetterDetailViewController *)self.viewController;
    [letter.navigationController pushViewController:browser animated:YES];
    
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
        return [MWPhoto photoWithURL:[NSURL URLWithString:_model.content]];
}

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
        
        WS(weakSelf);
        _logoImageView.touchBlock = ^{
            [MobClick event:@"chatEnterUserDetail"];
            LetterDetailViewController *letter = (LetterDetailViewController *)weakSelf.viewController;
            FateDetailViewController *fate = [[FateDetailViewController alloc] init];
            letter.model.user_id = letter.model.send_id;
            fate.fateModel = letter.model;
            fate.selectedArray = letter.selectedArray;
            [letter.navigationController pushViewController:fate animated:YES];
        };

        
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
        
        [_bgButton setBackgroundImage:[UIImage imageNamed:@"letter_message_white_bubble@2x" ImageType:@"png" withTop:20 andLeft:18] forState:UIControlStateNormal];
        [_bgButton setBackgroundImage:[UIImage imageNamed:@"letter_message_white_bubble@2x" ImageType:@"png" withTop:20 andLeft:18] forState:UIControlStateHighlighted];
        
        //Button方法
    }
    return _bgButton;
}

- (FateDetailVoiceButton *)voiceButton {
    if (!_voiceButton) {
        _voiceButton = [[FateDetailVoiceButton alloc] init];
        [_voiceButton addTarget:self action:@selector(handleVoice:) forControlEvents:UIControlEventTouchUpInside];
        _voiceButton.hidden = YES;
    }
    return _voiceButton;
}




- (UILabel *)voiceLabel {
	if (!_voiceLabel) {
		_voiceLabel = [[UILabel alloc] init];
//        _voiceLabel.backgroundColor = [UIColor yellowColor];
        _voiceLabel.font = kFont12;
        _voiceLabel.text = @"4''";
        _voiceLabel.textAlignment = NSTextAlignmentLeft;
        _voiceLabel.hidden = YES;
	}
	return _voiceLabel;
}

- (MZYImageView *)contentImageView {
	if (!_contentImageView) {
		_contentImageView = [[MZYImageView alloc] init];
        _contentImageView.hidden = YES;
        _contentImageView.image = LOADIMAGE(NSLocalizedString(@"letter_detail_imagePlaceholder", nil), @"png");
        _contentImageView.clipsToBounds = YES;
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImageView.layer.masksToBounds = YES;
        _contentImageView.layer.cornerRadius = 5;
        WS(weakSelf);
        _contentImageView.touchBlock = ^{
            [weakSelf photoData:0];
        };
	}
	return _contentImageView;
}

- (void)setModel:(LetterRecordModel *)model
{
    if (_model != model) {
        _model = model;
        WS(weakSelf);
        if ([_model.tag isEqualToString:@"7"]) {
            //图片
            _voiceLabel.hidden = YES;
            _voiceButton.hidden = YES;
            _contentImageView.hidden = NO;
            [self.bgButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf).offset(30);
                make.left.equalTo(weakSelf.logoImageView.mas_right).offset(kPercentIP6(12/2));
                make.width.mas_equalTo(210);
                make.height.mas_equalTo(290);
            }];
            [_contentImageView sd_setImageWithURL:[NSURL URLWithString:_model.content] placeholderImage:LOADIMAGE(NSLocalizedString(@"letter_detail_imagePlaceholder", nil), @"png")];

        } else {
            //音频
            _voiceLabel.hidden = NO;
            _voiceButton.hidden = NO;
            _contentImageView.hidden = YES;
            [self.bgButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf).offset(30);
                make.left.equalTo(weakSelf.logoImageView.mas_right).offset(kPercentIP6(12/2));
                make.width.mas_equalTo(60);
                make.height.mas_equalTo(50);
            }];

        }
    }
}
@end
