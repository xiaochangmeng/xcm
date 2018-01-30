//
//  FateDetailViewController.m
//  Appointment
//
//  Created by feiwu on 16/7/16.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "FateDetailViewController.h"
#import "FateUserInfoApi.h"
#import "FateHelloApi.h"
#import "FateUserAddBlackApi.h"
#import "FateUserAddReportApi.h"
#import "ActionSheetPicker.h"
#import "AbstractActionSheetPicker+Interface.h"
#import "LoginViewController.h"
#import "LetterDetailViewController.h"
#import "FateDetailRechargeMaskView.h"
#import "FateDetailBottomButtonView.h"
#import "MyGetInfoApi.h"
#import "NSObject+XWAdd.h"
@implementation FateDetailViewController

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [MobClick beginLogPageView:@"用户资料页面"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"用户资料页面"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self hideHUD];//隐藏指示器
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WS(weakSelf);
    [self.view addSubview:self.tableView];
    
    //头部视图
    //自定义动态导航条
    [self.view addSubview:self.navigationView];
    //返回按钮
    [_navigationView addSubview:self.backButton];
    
    //更多按钮
    [_navigationView addSubview:self.moreButton];
    
    //底部视图
    [self.view addSubview:self.fateDetailBottomButtonView];
    
    
    
    //导航条
    [_navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(weakSelf.view.mas_top);
    }];
    
    //返回按钮
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(weakSelf.navigationView.mas_centerY);
    }];
    
    //更多按钮
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
        make.right.mas_equalTo( - 12);
        make.centerY.mas_equalTo(weakSelf.navigationView.mas_centerY);
    }];
    [self getInfoRequest];//獲取我的信息
    [self getUserInfoRequest:_fateModel.user_id];//用户信息
    
    [self xw_addNotificationForName:@"FateDetailViewControllerScanPic" block:^(NSNotification *notification) {
        [weakSelf photoData:[notification object]];
    }];

    
    //短信包月VIP通知
    [self xw_addNotificationForName:@"VipAndWriterStatusChange" block:^(NSNotification *notification) {
        NSString *type = [notification object];
        [weakSelf.fateDetailRechargeMaskView removeFromSuperview];
        [self getInfoRequest];
        if ([type isEqualToString:@"vip"]) {
            weakSelf.ios_vip = @"1";
        } else if([type isEqualToString:@"writer"]) {
            weakSelf.ios_tell = @"1";
        }
        weakSelf.tableView.fateUserModel = _fateUserModel;
        weakSelf.headView.fateUserModel = _fateUserModel;
        weakSelf.tableView.isOpen = NO;//是否展开基本信息
        [weakSelf.tableView reloadData];

    }];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Event Responses
//事件响应方法
- (void)handleNextAction:(UIButton *)sender
{
    [MobClick event:@"userDetailNext"];
    [self getUserInfoRequest:_fateUserModel.next_user_id];
}

- (void)handleHelloAction:(UIButton *)sender
{
    [MobClick event:@"userDetailHello"];
    [self setFateHelloRequestWithMid:_fateUserModel.user_id];
}
- (void)backButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreButtonAction:(UIButton *)sender
{
    [self showMorePickerView:YES animated:YES];
}

#pragma mark 显示底部菜单菜单界面
- (void)showMorePickerView:(BOOL)isShow animated:(BOOL)animated{
    
    WS(weakSelf)
    if (isShow) {
        if (_backgroundView == nil) {
            weakSelf.view.superview.userInteractionEnabled = NO;
            _backgroundView = [[MZYImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            UIImage *image =  LOADIMAGE(@"common_actionsheet_background@2x", @"png");
            image = [image stretchableImageWithLeftCapWidth:2 topCapHeight:2];
            _backgroundView.image = image;
            _backgroundView.touchBlock = ^(){
                [weakSelf showMorePickerView:NO animated:YES];
            };
            [self.navigationController.view addSubview:_backgroundView];
            _actionSheet= [[MZYActionSheet alloc]init];
            
            if (!_titleArray) {
                NSString *black;
                if ([_fateUserModel.flag_black intValue] == 1) {
                    black = NSLocalizedString(@"已封锁", nil);
                } else {
                    black = NSLocalizedString(@"封锁", nil);
                }
                _titleArray = [NSMutableArray arrayWithObjects:NSLocalizedString(@"检举", nil),black, nil];
            }
            
            [_actionSheet setTitle:nil otherButtonTitle:_titleArray];
            _actionSheet.buttonBlock = ^(int tag){
                switch (tag) {
                    case 0:
                    {
                        //举报
                        [MobClick event:@"userDetailReport"];
                        [weakSelf showMorePickerView:NO animated:YES];
                        //居住地
                        NSArray *dataArr = @[NSLocalizedString(@"昵称不雅", nil),
                                             NSLocalizedString(@" 独白不雅", nil),
                                             NSLocalizedString(@"档案虚假", nil),
                                             NSLocalizedString(@"谩骂/辱骂", nil),
                                             NSLocalizedString(@"色情勾搭", nil),
                                             NSLocalizedString(@"钱财欺诈", nil),
                                             NSLocalizedString(@"代孕", nil),
                                             NSLocalizedString(@"传销/推销", nil),NSLocalizedString(@"其他", nil)];
                        
                        ActionSheetStringPicker *actionPicker = [[ActionSheetStringPicker alloc]initWithTitle:NSLocalizedString(@"检举原因", nil) rows:dataArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                            //*********一组点击确认按钮做处理************
                            NSString *content = (NSString *)selectedValue;
                            [weakSelf setUserAddReportRequestWithMid:weakSelf.fateUserModel.user_id Content:content];
                            
                        } cancelBlock:^(ActionSheetStringPicker *picker) {
                            
                        } origin:weakSelf.view];
                        [actionPicker customizeInterface];
                        [actionPicker showActionSheetPicker];
                    }
                        break;
                    case 1:
                    {
                        //拉黑
                        [MobClick event:@"userDetailBlack"];
                        if ([weakSelf.fateUserModel.flag_black isEqualToString:@"1"]) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"溫馨提醒", @"溫馨提醒")
                                                                            message:NSLocalizedString(@"该用户已封锁！", nil)
                                                                           delegate:nil
                                                                  cancelButtonTitle:NSLocalizedString(@"確定", @"確定")
                                                                  otherButtonTitles:nil];
                            [alert show];
                            
                        } else {
                            [weakSelf setUserAddBlackRequestWithMid:weakSelf.fateUserModel.user_id];
                        }
                        
                        [weakSelf showMorePickerView:NO animated:YES];
                    }
                        break;
                    default:
                    {
                        [weakSelf showMorePickerView:NO animated:YES];
                    }
                        break;
                }
            };
            [self.navigationController.view addSubview:_actionSheet];
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
            weakSelf.view.superview.userInteractionEnabled = YES;
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


#pragma mark - Network Data
#pragma mark - 获取我的页面信息
- (void)getInfoRequest {
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    MyGetInfoApi *api = [[MyGetInfoApi alloc] init];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf hideHUD];
        [weakSelf getInfoRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"获取我的页面信息请求失败:%@",request.responseString);
        [weakSelf hideHUD];
    }];
}
- (void)getInfoRequestFinish:(NSDictionary *)result{
    LogOrange(@"获取我的页面信息请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        NSDictionary *dic = [result objectForKey:@"data"];
        _ios_vip = [dic objectForKey:@"ios_vip"];
        _ios_tell = [dic objectForKey:@"ios_tell"];
    }else if([code intValue] == kNetWorkNoLoginCode){
        
    } else {
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
    }
}

#pragma mark - 获取用户信息
- (void)getUserInfoRequest:(NSString *)mid {
    LogOrange(@"你是谁呀:%@",mid);
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    FateUserInfoApi *api = [[FateUserInfoApi alloc] initWithMid:mid];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf hideHUD];
        [weakSelf getUserInfoRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"获取用户信息请求失败:%@",request.responseString);
        [weakSelf hideHUD];
        [weakSelf showHUDFail:kNetWorkErrorTitle];
        [weakSelf hideHUDDelay:1];
    }];
}

- (void)getUserInfoRequestFinish:(NSDictionary *)result{
    LogOrange(@"获取用户信息请求成功:%@",result);
   
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        NSDictionary *fateUserDic = [result objectForKey:@"data"];
        //是否有数据
        if ((NSNull *)fateUserDic != [NSNull null] && fateUserDic.count > 0)  {
            _fateUserModel = [[FateUserModel alloc] initWithDataDic:fateUserDic];
            if ([_fateUserModel.helloed isEqualToString:@"2"]) {
                [self.fateDetailBottomButtonView.helloButton setSelected:YES];
            }else{
                [self.fateDetailBottomButtonView.helloButton setSelected:NO];
            }
            _tableView.fateUserModel = _fateUserModel;
            _headView.fateUserModel = _fateUserModel;
            _tableView.isOpen = NO;//是否展开基本信息
            [_tableView reloadData];
//            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
            //更多
            NSString *black;
            if ([_fateUserModel.flag_black intValue] == 1) {
                black = NSLocalizedString(@"已封锁", nil);
            } else {
                black = NSLocalizedString(@"封锁", nil);
            }
            NSMutableArray *temp = [NSMutableArray arrayWithObjects:NSLocalizedString(@"检举", nil),black, nil];
            _titleArray = temp;
        }
        
    }else if([code intValue] == kNetWorkNoLoginCode){
        //没有登录
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
        [self performSelector:@selector(login) withObject:nil afterDelay:1];
    } else {
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
    }
}

#pragma mark - 拉黑用户
- (void)setUserAddBlackRequestWithMid:(NSString *)mid {
    WS(weakSelf);
    [weakSelf hideHUD];
    [weakSelf showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    FateUserAddBlackApi *api = [[FateUserAddBlackApi alloc] initWithMid:mid];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf hideHUD];
        [weakSelf setUserAddBlackRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"拉黑用户请求失败:%@",request.responseString);
        [weakSelf hideHUD];
        [weakSelf showHUDFail:kNetWorkErrorTitle];
        [weakSelf hideHUDDelay:1];
    }];
}

- (void)setUserAddBlackRequestFinish:(NSDictionary *)result{
    LogOrange(@"拉黑用户请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        [self showHUDComplete:NSLocalizedString(@"封锁用户成功", nil)];
        [self hideHUDDelay:1];
        _fateUserModel.flag_black = @"1";
        [_titleArray replaceObjectAtIndex:1 withObject:NSLocalizedString(@"已封锁", nil)];
    }else if([code intValue] == kNetWorkNoLoginCode){
        //没有登录
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
        [self performSelector:@selector(login) withObject:nil afterDelay:1];
    } else {
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
    }
}

- (void)login{
    WS(weakSelf);
    LoginViewController *login = [[LoginViewController alloc] init];
    login.isNoLogin = YES;
    login.loginBlock = ^(){
        [weakSelf getUserInfoRequest:weakSelf.fateModel.user_id];//用户信息
    };
    [self presentViewController:login animated:NO completion:^{
        
    }];
}

#pragma mark - 举报用户
- (void)setUserAddReportRequestWithMid:(NSString *)mid Content:(NSString *)content{
    WS(weakSelf);
    [weakSelf hideHUD];
    [weakSelf showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    FateUserAddReportApi *api = [[FateUserAddReportApi alloc] initWithMid:mid Content:content];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf hideHUD];
        [weakSelf setUserAddReportRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"举报用户请求失败:%@",request.responseString);
        [weakSelf hideHUD];
        [weakSelf showHUDFail:kNetWorkErrorTitle];
        [weakSelf hideHUDDelay:1];
    }];
}

- (void)setUserAddReportRequestFinish:(NSDictionary *)result{
    LogOrange(@"举报用户请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        if ([desc hasPrefix:@"ok"]) {
            [self showHUDComplete:NSLocalizedString(@"检举成功", nil)];
        } else {
            [self showHUDComplete:desc];
        }
        [self hideHUDDelay:1];
        
    }else if([code intValue] == kNetWorkNoLoginCode){
        //没有登录
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
        [self performSelector:@selector(login) withObject:nil afterDelay:1];
    } else {
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
    }
}

#pragma mark - 设置打招呼
- (void)setFateHelloRequestWithMid:(NSString *)mid {
    LogOrange(@"cell中和谁打招呼:%@",mid);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    FateHelloApi *api = [[FateHelloApi alloc] initWithMid:mid];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSLog(@"打招呼成功：%@",request.responseJSONObject);
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"打招呼请求失败:%@",request.responseString);
    }];
    [self performSelector:@selector(setFateHelloFinish) withObject:nil afterDelay:0.2];
}

- (void)setFateHelloFinish{
    [self hideHUD];
    [self showHUDComplete:NSLocalizedString(@"打招呼成功", nil)];
    [self hideHUDDelay:1];
    
    //添加到已打招呼数组
    [_selectedArray addObject:_fateUserModel.user_id];
    _fateUserModel.helloed = @"2";
    //打招呼成功回调
    if (_selectedBlock) {
        _selectedBlock(_selectedArray);
    }
    [_fateDetailBottomButtonView.helloButton setSelected:YES];
}

#pragma mark 封装图片数据
- (void)photoData:(NSString *)index
{
    // Browser
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    BOOL displayActionButton = NO;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    BOOL autoPlayOnAppear = NO;
    
    if (_fateUserModel.photos.count > 0) {
        //相册有图片
        for (NSString *pic in _fateUserModel.photos) {
            // Photos
            [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:pic]]];
        }
    } else {
        //相册没有图片
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:_fateUserModel.avatar]]];
    }
    _picArray = photos;
    
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
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _picArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _picArray.count)
        return [_picArray objectAtIndex:index];
    return nil;
}

#pragma mark - Getters And Setters
- (FateDetailTableView *)tableView {
    if (!_tableView) {
        _tableView = [[FateDetailTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _tableView.tableHeaderView = self.headView;
    }
    return _tableView;
}

- (FateDetailHeadView *)headView {
    if (!_headView) {
        _headView = [[FateDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kPercentIP6(477))];
    }
    return _headView;
}

- (UIView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[UIView alloc] init];
    }
    return _navigationView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:LOADIMAGE(@"common_chatroomback_default@2x", @"png") forState:UIControlStateNormal];
        [_backButton setImage:LOADIMAGE(@"common_chatroomback_default@2x", @"png") forState:UIControlStateHighlighted];
        [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [[UIButton alloc] init];
        [_moreButton setImage:LOADIMAGE(@"common_more_default@2x", @"png") forState:UIControlStateNormal];
        [_moreButton setImage:LOADIMAGE(@"common_more_default@2x", @"png") forState:UIControlStateHighlighted];
        [_moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

/**
 跳转到聊天界面
 */
- (void)skipToLetterDetailScreen{
    LetterDetailViewController *detail = [[LetterDetailViewController alloc] init];
    FateModel *model = [[FateModel alloc] init];
    model.send_id = _fateUserModel.user_id;
    model.user_id = _fateUserModel.user_id;
    model.name = _fateUserModel.name;
    detail.model = model;
    if ([[FWUserInformation sharedInstance].sex isEqualToString:@"1"]) {
        //男
        detail.flag_writer = [self.ios_tell intValue];
    } else {
        //女
        detail.flag_writer = YES;
    }
    [self.navigationController pushViewController:detail animated:YES];
}

- (FateDetailBottomButtonView *)fateDetailBottomButtonView
{
    if (!_fateDetailBottomButtonView) {
        _fateDetailBottomButtonView = [[FateDetailBottomButtonView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 90, ScreenWidth, 90)];
        
        WS(weakSelf);
        _fateDetailBottomButtonView.buttonHandle = ^(NSUInteger tag){
            switch (tag) {
                case 0:{//发信
                    [MobClick event:@"userDetailSend"];
                    if ([[FWUserInformation sharedInstance].sex isEqualToString:@"1"]) {
                        //男性用户
                        if ([weakSelf.ios_tell isEqualToString:@"1"]) {
                            [weakSelf skipToLetterDetailScreen];
                        }else{
                            weakSelf.fateDetailRechargeMaskView = [[FateDetailRechargeMaskView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                            weakSelf.fateDetailRechargeMaskView.fateDetailRechargeMaskViewHelloButton = ^(){
                                [MobClick event:@"userDetailHello"];
                                if (![weakSelf.fateUserModel.helloed isEqualToString:@"2"]) {
                                    [weakSelf handleHelloAction:nil];
                                } else {
                                    [weakSelf showHUDComplete:NSLocalizedString(@"已打招呼", nil)];
                                    [weakSelf hideHUDDelay:1];
                                }
                            };
                            [weakSelf.view addSubview:weakSelf.fateDetailRechargeMaskView];
                        }
                    } else {
                        //女性用户
                        [weakSelf skipToLetterDetailScreen];
                    }
                    break;
                }
                case 1:{//打招呼
                    [MobClick event:@"userDetailHello"];
                    if (![weakSelf.fateUserModel.helloed isEqualToString:@"2"]) {
                        [weakSelf setFateHelloRequestWithMid:weakSelf.fateUserModel.user_id];
                    } else {
                        [weakSelf showHUDComplete:NSLocalizedString(@"已打招呼", nil)];
                        [weakSelf hideHUDDelay:1];
                    }
                    break;
                }
                case 2:{//下一个
                    [MobClick event:@"userDetailNext"];
                    [weakSelf getUserInfoRequest:weakSelf.fateUserModel.next_user_id];
                    break;
                }
            }
        };
        
    }
    return _fateDetailBottomButtonView;
}
@end
