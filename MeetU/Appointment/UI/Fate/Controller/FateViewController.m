//
//  FirstViewController.m
//  Test
//
//  Created by feiwu on 16/7/7.
//  Copyright © 2016年 mazhiyuan. All rights reserved.
//

#import "FateViewController.h"
#import "TabBarView.h"
#import "FateListApi.h"
#import "FateCollectionViewCell.h"
#import "FateModel.h"
#import "GetLetterCountApi.h"
#import "LoginViewController.h"
#import "LXFileManager.h"
#import "PushRemindView.h"
#import "PushRemindUtils.h"
#import "FateCollectionHeadView.h"
#import "QuestionOfBottomView.h"
#import "MJRefreshHeader.h"
#import "SelectViewController.h"
#import "CustomNavigationController.h"
#import "MyFeedBackViewController.h"
#import "NSDate+MZYExtension.h"
#import "YLSwitch.h"
#import "FateHelloApi.h"

//#import "YTKNetworkAgent.h"
@interface FateViewController ()
@property (nonatomic,strong) YLSwitch * mySwitch     ;

@end

@implementation FateViewController

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createCustomNavView];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if (_fateDataArray.count <= 0) {
        [self getFateListRequest:@"1"];//有缘页
    }
    
    [[[UIApplication sharedApplication].windows lastObject] addSubview:[QuestionOfBottomView sharedManager]];
    if (![PushRemindUtils isAllowedNotification] && ![LXFileManager getUserChooseOfPush] ) {//用户没有开启推送 且没有点击不在提醒按钮
        [[[UIApplication sharedApplication].windows lastObject] addSubview:[PushRemindView sharedInstance]];
    }
    [MobClick beginLogPageView:@"缘分列表页面"];
    //    [[YTKNetworkAgent sharedInstance] cancelAllRequests];//取消所有网络请求
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //移除底部弹窗视图
    [_mySwitch removeFromSuperview];
    _mySwitch=nil;
    [[QuestionOfBottomView sharedManager] removeFromSuperview];
    [MobClick endLogPageView:@"缘分列表页面"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideTitleView];
    [self hideHUD];//隐藏指示器
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WS(weakSelf);
    //self.title = NSLocalizedString(@"缘份", nil);
    [self initLeftBarItem];//写信按钮
    [self initRrightBarItem];//搜索按钮
    [self initTabBarView];
    [self.view addSubview:self.fateScrollView];
    [self.fateScrollView addSubview:self.collection];
    [self.fateScrollView addSubview:self.nearbyTableView];
    [self.view addSubview:self.helloButton];
    self.view.backgroundColor=[UIColor whiteColor];
    [self.helloButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).offset(-60);
        // MARK: - 修改
        make.right.equalTo(weakSelf.view).offset(-20);
        //        make.centerX.equalTo(weakSelf.view);
        //        make.size.mas_equalTo(CGSizeMake(150, 44));
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [self getLetterCountRequest];//未读消息数
    _selectedArray = [NSMutableArray array];
    //全国列表
    [_collection getFateListRequest:@"1"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 初始化TabBar
- (void)initTabBarView{
    WS(weakSelf);
    TabBarView *tabBarView = [[TabBarView alloc] initWithIndex:0];
    [self.view addSubview:tabBarView];
    
    [tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(49);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
    }];
}

#pragma mark - 自定义导航栏
-(void)createCustomNavView{
    
    UIView * nav = [[UIView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, 44)];
    nav.backgroundColor=NavColor;
    if (_mySwitch==nil) {
        [self.navigationController.navigationBar addSubview:self.mySwitch];
    }
    
}

#pragma mark - 导航栏右侧按钮
- (void)initRrightBarItem{
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64/2, 64/2)];
    [self.rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setImage: LOADIMAGE(@"fate_navigation_select@2x", @"png") forState:UIControlStateNormal];
    [self.rightButton setImage: LOADIMAGE(@"fate_navigation_select@2x", @"png") forState:UIControlStateHighlighted];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    negativeSpacer.width = -5;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightItem, nil];
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
- (void)clickRightButton:(UIButton *)button
{
    [MobClick event:@"fate_navigation_select"];
    SelectViewController *select = [[SelectViewController alloc] init];
    CustomNavigationController *navigation = [[CustomNavigationController alloc] initWithRootViewController:select];
    
    [self presentViewController:navigation animated:YES completion:^{
        
    }];
}

- (void)clickLeftButton:(UIButton *)button
{
    [MobClick event:@"fate_navigation_writer"];
    MyFeedBackViewController *feed = [[MyFeedBackViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/iOS/Buy/write_v1",BaseUrl]];    CustomNavigationController *navigation = [[CustomNavigationController alloc] initWithRootViewController:feed];
    feed.titleStr = NSLocalizedString(@"写信包月", nil);
    feed.pushType = @"fate-write";
    [self presentViewController:navigation animated:YES completion:^{
        
    }];
}

#pragma mark - Network Data
#pragma mark - 获取缘分列表
- (void)getFateListRequest:(NSString *)page {
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    FateListApi *api = [[FateListApi alloc] initWithPage:page];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf.collection.mj_header endRefreshing];
        [weakSelf.collection.mj_footer endRefreshing];
        [weakSelf hideHUD];
        [weakSelf getFateListRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"缘分列表请求失败:%@",request.responseString);
        [weakSelf.collection.mj_header endRefreshing];
        [weakSelf.collection.mj_footer endRefreshing];
        [weakSelf hideHUD];
        [weakSelf showNetRefresh:^{
            [weakSelf hideNetRefresh];
            [weakSelf getFateListRequest:page];
        }];
    }];
}

- (void)getFateListRequestFinish:(NSDictionary *)result{
    LogOrange(@"缘分列表请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        
        if (_isRefresh) {
            _isRefresh = NO;
            _page = 1;
            [_fateDataArray removeAllObjects];
            [_collection reloadData];
        }
        NSMutableArray *fateArray = [NSMutableArray arrayWithArray:[result objectForKey:@"data"]];
        //是否有数据
        if ((NSNull *)fateArray != [NSNull null] && fateArray.count > 0)  {
            if (!_fateDataArray) {
                _fateDataArray = [NSMutableArray array];
            }
            for (NSDictionary *dic in fateArray) {
                FateModel *model = [[FateModel alloc] initWithDataDic:dic];
                [_fateDataArray addObject:model];
            }
            
            _collection.fateDataArray = _fateDataArray;
            [_collection reloadData];
            _page++;
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

- (void)login{
    WS(weakSelf);
    LoginViewController *login = [[LoginViewController alloc] init];
    login.isNoLogin = YES;
    login.loginBlock = ^(){
        weakSelf.isRefresh = YES;
        [weakSelf getFateListRequest:@"1"];
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
    MJRefreshStateHeader* header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isRefresh = YES;
        [weakSelf getFateListRequest:@"1"];
    }];
    [header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
    [header setTitle:NSLocalizedString(@"松开可以刷新", nil) forState:MJRefreshStatePulling];
    if ([[FWUserInformation sharedInstance].sex isEqualToString:@"1"]) {
        [header setTitle:NSLocalizedString(@"正在锁定妹子", nil) forState:MJRefreshStateRefreshing];
    }else{
        [header setTitle:NSLocalizedString(@"正在锁定帅哥", nil) forState:MJRefreshStateRefreshing];
    }
    _collection.mj_header = header;
}

#pragma mark 上拉加载数据
- (void)addFooter
{
    WS(weakSelf);
    _collection.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getFateListRequest:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    
}




#pragma mark - 点击二级选项卡
- (void)tabAction:(int)index{
    switch (index) {
        case 0:
        {
            // 全国
            if (self.collection.fateDataArray.count <= 0) {
                [self.collection getFateListRequest:@"1"];
            }
        }
            break;
        case 1:
        {
            // 附近
//            if (_nearbyTableView.nearbyDataArray.count <= 0) {
                [_nearbyTableView getNearbyListRequest];
//            }
            
        }
            break;
           
        default:
            break;
    }
    if (index == 1) {
        _helloButton.hidden = NO;
    } else {
        _helloButton.hidden = YES;
    }
    [_fateScrollView setContentOffset:CGPointMake(index * ScreenWidth, 0) animated:YES];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    int currentPage = point.x / ScreenWidth;
    //[_tabView tabIndex:currentPage];
    [self tabAction:currentPage];
    if (currentPage == 1) {
        _helloButton.hidden = NO;
        [_mySwitch rightButton:nil];
        
    } else {
        _helloButton.hidden = YES;
        [_mySwitch leftButton:nil];
        
    }
    
}

#pragma mark - Event Responses
- (void)handleHelloAllAction:(UIButton *)button
{
    [MobClick event:@"nearby_helloAll"];
    NSString *likeMids = @"";
    for (FateModel *model in _nearbyTableView.nearbyDataArray) {
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
    for (FateModel *model in _nearbyTableView.nearbyDataArray) {
        model.helloed = @"2";
        [temp addObject:model];
        
        //添加到已选中数组中
        if (![_selectedArray containsObject:model.user_id]) {
            [_selectedArray addObject:model.user_id];
        }
    }
    //刷新列表
    _nearbyTableView.nearbyDataArray = temp;
    [_nearbyTableView reloadData];
    [self showHUDComplete:NSLocalizedString(@"打招呼成功", nil)];
    [self hideHUDDelay:1];
    
}

#pragma mark -- YLSwitchDelegate

- (void)switchState:(UIView *)view leftTitle:(NSString *)title {
    [self tabAction:0];
    
}

- (void)switchState:(UIView *)view rightTitle:(NSString *)title {
    
    [self tabAction:1];
    
}

#pragma mark - Getters And Setters
- (FateCollectionView *)collection {
    if (!_collection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((ScreenWidth - 4) / 3.0, kPercentIP6(120));
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 2;
        layout.minimumInteritemSpacing = 2;
        layout.headerReferenceSize = CGSizeZero;
        layout.footerReferenceSize = CGSizeZero;
        _collection = [[FateCollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 49) collectionViewLayout:layout];
        
        [_collection registerClass:[FateCollectionViewCell class] forCellWithReuseIdentifier:identify];
        [_collection registerClass:[FateCollectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headIdentify];
    }
    return _collection;
}

-(YLSwitch *)mySwitch{
    
    if (_mySwitch == nil) {
        _mySwitch = [[YLSwitch alloc] initWithFrame:CGRectMake((ScreenWidth-200)/2.00,7, 200, 30)];
        //        _mySwitch.center=self.navigationController.navigationBar.center;
        _mySwitch.bgColor = NavColor;
        
        _mySwitch.thumbColor = [UIColor whiteColor] ;
        _mySwitch.layer.borderColor = [UIColor whiteColor].CGColor ;
        _mySwitch.layer.borderWidth = 1 ;
        _mySwitch.tag = 1;
        _mySwitch.delegate = self;
        _mySwitch.rightTitle = @"附近"  ;
        _mySwitch.leftTitle=@"缘份";
    }
    return _mySwitch  ;
}

/**
 底部scroll
 */
- (UIScrollView *)fateScrollView {
    if (!_fateScrollView) {
        _fateScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64  - 49)];
        _fateScrollView.delegate = self;
        _fateScrollView.pagingEnabled = YES;
        _fateScrollView.showsHorizontalScrollIndicator = NO;
        _fateScrollView.showsVerticalScrollIndicator = NO;
        _fateScrollView.bounces = NO;
        [_fateScrollView setContentSize:CGSizeMake(ScreenWidth * 2, ScreenHeight - 64  - 49)];
    }
    return _fateScrollView;
}

//群打招呼
- (UIButton *)helloButton
{
    if (!_helloButton) {
        _helloButton = [[UIButton alloc] init];
        [_helloButton addTarget:self action:@selector(handleHelloAllAction:) forControlEvents:UIControlEventTouchUpInside];
        [_helloButton setBackgroundImage:LOADIMAGE(NSLocalizedString(@"nearby_helloAll", nil), @"png") forState:UIControlStateNormal];
    }
    _helloButton.hidden=YES;
    return _helloButton;
}

/**
 附近视图
 */
- (NearbyTableView *)nearbyTableView {
    if (!_nearbyTableView) {
        _nearbyTableView = [[NearbyTableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - 64 -49 )];
        
    }
    return _nearbyTableView;
}


@end
