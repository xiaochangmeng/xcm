//
//  CircleTableViewCell.m
//  Appointment
//
//  Created by feiwu on 2017/2/5.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "CircleTableViewCell.h"
#import "NSString+MZYExtension.h"
#import "WJCirclViewController.h"
#import "CircleLikeApi.h"
#import "CircleSubmitCommentApi.h"
#import "CircleCommentView.h"
#import "QuestionOfBottomView.h"
#import "CircleCommentListViewController.h"
#import "CirclePhotoPayMaskView.h"
#import "QuestionOfBottomView.h"
#import "LXFileManager.h"
#import "StatisticalPayApi.h"
#import "LoginPhoneViewController.h"
#import "CustomNavigationController.h"
#import "CircleDaliyFreeView.h"
#import "NSDate+MZYExtension.h"
#import "NSString+MZYExtension.h"
@implementation CircleTableViewCell

#pragma mark - 生命周期方法
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


#pragma mark - 初始化
- (void)initView
{
    [self addSubview:self.userImageView];
    [self addSubview:self.userMaskView];
    [self addSubview:self.nickLabel];
    [self addSubview:self.sexImageView];
    [self addSubview:self.timeLabel];
    
    [self addSubview:self.contentLabel];
    
    [self addSubview:self.pageviewsLabel];
    [self addSubview:self.commentView];
    [self addSubview:self.likeView];
    [self addSubview:self.morebutton];
    [self addSubview:self.middleLineView];
    
    [self addSubview:self.bottomLineView];
}

#pragma mark - 布局
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
    
    [_sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nickLabel.mas_right).offset(6);
        make.centerY.mas_equalTo(weakSelf.nickLabel);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf).offset(-15);
        make.top.mas_equalTo(weakSelf).offset(22);
    }];
    
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(weakSelf.userImageView.mas_bottom).offset(10);
        make.width.mas_equalTo(ScreenWidth - 30);
        make.height.mas_equalTo(0);
    }];
    
    [_pageviewsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(15);
        make.centerY.mas_equalTo(weakSelf.likeView);
    }];
    
    
    [_commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.right.mas_equalTo(weakSelf.awardView.mas_left).offset(-10);
        make.right.mas_equalTo(weakSelf).offset(-2);
        make.top.mas_equalTo(weakSelf.likeView.mas_top);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 10));
    }];
    
    [_middleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(weakSelf.pageviewsLabel.mas_bottom).offset(18);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 1));
    }];
    
}


#pragma mark - 选中方法
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

#pragma mark - 按钮响应方法
/**
 点击查看更多评论
 */
- (void)clickMoreButton:(UIButton *)sender
{
    WJCirclViewController *near = (WJCirclViewController *)self.viewController;
    CircleCommentListViewController *comment = [[CircleCommentListViewController alloc] init];
    comment.model = _model;
    [near.navigationController pushViewController:comment animated:YES];
}

#pragma mark - Notification Responses
//通知响应方法


#pragma mark - 圈子点赞
- (void)setLikeRequest:(NSString *)comment_id {
    WS(weakSelf);
    weakSelf.likeView.typeImageView.image = LOADIMAGE(@"circle_liked@2x", @"png");
    weakSelf.likeView.contentLabel.textColor = Color16(0xF85F73);
    weakSelf.likeView.contentLabel.text = [NSString stringWithFormat:@"点赞(%d)",[_model.like_count intValue] + 1];
    weakSelf.model.isLike = @"1";
    
    __weak WJCirclViewController *near = (WJCirclViewController *)self.viewController;
    CircleLikeApi *api = [[CircleLikeApi alloc] initWithCommentID:comment_id];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        LogYellow(@"点赞请求成功:%@", request.responseJSONObject);
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"点赞请求失败:%@",request.responseString);
    }];
    
    [near hideHUD];
    [near showHUDComplete:@"点赞成功"];
    [near hideHUDDelay:1];
}

#pragma mark - 圈子评论
- (void)setCommentRequest:(NSString *)comment_id  Message:(NSString *)message{
    WS(weakSelf);
    __weak WJCirclViewController *near = (WJCirclViewController *)self.viewController;
    [near hideHUD];
    [near showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    CircleSubmitCommentApi *api = [[CircleSubmitCommentApi alloc] initWithCommentID:comment_id Content:message];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [near hideHUD];
        [weakSelf setCommentRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"评论请求失败:%@",request.responseString);
        [near hideHUD];
    }];
}

- (void)setCommentRequestFinish:(NSDictionary *)result{
    LogOrange(@"评论请求成功:%@",result);
    __weak WJCirclViewController *near = (WJCirclViewController *)self.viewController;
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        [near showHUDComplete:@"评论成功"];
        [near hideHUDDelay:1];
        NSDictionary *dic = [result objectForKey:@"data"];
        if (dic.count > 0) {
            NSMutableArray *temp = [NSMutableArray arrayWithArray:_model.comment_list];
            [temp insertObject:dic atIndex:0];
            
            CircleModel *model = [[CircleModel alloc] init];
//            model.author = _model.author;
            model.content = _model.content;
            model.from = _model.from;
            model.comment_id = _model.comment_id;
            model.hits_count = _model.hits_count;
            model.like_count = _model.like_count;
            model.isLike = _model.isLike;
            model.past_time = _model.past_time;
            model.comment_count = _model.comment_count;
            model.pics_url = _model.pics_url;
            model.publish_id = _model.publish_id;
            model.comment_list = temp;
            model.nickname=_model.nickname;
            model.avatar=_model.avatar;
            [near.circleTableView.circleDataArray replaceObjectAtIndex:_indexpath.row withObject:model];
            [near.circleTableView reloadData];
            
        }
        
    }else {
        [near showHUDFail:desc];
        [near hideHUDDelay:1];
    }
}

#pragma mark - 蒙版相册点击统计
- (void)setStatisticalPayRequest:(NSString *)action{
    WS(weakSelf);
    StatisticalPayApi *api = [[StatisticalPayApi alloc] initWithAction:action];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf setStatisticalPayRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"设置蒙版相册统计失败:%@",request.responseString);
    }];
}

- (void)setStatisticalPayRequestFinish:(NSDictionary *)result{
    LogOrange(@"设置蒙版相册统计成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    if ([code intValue] == kNetWorkSuccCode){
        
    } else {
        
    }
}


#pragma mark - 封装图片数据
- (void)photoData:(NSString *)index IsVip:(BOOL)isVip
{
    if (isVip) {
        _index = index;
    } else {
        _index = @"";
    }
    
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
    WJCirclViewController *near = (WJCirclViewController *)self.viewController;
    [near.navigationController pushViewController:browser animated:YES];
    
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _model.pics_url.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    NSDictionary *dic = [_model.pics_url objectAtIndex:index];
    NSString *status = [dic objectForKey:@"status"];
    NSString *url;
    
    // MARK: - 修改
    NSString *appstatus = [LXFileManager readUserDataForKey:kAppIsCheckStatus];
    if ([appstatus intValue] != 0) {
        if ([status integerValue] == 1) {
            url = [dic objectForKey:@"url_ori_big"];
        } else {
            //钻石VIP
            if ([_index integerValue] == index  &&  ![_index isEqualToString:@""]) {
                url = [dic objectForKey:@"url_ori_big"];
            } else {
                url = [dic objectForKey:@"url_blur"];
            }
            //钻石VIP
        }
    } else {
        //审核中
        url = [dic objectForKey:@"url_ori_big"];
    }
    
    return [MWPhoto photoWithURL:[NSURL URLWithString:url]];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        WJCirclViewController *near = (WJCirclViewController *)self.viewController;
        LoginPhoneViewController *phone = [[LoginPhoneViewController alloc] initWithType:@"2"];
        CustomNavigationController *navigation = [[CustomNavigationController alloc] initWithRootViewController:phone];
        [near presentViewController:navigation animated:YES completion:^{
            
        }];
        
    }
}

#pragma mark - 懒加载子控件
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
        _nickLabel.font = [UIFont systemFontOfSize:kPercentIP6(16)];
        _nickLabel.textColor = Color16(0x727EB3);
        [_nickLabel sizeToFit];
        //        _nickLabel.text = @"西门飘雪";
        //        _nickLabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _nickLabel;
}

/**
 性别图标
 */
- (UIImageView *)sexImageView {
    if (!_sexImageView) {
        _sexImageView = [[UIImageView alloc] init];
        //        _sexImageView.backgroundColor = [UIColor orangeColor];
    }
    return _sexImageView;
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
        //         _timeLabel.backgroundColor = [UIColor lightGrayColor];
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
        //           _contentLabel.backgroundColor = [UIColor lightGrayColor];
        //        _contentLabel.text = @"老板我错了，你别开除我？？？";
    }
    return _contentLabel;
}

/**
 浏览量
 */
- (UILabel *)pageviewsLabel {
    if (!_pageviewsLabel) {
        _pageviewsLabel = [[UILabel alloc] init];
        //        _pageviewsLabel.backgroundColor = [UIColor lightGrayColor];
        _pageviewsLabel.font = [UIFont systemFontOfSize:kPercentIP6(12)];
        _pageviewsLabel.textColor = Color16(0xA4A7B3);
        [_pageviewsLabel sizeToFit];
        //        _pageviewsLabel.text = @"浏览97次";
    }
    return _pageviewsLabel;
}

/**
 评论
 */
- (CircleButton *)commentView {
    if (!_commentView) {
        _commentView = [[CircleButton alloc] initWithTitle:@"评论" TypeImage:@"circle_comment@2x"];
        WS(weakSelf);
        _commentView.circleBlock = ^(){
            NSString *key = [NSString stringWithFormat:@"%@phone",[FWUserInformation sharedInstance].mid];
            NSString *value = [LXFileManager readUserDataForKey:key];
            NSString *status = [LXFileManager readUserDataForKey:kAppIsCheckStatus];
            WJCirclViewController *near = (WJCirclViewController *)weakSelf.viewController;
            if ([value integerValue] == 1 || [status integerValue] == 0) {

                //已验证手机号
                [[QuestionOfBottomView sharedManager] removeFromSuperview];
                CircleCommentView *comment = [[CircleCommentView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                comment.commentBlock = ^(NSString *message){
                    [weakSelf setCommentRequest:weakSelf.model.comment_id Message:message];
                };
                [near.navigationController.view addSubview:comment];
            } else {
                //没有验证手机号
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"您还没进行手机验证，验证手机号码后才能评论!" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"立即验证", nil];
                [alert show];
            }
        };
    }
    return _commentView;
}


/**
 点赞
 */
- (CircleButton *)likeView {
    if (!_likeView) {
        _likeView = [[CircleButton alloc] initWithTitle:@"赞" TypeImage:@"circle_like@2x"];
        WS(weakSelf);
        _likeView.circleBlock = ^(){
            if ([weakSelf.model.isLike isEqualToString:@"0"]) {
                //没有点赞
                [weakSelf setLikeRequest:weakSelf.model.comment_id];
            }
        };
        //        _likeView.backgroundColor = [UIColor orangeColor];
    }
    return _likeView;
}

/**
 打赏视图
 */
- (UIView *)awardView {
    if (!_awardView) {
        _awardView = [[UIView alloc] init];
        _awardView.backgroundColor = Color16(0xF3F3F3);
    }
    return _awardView;
}

/**
 打赏label
 */
- (UILabel *)awardLabel {
    if (!_awardLabel) {
        _awardLabel = [[UILabel alloc] init];
        _awardLabel.textColor = Color16(0x727EB3);
        _awardLabel.font = [UIFont systemFontOfSize:kPercentIP6(14)];
        _awardLabel.numberOfLines = 0;
        //        _awardLabel.backgroundColor = [UIColor orangeColor];
    }
    return _awardLabel;
}
/**
 打赏UIImageView
 */
- (UIImageView *)awardImageView {
    if (!_awardImageView) {
        _awardImageView = [[UIImageView alloc] init];
        _awardImageView.image = LOADIMAGE(@"circle_award@2x", @"png");
    }
    return _awardImageView;
}


/**
 查看更多
 */
- (UIButton *)morebutton {
    if (!_morebutton) {
        _morebutton = [[UIButton alloc] init];
        _morebutton.hidden = YES;
        [_morebutton setTitle:@"查看更多评论" forState:UIControlStateNormal];
        _morebutton.titleLabel.textAlignment = NSTextAlignmentLeft;
        _morebutton.titleLabel.font =  [UIFont systemFontOfSize:kPercentIP6(14)];
        [_morebutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_morebutton addTarget:self action:@selector(clickMoreButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _morebutton;
}

/**
 评论上部线条
 */
- (UIView *)middleLineView {
    if (!_middleLineView) {
        _middleLineView = [[UIView alloc] init];
        _middleLineView.backgroundColor =  Color16(0xF3F3F3);
    }
    return _middleLineView;
}


/**
 底部线条
 */
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = Color10(239, 239, 239, 1);
    }
    return _bottomLineView;
}
/**
 modelset方法
 */
- (void)setModel:(CircleModel *)model{
    if (_model != model) {
        _model = model;
        //头像
        WS(weakSelf);
//        NSDictionary *user = _model.author;
        [_userImageView sd_setImageWithURL:[NSURL URLWithString:_model.avatar] placeholderImage:LOADIMAGE(@"fate_headPlaceholder@2x", @"png") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        
        //昵称
        _nickLabel.text = _model.nickname;
        
        //性别
        NSString *sex = @"0";
        if ([sex integerValue] == 0) {
            //女
            _sexImageView.image = LOADIMAGE(@"fate_woman@2x", @"png");
        } else {
            //男
            _sexImageView.image = LOADIMAGE(@"fate_man@2x", @"png");
        }
        
        //时间
        _timeLabel.text = _model.past_time;
        
        //内容
        _contentLabel.text = _model.content;
        CGFloat height = [_model.content textHeightWithContentWidth:ScreenWidth - 30 font:_contentLabel.font = [UIFont systemFontOfSize:kPercentIP6(16)]];
        if (height > 90) {
            height = 90;
        }
        [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height + 2);
        }];
        
        //*********图片
        //移除先前的图片
        for (int i = 0; i < _picArray.count; i++) {
            CirclePhotoView *pic = (CirclePhotoView *)[_picArray objectAtIndex:i];
            [pic removeFromSuperview];
        }
        
        if (_model.pics_url.count > 0) {
            UIView *lastView = _contentLabel;
            if (!_picArray) {
                _picArray = [NSMutableArray array];
            }
            
            for (int i = 0; i < _model.pics_url.count; i++) {
                int line = i % 3;//列
                int row = i / 3;//行
                NSDictionary *dic = [_model.pics_url objectAtIndex:i];
                CirclePhotoView *photo;
                if (i < _picArray.count) {
                    photo = [_picArray objectAtIndex:i];
                } else {
                    photo = [[CirclePhotoView alloc] init];
                    photo.clipsToBounds = YES;
                    photo.contentMode = UIViewContentModeScaleAspectFill;
                    photo.userInteractionEnabled = YES;
                    [_picArray addObject:photo];
                }
                photo.tag = 6000 + i;
                
                // MARK: - 修改
                NSString *url;
                NSString *status = [LXFileManager readUserDataForKey:kAppIsCheckStatus];
                if ([status intValue] != 0) {
                    if ([[dic objectForKey:@"status"] integerValue] == 1) {
                        url = [dic objectForKey:@"url_ori_big"];
                        photo.lockView.hidden = YES;
                    } else {
                        url = [dic objectForKey:@"url_blur"];
                        photo.lockView.hidden = NO;
                    }
                } else {
                    
#pragma mark- 崩溃点
                    url = [dic objectForKey:@"url_ori_big"];
                    photo.lockView.hidden = YES;
                }
                
                [self addSubview:photo];
                [photo mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(15 + ((ScreenWidth - 50) / 3.0 + 10) * line);
                    make.top.mas_equalTo(weakSelf.contentLabel.mas_bottom).offset(10 + ((ScreenWidth - 50) / 3.0 + 10) * row);
                    make.width.mas_equalTo((ScreenWidth - 50) / 3.0);
                    make.height.mas_equalTo((ScreenWidth - 50) / 3.0);
                }];
                
                photo.touchBlock = ^(){
//                    if ([status intValue] != 0) {
                        if ([[dic objectForKey:@"status"] integerValue] == 1) {
                            //免费图片
                            [weakSelf photoData:[NSString stringWithFormat:@"%d",i] IsVip:NO];
                        } else {
                            //**************************8*************打赏看图片
                            [weakSelf setStatisticalPayRequest:@"moments-marked-photos"];
                            
                            // MARK: 修改
                            if ([status intValue] != 0) {
                                [[QuestionOfBottomView sharedManager] removeFromSuperview];
                            }
                            WJCirclViewController *near = (WJCirclViewController *)weakSelf.viewController;
                            
                            //是否使用每日一次查看私密照
                            NSString *currentDate = [NSDate getDate:[NSDate date] dateFormatter:@"yyyyMMdd"];
                            NSString *circlePhotoKey = [NSString stringWithFormat:@"%@%@CirclePhotoKey",currentDate,[FWUserInformation sharedInstance].mid];
                            NSString *value = [LXFileManager readUserDataForKey:circlePhotoKey];
                            if ([value isEqualToString:@"1"]) {
                                CircleDaliyFreeView *freeView = [[CircleDaliyFreeView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) Index:[NSString stringWithFormat:@"%d",i]];
                                freeView.seePhotoBlock = ^(NSString * index) {
                                    [weakSelf photoData:index IsVip:YES];
                                };
                                [near.navigationController.view addSubview:freeView];
                                //是否使用每日一次查看私密照
                            } else {
                                //打赏弹框
                                CirclePhotoPayMaskView *payview = [[CirclePhotoPayMaskView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) CircleModel:weakSelf.model IndexPath:weakSelf.indexpath Index:[NSString stringWithFormat:@"%d",i]];
                                
                                payview.vipBlock = ^(NSDictionary *dic){//钻石VIP
                                    [weakSelf photoData:[NSString stringWithFormat:@"%d",i] IsVip:YES];
                                };
                                [near.navigationController.view addSubview:payview];
                                //打赏弹框
                            }
                            //             **************************8*************打赏看图片
                        }

                    
                };
                
                [photo sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:LOADIMAGE(@"my_headPlaceholder@2x", @"png") options:SDWebImageRefreshCached];
                lastView = photo;
            }
            
            [_likeView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(weakSelf.commentView.mas_left).offset(-30);
                make.top.mas_equalTo(lastView.mas_bottom).offset(10);
                make.width.mas_equalTo(60);
                make.height.mas_equalTo(30);
            }];
            
            ///有图片
        } else {
            [_likeView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(weakSelf.commentView.mas_left).offset(-30);
                make.top.mas_equalTo(weakSelf.contentLabel.mas_bottom).offset(10);
                make.width.mas_equalTo(60);
                make.height.mas_equalTo(30);
            }];
        }
        //*********图片
        
        
        //浏览量
        if ([_model.hits_count integerValue] > 0) {
            _pageviewsLabel.text = [NSString stringWithFormat:@"浏览%@次",_model.hits_count];
        } else {
            _pageviewsLabel.text = @"";
        }
        //点赞量
        if ([_model.like_count integerValue] > 0) {
            _likeView.contentLabel.text = [NSString stringWithFormat:@"点赞 %@",_model.like_count];
        } else {
            _likeView.contentLabel.text = @"点赞";
        }
        
        if ([_model.isLike isEqualToString:@"1"]) {
            _likeView.typeImageView.image = LOADIMAGE(@"circle_liked@2x", @"png");
            _likeView.contentLabel.textColor = Color16(0xF85F73);
        } else {
            _likeView.typeImageView.image = LOADIMAGE(@"circle_like@2x", @"png");
            _likeView.contentLabel.textColor = Color16(0x868A9B);
        }
        
        //打赏
        if ([model.dashang_num integerValue] > 0) {
            [self addSubview:self.awardView];
            [self addSubview:self.awardLabel];
            [self addSubview:self.awardImageView];
            
            NSString *temp = @"";
            NSInteger dashangnum;
            NSString *content = @"";
            if (model.dashang_list.count > 6) {
                dashangnum = 6;
            } else {
                dashangnum = model.dashang_list.count;
            }
            
            for (int i = 0; i < dashangnum; i++) {
                NSDictionary *dic = [_model.dashang_list objectAtIndex:i];
                NSString *name = [NSString stringWithFormat:@"%@、",[dic objectForKey:@"nickname"]];
                temp =  [temp stringByAppendingString:name];
            }
            
            if (model.dashang_list.count > 6) {
                content = [NSString stringWithFormat:@"%@等%lu人打赏了Ta",temp,(unsigned long)model.dashang_list.count];
                _awardLabel.attributedText = [content changeCorlorWithColor:Color16(0x666666) TotalString:content SubStringArray:@[[NSString stringWithFormat:@"等%lu人打赏了Ta",(unsigned long)model.dashang_list.count]]];
            } else {
                content = [NSString stringWithFormat:@"%@等打赏了Ta",temp];
                _awardLabel.attributedText = [content changeCorlorWithColor:Color16(0x666666) TotalString:content SubStringArray:@[@"等打赏了Ta"]];
            }
            
            CGFloat  awardHeight = [content textHeightWithContentWidth:ScreenWidth - 80 font:[UIFont systemFontOfSize:kPercentIP6(14)]] + 10;//打赏
            
            [_awardView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(weakSelf).offset(-15);
                make.left.mas_equalTo(weakSelf).offset(15);
                make.top.mas_equalTo(weakSelf.likeView.mas_bottom).offset(10);
                make.height.mas_equalTo(awardHeight);
            }];
            
            [_awardImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(weakSelf.awardView).offset(5);
                make.top.mas_equalTo(weakSelf.awardView).offset(5);
                make.height.mas_equalTo(15);
                make.width.mas_equalTo(15);
            }];
            
            [_awardLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(weakSelf.awardView).offset(-15);
                make.left.mas_equalTo(weakSelf.awardImageView.mas_right).offset(15);
                make.top.mas_equalTo(weakSelf.awardView).offset(0);
                make.bottom.mas_equalTo(weakSelf.awardView).offset(0);
            }];
            
        } else {
            [_awardView removeFromSuperview];
            [_awardLabel removeFromSuperview];
            [_awardImageView removeFromSuperview];
        }
        
        
        if ([_model.comment_count integerValue] > 3 && _model.comment_list.count > 0) {
            _morebutton.hidden = NO;
        } else {
            _morebutton.hidden = YES;
        }
        
        if ([_model.comment_count integerValue] > 0 && [model.dashang_num integerValue] <= 0) {
            _middleLineView.hidden = NO;
        } else {
            _middleLineView.hidden = YES;
        }
        
        
        //移除先前的评论
        for (int i = 0; i < _labelArray.count; i++) {
            UILabel *label = (UILabel *)[_labelArray objectAtIndex:i];
            [label removeFromSuperview];
        }
        
        //显示评论
        if (_model.comment_list.count > 0) {
            if (!_labelArray) {
                _labelArray = [NSMutableArray array];
            }
            
            UIView *lastView = nil;
            NSInteger count  = 0;
            if (_model.comment_list.count <= 3) {
                count = _model.comment_list.count;
            } else {
                count = 3;
            }
            
            for (NSInteger i = 0; i < count; i++) {
                NSDictionary *dic = [_model.comment_list objectAtIndex:i];//评论信息
                NSString *str = [NSString stringWithFormat:@"%@:%@",[dic objectForKey:@"nickname"], [dic objectForKey:@"content"]];
                UILabel *message;
                if (i < _labelArray.count) {
                    message = (UILabel *)[_labelArray objectAtIndex:i];
                } else {
                    message = [[UILabel alloc] init];
                    message.numberOfLines = 0;
                    message.font = [UIFont systemFontOfSize:kPercentIP6(14)];
                    [_labelArray addObject:message];//添加到数组中
                }
                
                message.attributedText = [str changeCorlorWithColor:Color16(0x727Eb3) TotalString:str SubStringArray:@[[dic objectForKey:@"nickname"]]];
                [self addSubview:message];
                CGFloat height = [str textHeightWithContentWidth:ScreenWidth - 30 font:[UIFont systemFontOfSize:kPercentIP6(14)]];
                //打赏
                if ([model.dashang_num integerValue] > 0) {
                    [message mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(15);
                        make.top.mas_equalTo(lastView ?( lastView.mas_bottom) :(weakSelf.awardView.mas_bottom) ).offset(lastView ? (0) :(10));
                        make.width.mas_equalTo(ScreenWidth - 30);
                        make.height.mas_equalTo(height + 10);
                    }];
                } else {
                    [message mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(15);
                        make.top.mas_equalTo(lastView ?( lastView.mas_bottom) :(weakSelf.pageviewsLabel.mas_bottom) ).offset(lastView ? (0) :(30));
                        make.width.mas_equalTo(ScreenWidth - 30);
                        make.height.mas_equalTo(height + 10);
                    }];
                }
                
                lastView = message;
            }
            
            //更多
            if ([_model.comment_count integerValue] > 3) {
                [_morebutton mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(12);
                    make.top.mas_equalTo(lastView.mas_bottom).offset(0);
                    make.width.mas_equalTo(kPercentIP6(90));
                    make.height.mas_equalTo(30);
                }];
            }

        }
        
        
    }
}

@end
