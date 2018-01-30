//
//  CircleCommentListViewController.m
//  Appointment
//  评论列表
//  Created by feiwu on 2017/2/9.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "CircleCommentListViewController.h"
#import "CircleCommentListApi.h"
#import "LoginViewController.h"
#import "CircleCommentTableViewCell.h"
#import "NSString+MZYExtension.h"
#import "CircleCommnetModel.h"
#import "CircleSubmitCommentApi.h"
@interface CircleCommentListViewController ()

@end

@implementation CircleCommentListViewController
#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"圈子评论页面"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"圈子评论页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论列表";
    self.isBack = YES;
    self.page = 0;
    self.isRefresh = NO;
    [self initView];
    [self makeConstraints];
    
    [self addHeader];
    [self addFooter];
    
    [self getCommentListRequestCommentId:self.model.comment_id Page:@"0"];//评论列表
    
    //控制键盘显隐
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
//私有方法
- (void)initView
{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.textBGView];
    [self.textBGView addSubview:self.descTextView];
    [self.textBGView addSubview:self.sendButton];
}

- (void)makeConstraints
{
    WS(weakSelf)
    //背景
    [self.textBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).offset(0);
        make.left.equalTo(weakSelf.view).offset(0);
        make.right.equalTo(weakSelf.view).offset(0);
        make.height.mas_equalTo(49);
    }];
    
    //内容
    [self.descTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.textBGView.mas_top).offset(9);
        make.left.equalTo(weakSelf.textBGView).offset(15);
        make.right.equalTo(weakSelf.sendButton.mas_left).offset(-15);
        make.bottom.equalTo(weakSelf.textBGView.mas_bottom).offset(-9);
    }];
    
    //发送
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.textBGView);
        make.right.equalTo(weakSelf.view).offset(-15);
        make.size.mas_equalTo(CGSizeMake(120/2, 64/2));
    }];
    
}
#pragma mark - Notification Responses
#pragma mark 键盘显示
- (void) keyboardWillShowNotification:(NSNotification*) notification {
    WS(weakSelf)
    //键盘高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    [self.textBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).offset(-keyboardHeight);
        make.left.equalTo(weakSelf.view).offset(0);
        make.right.equalTo(weakSelf.view).offset(0);
        make.height.mas_equalTo(49);
    }];
    
}

#pragma mark - Event Responses
/**
 点击发送消息按钮
 */
- (void)clickSendButton:(UIButton *)sender
{
    if (_descTextView.text != nil && ![_descTextView.text isEqualToString:@""]) {
        [self.descTextView resignFirstResponder];
        [_descTextView resignFirstResponder];
        [self setCommentRequest:_model.comment_id Message:_descTextView.text];
    }
}

#pragma mark 键盘隐藏
- (void) keyboardWillHideNotification:(NSNotification*) notification {
    WS(weakSelf)
    [self.textBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).offset(0);
        make.left.equalTo(weakSelf.view).offset(0);
        make.right.equalTo(weakSelf.view).offset(0);
        make.height.mas_equalTo(49);
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *circle_identify = @"CircleCommentTableViewCell";
    CircleCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:circle_identify];
    if (cell == nil) {
        cell = [[CircleCommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:circle_identify];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_commentDataArray.count > 0) {
        CircleCommentTableViewCell *circleCell = (CircleCommentTableViewCell *)cell;
        circleCell.model = _commentDataArray[indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleCommnetModel *model = _commentDataArray[indexPath.row];
    CGFloat height = [model.content textHeightWithContentWidth:ScreenWidth - 72 font:[UIFont systemFontOfSize:kPercentIP6(16)]];//文本
    if (height > 90) {
        height = 90;
    }
    return  12 + 36 + 10 + height + 2 + 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - Network Data
#pragma mark - 评论列表
- (void)getCommentListRequestCommentId:(NSString *)comment_id Page:(NSString *)page {
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    CircleCommentListApi *api = [[CircleCommentListApi alloc] initWithCommentID:comment_id Page:page];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf hideHUD];
        [weakSelf getCommentListRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"评论列表请求失败:%@",request.responseString);
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf hideHUD];
    }];
}

- (void)getCommentListRequestFinish:(NSDictionary *)result{
    LogOrange(@"评论列表请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        
        if (_isRefresh) {
            _isRefresh = NO;
            _page = 0;
            [_commentDataArray removeAllObjects];
            [_tableView reloadData];
        }
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[result objectForKey:@"data"]];
        NSMutableArray *commentArray = [NSMutableArray arrayWithArray:[dic objectForKey:@"list"]];
        //是否有数据
        if ((NSNull *)commentArray != [NSNull null] && commentArray.count > 0)  {
            
            if (!_commentDataArray) {
                _commentDataArray = [NSMutableArray array];
            }
            
            for (int i = 0; i < commentArray.count; i++) {
                NSDictionary *dic = [commentArray objectAtIndex:i];
                CircleCommnetModel *model = [[CircleCommnetModel alloc] initWithDataDic:dic];
                [_commentDataArray addObject:model];
            }
            
            [_tableView reloadData];
            _page++;
        }
        
        
    }else if([code intValue] == kNetWorkNoLoginCode){
        //没有登录
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
        [self performSelector:@selector(login) withObject:nil afterDelay:1];
        
    }else if([code intValue] == kNetWorkNoDataCode){
        //没有数据
        [self showHUDFail:@"没有更多数据请稍后重试"];
        [self hideHUDDelay:1];
    } else {
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
    }
}

#pragma mark - 圈子评论
- (void)setCommentRequest:(NSString *)comment_id  Message:(NSString *)message{
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    CircleSubmitCommentApi *api = [[CircleSubmitCommentApi alloc] initWithCommentID:comment_id Content:message];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf hideHUD];
        [weakSelf setCommentRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"评论请求失败:%@",request.responseString);
        [weakSelf hideHUD];
    }];
}
- (void)setCommentRequestFinish:(NSDictionary *)result{
    LogOrange(@"评论请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        _descTextView.text = @"";
        [self showHUDComplete:@"评论成功"];
        [self hideHUDDelay:1];
        NSDictionary *dic = [result objectForKey:@"data"];
        if (dic.count > 0) {
            CircleCommnetModel *model = [[CircleCommnetModel alloc] initWithDataDic:dic];
            [_commentDataArray insertObject:model atIndex:0];
            [_tableView reloadData];
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        
    }else {
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
    }
}


- (void)login{
    WS(weakSelf);
    LoginViewController *login = [[LoginViewController alloc] init];
    login.isNoLogin = YES;
    login.loginBlock = ^(){
        [weakSelf getCommentListRequestCommentId:weakSelf.model.comment_id Page:@"0"];
    };
    [self presentViewController:login animated:NO completion:^{
        
    }];
}

#pragma mark 下拉刷新数据
- (void)addHeader
{
    WS(weakSelf);
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isRefresh = YES;
        [weakSelf getCommentListRequestCommentId:weakSelf.model.comment_id Page:@"0"];
    }];
}

#pragma mark 上拉加载数据
- (void)addFooter
{
    WS(weakSelf);
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getCommentListRequestCommentId:weakSelf.model.comment_id Page:[NSString stringWithFormat:@"%d",weakSelf.page]];
    }];
}


#pragma mark - Getters And Setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 49 - 64)];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;//隐藏cell分割线
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIView *)textBGView
{
    if (!_textBGView) {
        _textBGView = [UIView new];
        _textBGView.backgroundColor = Color16(0xF4F4F4);
    }
    return _textBGView;
}

- (UITextField *)descTextView
{
    if (!_descTextView) {
        _descTextView = [UITextField new];
        _descTextView.font = kFont14;
        _descTextView.textColor = Color16(0x333333);
        _descTextView.delegate = self;
        _descTextView.placeholder = @"请输入评论内容";
        [_descTextView setBorderStyle:UITextBorderStyleRoundedRect];
    }
    return _descTextView;
}

- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [UIButton new];
        [_sendButton setBackgroundImage:LOADIMAGE(@"circle_sendDefault@2x", @"png") forState:UIControlStateNormal];
        [_sendButton setBackgroundImage:LOADIMAGE(@"circle_sendSelect@2x", @"png") forState:UIControlStateSelected];
        [_sendButton addTarget:self action:@selector(clickSendButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}


@end
