//
//  NewnearbyVController.h
//  taiwantongcheng
//
//  Created by wanchangwen on 2017/11/29.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "NewnearbyVController.h"
#import "Masonry.h"
#import "TimeLineTableViewCell.h"
#import "TimeModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "MJRefresh.h"
#import "TimeLineSegmentView.h"
#import "MyFeedBackViewController.h"
#import "SelectViewController.h"
#import "CustomNavigationController.h"


#import "LunboWebController.h"
#define color(r,g,b)     [UIColor colorWithRed:(r/255.0) green:g/255.0 blue:b/255.0 alpha:1]

@interface NewnearbyVController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UITableView* rightTableView;
//@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, weak) TimeLineSegmentView* segmentView;


@property(nonatomic,strong)NSMutableArray * dateArray;
@property(nonatomic,assign)NSInteger currentindex;
@end

@implementation NewnearbyVController
#pragma mark - 创建导航栏
-(void)createNator{
    //    登陆label
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"圈子";
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

-(void)RightbuttonClick{
    [MobClick event:@"fate_navigation_select"];
    SelectViewController *select = [[SelectViewController alloc] init];
    CustomNavigationController *navigation = [[CustomNavigationController alloc] initWithRootViewController:select];
    
    [self presentViewController:navigation animated:YES completion:^{
        
    }];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        [self createNator];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    self.automaticallyAdjustsScrollViewInsets =YES;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.tabBarController.hidesBottomBarWhenPushed =NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quanzimakesureBtnClick) name:@"quanzimakesureBtnClick" object:nil];
    self.dateArray = [NSMutableArray array];
    self.currentindex = 0;
    
    
    UITableView* rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    self.rightTableView = rightTableView;
    rightTableView.dataSource = self;
    rightTableView.delegate = self;
    rightTableView.backgroundColor = [UIColor whiteColor];
    rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:rightTableView];
    
    
    __weak NewnearbyVController *weakSelf = self;
    [self.rightTableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //获取第一页数据
        weakSelf.currentindex = 0;
        [weakSelf loaddeta];
    }];
    
    [self.rightTableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        weakSelf.currentindex ++;
        [weakSelf loaddeta];
    }];
    
    double delayInSeconds = 0.0;
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, mainQueue, ^{

        [self loaddeta];
    });
    
    
}


-(void)quanzimakesureBtnClick{
    
    LunboWebController *LunboWebC = [[LunboWebController alloc] init];
     LunboWebC.webstr = [NSString stringWithFormat:@"%@/ios/buy/vip_v2.html?token=%@&language=zh",BaseUrl,[FWUserInformation sharedInstance].token];
    [self.navigationController pushViewController:LunboWebC animated:YES];
    
}


-(void)loaddeta{
    
    
     HSKStorage *storage = [[HSKStorage alloc]initWithPath:AccountPath];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",nil];
    NSString * url = [NSString stringWithFormat:@"%@/iOS/circle/getList",BaseUrl];
    
    
    NSString * page = [NSString stringWithFormat:@"%ld",self.currentindex];
    //3.请求
    NSDictionary *dic;
    if ([page isEqualToString:@"0"]) {
        dic= @{@"num":@"3",@"page":page};
    }else{
        dic= @{@"num":@"10",@"page":page};
    }
    
    
   
    [manager POST:url parameters:dic success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = responseObject[@"code"];
      
        if ([code isEqualToString:@"200"]) {
            
            [self.rightTableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
            [self.rightTableView footerEndRefreshing];
            NSMutableArray * datearray = [NSMutableArray array];
            datearray = responseObject[@"data"];
            
            if ([page isEqualToString:@"0"]) {
                if (self.dateArray.count != 0) {
                    [self.dateArray removeAllObjects];
                }
                for (int i = 0;i< datearray.count ; i++) {
                    TimeModel * model = [[TimeModel alloc] init];
                    [model mj_setKeyValues:datearray[i]];
                    NSMutableArray *imgagearray =  datearray[i][@"albums"];
                    model.imageArray = [NSMutableArray array];
                    if (imgagearray.count != 0) {
                        for (int j = 0; j < imgagearray.count; j++) {
                             ContentImageModel *imagemodel = [[ContentImageModel alloc] init];
                            imagemodel.imageUrl = imgagearray[j];
                            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagemodel.imageUrl]];
                            UIImage *image = [UIImage imageWithData:data];
                            imagemodel.height = image.size.height;
                            imagemodel.width  = image.size.width;
                            if (imagemodel.height == 0) {
                                imagemodel.height = 434;
                            }
                            
                            if (imagemodel.width == 0) {
                                imagemodel.width = 430;
                            }
                            [model.imageArray addObject:imagemodel];
                        }
                    }
                   
                    
                    [self.dateArray addObject:model];
                }

            }else{
                for (int i = 0;i< datearray.count ; i++) {
                    TimeModel * model = [[TimeModel alloc] init];
                    [model mj_setKeyValues:datearray[i]];
                    NSMutableArray *imgagearray =  datearray[i][@"albums"];
                    model.imageArray = [NSMutableArray array];
                    if (imgagearray.count != 0) {
                        for (int j = 0; j < imgagearray.count; j++) {
                            ContentImageModel *imagemodel = [[ContentImageModel alloc] init];
                            imagemodel.imageUrl = imgagearray[j];
                            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagemodel.imageUrl]];
                            UIImage *image = [UIImage imageWithData:data];
                            imagemodel.height = image.size.height;
                            imagemodel.width  = image.size.width;
                            if (imagemodel.height == 0) {
                                imagemodel.height = 434;
                            }
                            
                            if (imagemodel.width == 0) {
                                imagemodel.width = 430;
                            }
                            [model.imageArray addObject:imagemodel];
                        }
                    }
                    
                    
                    [self.dateArray addObject:model];
                }
                
                if (datearray.count != 0) {
                    [storage hsk_setObject:datearray forKey:@"neardatearray"];
                }
            }
            
        }else{
            [self.rightTableView headerEndRefreshingWithResult:JHRefreshResultNone];
            [self.rightTableView footerEndRefreshing];
            
        }
        [self.rightTableView reloadData];
    }failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self.rightTableView headerEndRefreshingWithResult:JHRefreshResultNone];
        [self.rightTableView footerEndRefreshing];
        
        NSMutableArray * fatearray = (NSMutableArray *)[storage hsk_objectForKey:@"neardatearray"];
        if (fatearray.count != 0) {
            
            if (self.dateArray.count != 0) {
                [self.dateArray removeAllObjects];
            }
            for (int i = 0;i< fatearray.count ; i++) {
                TimeModel * model = [[TimeModel alloc] init];
                [model mj_setKeyValues:fatearray[i]];
                NSMutableArray *imgagearray =  fatearray[i][@"albums"];
                model.imageArray = [NSMutableArray array];
                if (imgagearray.count != 0) {
                    for (int j = 0; j < imgagearray.count; j++) {
                        ContentImageModel *imagemodel = [[ContentImageModel alloc] init];
                        imagemodel.imageUrl = imgagearray[j];
                        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagemodel.imageUrl]];
                        UIImage *image = [UIImage imageWithData:data];
                        imagemodel.height = image.size.height;
                        imagemodel.width  = image.size.width;
                        if (imagemodel.height == 0) {
                            imagemodel.height = 434;
                        }
                        
                        if (imagemodel.width == 0) {
                            imagemodel.width = 430;
                        }
                        
                        [model.imageArray addObject:imagemodel];
                    }
                }
                
                
                [self.dateArray addObject:model];
            }
            [self.rightTableView reloadData];
        }
    
    }];
    
    
}


#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dateArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimeLineTableViewCell* cell = [TimeLineTableViewCell cellWithTableView:tableView];
    
    if (self.dateArray.count != 0) {
        cell.model = self.dateArray[indexPath.section];
    }
    

    cell.sd_indexPath = indexPath;
 
    [cell setShowallClickBlock:^(NSIndexPath* indexPath){
        
        [tableView reloadData];
        
//        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.row];
//        [_rightTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
//        [_rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]
//                                    animated:YES
//                              scrollPosition:UITableViewScrollPositionNone];
    }];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [tableView cellHeightForIndexPath:indexPath model:self.dateArray[indexPath.section] keyPath:@"model" cellClass:[TimeLineTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    
    
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.1;
//}


//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 100;
//}


@end

