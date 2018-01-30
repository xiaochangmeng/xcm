//
//  LetterDetailViewController.m
//  Appointment
//
//  Created by feiwu on 16/7/20.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "LetterDetailViewController.h"
#import "LetterGetChatRecordApi.h"
#import "LetterRecordModel.h"
#import "LetterReplyQuestionApi.h"
#import "MyFeedBackViewController.h"
#import "LetterSendMessageApi.h"
#import "MyGetInfoApi.h"
#import "LoginViewController.h"
#import "NSDate+MZYExtension.h"
#import "AppDelegate.h"
#import "LetterSelectPayView.h"
#import "NSObject+XWAdd.h"
#import "StatisticalPayApi.h"
#import "LXFileManager.h"
#import "MyVerifyPayResultApi.h"
#import "LetterVideoView.h"
@interface LetterDetailViewController ()

@end

@implementation LetterDetailViewController

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.tabBarController.hidesBottomBarWhenPushed =YES;
    [self getLetterRecordRequest:_model.send_id];
    
    //标识当前是否在聊天页
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isLetter = YES;
    [MobClick beginLogPageView:@"聊天页面"];
    // 通过观察者监听交易状态
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"聊天页面"];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideHUD];//隐藏指示器
    
    //标识当前是否在聊天页
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isLetter = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WS(weakSelf);
    
    self.view.backgroundColor = Color10(243, 245, 246, 1);
    self.title = _model.name;
    self.isBack = YES;
    
    //已选中
    _selectedArray = [NSMutableArray array];
    if (_model.user_id) {
        [_selectedArray addObject:_model.user_id];
    } else if (_model.send_id ) {
        [_selectedArray addObject:_model.send_id];
    }
    
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.replyButton];
    [self.view addSubview:self.replyView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(0);
        make.left.equalTo(weakSelf.view).offset(0);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(ScreenHeight - 64 - 50);
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).offset(0);
        make.left.equalTo(weakSelf.view).offset(0);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 50));
    }];
    
    [_replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(ScreenHeight - 64 - 50);
        make.left.equalTo(weakSelf.view).offset(16);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 32, 40));
    }];
    
    [_replyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).offset(0);
        make.left.equalTo(weakSelf.view).offset(0);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 50));
    }];
    
    [self addFooter];
    
    //控制键盘显隐
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    //短信包月VIP通知
    [self xw_addNotificationForName:@"VipAndWriterStatusChange" block:^(NSNotification *notification) {
        NSString *type = [notification object];
        if ([type isEqualToString:@"writer"]) {
            weakSelf.flag_writer = YES;
            [weakSelf showBottomView:@"1"];
            [weakSelf getInfoRequest];
        }
    }];
    
    //私信列表
    [self xw_addNotificationForName:@"LetterViewControllerRefreshLetterList" block:^(NSNotification *notification) {
        NSString *mid = [notification object];
        //是否是同一个用户
        if ([mid isEqualToString:weakSelf.model.user_id]) {
            //是否是当前控制器
            if ([weakSelf isCurrentViewControllerVisible:weakSelf]) {
                [weakSelf getLetterRecordRequest:weakSelf.model.send_id];
            }
        }
    }];
    //后台进入
    [self xw_addNotificationForName:@"backgroundNewLetter" block:^(NSNotification *notification) {
        NSDictionary *dic = [notification object];
        NSString *mid = [[dic allKeys] firstObject];
        NSString *nickname = [[dic allValues] firstObject];
        weakSelf.title = nickname;
        [weakSelf getLetterRecordRequest:mid];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark 键盘显示
- (void) keyboardWillShowNotification:(NSNotification*) notification {
    WS(weakSelf)
    //键盘高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyboardHeight = keyboardRect.size.height;
    [_replyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).offset(-weakSelf.keyboardHeight);
        make.left.equalTo(weakSelf.view).offset(0);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 50));
    }];
    
    if (!_send_bool) {
        [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view).offset(75);
            make.left.equalTo(weakSelf.view).offset(0);
            make.width.mas_equalTo(ScreenWidth);
            make.height.mas_equalTo(ScreenHeight - 64 - 50 -75 - weakSelf.keyboardHeight);
        }];
    } else {
        [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view).offset(0);
            make.left.equalTo(weakSelf.view).offset(0);
            make.width.mas_equalTo(ScreenWidth);
            make.height.mas_equalTo(ScreenHeight - 64 - 50 - weakSelf.keyboardHeight);
        }];
        
    }
    
    //     [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_recordDataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
}

#pragma mark 键盘隐藏
- (void) keyboardWillHideNotification:(NSNotification*) notification {
    WS(weakSelf)
    [_replyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).offset(0);
        make.left.equalTo(weakSelf.view).offset(0);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 50));
    }];
    
    if (!_send_bool) {
        [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view).offset(75);
            make.left.equalTo(weakSelf.view).offset(0);
            make.width.mas_equalTo(ScreenWidth);
            make.height.mas_equalTo(ScreenHeight - 64 - 50 -75);
        }];
    } else {
        [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view).offset(0);
            make.left.equalTo(weakSelf.view).offset(0);
            make.width.mas_equalTo(ScreenWidth);
            make.height.mas_equalTo(ScreenHeight - 64 - 50);
        }];
        
    }
    
    //     [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_recordDataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - Public Methods
//展示底部视图的显示
- (void)showBottomView:(NSString *)flag_showinput
{
    if ([flag_showinput isEqualToString:@"2"]) {
        //显示充值button
        _tipLabel.hidden = YES;
        _replyButton.hidden = NO;
        _replyView.hidden = YES;
    } else if ([flag_showinput isEqualToString:@"1"]) {
        //显示输入框
        _tipLabel.hidden = YES;
        _replyButton.hidden = YES;
        _replyView.hidden = NO;
    } else if ([flag_showinput isEqualToString:@"0"]) {
        //提示
        _tipLabel.hidden = NO;
        _replyButton.hidden = YES;
        _replyView.hidden = YES;
    } else {
        //默认显示输入框
        _tipLabel.hidden = YES;
        _replyButton.hidden = YES;
        _replyView.hidden = NO;
    }
    
}

#pragma mark - Network Data
#pragma mark - 私信聊天记录
- (void)getLetterRecordRequest:(NSString *)other_id {
    LogRed(@"和谁聊天呢:%@",other_id);
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    LetterGetChatRecordApi *api = [[LetterGetChatRecordApi alloc] initWithOther_id:other_id];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf hideHUD];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf getLetterRecordRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"私信聊天记录请求失败:%@",request.responseString);
        [weakSelf hideHUD];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf showHUDFail:kNetWorkErrorTitle];
        [weakSelf hideHUDDelay:1];
    }];
}

- (void)getLetterRecordRequestFinish:(NSDictionary *)result{
    LogOrange(@"私信聊天记录请求成功:%@",result);
    WS(weakSelf);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    
    if ([code intValue] == kNetWorkSuccCode){
        
        NSMutableArray *recordArray = [NSMutableArray arrayWithArray:[[result objectForKey:@"data"] objectForKey:@"list"]];
        //是否有数据
        if ((NSNull *)recordArray != [NSNull null] && recordArray.count > 0)  {
            if (!_recordDataArray) {
                _recordDataArray = [NSMutableArray array];
            }
            
            //清除已显示数据
            [_recordDataArray removeAllObjects];
            [_tableView reloadData];
            
            for (NSDictionary *dic in recordArray) {
                LetterRecordModel *model = [[LetterRecordModel alloc] initWithDataDic:dic];
                //question
                if (![model.tag isEqualToString:@"5"]) {
                    [_recordDataArray addObject:model];
                    
                    if ([model.tag isEqualToString:@"2"]) {
                        _img = model.avatar;
                    }
                    
                } else {
                    NSMutableArray *answer = [dic objectForKey:@"answer_full"];
                    NSMutableArray *answerShort = [dic objectForKey:@"answer"];
                    _answerDataDic = dic;//问题数据
                    _answerDataArray = answer;//答案数组
                    
                    UIView *lastView = nil;
                    [_questionView removeFromSuperview];
                    _questionView = nil;
                    _questionView = [[UIView alloc] init];
                    _questionView.backgroundColor = Color10(243, 245, 246, 1);
                    [self.view addSubview:_questionView];
                    
                    [_questionView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(weakSelf.view).offset(0);
                        make.bottom.mas_equalTo(weakSelf.view).offset(0);
                        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 60 * answer.count));
                    }];
                    //button
                    for (int i = 0; i < answer.count; i++) {
                        UIButton *question = [[UIButton alloc] init];
                        question.tag = 3000 + i;
                        [question addTarget:self action:@selector(handleSelect:) forControlEvents:UIControlEventTouchUpInside];
                        [question setTitle:[answerShort objectAtIndex:i] forState:UIControlStateNormal];
                        question.titleLabel.font = kFont14;
                        question.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                        [question setTitleColor:Color10(191, 123, 196, 1) forState:UIControlStateNormal];
                        [question setTitleColor:Color10(191, 123, 196, 1) forState:UIControlStateHighlighted];
                        [question setBackgroundImage:[UIImage imageNamed:@"common_button_white_normal@2x" ImageType:@"png" withTop:5 andLeft:15] forState:UIControlStateNormal];
                        [question setBackgroundImage:[UIImage imageNamed:@"common_button_white_press@2x" ImageType:@"png" withTop:5 andLeft:15] forState:UIControlStateHighlighted];
                        
                        [_questionView addSubview:question];
                        
                        [question mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.mas_equalTo(weakSelf.view).offset(15);
                            make.top.mas_equalTo(lastView ? lastView.mas_bottom : weakSelf.questionView.mas_top).offset(10);
                            make.size.mas_equalTo(CGSizeMake(ScreenWidth - 30, 40));
                        }];
                        lastView = question;
                    }
                    //button
                }
                //question
            }
            
            _tableView.recordDataArray = _recordDataArray;
            [_tableView reloadData];
            
            //滑到最底部
            if (_recordDataArray.count > 3) {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_recordDataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            
        }
        //是否有数据
        
    }else if([code intValue] == kNetWorkNoLoginCode){
        //没有登录
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
        [self performSelector:@selector(login) withObject:nil afterDelay:1];
        
    } else {
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
    }
    
    //底部视图显示
    NSString *show =[[result objectForKey:@"data"] objectForKey:@"flag_showinput"];
    _flag_refresh =[[[result objectForKey:@"data"] objectForKey:@"flag_refresh"] intValue];
    _send_bool =[[[result objectForKey:@"data"] objectForKey:@"send_bool"] intValue];
    
    //是否已发送
    if (!_send_bool) {
        [self showNoLetter];
        [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view).offset(75);
            make.left.equalTo(weakSelf.view).offset(0);
            make.width.mas_equalTo(ScreenWidth);
            make.height.mas_equalTo(ScreenHeight - 64 - 50 - 75);
        }];
        
    }
    
    [self showBottomView:show];
    
}

- (void)login{
    WS(weakSelf);
    LoginViewController *login = [[LoginViewController alloc] init];
    login.isNoLogin = YES;
    login.loginBlock = ^(){
        [weakSelf getLetterRecordRequest:weakSelf.model.send_id];//私信聊天记录
        
    };
    [self presentViewController:login animated:NO completion:^{
        
    }];
}

#pragma mark - 回复问题
- (void)setReplyQuestionRequest:(NSString *)other_id Greet_id:(NSString *)greet_id Select_id:(NSString *)select_id {
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    LetterReplyQuestionApi*api = [[LetterReplyQuestionApi alloc] initWithOther_id:other_id Greet_id:greet_id Select_id:select_id];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"回复问题请求失败:%@",request.responseString);
    }];
    
    //回复问题
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [weakSelf setReplyQuestionWithSelect_id:select_id];
    });
}

- (void)setReplyQuestionWithSelect_id:(NSString *)select_id {
    
    [self hideHUD];
    [_questionView removeFromSuperview];
    _questionView = nil;
    
    LetterRecordModel *model = [[LetterRecordModel alloc] init];
    NSInteger index = [select_id integerValue] - 1;
    model.tag = @"2";
    model.content = [_answerDataArray objectAtIndex:index];
    model.avatar = _img;
    model.showtime = [NSDate getDate:[NSDate date] dateFormatter:@"yyyy-MM-dd hh:mm"];
    [_recordDataArray addObject:model];
    _tableView.recordDataArray = _recordDataArray;
    [_tableView reloadData];
    [self showBottomView:@"0"];
    
    //更新页面
    WS(weakSelf);
    _send_bool =  YES;
    [self hideTitleView];
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(0);
        make.left.equalTo(weakSelf.view).offset(0);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(ScreenHeight - 64 - 50 );
    }];
    
}

#pragma mark - 发送消息
- (void)setMessageRequest:(NSString *)other_id Content:(NSString *)content{
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    LetterSendMessageApi *api = [[LetterSendMessageApi alloc] initWithOther_id:other_id Content:content];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf hideHUD];
        [weakSelf setMessageRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"回复请求失败:%@",request.responseString);
        [weakSelf hideHUD];
        [weakSelf showHUDFail:kNetWorkErrorTitle];
        [weakSelf hideHUDDelay:1];
    }];
}

- (void)setMessageRequestFinish:(NSDictionary *)result{
    LogOrange(@"回复请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        if (!_recordDataArray) {
            _recordDataArray = [NSMutableArray array];
        }
        
        LetterRecordModel *model = [[LetterRecordModel alloc] init];
        model.tag = @"2";
        model.content = _replyView.descTextView.text;
        model.avatar = _img;
        model.showtime = [NSDate getDate:[NSDate date] dateFormatter:@"yyyy-MM-dd hh:mm"];
        [_recordDataArray addObject:model];
        _tableView.recordDataArray = _recordDataArray;
        [_tableView reloadData];
        
        //底部显示切换
        if (_flag_refresh && !_flag_writer ) {
            [self showBottomView:@"1"];
            _isFirstReply = YES;
        } else if (_flag_writer) {
            [self showBottomView:@"1"];
        }
        _replyView.descTextView.text = @"";
        //滑到最底部
        if (_recordDataArray.count > 3) {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_recordDataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        
        //更新页面
        WS(weakSelf);
        _send_bool = YES;
        [self hideTitleView];
        [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view).offset(0);
            make.left.equalTo(weakSelf.view).offset(0);
            make.width.mas_equalTo(ScreenWidth);
            make.height.mas_equalTo(ScreenHeight - 64 - 50 );
        }];
        
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
        [weakSelf getInfoRequest];
    }];
}

- (void)getInfoRequestFinish:(NSDictionary *)result{
    LogOrange(@"获取我的页面信息请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    if ([code intValue] == kNetWorkSuccCode){
        
    }else {
        
    }
}
#pragma mark - 支付路径
- (void)setStatisticalPayRequest:(NSString *)action{
    WS(weakSelf);
    StatisticalPayApi *api = [[StatisticalPayApi alloc] initWithAction:action];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf setStatisticalPayRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"设置支付路径失败:%@",request.responseString);
    }];
}

- (void)setStatisticalPayRequestFinish:(NSDictionary *)result{
    LogOrange(@"设置支付路径成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    if ([code intValue] == kNetWorkSuccCode){
        
    } else {
        
    }
}

#pragma mark - 验证支付结果
- (void)verifyPayResultRequest:(NSString *)receipt TransactionId:(NSString *)tid  Time:(NSString *)time{
    WS(weakSelf);
    NSLog(@"订单号:%@",tid);
    MyVerifyPayResultApi *api = [[MyVerifyPayResultApi alloc] initWithReceipt:receipt Transactionid:tid Productid:_productId From:_from Time:time];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf hideHUD];
        [weakSelf verifyPayResultRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"验证订单信息请求失败:%@",request.responseString);
    }];
}

- (void)verifyPayResultRequestFinish:(NSDictionary *)result{
    LogOrange(@"验证订单信息请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    if ([code intValue] == kNetWorkSuccCode){
        //移除订单信息
        NSString *mid = [FWUserInformation sharedInstance].mid;//用户id
        NSString *key = [NSString stringWithFormat:@"%@inAppBuy",mid];//key
        [LXFileManager removeUserDataForkey:key];
        
        //短信包月VIP通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"VipAndWriterStatusChange" object:@"writer"];
        //友盟付费统计
        [MobClickGameAnalytics pay:[_price doubleValue] source:2 item:_productName amount:1 price:[_price doubleValue]];
        
    }else {
    }
}

#pragma mark 下拉刷新数据
- (void)addFooter
{
    WS(weakSelf);
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getLetterRecordRequest:weakSelf.model.send_id];//私信聊天记录
    }];
    
}

#pragma mark - Event Responses
- (void)handleSelect:(UIButton *)button
{
    NSInteger index = button.tag - 3000 + 1;
    NSString *greet_id = [_answerDataDic objectForKey:@"id"];
    [self setReplyQuestionRequest:_model.user_id Greet_id:greet_id Select_id:[NSString stringWithFormat:@"%ld",(long)index]];
}

//回复索要联系方式
- (void)handleReplyAction
{
    [MobClick event:@"letterGetInfo"];
    WS(weakSelf);
    //买点
    [weakSelf setStatisticalPayRequest:@"chat-write"];
    LetterSelectPayView* letterSelectPayView = [[LetterSelectPayView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    letterSelectPayView.LetterSelectPayBlock = ^(NSInteger typeIndex){
        if (typeIndex == 0) {
            //短信回复包一年(198)
            [MobClick event:@"webWriter12"];
            //买点
            [weakSelf setStatisticalPayRequest:@"chat-write-button-890"];
            weakSelf.price = write_12;
            weakSelf.productName = NSLocalizedString(@"365天写信包月", nil);
            weakSelf.productId = @"8";
            weakSelf.from = @"chat-write-button-890";
            // 向苹果服务器请求可卖的商品
            if ([SKPaymentQueue canMakePayments]) {
                [weakSelf requestProducts:@"taiwantongcheng_writer365"];
                [weakSelf showHUD:NSLocalizedString(@"正在处理支付，请稍后", nil) isDim:NO mode:MBProgressHUDModeIndeterminate];
            } else {
                [weakSelf hideHUD];
                [weakSelf showHUDFail:NSLocalizedString(@"用户禁止应用内购买", nil)];
                [weakSelf hideHUDDelay:1];
            };
            
        } else if (typeIndex == 1){
            //短信回复包三月(100)
            [MobClick event:@"webWriter3"];
            //买点
            [weakSelf setStatisticalPayRequest:@"chat-write-button-450"];
            weakSelf.price = write_3;
            weakSelf.productName = NSLocalizedString(@"90天写信包月", nil);
            weakSelf.productId = @"7";
            weakSelf.from = @"chat-write-button-450";
            // 向苹果服务器请求可卖的商品
            if ([SKPaymentQueue canMakePayments]) {
                [weakSelf requestProducts:@"taiwantongcheng_writer90"];
                [weakSelf showHUD:NSLocalizedString(@"正在处理支付，请稍后", nil) isDim:NO mode:MBProgressHUDModeIndeterminate];
            } else {
                [weakSelf hideHUD];
                [weakSelf showHUDFail:NSLocalizedString(@"用户禁止应用内购买", nil)];
                [weakSelf hideHUDDelay:1];
            };
            
        } else if (typeIndex == 2){
            //短信回复包一月(50)
            [MobClick event:@"webWriter1"];
            //买点
            [weakSelf setStatisticalPayRequest:@"chat-write-button-240"];
            weakSelf.price = write_1;
            weakSelf.productName = NSLocalizedString(@"30天写信包月", nil);
            weakSelf.productId = @"6";
            weakSelf.from = @"chat-write-button-240";
            // 向苹果服务器请求可卖的商品
            if ([SKPaymentQueue canMakePayments]) {
                [weakSelf requestProducts:@"taiwantongcheng_writer30"];
                [weakSelf showHUD:NSLocalizedString(@"正在处理支付，请稍后", nil) isDim:NO mode:MBProgressHUDModeIndeterminate];
            } else {
                [weakSelf hideHUD];
                [weakSelf showHUDFail:NSLocalizedString(@"用户禁止应用内购买", nil)];
                [weakSelf hideHUDDelay:1];
            };
            
        }
    };
    [self.view addSubview:letterSelectPayView];
}
#pragma mark -- 内购
/**
 *  请求可卖商品
 */
- (void)requestProducts:(NSString *)productId
{
    
    // 1.获取productid的set(集合中)
    NSSet *set = [NSSet setWithObjects:productId, nil];
    
    // 2.向苹果发送请求,请求可卖商品
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    /*
     for (SKProduct *product in response.products) {
     NSLog(@"价格:%@", product.price);
     NSLog(@"标题:%@", product.localizedTitle);
     NSLog(@"秒速:%@", product.localizedDescription);
     NSLog(@"productid:%@", product.productIdentifier);
     }
     */
    
    self.products = response.products;
    NSLog(@"商品的數量:%@",self.products);
    // 1.取出模型
    SKProduct *product = [self.products firstObject];
    // 2.购买商品
    if (product) {
        [self buyProduct:product];
    } else {
        [self showHUDFail:NSLocalizedString(@"无法获取产品信息", nil)];
        [self hideHUDDelay:1];
    }
    
}

//查询失败后的回调
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    [self hideHUD];
}

#pragma mark - 购买商品
- (void)buyProduct:(SKProduct *)product
{
    // 1.创建票据
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    // 2.将票据加入到交易队列中
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - 实现观察者回调的方法
/**
 *  当交易队列中的交易状态发生改变的时候会执行该方法
 *
 *  @param transactions 数组中存放了所有的交易
 */
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    /*
     SKPaymentTransactionStatePurchasing, 正在购买
     SKPaymentTransactionStatePurchased, 购买完成(销毁交易)
     SKPaymentTransactionStateFailed, 购买失败(销毁交易)
     SKPaymentTransactionStateRestored, 恢复购买(销毁交易)
     SKPaymentTransactionStateDeferred 最终状态未确定
     */
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"用户正在购买");
                break;
            case SKPaymentTransactionStatePurchased:
            {
                NSLog(@"购买成功");
                [self hideHUD];
                [self showHUD:NSLocalizedString(@"正在验证支付结果", nil) isDim:NO mode:MBProgressHUDModeIndeterminate];
                NSData *data =  [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                NSString *receipt = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//凭证
                NSString *mid = [FWUserInformation sharedInstance].mid;//用户id
                NSString *key = [NSString stringWithFormat:@"%@inAppBuy",mid];//key
                NSString *dateString = [NSString stringWithFormat:@"%ld",time(NULL)];//时间戳
                NSDictionary *dic =[ NSDictionary dictionaryWithObjectsAndKeys:
                                    receipt, @"receipt", dateString, @"date", mid, @"user_id", transaction.transactionIdentifier, @"transactionId", _productId, @"product_id",_from, @"from", nil];//保存的信息防止漏单
                [LXFileManager saveUserData:dic forKey:key];
                [queue finishTransaction:transaction];
                
                [self verifyPayResultRequest:receipt TransactionId:transaction.transactionIdentifier Time:dateString];
            }
                break;
            case SKPaymentTransactionStateFailed:
            {
                NSLog(@"购买失败");
                [self hideHUD];
                NSString *error = [transaction.error.userInfo objectForKey:@"NSLocalizedDescription"];
                if (![error isEqualToString:@""]) {
                    [self showHUDFail:error];
                    [self hideHUDDelay:2];
                }
                [queue finishTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"恢复购买");
                [self hideHUD];
                [queue finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateDeferred:
                NSLog(@"最终状态未确定");
                [self hideHUD];
                break;
            default:
                break;
        }
    }
}
#pragma mark -- 内购


#pragma mark - Getters And Setters
- (LetterDetailTableView *)tableView {
    if (!_tableView) {
        _tableView = [[LetterDetailTableView alloc] init];
        _tableView.backgroundColor = Color10(243, 245, 246, 1);
        
    }
    return _tableView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = NSLocalizedString(@"请耐心等待Ta的回信", nil);
        _tipLabel.font = kFont16;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.backgroundColor = Color10(243, 245, 246, 1);
        _tipLabel.hidden = YES;
    }
    return _tipLabel;
}
- (UIButton *)replyButton {
    if (!_replyButton) {
        _replyButton = [[UIButton alloc] init];
        [_replyButton setTitle:NSLocalizedString(@"回复并索要联系方式", nil) forState:UIControlStateNormal];
        _replyButton.titleLabel.font = kFont14;
        [_replyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_replyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_replyButton setBackgroundImage:[UIImage imageNamed:@"letter_replyBackground@2x" ImageType:@"png" withTop:20 andLeft:100] forState:UIControlStateNormal];
        [_replyButton setBackgroundImage:[UIImage imageNamed:@"letter_replyBackground@2x" ImageType:@"png" withTop:20 andLeft:100] forState:UIControlStateHighlighted];
        [_replyButton addTarget:self action:@selector(handleReplyAction) forControlEvents:UIControlEventTouchUpInside];
        _replyButton.hidden = YES;
    }
    return _replyButton;
}




-(void)testClick{
   WS(weakSelf);
   LetterVideoView* letterVideoView = [[LetterVideoView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) Type:@"2" Mid:_model.user_id Nickname:_model.name Img:_model.img_deal];
   [letterVideoView setLetterVideoBlock:^(NSString *type) {
      if ([type intValue]==1) {
         [weakSelf handleReplyAction];
      }
      }];
   [[[UIApplication sharedApplication].windows lastObject] addSubview:letterVideoView];
}


- (LetterReplyView *)replyView {
    if (!_replyView) {
        _replyView = [[LetterReplyView alloc] init];
        _replyView.titleStr = _model.name;
        _replyView.hidden = YES;
        WS(weakSelf);
        _replyView.sendBlock =^(NSString *message){
            if (weakSelf.isFirstReply ) {
                weakSelf.isFirstReply = NO;
                [weakSelf handleReplyAction];
                [weakSelf showBottomView:@"2"];
            } else {
                [weakSelf setMessageRequest:weakSelf.model.send_id Content:message];
            }
        };
       [_replyView setSendVodeoBlock:^{
          [weakSelf vedioSelect];
       }];
    }
    return _replyView;
}

#pragma mark - 视频按钮，选择视频页面还是充值页面
-(void)vedioSelect{
   FWUserInformation * info = [FWUserInformation sharedInstance];
   
   if ([info.vip_tell intValue]==1) {
      [self testClick];
   }else{
      [self handleReplyAction];
   }
   
}

@end
