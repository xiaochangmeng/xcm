//
//  LetterVideoView.m
//  Appointment
//
//  Created by feiwu on 2017/1/21.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "LetterVideoView.h"
#import "LetterRefuseVideoApi.h"
#import "LetterAnswerApi.h"
#import "AppDelegate.h"
#import "LetterViewController.h"
#import "LetterDetailViewController.h"
@implementation LetterVideoView
{
    NSString *_type;//1.异性向你发送邀请  2.你邀请用户
    NSString *_mid;
    NSString *_nickname;
    NSString *_img;
}

- (instancetype)initWithFrame:(CGRect)frame Type:(NSString *)type Mid:(NSString *)mid Nickname:(NSString *)name Img:(NSString *)img{
    if (self = [super initWithFrame:frame]) {
        _type = type;
        _mid = mid;
        _nickname = name;
        _img = img;
        [self setupView];
        
        //播放声音
        NSString *mp3Path = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"];
        NSURL *url = [NSURL fileURLWithPath:mp3Path];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [_player setNumberOfLoops:-1];
        [_player prepareToPlay];
        [_player play];
        
        //启动倒计时
        [self calculateCencel:30 Mid:_mid];
        
    }
    
    return self;
}


/**
 点击半透明背景视图  移除
 
 @param tapGestureRecognizer 点击事件
 */
- (void)tapGestureRecognizerHandle:(UITapGestureRecognizer*)tapGestureRecognizer{
//   [self removeView];
}

/**
 点击拒绝
 
 @param sender 拒绝按钮
 */
- (void)selectNoAction:(UIButton*)sender{
    [self setRefuseRequest:_mid];
    if (self.letterVideoBlock) {
        self.letterVideoBlock(@"0");
    }

    [self removeView];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = delegate.viewControllers[1];
    UINavigationController *navigation = delegate.viewControllers[1];
    FateModel *model = [[FateModel alloc] init];
    model.user_id = _mid;
    model.name = _nickname;
    LetterViewController *letter = [navigation.viewControllers firstObject];
    LetterDetailViewController *detail = [[LetterDetailViewController alloc] init];
    detail.model = model;
    [letter.navigationController pushViewController:detail animated:YES];
}

/**
 点击接听
 
 @param sender 接听按钮
 */
- (void)selectYesAction:(UIButton*)sender{
    [self setAnswerRequest:_mid];
    if (self.letterVideoBlock) {
        self.letterVideoBlock(@"1");
    }
    [self removeView];
}

/**
 取消邀请
 
 @param sender 取消按钮
 */
- (void)selectCancelAction:(UIButton*)sender{
    if (self.letterVideoBlock) {
        self.letterVideoBlock(@"0");
    }
    [self removeView];
}



/**
 添加试图
 */
- (void)setupView{
    [self addSubview:self.alphaView];
    [self addSubview:self.headImageView];
    [self addSubview:self.nickLabel];
    [self addSubview:self.tipLabel];
    
    if ([_type isEqualToString:@"1"]) {
        [self addSubview:self.noButton];
        [self addSubview:self.yesButton];
    } else if ([_type isEqualToString:@"2"]) {
        [self addSubview:self.cancleButton];
    }
    
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
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf).offset(40);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(60);
        make.left.mas_equalTo(weakSelf).offset(20);
    }];
    
    [_nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.headImageView.mas_top).offset(5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(200);
        make.left.mas_equalTo(weakSelf.headImageView.mas_right).offset(7);
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.nickLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(200);
        make.left.mas_equalTo(weakSelf.headImageView.mas_right).offset(10);
    }];
    
    if ([_type isEqualToString:@"1"]) {
        [_noButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(weakSelf).offset(-40);
            make.height.mas_equalTo(73);
            make.width.mas_equalTo(100);
            make.left.mas_equalTo(weakSelf).offset(44);
        }];
        
        [_yesButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(weakSelf).offset(-40);
            make.height.mas_equalTo(73);
            make.width.mas_equalTo(100);
            make.right.mas_equalTo(weakSelf).offset(-44);
        }];

    } else if ([_type isEqualToString:@"2"]) {
        [_cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(weakSelf).offset(-40);
            make.height.mas_equalTo(73);
            make.width.mas_equalTo(100);
            make.centerX.mas_equalTo(weakSelf);
        }];
    }
}

/**
 背景图
 */

- (UIImageView *)alphaView{
    if (_alphaView == nil) {
        _alphaView = [UIImageView new];
        _alphaView.userInteractionEnabled = YES;
        _alphaView.clipsToBounds = YES;
        _alphaView.contentMode = UIViewContentModeScaleAspectFill;
        
        if ([_type isEqualToString:@"1"]) {
            _alphaView.image = LOADIMAGE(@"letter_video_bg@2x", @"png");
        } else if ([_type isEqualToString:@"2"]) {
            NSString *sex = [FWUserInformation sharedInstance].sex;
            if ([sex isEqualToString:@"1"]) {
                //男
                _alphaView.image = [UIImage imageNamed:@"letter_video_boymask"];
            } else {
                _alphaView.image = LOADIMAGE(@"letter_video_girlmask@2x", @"png");
            }
        }
        UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerHandle:)];
        [_alphaView addGestureRecognizer:tapGestureRecognizer];
    }
    return _alphaView;
}

/**
  头像
  */
- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
//        _headImageView.backgroundColor = [UIColor orangeColor];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 8.0;
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:_img] placeholderImage:LOADIMAGE(@"my_headPlaceholder@2x", @"png")];
    }
    return _headImageView;
}

/**
 昵称label
 */
- (UILabel *)nickLabel
{
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc] init];
//        _nickLabel.backgroundColor = [UIColor whiteColor];
        _nickLabel.text = _nickname;
        _nickLabel.textColor = Color16(0x52525c);
        _nickLabel.font = [UIFont systemFontOfSize:24];
    }
    return _nickLabel;
}

/**
 提示label
 */

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
//        _tipLabel.backgroundColor = [UIColor whiteColor];
        
        if ([_type isEqualToString:@"1"]) {
            _tipLabel.text = @"邀请您进行私密视频聊天";
        } else if ([_type isEqualToString:@"2"]) {
            _tipLabel.text = @"正在等待对方接受邀请";
        }
        _tipLabel.textColor = Color16(0x6F6F78);
        _tipLabel.font = kFont15;
    }
    return _tipLabel;
}

/**
 拒绝按钮
 */
- (UIButton *)noButton{
    if (_noButton == nil) {
        _noButton = [UIButton new];
        [_noButton addTarget:self action:@selector(selectNoAction:) forControlEvents:UIControlEventTouchUpInside];
        [_noButton setBackgroundImage:LOADIMAGE(@"letter_video_refuse@2x", @"png") forState:UIControlStateNormal];
        _noButton.tag = 9000;
    }
    return _noButton;
}

/**
 接听按钮
 */

- (UIButton *)yesButton{
    if (_yesButton == nil) {
        _yesButton = [UIButton new];
        [_yesButton addTarget:self action:@selector(selectYesAction:) forControlEvents:UIControlEventTouchUpInside];
        [_yesButton setBackgroundImage:LOADIMAGE(@"letter_video_answer@2x.png", @"png") forState:UIControlStateNormal];
        _yesButton.tag = 9001;
    }
    return _yesButton;
}

/**
 取消按钮
 */
- (UIButton *)cancleButton{
    if (_cancleButton == nil) {
        _cancleButton = [UIButton new];
        [_cancleButton addTarget:self action:@selector(selectCancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [_cancleButton setBackgroundImage:LOADIMAGE(@"letter_video_cancel@2x.png", @"png") forState:UIControlStateNormal];
        _cancleButton.tag = 9002;
    }
    return _cancleButton;
}

#pragma mark - 取消倒计时
- (void)calculateCencel:(NSInteger)time Mid:(NSString *)mid{
    WS(weakSelf);
    __block int timeout = (int)time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                if (weakSelf.letterVideoBlock) {
                    weakSelf.letterVideoBlock(@"0");
                }

                [weakSelf removeView];
                [weakSelf setRefuseRequest:mid];
            });

        }else{
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
/**
 移除视图
 */

- (void)removeView{
    [_player stop];
    [self removeFromSuperview];
}

#pragma mark - Network Data
#pragma mark - 拒绝视频聊天
- (void)setRefuseRequest:(NSString *)mid {
    LetterRefuseVideoApi*api = [[LetterRefuseVideoApi alloc] initWithMid:mid];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        LogYellow(@"拒绝视频请求成功:%@",request.responseJSONObject);
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"拒绝视频请求失败:%@",request.responseString);
    }];
}

#pragma mark - 接听视频聊天
- (void)setAnswerRequest:(NSString *)mid {
    LetterAnswerApi*api = [[LetterAnswerApi alloc] initWithMid:mid];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        LogYellow(@"接听视频请求成功:%@",request.responseJSONObject);
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"接听视频请求失败:%@",request.responseString);
    }];
}


@end
