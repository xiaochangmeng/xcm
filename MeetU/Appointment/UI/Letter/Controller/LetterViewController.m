//
//  LetterViewController.m
//  Appointment
//
//  Created by feiwu on 16/7/8.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "LetterViewController.h"
#import "TabBarView.h"
#import "LetterListApi.h"
#import "MyGetInfoApi.h"
#import "FateModel.h"
#import "GetLetterCountApi.h"
#import "MyInfoViewController.h"
#import "LoginViewController.h"
#import "LXFileManager.h"
#import "NSObject+XWAdd.h"
#import "MyFeedBackViewController.h"
#import "CustomNavigationController.h"
@interface LetterViewController ()

@end

@implementation LetterViewController
#pragma mark - Life Cycle

#pragma mark - 创建导航栏
-(void)createNator{
    //    登陆label
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"私信";
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    //    设置导航栏背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dh_02"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    
    //    导航栏左边按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"fate_navigation_writer"] forState:UIControlStateNormal];
    //    添加点击事件
    [leftButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(0, 0, 40, 26);
    UIBarButtonItem *leftItemCustom = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItemCustom;
    
//    //    导航栏右边按钮
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    //            [rightButton setTitle:@"分享" forState:UIControlStateNormal];
//    //            [rightButton setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
//    //            rightButton.titleLabel.font = [UIFont systemFontOfSize:17];
//    [rightButton setImage:[UIImage imageNamed:@"fate_navigation_select"] forState:UIControlStateNormal];
//    //    添加点击事件
//    [rightButton addTarget:self action:@selector(RightbuttonClick) forControlEvents:UIControlEventTouchUpInside];
//    rightButton.frame = CGRectMake(0, 0, 18, 18);
//    UIBarButtonItem *rightItemCustom = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = rightItemCustom;
    
    
}

-(void)buttonClick{
    [MobClick event:@"fate_navigation_writer"];
    MyFeedBackViewController *feed = [[MyFeedBackViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/iOS/Buy/write_v1",BaseUrl]];    CustomNavigationController *navigation = [[CustomNavigationController alloc] initWithRootViewController:feed];
    feed.titleStr = NSLocalizedString(@"写信包月", nil);
    feed.pushType = @"fate-write";
    [self presentViewController:navigation animated:YES completion:^{
        
    }];
    
    
}

//-(void)RightbuttonClick{
//    [MobClick event:@"fate_navigation_select"];
//    SelectViewController *select = [[SelectViewController alloc] init];
//    CustomNavigationController *navigation = [[CustomNavigationController alloc] initWithRootViewController:select];
//
//    [self presentViewController:navigation animated:YES completion:^{
//
//    }];
//
//}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
  self.tabBarController.hidesBottomBarWhenPushed =NO;
    [self initLeftBarItem];//写信按钮
    
    //未读消息
    [self getLetterCountRequest];
    
     [_letterTableView reloadData];
    [MobClick beginLogPageView:@"私信列表页面"];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"私信列表页面"];
    
//    self.tabBarController.hidesBottomBarWhenPushed =YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideHUD];//隐藏指示器
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    self.title = NSLocalizedString(@"私信", nil);
    
    [self createNator];
    _isRefresh = YES;
    _page = 0;
    
    WS(weakSelf);
    [self initTabBarView];
    [self.view addSubview:self.perfectInfoView];
    [self.view addSubview:self.letterTableView];
    
    [_perfectInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(30);
    }];
    
    [_letterTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.perfectInfoView.mas_bottom);
        make.left.equalTo(weakSelf.view);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(ScreenHeight - 64 - 49 -30);
    }];
    
    //私信列表
    [self addHeader];
    [self addFooter];
    
    
    //私信列表
    [self xw_addNotificationForName:@"LetterViewControllerRefreshLetterList" block:^(NSNotification *notification) {
        weakSelf.isRefresh = YES;
        //是否当前可见
        if ([weakSelf isCurrentViewControllerVisible:weakSelf]) {
            [weakSelf getLetterListRequest:@"0"];
        }
    }];
    
    //图片动画
    [self xw_addNotificationForName:@"LetterViewControllerRefreshHighlight" block:^(NSNotification *notification) {
        [weakSelf.letterTableView reloadData];
    }];
    
    //短信包月VIP通知
    [self xw_addNotificationForName:@"VipAndWriterStatusChange" block:^(NSNotification *notification) {
        NSString *type = [notification object];
        if ([type isEqualToString:@"writer"]) {
            weakSelf.ios_tell = @"1";
            [weakSelf.letterTableView reloadData];
        } else if([type isEqualToString:@"vip"]){
            weakSelf.ios_vip = @"1";
        }
        [weakSelf.letterTableView reloadData];
    }];
    [self getInfoRequest];//請求是否是VIP
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
    TabBarView *tabBarView = [[TabBarView alloc] initWithIndex:1];
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

#pragma mark - Event Response

- (void)clickLeftButton:(UIButton *)button
{
     [MobClick event:@"letter_navigation_writer"];
      MyFeedBackViewController *feed = [[MyFeedBackViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/iOS/Buy/write_v1",BaseUrl]];
    CustomNavigationController *navigation = [[CustomNavigationController alloc] initWithRootViewController:feed];
    feed.titleStr = NSLocalizedString(@"写信包月", nil);
    feed.pushType = @"letter-write";
    [self presentViewController:navigation animated:YES completion:^{
        
    }];
}


#pragma mark - Network Data
#pragma mark - 私信列表
- (void)getLetterListRequest:(NSString *)page {
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    LetterListApi*api = [[LetterListApi alloc] initWithPage:page];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf.letterTableView.mj_header endRefreshing];
        [weakSelf.letterTableView.mj_footer endRefreshing];
        [weakSelf hideHUD];
        [weakSelf getLetterListRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"私信列表请求失败:%@",request.responseString);
        [weakSelf.letterTableView.mj_header endRefreshing];
        [weakSelf.letterTableView.mj_footer endRefreshing];
        [weakSelf hideHUD];
        [weakSelf showNetRefresh:^{
            [weakSelf hideNetRefresh];
            [weakSelf getLetterListRequest:page];
        }];
    }];
}

- (void)getLetterListRequestFinish:(NSDictionary *)result{
    LogOrange(@"私信列表请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        
        if (_isRefresh) {
            _isRefresh = NO;
            _page = 0;
            [_letterDataArray removeAllObjects];
            [_letterMidArray removeAllObjects];
            [_letterTableView reloadData];
        }
        NSMutableArray *letterArray = [NSMutableArray arrayWithArray:[result objectForKey:@"data"]];
        //是否有数据
        if (((NSNull *)letterArray != [NSNull null] && letterArray.count > 0 )  )  {
            if (!_letterDataArray) {
                _letterDataArray = [NSMutableArray array];
            }
            
            if (!_letterMidArray) {
                _letterMidArray = [NSMutableArray array];
            }
            
            for (NSDictionary *dic in letterArray) {
                FateModel *model = [[FateModel alloc] initWithDataDic:dic];
                //判断是否已加入，防止重复
                if (![_letterMidArray containsObject:model.send_id]) {
                    [_letterDataArray addObject:model];
                    [_letterMidArray addObject:model.send_id];
                }
                
            }
            
            _letterTableView.letterDataArray = _letterDataArray;
            _letterTableView.visitor_num = _visitor_num;
            [_letterTableView reloadData];
            if (letterArray.count > 0) {
                _page++;
            }
        }
               //是否显示空状态
        [_letterTableView tableViewDisplayWitMsg:@"暫時還沒有私信" imageName:@"empty_letter@2x" imageType:@"jpg" ifNecessaryForRowCount:_letterDataArray.count];
        
    }else if([code intValue] == kNetWorkNoLoginCode){
        //没有登录
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
        [self performSelector:@selector(login) withObject:nil afterDelay:1];
        
    } else if ([code intValue] == kNetWorkNoDataCode) {
        //没有数据
        [_letterTableView tableViewDisplayWitMsg:@"暂时还没有私信" imageName:@"empty_letter@2x" imageType:@"jpg" ifNecessaryForRowCount:_letterDataArray.count];
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
        weakSelf.isRefresh = YES;
        [weakSelf getLetterListRequest:@"0"];
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
        _visitor_num = [NSString stringWithFormat:@"%@",[dic objectForKey:@"lately_total"]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LetterCountChange" object:newCount];
        NSString *userid = [NSString stringWithFormat:@"%@%@",[FWUserInformation sharedInstance].mid,kUserLetterCount];
        [LXFileManager saveUserData:newCount forKey:userid];

        //如果最新的大于当前的刷新列表
        NSString *oldCount = [LXFileManager readUserDataForKey:userid];
        if (([newCount integerValue] != [oldCount integerValue]) ||_letterDataArray.count <= 0  || _letterDataArray.count < letter) {
            _isRefresh = YES;
            _page = 0;
            [self getLetterListRequest:@"0"];
        }
        
    } else if ([code intValue] == kNetWorkNoSetSexCode) {
        
    } else {
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


#pragma mark 下拉刷新数据
- (void)addHeader
{
    WS(weakSelf);
    _letterTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isRefresh = YES;
        [weakSelf getLetterListRequest:@"0"];
        [weakSelf getLetterCountRequest];
    }];
}

#pragma mark 上拉加载数据
- (void)addFooter
{
    WS(weakSelf);
    _letterTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.isRefresh = NO;
        [weakSelf getLetterListRequest:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
}

#pragma mark - Getters And Setters
- (LetterTableView *)letterTableView {
    if (!_letterTableView) {
        _letterTableView = [[LetterTableView alloc] init];
    }
    return _letterTableView;
}

- (LetterPerfectInfoView *)perfectInfoView {
    if (!_perfectInfoView) {
        _perfectInfoView = [[LetterPerfectInfoView alloc] init];
        _perfectInfoView.backgroundColor = Color16(0xE666AF);
        WS(weakSelf);
        _perfectInfoView.perfectBlock = ^{
            MyInfoViewController *info = [[MyInfoViewController alloc] init];
            [weakSelf.navigationController pushViewController:info animated:YES];
        };
    }
    return _perfectInfoView;
}
@end
