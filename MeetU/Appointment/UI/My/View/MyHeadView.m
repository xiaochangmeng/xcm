//
//  MyHeadView.m
//  Appointment
//
//  Created by feiwu on 16/7/18.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MyHeadView.h"
#import "MyInfoViewController.h"
#import "MyViewController.h"
#import "MyUploadImageApi.h"
#import "MyPhotoDetailViewController.h"
#import "LoginViewController.h"
#import "LXFileManager.h"
#import "VoiceIntroducedController.h"
#import "MySetViewController.h"
#import "QuestionOfBottomView.h"
#import "NSObject+XWAdd.h"
@implementation MyHeadView

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Methods

#pragma mark 初始化了视图
- (void)initSubviews{
    WS(weakSelf);
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    if (!_imageViewArray) {
        _imageViewArray = [NSMutableArray array];
    }
    
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backgroundImageView];
    //头像
    [self addSubview:self.userImageView];
    //昵称
    [self addSubview:self.userNickLabel];
    //资料
    [self addSubview:self.userinfoButton];
    
    [self addSubview:self.vipImageView];
    [self addSubview:self.writeImageView];
    //上传button
    [self addSubview:self.uploadButton];
    
    //声音介绍按钮
    [self addSubview:self.voiceIntroduced];
    //图片
    [self addSubview:self.uploadScroll];
    
    //对以上视图进行布局
    [self makeConstraints];
    
    //头像
    [self xw_addNotificationForName:@"MyHandleHeadChange" block:^(NSNotification *notification) {
        MyViewController *my = (MyViewController *)weakSelf.viewController;
        my.infoModel.avatar = [notification object];
        [weakSelf.userImageView sd_setImageWithURL:[NSURL URLWithString:[notification object]] placeholderImage:LOADIMAGE(NSLocalizedString(@"my_headPlaceholder", nil), @"png")];
    }];

    //昵称
    [self xw_addNotificationForName:@"MyInfoViewControllerModifyNickname" block:^(NSNotification *notification) {
      weakSelf.userNickLabel.text = [notification object];
    }];

    //录音
       [self xw_addNotificationForName:@"MyInfoViewControllerRecordChange" block:^(NSNotification *notification) {
           NSString *duration = [notification object];
          MyViewController *my = (MyViewController *)weakSelf.viewController;
           [weakSelf.voiceIntroduced setTitle:duration forState:UIControlStateNormal];
           my.infoModel.voice_length = duration;
           weakSelf.infoModel.voice_length = duration;
    }];
}

- (void)makeConstraints{
    WS(weakSelf);
    //头像背景图
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(0);
        make.top.mas_equalTo(weakSelf).offset(0);
        make.right.mas_equalTo(weakSelf).offset(0);
        make.bottom.mas_equalTo(weakSelf).offset(0);
    }];
    
    [_userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(75);
        make.left.mas_equalTo(weakSelf).offset(23);
        make.top.mas_equalTo(weakSelf).offset(8);
    }];
    
    [_userNickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(weakSelf.userImageView.mas_right).offset(16.5);
        make.top.mas_equalTo(weakSelf).offset(22.5);
    }];
    
    [_vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(35.5);
        make.height.mas_equalTo(16);
        make.left.mas_equalTo(weakSelf.userImageView.mas_right).offset(16.5);
        make.top.mas_equalTo(weakSelf.userNickLabel.mas_bottom).offset(14);
    }];
    
    [_writeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(16);
        make.left.mas_equalTo(weakSelf.vipImageView.mas_right).offset(3);
        make.top.mas_equalTo(weakSelf.userNickLabel.mas_bottom).offset(14);
    }];
    
    [_userinfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(93.5);
        make.height.mas_equalTo(31);
        make.right.mas_equalTo(weakSelf).offset(-kPercentIP6(20));
        make.top.mas_equalTo(weakSelf).offset(14.5);
    }];
    
    
    
    
    //声音介绍按钮布局约束
    [_voiceIntroduced mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(32);
        make.right.mas_equalTo(weakSelf).offset(-kPercentIP6(20));
        make.top.mas_equalTo(weakSelf.userinfoButton.mas_bottom).offset(30);
    }];
    
    [_uploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
        make.left.mas_equalTo(weakSelf).offset(20);
        make.top.mas_equalTo(weakSelf.userImageView.mas_bottom).offset(28);
    }];
    
    
    
    [_uploadScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(80);
        make.right.mas_equalTo(weakSelf).offset(-5);
        make.left.mas_equalTo(weakSelf.uploadButton.mas_right).offset(5);
        make.top.mas_equalTo(weakSelf.userImageView.mas_bottom).offset(28);
    }];
}



#pragma mark - Event Responses
//资料
- (void)handleInfoAction:(UIButton *)button
{
    [MobClick event:@"myInfo"];
    MyInfoViewController *info = [[MyInfoViewController alloc] init];
    MyViewController *my = (MyViewController *)self.viewController;
    [my.navigationController pushViewController:info animated:YES];
}

//上传button
- (void)handleUploadAction:(UIButton *)button
{
    [MobClick event:@"myUploadPic"];
    self.uploadType = @"photo";
    if (_photoArray.count >= 10) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"溫馨提醒", @"溫馨提醒")
                                                        message:NSLocalizedString(@"相册最多只能上传10张图片！", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"確定", @"確定")
                                              otherButtonTitles:nil];
        [alert show];
        
    } else {
        [self showPhotoActionSheet:YES animated:YES];
        [[QuestionOfBottomView sharedManager] removeFromSuperview];
    }
    
}

/**
 *  声音介绍按钮点击事件
 *
 *  @param sender 声音按钮
 */
#pragma mark - voiceIntroducedHandle
- (void)voiceIntroducedHandle:(UIButton*)sender{
    [MobClick event:@"myVoiceIndruction"];
    MyViewController *my = (MyViewController *)self.viewController;
    VoiceIntroducedController* voiceIntroducedController = [[VoiceIntroducedController alloc]initWithNibName:@"VoiceIntroducedController" bundle:nil];
    
    if (![_infoModel.voice_length isEqualToString:@""]) {
        voiceIntroducedController.status = RECORDVIEWSTATUS_PLAY;
    }else{
        voiceIntroducedController.status = RECORDVIEWSTATUS_NORAML;
    }
    
    [my.navigationController pushViewController:voiceIntroducedController animated:YES];
}

//显示相册还是图库
- (void)showPhotoActionSheet:(BOOL)isShow animated:(BOOL)animated{
    
    WS(weakSelf)
    
    if (isShow) {
        if (_backgroundView == nil) {
            self.viewController.view.userInteractionEnabled = NO;
            _backgroundView = [[MZYImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            
            UIImage *image = LOADIMAGE(@"common_actionsheet_background@2x", @"png");
            image = [image stretchableImageWithLeftCapWidth:2 topCapHeight:2];
            _backgroundView.image = image;
            [self.viewController.navigationController.view addSubview:_backgroundView];
            _backgroundView.touchBlock = ^(){
                [weakSelf showPhotoActionSheet:NO animated:YES];
            };
            _actionSheet= [[MZYActionSheet alloc]init];
            NSArray *array = [NSArray arrayWithObjects:NSLocalizedString(@"打开相册", @"打开相册") ,NSLocalizedString(@"拍照", @"拍照"), nil];
            [_actionSheet setTitle:nil otherButtonTitle:array];
            _actionSheet.buttonBlock = ^(int tag){
                switch (tag) {
                    case 0:
                    {
                        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                        imagePicker.delegate = weakSelf;
                        imagePicker.allowsEditing = YES;
                        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        [weakSelf.viewController presentViewController:imagePicker animated:YES completion:nil];
                        
                        [weakSelf showPhotoActionSheet:NO animated:YES];
                    }
                        break;
                    case 1:
                    {
                        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                        imagePicker.delegate = weakSelf;
                        imagePicker.allowsEditing = YES;
                        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        [weakSelf.viewController presentViewController:imagePicker animated:YES completion:^{
                            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"请在iPhone的“设置-隐私-相机”选项中允许访问您的相机" ,@"请在iPhone的“设置-隐私-相机”选项中允许访问您的相机") delegate:weakSelf cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"確定", @"確定"), nil];
                                [alertView show];
                                
                            }
                        }];
                        
                        [weakSelf showPhotoActionSheet:NO animated:YES];
                    }
                        break;
                    case 100:{
                        [weakSelf showPhotoActionSheet:NO animated:YES];
                    }
                        break;
                }
            };
            
            
            [self.viewController.navigationController.view addSubview:_actionSheet];
            
            
            //动画
            if (animated) {
                [UIView animateWithDuration:0.5 animations:^{
                    [UIView setAnimationRepeatCount:0];
                    weakSelf.actionSheet.extBottom = ScreenHeight;
                } completion:^(BOOL finished){
                    if (finished) {
                        
                    }
                }];
            }else{
                weakSelf.actionSheet.extBottom = ScreenHeight;
            }
        }
    }else{
        if (_backgroundView != nil) {
            self.viewController.view.userInteractionEnabled = YES;
            
            if (animated) {
                [UIView animateWithDuration:0.2 animations:^{
                    [UIView setAnimationRepeatCount:0];
                    weakSelf.actionSheet.extTop = ScreenHeight;
                } completion:^(BOOL finished){
                    if (finished) {
                        [weakSelf.actionSheet removeFromSuperview];
                        [weakSelf.backgroundView removeFromSuperview];
                        weakSelf.actionSheet = nil;
                        weakSelf.backgroundView = nil;
                    }
                }];
            }else{
                [_actionSheet removeFromSuperview];
                [_backgroundView removeFromSuperview];
                _actionSheet = nil;
                _backgroundView = nil;
                
            }
            
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    LogOrange(@"上传的类型是:%@",_uploadType);
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    [self setUploadImageRequest:img Type:_uploadType];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 上传图片
- (void)setUploadImageRequest:(UIImage *)image Type:(NSString *)type{
    WS(weakSelf);
    __weak MyViewController *my = (MyViewController *)self.viewController;
    [my hideHUD];
    [my showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    MyUploadImageApi* api = [[MyUploadImageApi alloc] initWithImage:image Type:type];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [my hideHUD];
        [weakSelf setUploadImageRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"上传图片请求失败:%@",request.responseString);
        [my hideHUD];
        [my showHUDFail:kNetWorkErrorTitle];
        [my hideHUDDelay:1];
    }];
}

- (void)setUploadImageRequestFinish:(NSDictionary *)result{
    LogOrange(@"上传图片请求成功:%@",result);
    WS(weakSelf);
    __weak MyViewController *my = (MyViewController *)self.viewController;
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        if ([_uploadType isEqualToString:@"img"]) {
            //头像
            LogOrange(@"头像上传成功");
            [_userImageView sd_setImageWithURL:[NSURL URLWithString:[result objectForKey:@"data"]] placeholderImage:LOADIMAGE(NSLocalizedString(@"my_headPlaceholder", nil), @"png")  options:SDWebImageRefreshCached];
            NSString *key = [NSString stringWithFormat:@"%@userImage",[FWUserInformation sharedInstance].mid];
            NSString *value = [result objectForKey:@"data"];
            [LXFileManager saveUserData:value forKey:key];
        } else {
            //相册
            LogOrange(@"相册上传成功");
            NSMutableArray *albums = [result[@"data"] objectForKey:@"albums"];
            NSMutableArray *albums_original = [result[@"data"] objectForKey:@"albums_original"];
            NSMutableArray *albums_urlencode = [result[@"data"] objectForKey:@"albums_urlencode"];
            
            _photoArray = albums;
            _infoModel.albums = albums;
            _infoModel.albums_original = albums_original;
            _infoModel.albums_urlencode = albums_urlencode;
            
            MZYImageView *photoImageView;
            
            if (_photoArray.count <= _imageViewArray.count) {
                photoImageView = (MZYImageView *)_imageViewArray[_photoArray.count - 1];
            } else {
                photoImageView = [MZYImageView new];
                photoImageView.contentMode = UIViewContentModeScaleToFill;
                photoImageView.userInteractionEnabled = YES;
                photoImageView.layer.masksToBounds = YES;
                photoImageView.layer.cornerRadius = 5;
                [_imageViewArray addObject:photoImageView];
            }
            photoImageView.tag = 8000 + _photoArray.count - 1;
             [photoImageView sd_setImageWithURL:[NSURL URLWithString:[albums lastObject]] placeholderImage:LOADIMAGE(NSLocalizedString(@"my_headPlaceholder", nil), @"png") options:SDWebImageRefreshCached];
            [_uploadScroll addSubview:photoImageView];
            photoImageView.touchBlock = ^(){
                MyPhotoDetailViewController *detail = [[MyPhotoDetailViewController alloc] init];
                detail.photoOriginalArray = weakSelf.infoModel.albums_original;//原始
                detail.photoDeleteArray = weakSelf.infoModel.albums_urlencode;//删除数组
                detail.photoArray = weakSelf.infoModel.albums;//处理图
                detail.index = photoImageView.tag - 8000;
                
                [my.navigationController pushViewController:detail animated:YES];
            };
            
            [photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.uploadScroll).offset(0);
                make.size.mas_equalTo(CGSizeMake(80, 80));
                if (weakSelf.lastView) {
                    make.left.equalTo(weakSelf.lastView.mas_right).offset(30/2);
                }else{
                    make.left.equalTo(weakSelf.uploadScroll).offset(30/2);
                }
            }];
            _lastView = photoImageView;
            [_uploadScroll setContentSize:CGSizeMake(80 +(100 * _photoArray.count), 80)];
        }
        
    }else if([code intValue] == kNetWorkNoLoginCode){
        //没有登录
        [my showHUDFail:desc];
        [my hideHUDDelay:1];
        [self performSelector:@selector(login) withObject:nil afterDelay:1];
    } else {
        [my hideHUD];
        [my showHUDFail:desc];
        [my hideHUDDelay:1];
    }
}

- (void)login{
    MyViewController *my = (MyViewController *)self.viewController;
    LoginViewController *login = [[LoginViewController alloc] init];
    login.isNoLogin = YES;
    [my presentViewController:login animated:NO completion:^{
        
    }];
}

#pragma mark - Getters and Setters

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.userInteractionEnabled = YES;
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        _backgroundImageView.image = LOADIMAGE(@"my_headBackground@2x", @"png");
    }
    return _backgroundImageView;
}
- (MZYImageView *)userImageView {
    if (!_userImageView) {
        WS(weakSelf);
        _userImageView = [[MZYImageView alloc] init];
        _userImageView.clipsToBounds = YES;
        _userImageView.contentMode = UIViewContentModeScaleAspectFill;
        _userImageView.layer.masksToBounds = YES;
        _userImageView.layer.cornerRadius = 75/2.0;
        _userImageView.image = LOADIMAGE(NSLocalizedString(@"my_headPlaceholder", nil), @"png");
        //        _userImageView.backgroundColor = [UIColor orangeColor];
        _userImageView.touchBlock = ^{
            weakSelf.uploadType = @"img";
            [weakSelf showPhotoActionSheet:YES animated:YES];
            [[QuestionOfBottomView sharedManager] removeFromSuperview];
        };
    }
    return _userImageView;
}

- (UILabel *)userNickLabel {
    if (!_userNickLabel) {
        _userNickLabel = [[UILabel alloc] init];
        _userNickLabel.font = [UIFont systemFontOfSize:kPercentIP6(16)];
        _userNickLabel.textColor = [UIColor whiteColor];
        //        _userNickLabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _userNickLabel;
}

- (UIButton *)userinfoButton {
    if (!_userinfoButton) {
        _userinfoButton = [[UIButton alloc] init];
        [_userinfoButton setTitle:NSLocalizedString(@"数据", nil) forState:UIControlStateNormal];
        [_userinfoButton setBackgroundImage:LOADIMAGE(@"my_info@2x", @"png") forState:UIControlStateNormal];
        _userinfoButton.titleLabel.font = kFont13;
        [_userinfoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_userinfoButton addTarget:self action:@selector(handleInfoAction:) forControlEvents:UIControlEventTouchUpInside];
        [_userinfoButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    }
    return _userinfoButton;
}

- (UIImageView *)vipImageView {
    if (!_vipImageView) {
        _vipImageView = [[UIImageView alloc] init];
        //        _vipImageView.backgroundColor = [UIColor orangeColor];
    }
    return _vipImageView;
}

- (UIImageView *)writeImageView {
    if (!_writeImageView) {
        _writeImageView = [[UIImageView alloc] init];
        //        _writeImageView.backgroundColor = [UIColor yellowColor];
    }
    return _writeImageView;
}

- (UIButton *)uploadButton {
    if (!_uploadButton) {
        _uploadButton = [[UIButton alloc] init];
        [_uploadButton setBackgroundImage:LOADIMAGE(NSLocalizedString(@"my_upload_photo", nil), @"png") forState:UIControlStateNormal];
        [_uploadButton setBackgroundImage:LOADIMAGE(NSLocalizedString(@"my_upload_photo", nil), @"png") forState:UIControlStateHighlighted];
        [_uploadButton addTarget:self action:@selector(handleUploadAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadButton;
}

/**
 *  懒加载
 *
 *  @return 初始化之后的声音介绍按钮
 */
#pragma mark - voiceIntroduced
- (UIButton *)voiceIntroduced{
    if (!_voiceIntroduced) {
        _voiceIntroduced = [[UIButton alloc]init];
        [_voiceIntroduced setBackgroundImage:LOADIMAGE(@"my_record@2x", @"png") forState:UIControlStateNormal];
        [_voiceIntroduced setBackgroundImage:LOADIMAGE(@"my_record@2x", @"png") forState:UIControlStateHighlighted];
        [_voiceIntroduced setTitle:NSLocalizedString(@"添加录音", nil) forState:UIControlStateNormal];
        _voiceIntroduced.titleLabel.font = kFont13;
        [_voiceIntroduced setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //添加监听方法
        [_voiceIntroduced addTarget:self action:@selector(voiceIntroducedHandle:) forControlEvents:UIControlEventTouchUpInside];
        [_voiceIntroduced setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    }
    return _voiceIntroduced;
}
- (UIScrollView *)uploadScroll {
    if (!_uploadScroll) {
        _uploadScroll = [[UIScrollView alloc] init];
        //        _uploadScroll.backgroundColor = [UIColor yellowColor];
        _uploadScroll.showsHorizontalScrollIndicator = NO;
        _uploadScroll.showsVerticalScrollIndicator = NO;
        _uploadScroll.bounces = NO;
        _uploadScroll.scrollEnabled = YES;
        
    }
    return _uploadScroll;
}
- (void)setInfoModel:(UserInfoModel *)infoModel
{
    _infoModel = infoModel;
    
    WS(weakSelf);
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:_infoModel.avatar] placeholderImage:LOADIMAGE(NSLocalizedString(@"my_headPlaceholder", nil), @"png")];
    _userNickLabel.text = _infoModel.name;
    
    //vip与包月图标显示
    if ([_infoModel.ios_vip integerValue] > 0) {
        _vipImageView.image = LOADIMAGE(NSLocalizedString(@"my_tag_vip", nil), @"png");
    } else {
        _vipImageView.image = LOADIMAGE(NSLocalizedString(@"my_tag_vipNo", nil), @"png");
    }
    
    if ([_infoModel.ios_tell integerValue] > 0) {
        _writeImageView.image = LOADIMAGE(NSLocalizedString(@"my_tag_write", nil), @"png");
    } else {
        _writeImageView.image = LOADIMAGE(NSLocalizedString(@"my_tag_writeNo", nil), @"png");
    }
    
    if (![_infoModel.voice_url isEqualToString:@""] && _infoModel.voice_url != nil) {
        NSString *voice_length = [NSString stringWithFormat:@"%@''",_infoModel.voice_length];
        [_voiceIntroduced setTitle:voice_length forState:UIControlStateNormal];
    } else {
        [_voiceIntroduced setTitle:NSLocalizedString(@"添加录音", nil) forState:UIControlStateNormal];
    }
    
    //已显示的相册图片清除掉
    NSInteger count = _imageViewArray.count;
    for (int i = 0; i < count; i++) {
        MZYImageView *photo = (MZYImageView *)_imageViewArray[i];
        [photo removeFromSuperview];
    }
    _lastView = nil;
    
    if (_infoModel.albums.count > 0) {
        _photoArray = _infoModel.albums;
        __weak MyViewController *my = (MyViewController *)self.viewController;
        //创建ImageVeiw展示
        for (int i = 0; i < _infoModel.albums.count; i++) {
            MZYImageView *photoImageView;
            if (i < _imageViewArray.count) {
                photoImageView = (MZYImageView *)_imageViewArray[i];
            } else {
                photoImageView = [MZYImageView new];
                photoImageView.clipsToBounds = YES;
                photoImageView.contentMode = UIViewContentModeScaleAspectFill;
                photoImageView.userInteractionEnabled = YES;
                photoImageView.layer.masksToBounds = YES;
                photoImageView.layer.cornerRadius = 5;
                [_imageViewArray addObject:photoImageView];
            }
            photoImageView.tag = 8000 + i;
            [photoImageView sd_setImageWithURL:[NSURL URLWithString:[_infoModel.albums objectAtIndex:i]] placeholderImage:LOADIMAGE(NSLocalizedString(@"my_headPlaceholder", nil), @"png")  options:SDWebImageRefreshCached];
            
            photoImageView.touchBlock = ^(){
                MyPhotoDetailViewController *detail = [[MyPhotoDetailViewController alloc] init];
                detail.photoOriginalArray = weakSelf.infoModel.albums_original;//原始
                detail.photoDeleteArray = weakSelf.infoModel.albums_urlencode;//删除数组
                detail.photoArray = weakSelf.infoModel.albums;
                detail.index = i;
                [my.navigationController pushViewController:detail animated:YES];
            };
            
            [_uploadScroll addSubview:photoImageView];
            
            [photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.uploadScroll.mas_top).offset(0);
                make.size.mas_equalTo(CGSizeMake(80, 80));
                if (weakSelf.lastView) {
                    make.left.equalTo(weakSelf.lastView.mas_right).offset(30/2);
                }else{
                    make.left.equalTo(weakSelf.uploadScroll.mas_left).offset(30/2);
                }
            }];
            _lastView = photoImageView;
        }
        [_uploadScroll setContentSize:CGSizeMake(80 +(100 * _infoModel.albums.count), 80)];
    }
}
@end
