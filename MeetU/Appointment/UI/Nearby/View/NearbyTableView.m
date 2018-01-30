//
//  NearbyTableView.m
//  Appointment
//
//  Created by feiwu on 16/7/11.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "NearbyTableView.h"
#import "SelectTableViewCell.h"
#import "NearbyViewController.h"
#import "FateDetailViewController.h"
#import "NearbyListApi.h"
#import "FateViewController.h"
#import "LoginViewController.h"
@implementation NearbyTableView

#pragma mark - Life Cycle
//生命周期方法
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - Private Methods
//私有方法
- (void) initView
{
    self.separatorStyle = UITableViewCellSelectionStyleNone;//隐藏cell分割线
    self.backgroundColor = [UIColor clearColor];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
    self.dataSource =self;
    [self addHeader];
    [self addFooter];
}

#pragma mark - Public Methods
//公有方法

#pragma mark - Event Responses
//事件响应方法

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nearbyDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify_SelectCell = @"SelectTableViewCell";
    SelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify_SelectCell];
    if (cell == nil) {
        cell = [[SelectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify_SelectCell];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_nearbyDataArray.count > 0) {
        SelectTableViewCell *selectCell = (SelectTableViewCell *)cell;
        selectCell.model = _nearbyDataArray[indexPath.row];
    }


}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      [MobClick event:@"nearbyEnterUserDetail"];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    FateModel *model = _nearbyDataArray[indexPath.row];
    __weak NearbyViewController *near = (NearbyViewController *)self.viewController;
    WS(weakSelf);
    FateDetailViewController *detail = [[FateDetailViewController alloc] init];
    detail.fateModel = model;
    detail.selectedArray = near.selectedArray;
    detail.selectedBlock = ^(NSMutableArray *selected){
        NSMutableArray *temp = [NSMutableArray array];
        near.selectedArray = selected;//已经选中数组
        for (FateModel *model in near.nearbyDataArray) {
            if ([near.selectedArray containsObject:model.user_id]) {
                model.helloed = @"2";
            }
            [temp addObject:model];
        }
        near.nearbyDataArray = temp;//列表数据重新赋予
        [weakSelf reloadData];

    };

    [near.navigationController pushViewController:detail animated:YES];
    
}

#pragma mark - 搜索列表
- (void)getNearbyListRequest {
    WS(weakSelf);
    __weak FateViewController *near = (FateViewController *)self.viewController;
    [near hideHUD];
    [near showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    NearbyListApi *api = [[NearbyListApi alloc] initWithPage:@"1"];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf.mj_header endRefreshing];
        [weakSelf.mj_footer endRefreshing];
        [near hideHUD];
        [weakSelf getNearbyListRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"附近列表请求失败:%@",request.responseString);
        [weakSelf.mj_header endRefreshing];
        [weakSelf.mj_footer endRefreshing];
        [near hideHUD];
        [near showNetRefresh:^{
            [near hideNetRefresh];
            [weakSelf getNearbyListRequest];
        }];
        
    }];
}

- (void)getNearbyListRequestFinish:(NSDictionary *)result{
    LogOrange(@"附近列表请求成功:%@",result);
    __weak FateViewController *near = (FateViewController *)self.viewController;
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
            
            for (int i = 0; i < nearbyArray.count; i++) {
                NSDictionary *dic = [nearbyArray objectAtIndex:i];
                FateModel *model = [[FateModel alloc] initWithDataDic:dic];
                [_nearbyDataArray addObject:model];
            }
            
            
            [self reloadData];
            
            
        }
        
    }else if([code intValue] == kNetWorkNoLoginCode){
        //没有登录
        [near showHUDFail:desc];
        [near hideHUDDelay:1];
        [self performSelector:@selector(login) withObject:nil afterDelay:1];
        
    }else if([code intValue] == kNetWorkNoDataCode){
        //没有数据
        [near showHUDFail:@"没有更多数据请稍后重试"];
        [near hideHUDDelay:1];
    } else {
        [near showHUDFail:desc];
        [near hideHUDDelay:1];
    }
}

- (void)login{
    WS(weakSelf);
    __weak FateViewController *near = (FateViewController *)self.viewController;
    LoginViewController *login = [[LoginViewController alloc] init];
    login.isNoLogin = YES;
    login.loginBlock = ^(){
        [weakSelf getNearbyListRequest];
    };
    [near presentViewController:login animated:NO completion:^{
        
    }];
}


#pragma mark 下拉刷新数据
- (void)addHeader
{
    WS(weakSelf);
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getNearbyListRequest];
    }];
}

#pragma mark 上拉加载数据
- (void)addFooter
{
    WS(weakSelf);
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getNearbyListRequest];
    }];
}
#pragma mark - Getters And Setters
@end
