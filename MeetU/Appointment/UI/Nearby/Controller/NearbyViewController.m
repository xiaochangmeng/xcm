//
//  NearbyViewController.m
//  Appointment
//
//  Created by feiwu on 16/7/8.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "NearbyViewController.h"
#import "TabBarView.h"
#import "NearbyListApi.h"
#import "FateHelloApi.h"
#import "FateModel.h"
#import "GetLetterCountApi.h"
#import "LoginViewController.h"
#import "LXFileManager.h"
#import "QuestionOfBottomView.h"
#import "NSObject+XWAdd.h"
#import "MyFeedBackViewController.h"
#import "CustomNavigationController.h"
@interface NearbyViewController ()

@end

@implementation NearbyViewController

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initLeftBarItem];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if (_nearbyDataArray.count <= 0) {
        [self getNearbyListRequest];
    }
    
    [[[UIApplication sharedApplication].windows lastObject] addSubview:[QuestionOfBottomView sharedManager]];
    [MobClick beginLogPageView:@"附近页面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //移除底部弹窗视图
    [[QuestionOfBottomView sharedManager] removeFromSuperview];
    [MobClick endLogPageView:@"附近页面"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideTitleView];
    [self hideHUD];//隐藏指示器
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"附近", nil);
    WS(weakSelf);
    [self initTabBarView];
    [self.view addSubview:self.nearbyTableView];
    [self.view addSubview:self.helloButton];
    [self.nearbyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, ScreenHeight - 64 - 49));
    }];
    
    [self.helloButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).offset(-60);
        make.right.equalTo(weakSelf.view).offset(-20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    //附近
    [self addHeader];
    [self addFooter];
    [self getLetterCountRequest];//未读消息数
    
    _selectedArray = [NSMutableArray array];
    
    //刷新列表
    [self xw_addNotificationForName:@"RefreshSelectList" block:^(NSNotification *notification) {
        [weakSelf getNearbyListRequest];
    }];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTabBarView{
    WS(weakSelf);
    TabBarView *tabBarView = [[TabBarView alloc] initWithIndex:2];
    [self.view addSubview:tabBarView];
    
    [tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(49);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
    }];
}
#pragma mark - 导航栏左侧按钮
- (void)initLeftBarItem{
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80/2, 64/2)];
    [self.leftButton addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton setImage: [UIImage imageNamed:NSLocalizedString(@"fate_navigation_writer", nil)] forState:UIControlStateNormal];
    [self.leftButton setImage: [UIImage imageNamed:NSLocalizedString(@"fate_navigation_writer", nil)] forState:UIControlStateHighlighted];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    negativeSpacer.width = -5;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, leftItem, nil];
}



- (void)clickLeftButton:(UIButton *)button
{
    [MobClick event:@"nearby_navigation_write"];
    MyFeedBackViewController *feed = [[MyFeedBackViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/iOS/Buy/write_v1",BaseUrl]];    CustomNavigationController *navigation = [[CustomNavigationController alloc] initWithRootViewController:feed];
    feed.titleStr = NSLocalizedString(@"写信包月", nil);
    feed.pushType = @"nearby-write";
    [self presentViewController:navigation animated:YES completion:^{
        
    }];
}

#pragma mark - Event Responses
- (void)handleHelloAllAction:(UIButton *)button
{
    [MobClick event:@"nearby_helloAll"];
    NSString *likeMids = @"";
    for (FateModel *model in _nearbyDataArray) {
        if ([model.helloed isEqualToString:@"0"]) {
            likeMids = [NSString stringWithFormat:@"%@,%@",likeMids,model.user_id];
        }
    }
    
    if (likeMids.length > 3) {
        NSString *mids = [likeMids substringFromIndex:1];
        NSLog(@"群打招呼是:%@",mids);
        [self setHelloAllRequest:mids];
    }
}

#pragma mark - Network Data
#pragma mark - 搜索列表
- (void)getNearbyListRequest {
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    NearbyListApi *api = [[NearbyListApi alloc] initWithPage:@"1"];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf.nearbyTableView.mj_header endRefreshing];
        [weakSelf.nearbyTableView.mj_footer endRefreshing];
        [weakSelf hideHUD];
        [weakSelf getNearbyListRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"附近列表请求失败:%@",request.responseString);
        [weakSelf.nearbyTableView.mj_header endRefreshing];
        [weakSelf.nearbyTableView.mj_footer endRefreshing];
        [weakSelf hideHUD];
        [weakSelf showNetRefresh:^{
            [weakSelf hideNetRefresh];
            [weakSelf getNearbyListRequest];
        }];
        
    }];
}

- (void)getNearbyListRequestFinish:(NSDictionary *)result{
    LogOrange(@"附近列表请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        
        NSMutableArray *nearbyArray = [NSMutableArray arrayWithArray:[result objectForKey:@"data"]];
        //是否有数据
        if ((NSNull *)nearbyArray != [NSNull null] && nearbyArray.count > 0)  {
            [_nearbyDataArray removeAllObjects];//移除之前的元素
            
            if (!_nearbyDataArray) {
                _nearbyDataArray = [NSMutableArray array];
            }
            
            for (NSDictionary *dic in nearbyArray) {
                FateModel *model = [[FateModel alloc] initWithDataDic:dic];
                [_nearbyDataArray addObject:model];
            }
            
            _nearbyTableView.nearbyDataArray = _nearbyDataArray;
            [_nearbyTableView reloadData];
            [_nearbyTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            
        }
        
        
    }else if([code intValue] == kNetWorkNoLoginCode){
        //没有登录
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
        [self performSelector:@selector(login) withObject:nil afterDelay:1];
        
    }else if([code intValue] == kNetWorkNoDataCode){
        //没有数据
        [self showHUDFail:NSLocalizedString(@"没有更多数据，请稍后重试", nil)];
        [self hideHUDDelay:1];
    } else {
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
    }
}

#pragma mark - 群打招呼
- (void)setHelloAllRequest:(NSString *)mids {
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    FateHelloApi *api = [[FateHelloApi alloc] initWithMid:mids];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf hideHUD];
        [weakSelf setHelloAllRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"群打招呼请求失败:%@",request.responseString);
        [weakSelf hideHUD];
        [weakSelf showHUDFail:kNetWorkErrorTitle];
        [weakSelf hideHUDDelay:1];
    }];
}

- (void)setHelloAllRequestFinish:(NSDictionary *)result{
    LogOrange(@"群打招呼成功:%@",result);
    //改变helloed值
    NSMutableArray *temp = [NSMutableArray array];
    for (FateModel *model in _nearbyDataArray) {
        model.helloed = @"2";
        [temp addObject:model];
        
        //添加到已选中数组中
        if (![_selectedArray containsObject:model.user_id]) {
            [_selectedArray addObject:model.user_id];
        }
    }
    //刷新列表
    _nearbyDataArray = temp;
    [_nearbyTableView reloadData];
    [self showHUDComplete:NSLocalizedString(@"打招呼成功", nil)];
    [self hideHUDDelay:1];
    
}


- (void)login{
    WS(weakSelf);
    LoginViewController *login = [[LoginViewController alloc] init];
    login.isNoLogin = YES;
    login.loginBlock = ^(){
        [weakSelf getNearbyListRequest];
    };
    [self presentViewController:login animated:NO completion:^{
        
    }];
}
#pragma mark - 未读私信数量
- (void)getLetterCountRequest{
    WS(weakSelf);
    GetLetterCountApi *api = [[GetLetterCountApi alloc] init];
    [api startWithCompletionBlockWithSuccess:^( YTKBaseRequest *request) {
        [weakSelf getLetterCountRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        if ([[request.responseJSONObject objectForKey:@"code"] integerValue] == 200) {
            [weakSelf getLetterCountRequestFinish:request.responseJSONObject];
        }
    }];
}

- (void)getLetterCountRequestFinish:(NSDictionary *)result{
    LogOrange(@"未读私信请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    if ([code intValue] == kNetWorkSuccCode){
        NSDictionary *dic = [result objectForKey:@"data"];
        NSInteger visitor = [[dic objectForKey:@"lately_total"] integerValue];
        NSInteger letter = [[dic objectForKey:@"letter_total"] integerValue];
        NSString *newCount = [NSString  stringWithFormat:@"%ld",visitor + letter];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LetterCountChange" object:newCount];
        NSString *userid = [NSString stringWithFormat:@"%@%@",[FWUserInformation sharedInstance].mid,kUserLetterCount];
        [LXFileManager saveUserData:newCount forKey:userid];
        
        if ([newCount integerValue] > 0) {
            [self showLetterCount:newCount];
        }
        
    } else if ([code intValue] == kNetWorkNoSetSexCode) {
        
    } else {
    }
}

#pragma mark 下拉刷新数据
- (void)addHeader
{
    WS(weakSelf);
    _nearbyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getNearbyListRequest];
    }];
}

#pragma mark 上拉加载数据
- (void)addFooter
{
    WS(weakSelf);
    _nearbyTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getNearbyListRequest];
    }];
}

#pragma mark - Getters And Setters
- (NearbyTableView *)nearbyTableView {
    if (!_nearbyTableView) {
        _nearbyTableView = [[NearbyTableView alloc] init];
    }
    return _nearbyTableView;
}
//群打招呼
- (UIButton *)helloButton
{
    if (!_helloButton) {
        _helloButton = [[UIButton alloc] init];
        [_helloButton addTarget:self action:@selector(handleHelloAllAction:) forControlEvents:UIControlEventTouchUpInside];
        [_helloButton setBackgroundImage:LOADIMAGE(NSLocalizedString(@"nearby_helloAll", nil), @"png") forState:UIControlStateNormal];
    }
    return _helloButton;
}

@end
