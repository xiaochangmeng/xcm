//
//  NewFateViewController.m
//  taiwantongcheng
//
//  Created by wanchangwen on 2017/11/28.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "NewFateViewController.h"
#import "ListViewController.h"
#import "CollectionViewController.h"
#import "NearbyViewController.h"
#import "LXFileManager.h"
#import "PushRemindView.h"
#import "PushRemindUtils.h"
#import "QuestionOfBottomView.h"
#import "MyFeedBackViewController.h"
#import "CustomNavigationController.h"
#import "SelectViewController.h"
@interface NewFateViewController ()<TYTabPagerControllerDataSource,TYTabPagerControllerDelegate>
@property (nonatomic, strong) NSArray *datas;

@property(nonatomic,strong)CollectionViewController *VC;

@end

@implementation NewFateViewController
#pragma mark - 创建导航栏
-(void)createNator{
    //    登陆label
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"缘分";
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
    
            //    导航栏右边按钮
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
//            [rightButton setTitle:@"分享" forState:UIControlStateNormal];
//            [rightButton setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
//            rightButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [rightButton setImage:[UIImage imageNamed:@"fate_navigation_select"] forState:UIControlStateNormal];
            //    添加点击事件
                [rightButton addTarget:self action:@selector(RightbuttonClick) forControlEvents:UIControlEventTouchUpInside];
            rightButton.frame = CGRectMake(0, 0, 18, 18);
            UIBarButtonItem *rightItemCustom = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
            self.navigationItem.rightBarButtonItem = rightItemCustom;
    
    
}

-(void)buttonClick{
    [MobClick event:@"fate_navigation_writer"];
    MyFeedBackViewController *feed = [[MyFeedBackViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/iOS/Buy/write_v1",BaseUrl]];    CustomNavigationController *navigation = [[CustomNavigationController alloc] initWithRootViewController:feed];
    feed.titleStr = NSLocalizedString(@"写信包月", nil);
    feed.pushType = @"fate-write";
    [self presentViewController:navigation animated:YES completion:^{
        
    }];
    
    
}

-(void)RightbuttonClick{
    [MobClick event:@"fate_navigation_select"];
    SelectViewController *select = [[SelectViewController alloc] init];
    CustomNavigationController *navigation = [[CustomNavigationController alloc] initWithRootViewController:select];
    
    [self presentViewController:navigation animated:YES completion:^{
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self createNator];
   
    self.tabBarHeight = 44;
    self.tabBar.layout.barStyle = TYPagerBarStyleProgressView;
    self.tabBar.layout.cellWidth = CGRectGetWidth(self.view.frame)/3;
    self.tabBar.layout.cellSpacing = 0;
    self.tabBar.layout.cellEdging = 0;
    self.tabBar.layout.adjustContentCellsCenter = YES;
    self.dataSource = self;
    self.delegate = self;
    
    [self loadData];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
      [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    self.automaticallyAdjustsScrollViewInsets =YES;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.tabBarController.hidesBottomBarWhenPushed =NO;
    
    
    
    [[[UIApplication sharedApplication].windows lastObject] addSubview:[QuestionOfBottomView sharedManager]];
    if (![PushRemindUtils isAllowedNotification] && ![LXFileManager getUserChooseOfPush] ) {//用户没有开启推送 且没有点击不在提醒按钮
        [[[UIApplication sharedApplication].windows lastObject] addSubview:[PushRemindView sharedInstance]];
    }
    [MobClick beginLogPageView:@"缘分列表页面"];
    //    [[YTKNetworkAgent sharedInstance] cancelAllRequests];//取消所有网络请求


    //    [[YTKNetworkAgent sharedInstance] cancelAllRequests];//取消所有网络请求
   
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//     self.tabBarController.hidesBottomBarWhenPushed = NO;
    //移除底部弹窗视图
    [MobClick endLogPageView:@"缘分列表页面"];
}




- (void)loadData {
    NSMutableArray *datas = [NSMutableArray array];
//    for (NSInteger i = 0; i < 2; ++i) {
//        [datas addObject:i%1 == 0 ? [NSString stringWithFormat:@"Tab %ld",i]:[NSString stringWithFormat:@"Tab Tab %ld",i]];
//    }
    datas = [NSMutableArray arrayWithObjects:@"缘分",@"附近", nil];
    _datas = [datas copy];
    
    [self reloadData];
    [self scrollToControllerAtIndex:0 animate:YES];
}

#pragma mark - TYTabPagerControllerDataSource

- (NSInteger)numberOfControllersInTabPagerController {
    return _datas.count;
}

- (UIViewController *)tabPagerController:(TYTabPagerController *)tabPagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    if (index%3 == 0) {
     
        self.VC = [[CollectionViewController alloc]init];
        self.VC.text = [@(index) stringValue];
      
        return self.VC;
    }else {
        NearbyViewController *VC = [[NearbyViewController alloc]init];
//        VC.text = [@(index) stringValue];
        return VC;
    }
}









- (NSString *)tabPagerController:(TYTabPagerController *)tabPagerController titleForIndex:(NSInteger)index {
    NSString *title = _datas[index];
    return title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
