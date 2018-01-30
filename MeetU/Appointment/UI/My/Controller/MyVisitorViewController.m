//
//  MyVisitorViewController.m
//  Appointment
//
//  Created by feiwu on 16/8/24.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MyVisitorViewController.h"
#import "MyVisitorApi.h"
#import "FateModel.h"
#import "SelectTableViewCell.h"
#import "FateDetailViewController.h"
#import "LoginViewController.h"

@implementation MyVisitorViewController
#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if (_visitorDataArray.count <= 0) {
        [self getVisiotorListRequest:@"1"];
    }
    [MobClick beginLogPageView:@"最近访客页面"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"最近访客页面"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideHUD];//隐藏指示器
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.isBack = YES;
    self.title = NSLocalizedString(@"我的访客", nil);
    _isRefresh = YES;
    _page = 1;
    
    _selectedArray = [NSMutableArray array];
    
    [self.view addSubview:self.tableView];
    
    [self addHeader];
    [self addFooter];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _visitorDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"MyTableViewCell";
    SelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[SelectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_visitorDataArray.count > 0) {
        SelectTableViewCell *selectCell = (SelectTableViewCell *)cell;
        selectCell.model = _visitorDataArray[indexPath.row];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MobClick event:@"visitorEnterUserDetail"];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    WS(weakSelf);
    FateModel *model = _visitorDataArray[indexPath.row];
    FateDetailViewController *detail = [[FateDetailViewController alloc] init];
    detail.fateModel = model;
    detail.selectedArray = self.selectedArray;
    detail.selectedBlock = ^(NSMutableArray *selected){
        NSMutableArray *temp = [NSMutableArray array];
        weakSelf.selectedArray = selected;//已经选中数组
        for (FateModel *model in weakSelf.visitorDataArray) {
            if ([weakSelf.selectedArray containsObject:model.user_id]) {
                model.helloed = @"2";
            }
            [temp addObject:model];
        }
        weakSelf.visitorDataArray = temp;//列表数据重新赋予
        [weakSelf.tableView reloadData];
        
    };
    
    //取消关注操作
    detail.cancelAddentionBlock = ^(){
        weakSelf.isRefresh = YES;
        [weakSelf getVisiotorListRequest:@"1"];
    };
    
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark - Network Data
#pragma mark - 最近访客列表
- (void)getVisiotorListRequest:(NSString *)p {
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    MyVisitorApi *api = [[MyVisitorApi alloc] initWithP:p Flag_vip:@"1"];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf hideHUD];
        [weakSelf getVisitorListRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"最近访客列表请求失败:%@",request.responseString);
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf hideHUD];
        [weakSelf showHUDFail:kNetWorkErrorTitle];
        [weakSelf hideHUDDelay:1];
    }];
}

- (void)getVisitorListRequestFinish:(NSDictionary *)result{
    LogOrange(@"最近访客列表请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        
        if (_isRefresh) {
            _isRefresh = NO;
            _page = 1;
            [_visitorDataArray removeAllObjects];
            [_midArray removeAllObjects];
            [_tableView reloadData];
        }
        NSMutableArray *addentionArray = [NSMutableArray arrayWithArray:[result objectForKey:@"data"]];
        //是否有数据
        if ((NSNull *)addentionArray != [NSNull null] && addentionArray.count > 0)  {
            if (!_visitorDataArray) {
                _visitorDataArray = [NSMutableArray array];
            }
            
            if (!_midArray) {
                _midArray = [NSMutableArray array];
            }
            
            for (NSDictionary *dic in addentionArray) {
                FateModel *model = [[FateModel alloc] initWithDataDic:dic];
                if (![_midArray containsObject:model.user_id]) {
                    [_visitorDataArray addObject:model];
                    [_midArray addObject:model.user_id];
                }
                
            }
            [_tableView reloadData];
            
            _page++;
        }
        //没有数据
        [_tableView tableViewDisplayWitMsg:@"暫無訪客,快去緣分頁找找" imageName:@"empty_focus@2x" imageType:@"png" ifNecessaryForRowCount:_visitorDataArray.count];
        
    }else if([code intValue] == kNetWorkNoLoginCode){
        //没有登录
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
        [self performSelector:@selector(login) withObject:nil afterDelay:1];
        
    } else if ([code intValue] == kNetWorkNoDataCode) {
        //没有数据
        [_tableView tableViewDisplayWitMsg:@"暫無訪客,快去緣分頁找找" imageName:@"empty_focus@2x" imageType:@"png" ifNecessaryForRowCount:_visitorDataArray.count];
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
        [weakSelf getVisiotorListRequest:@"1"];
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
        [weakSelf getVisiotorListRequest:@"1"];
    }];
}

#pragma mark 上拉加载数据
- (void)addFooter
{
    WS(weakSelf);
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getVisiotorListRequest:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
    }];
}


#pragma mark - Getters And Setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;//隐藏cell分割线
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

@end
