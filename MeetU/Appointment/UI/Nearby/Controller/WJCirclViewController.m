//
//  NearbyViewController.m
//  Appointment
//
//  Created by feiwu on 16/7/8.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "WJCirclViewController.h"
#import "TabBarView.h"
#import "LXFileManager.h"
#import "QuestionOfBottomView.h"
#import "NSObject+XWAdd.h"
#import "MyFeedBackViewController.h"
#import "CustomNavigationController.h"




@interface WJCirclViewController ()

@end

@implementation WJCirclViewController

#pragma mark - 生命周期方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    NSString *status = [LXFileManager readUserDataForKey:kAppIsCheckStatus];
    if ([status intValue] != 0) {
        [[[UIApplication sharedApplication].windows lastObject] addSubview:[QuestionOfBottomView sharedManager]];
    }
    [MobClick beginLogPageView:@"圈子页面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 移除底部弹窗视图
    // MARK: - 修改
    NSString *status = [LXFileManager readUserDataForKey:kAppIsCheckStatus];
    if ([status intValue] != 0) {
        [[QuestionOfBottomView sharedManager] removeFromSuperview];
    }
    [MobClick endLogPageView:@"圈子页面"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self hideTitleView];
    [self hideHUD];  // 隐藏指示器
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WS(weakSelf);
    self.title = @"圈子";
    [self initTabBarView];
    [self.view addSubview:self.circleTableView];
    [self.view addSubview:self.backTopButton];
    [self.backTopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).offset(-70);
        make.right.equalTo(weakSelf.view).offset(-20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    // MARK: - 缓存: 查看沙盒中是否缓存圈子数据
    // 加载圈子模块数据
    [_circleTableView getCircleListRequest:@"0"];
    
    
    
    
}

#pragma mark - 移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化tabbar
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

#pragma mark - 初始化导航栏左侧按钮
- (void)initLeftBarItem{
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64/2, 64/2)];
    [self.leftButton addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton setImage: LOADIMAGE(@"fate_navigation_vip@2x", @"png") forState:UIControlStateNormal];
    [self.leftButton setImage: LOADIMAGE(@"fate_navigation_vip@2x", @"png") forState:UIControlStateHighlighted];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    negativeSpacer.width = -5;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, leftItem, nil];
}

#pragma mark - 导航栏左侧按钮监听方法
- (void)clickLeftButton:(UIButton *)button
{
    [MobClick event:@"nearby_navigation_vip"];
    MyFeedBackViewController *feed = [[MyFeedBackViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/WebApi/Buy/apple_vip_v3.html",BaseUrl]];
    CustomNavigationController *navigation = [[CustomNavigationController alloc] initWithRootViewController:feed];
    feed.titleStr = @"VIP会员";
    feed.pushType = @"circle-vip";
    [self presentViewController:navigation animated:YES completion:^{
        
    }];
}

#pragma mark - 回到顶部按钮响应方法
- (void)clickBackTopButton:(UIButton *)button
{
    [MobClick event:@"nearby_backtop"];
    [_circleTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self hideHUD];
    [self showHUD:@"正在加载" isDim:NO mode:MBProgressHUDModeIndeterminate];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideHUD];
}



/**
 圈子模块tableView
 */
- (CircleTableView *)circleTableView {
    if (!_circleTableView) {
        // MARK: - 修改
        NSInteger height = 0;
        NSString *status = [LXFileManager readUserDataForKey:kAppIsCheckStatus];
        if ([status intValue] != 0) {
            height = 30;
        }
        _circleTableView = [[CircleTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64-49  - height)];
    }
    return _circleTableView;
}


/**
 返回顶部按钮
 */
- (UIButton *)backTopButton {
    if (!_backTopButton) {
        _backTopButton = [[UIButton alloc] init];
        [_backTopButton setImage:LOADIMAGE(@"circle_backTop@2x", @"png") forState:UIControlStateNormal];
        [_backTopButton addTarget:self action:@selector(clickBackTopButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backTopButton;
}

@end

