//
//  SecondViewController.m
//  Test
//
//  Created by feiwu on 16/7/7.
//  Copyright © 2016年 mazhiyuan. All rights reserved.
//

#import "SelectViewController.h"
#import "FateListApi.h"
#import "FateModel.h"
#import "SelectConditionViewController.h"
#import "CustomNavigationController.h"
#import "LoginViewController.h"
#import "QuestionOfBottomView.h"
#import "NSObject+XWAdd.h"
@interface SelectViewController ()

@end

@implementation SelectViewController

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initRrightBarItem];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if (_selectDataArray.count <= 0) {
        [self getSelectListRequest:@"1"];
    }
    [MobClick beginLogPageView:@"搜索列表页面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"搜索列表页面"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideTitleView];
    [self hideHUD];//隐藏指示器
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isRefresh = NO;//刷新
    _page = 1;
    self.isCancel = YES;
    self.title = NSLocalizedString(@"搜索", nil);
    WS(weakSelf);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, ScreenHeight - 64));
    }];
    
    //筛选列表
    [self addHeader];
    [self addFooter];
    _selectedArray = [NSMutableArray array];
    
    //刷新列表
    [self xw_addNotificationForName:@"RefreshSelectList" block:^(NSNotification *notification) {
        weakSelf.isRefresh = YES;
        [weakSelf getSelectListRequest:@"1"];
    }];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 导航栏右侧按钮
- (void)initRrightBarItem{
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64/2, 64/2)];
    [self.rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setImage: LOADIMAGE(@"select_navigation@2x", @"png") forState:UIControlStateNormal];
    [self.rightButton setImage: LOADIMAGE(@"select_navigation@2x", @"png") forState:UIControlStateHighlighted];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    negativeSpacer.width = -5;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightItem, nil];
}

#pragma mark - Event Responses

- (void)clickRightButton:(UIButton *)button
{
    [MobClick event:@"selectEnterCondition"];
    SelectConditionViewController *set = [[SelectConditionViewController alloc] init];
    CustomNavigationController *navigation = [[CustomNavigationController alloc] initWithRootViewController:set];
    [self presentViewController:navigation animated:YES completion:^{
        
    }];
}
#pragma mark - Network Data
#pragma mark - 搜索列表
- (void)getSelectListRequest:(NSString *)page {
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    FateListApi *api = [[FateListApi alloc] initWithPage:page];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf hideHUD];
        [weakSelf getSelectListRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"帅选列表请求失败:%@",request.responseString);
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf hideHUD];
        [weakSelf showNetRefresh:^{
            [weakSelf hideNetRefresh];
            [weakSelf getSelectListRequest:page];
        }];
        
    }];
}

- (void)getSelectListRequestFinish:(NSDictionary *)result{
    LogOrange(@"筛选列表请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        
        if (_isRefresh) {
            _isRefresh = NO;
            _page =1;
            [_selectDataArray removeAllObjects];
            [_tableView reloadData];
        }
        NSMutableArray *selectArray = [NSMutableArray arrayWithArray:[result objectForKey:@"data"]];
        //是否有数据
        if ((NSNull *)selectArray != [NSNull null] && selectArray.count > 0)  {
            if (!_selectDataArray) {
                _selectDataArray = [NSMutableArray array];
            }
            for (NSDictionary *dic in selectArray) {
                FateModel *model = [[FateModel alloc] initWithDataDic:dic];
                [_selectDataArray addObject:model];
            }
            
            _tableView.selectDataArray = _selectDataArray;
            [_tableView reloadData];
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
        [weakSelf getSelectListRequest:@"1"];//用户信息
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
        [weakSelf getSelectListRequest:@"1"];
    }];
}

#pragma mark 上拉加载数据
- (void)addFooter
{
    WS(weakSelf);
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getSelectListRequest:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
    
}


#pragma mark - Getters And Setters
- (SelectTableView *)tableView {
    if (!_tableView) {
        _tableView = [[SelectTableView alloc] init];
    }
    return _tableView;
}

@end
