//
//  FateDetailHeadView.m
//  Appointment
//
//  Created by feiwu on 16/7/21.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "FateDetailHeadView.h"
#import "FateUserLikeApi.h"
#import "LoginViewController.h"
#import "FateDetailViewController.h"
#import "MyFeedBackViewController.h"
#import "NSString+MZYExtension.h"
@implementation FateDetailHeadView

#pragma mark - Life Cycle
//生命周期方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self makeConstraints];
    }
    return self;
    
}

#pragma mark - Private Methods
//私有方法
- (void)initView
{
    //底部背景
    [self addSubview:self.backgroundImageView];
    
    //底部视图
    [self addSubview:self.bottomView];
    
    //昵称
    [self addSubview:self.nickLabel];
    
    //vip
    [self addSubview:self.vipImageView];
    
    //年龄
    [self addSubview:self.ageLabel];
    
    //语音
    [self addSubview:self.voiceButton];
    
    //用户相册
    [self addSubview:self.userPhotoButton];
    
    //用户关注
    [self addSubview:self.userAddentionButton];
    
    
}

- (void)makeConstraints
{
    WS(weakSelf)
    
    //scroll
    
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(kPercentIP6(471.5));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(weakSelf.mas_top);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(kPercentIP6(186.5));
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(weakSelf);
    }];
    
    
    [_nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(0);
        make.top.mas_equalTo(weakSelf.bottomView).offset(kPercentIP6(19.5));
        make.height.mas_equalTo(kPercentIP6(22));
    }];
    
    [_vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nickLabel.mas_right).offset(3);
        make.centerY.mas_equalTo(weakSelf.nickLabel);
        make.size.mas_equalTo(CGSizeMake(27, 12));
    }];

    [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(weakSelf).offset(-160);
        make.top.mas_equalTo(weakSelf.bottomView).offset(kPercentIP6(52.5));
        make.height.mas_equalTo(kPercentIP6(15));
    }];
    
    [_voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(61);
        make.height.mas_equalTo(61);
        make.right.mas_equalTo(-25);
        make.top.mas_equalTo(weakSelf.bottomView).offset(kPercentIP6(14));
    }];
    
    [_userPhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.bottom.mas_equalTo(weakSelf.bottomView).offset(-1);
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(weakSelf.bottomView).offset(kPercentIP6(90));
    }];
    
       [_userAddentionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.bottom.mas_equalTo(weakSelf.bottomView).offset(-1);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(weakSelf.bottomView).offset(kPercentIP6(90));
  }];
    
}

#pragma mark - Public Methods
//关注
#pragma mark - Event Responses
//用户相册
- (void)handleUserPhotoAction:(UIButton *)button
{
    FateDetailViewController *fate = (FateDetailViewController *)self.viewController;
    if (![fate.ios_vip isEqualToString:@"1"]) {
        //没有开通VIP
        _vipMaskView = [[FateDetailVipMaskView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) Title:NSLocalizedString(@"马上开通尊贵VIP就可以去撩TA了", nil)];
        [self.viewController.view addSubview:_vipMaskView];
    } else {
        //已开通vip
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FateDetailViewControllerScanPic" object:[NSString stringWithFormat:@"%d",0]];
    }
}
//用户关注
- (void)handleUserAddentionAction:(UIButton *)button
{
    [self setUserLikeRequestWithMid:_fateUserModel.user_id];
}
#pragma mark - "控件代理方法"
//控件代理方法

#pragma mark - Notification Responses
//通知响应方法

#pragma mark - Network Data
//网络请求处理方法
#pragma mark - 关注用户
- (void)setUserLikeRequestWithMid:(NSString *)mid {
    WS(weakSelf);
    __weak FateDetailViewController *fate = (FateDetailViewController *)self.viewController;
    [fate hideHUD];
    [fate showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    FateUserLikeApi *api = [[FateUserLikeApi alloc] initWithMid:mid];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [fate hideHUD];
        [weakSelf setUserLikeRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"关注用户请求失败:%@",request.responseString);
        [fate hideHUD];
        [fate showHUDFail:kNetWorkErrorTitle];
        [fate hideHUDDelay:1];
    }];
}

- (void)setUserLikeRequestFinish:(NSDictionary *)result{
    LogOrange(@"关注用户请求成功:%@",result);
    __weak FateDetailViewController *fate = (FateDetailViewController *)self.viewController;
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"data"];
    if ([code intValue] == kNetWorkSuccCode){
        FWUserInformation* information = [FWUserInformation sharedInstance];
        if ([desc hasPrefix:@"unlove"]) {
            _fateUserModel.flag_attention = @"0";
            [fate showHUDComplete:NSLocalizedString(@"取消关注成功", nil)];
            [_userAddentionButton.contentButton setImage:LOADIMAGE(@"fate_detail_noaddention@2x", @"png") forState:UIControlStateNormal];
            [_userAddentionButton.contentButton setImage:LOADIMAGE(@"fate_detail_noaddention@2x", @"png") forState:UIControlStateHighlighted];
            if ([information.addentionCount intValue] > 0) {
                information.addentionCount = [NSString stringWithFormat:@"%d",[information.addentionCount intValue] - 1];
            } else {
                information.addentionCount = @"";
            }
            if ([_fateUserModel.attention_me_num intValue ] > 0) {
                _userAddentionButton.contentLabel.text = [NSString stringWithFormat:@"%@ %d",NSLocalizedString(@"关注", nil),[_fateUserModel.attention_me_num intValue] - 1];
                _fateUserModel.attention_me_num = [NSString stringWithFormat:@"%d",[_fateUserModel.attention_me_num intValue] - 1];
            } else {
                _userAddentionButton.contentLabel.text = NSLocalizedString(@"关注", nil);
                _fateUserModel.attention_me_num = @"0";
            }
            
        }
        else {
            _fateUserModel.flag_attention = @"1";
            [fate showHUDComplete:NSLocalizedString(@"关注成功", nil)];
            [_userAddentionButton.contentButton setImage:LOADIMAGE(@"fate_detail_addention@2x", @"png") forState:UIControlStateNormal];
            [_userAddentionButton.contentButton setImage:LOADIMAGE(@"fate_detail_addention@2x", @"png") forState:UIControlStateHighlighted];
            if ([information.addentionCount intValue] > 0) {
                information.addentionCount = [NSString stringWithFormat:@"%d",[information.addentionCount intValue] + 1];
            } else {
                information.addentionCount = @"1";
            }
            
            //用户关注数加一
            if ([_fateUserModel.attention_me_num intValue ] > 0) {
                _userAddentionButton.contentLabel.text = [NSString stringWithFormat:@"%@ %d",NSLocalizedString(@"关注", nil),[_fateUserModel.attention_me_num intValue] + 1];
                _fateUserModel.attention_me_num = [NSString stringWithFormat:@"%d",[_fateUserModel.attention_me_num intValue] + 1];
            } else {
                _userAddentionButton.contentLabel.text = [NSString stringWithFormat:@"%@ 1",NSLocalizedString(@"关注", nil)];
                _fateUserModel.attention_me_num = @"1";
            }
        }
        
        [information saveUserInformation];
        [fate hideHUDDelay:1];
        
        //取消关注
        if (fate.cancelAddentionBlock) {
            fate.cancelAddentionBlock();
        }
        
    }else if([code intValue] == kNetWorkNoLoginCode){
        //没有登录
        LoginViewController *login = [[LoginViewController alloc] init];
        login.isNoLogin = YES;
        [fate presentViewController:login animated:NO completion:^{
            
        }];
        
    } else {
        [fate showHUDFail:desc];
        [fate hideHUDDelay:1];
    }
}




#pragma mark - Getters And Setters
//getter 和 setter 方法

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.clipsToBounds = YES;
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.userInteractionEnabled = YES;
        
    }
    return _backgroundImageView;
    
}

- (UIImageView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIImageView alloc] init];
        _bottomView.userInteractionEnabled = YES;
        _bottomView.image = LOADIMAGE(@"fate_detail_bottom@2x", @"png");
        
    }
    return _bottomView;
    
}

- (FateDetailVoiceButton *)voiceButton {
    if (!_voiceButton) {
        _voiceButton = [[FateDetailVoiceButton alloc] init];
        [_voiceButton setBackgroundImage:LOADIMAGE(@"fate_detail_VoiceBackground@2x", @"png") forState:UIControlStateNormal];
        [_voiceButton setBackgroundImage:LOADIMAGE(@"fate_detail_VoiceBackground@2x", @"png") forState:UIControlStateHighlighted];
        _voiceButton.hidden = YES;
        WS(weakSelf);
        _voiceButton.voiceBlock = ^(){
            //播放动画
            weakSelf.voiceButton.voiceImageView.animationImages = @[LOADIMAGE(@"fate_detail_voice1@2x", @"png"),LOADIMAGE(@"fate_detail_voice2@2x", @"png"),LOADIMAGE(@"fate_detail_voice3@2x", @"png")];
            weakSelf.voiceButton.voiceImageView.animationDuration = 1;
            weakSelf.voiceButton.voiceImageView.animationRepeatCount = [weakSelf.fateUserModel.voice_length integerValue] + 1;
            [weakSelf.voiceButton.voiceImageView startAnimating];
            
            //播放声音
            NSURL * url  = [NSURL URLWithString:weakSelf.fateUserModel.voice_url];
            AVPlayerItem * playItem = [[AVPlayerItem alloc]initWithURL:url];
            if (!weakSelf.player) {
                weakSelf.player = [[AVPlayer alloc] init];
                [weakSelf.player replaceCurrentItemWithPlayerItem:playItem];
            } else {
                [weakSelf.player replaceCurrentItemWithPlayerItem:playItem];
            }
            [weakSelf.player play];
            
        };
    }
    return _voiceButton;
}

- (UILabel *)nickLabel
{
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc] init];
        _nickLabel.font = [UIFont systemFontOfSize:kPercentIP6(20)];
        _nickLabel.textColor = Color16(0xFFFFFF);
        //        _nickLabel.text = @"东方不败";
        //        _nickLabel.backgroundColor = [UIColor orangeColor];
        
    }
    return _nickLabel;
}
- (UIImageView *)vipImageView {
    if (!_vipImageView) {
        _vipImageView = [[UIImageView alloc] init];
        _vipImageView.image =LOADIMAGE(@"select_vip@2x", @"png");
        _vipImageView.hidden = YES;
    }
    return _vipImageView;
}

- (UILabel *)ageLabel
{
    if (!_ageLabel) {
        _ageLabel = [[UILabel alloc] init];
        _ageLabel.font = [UIFont systemFontOfSize:kPercentIP6(13)];
        _ageLabel.textColor = Color16(0xFFFFFF);
        //        _ageLabel.text = @"24岁 170cm 广东";
        //        _ageLabel.backgroundColor = [UIColor lightGrayColor];
        
    }
    return _ageLabel;
}
- (FateDetailInfoView *)userPhotoButton
{
    if (!_userPhotoButton) {
        _userPhotoButton =  [[FateDetailInfoView alloc] init];
        [_userPhotoButton.contentButton setImage:LOADIMAGE(@"fate_detail_userPhoto@2x", @"png") forState:UIControlStateNormal];
        [_userPhotoButton.contentButton addTarget:self action:@selector(handleUserPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
        _userPhotoButton.contentLabel.text = NSLocalizedString(@"相册", nil);
    }
    return _userPhotoButton;
}
- (FateDetailInfoView *)userAddentionButton
{
    if (!_userAddentionButton) {
        _userAddentionButton =  [[FateDetailInfoView alloc] init];
        [_userAddentionButton.contentButton setImage:LOADIMAGE(@"fate_detail_addention@2x", @"png") forState:UIControlStateNormal];
        [_userAddentionButton.contentButton addTarget:self action:@selector(handleUserAddentionAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userAddentionButton;
}


- (void)setFateUserModel:(FateUserModel *)fateUserModel
{
    
    if (_fateUserModel != fateUserModel) {
        _fateUserModel = fateUserModel;
        
        //头像
        [_backgroundImageView sd_setImageWithURL:[NSURL URLWithString:fateUserModel.avatar] placeholderImage:LOADIMAGE(NSLocalizedString(@"fate_detail_headPlaceholder", nil), @"png") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        
        //昵称

        _nickLabel.text = _fateUserModel.name;
        
        CGFloat ageWidth = [_fateUserModel.name textWidthWithContentHeight:kPercentIP6(22) font:[UIFont systemFontOfSize:kPercentIP6(20)]] + 2;
        if (ageWidth > ScreenWidth - 160) {
            ageWidth = ScreenWidth - 160;
        }
        [_nickLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(ageWidth);
        }];
        //是否是vip
        if ([_fateUserModel.flag_vip isEqualToString:@"0"]) {
            //不是vip
            _vipImageView.hidden = YES;
        } else if ([_fateUserModel.flag_vip isEqualToString:@"1"]) {
            //是VIP
            _vipImageView.hidden = NO;
        } else {
            _vipImageView.hidden = YES;
        }
        
        //年龄
        NSLog(@"地区是否为空:%@",_fateUserModel.region_name);
        _ageLabel.text = [NSString stringWithFormat:@"%@歲 %@cm %@",_fateUserModel.age,_fateUserModel.height,_fateUserModel.region_name];
        
        //语音button
        if (![_fateUserModel.voice_url isEqualToString:@""]) {
            _voiceButton.hidden = NO;
            _voiceButton.fateUserModel = _fateUserModel;
        } else {
            _voiceButton.hidden = YES;
        }
        //相册
        if (_fateUserModel.photos==nil&&[_fateUserModel.photos isEqual:@""]) {
            _userPhotoButton.contentLabel.text = [NSString stringWithFormat:@"%@ 1",NSLocalizedString(@"相冊", nil)];
        }
        else if (_fateUserModel.photos.count > 0) {
            _userPhotoButton.contentLabel.text = [NSString stringWithFormat:@"%@ %d",NSLocalizedString(@"相册", nil),(int)_fateUserModel.photos.count];
        } else {
            _userPhotoButton.contentLabel.text =[NSString stringWithFormat:@"%@ 1",NSLocalizedString(@"相冊", nil)];
        }
        
        //关注
        if ([_fateUserModel.flag_attention intValue] == 1) {
            [_userAddentionButton.contentButton setImage:LOADIMAGE(@"fate_detail_addention@2x", @"png") forState:UIControlStateNormal];
            [_userAddentionButton.contentButton setImage:LOADIMAGE(@"fate_detail_addention@2x", @"png") forState:UIControlStateHighlighted];
        } else {
            [_userAddentionButton.contentButton setImage:LOADIMAGE(@"fate_detail_noaddention@2x", @"png") forState:UIControlStateNormal];
            [_userAddentionButton.contentButton setImage:LOADIMAGE(@"fate_detail_noaddention@2x", @"png") forState:UIControlStateHighlighted];
        }
        
        if ([_fateUserModel.attention_me_num intValue ] > 0) {
            _userAddentionButton.contentLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"关注", nil),_fateUserModel.attention_me_num];
        } else {
            _userAddentionButton.contentLabel.text = [NSString stringWithFormat:@"%@ 0",NSLocalizedString(@"关注", nil)];
        }
        
    }
}

@end
