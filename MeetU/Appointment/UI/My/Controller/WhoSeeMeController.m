//
//  WhoSeeMeController.m
//  Appointment
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "WhoSeeMeController.h"
#import "WhoSeeMeCollectionView.h"
#import "WhoSeeMeCollectionViewFlowlayout.h"
#import "MyVisitorApi.h"
#import "UICollectionView+Handle.h"
@interface WhoSeeMeController ()

@property (strong, nonatomic) WhoSeeMeCollectionView* collectionView;

@end

@implementation WhoSeeMeController


- (void)refreshData{
    WS(weakSelf);
    MyVisitorApi *api = [[MyVisitorApi alloc] initWithP:@"1" Flag_vip:@"0"];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf getVisitorListRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"最近访客列表请求失败:%@",request.responseString);
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
}

- (void)getVisitorListRequestFinish:(NSDictionary*)dictionary{
   LogOrange(@"最近访客列表请求成功:%@",dictionary);
    if ([[dictionary objectForKey:@"code"] isEqualToString:@"412"]) {
        [self.collectionView collectionViewDisplayWitMsg:@"暫無訪客,快去緣分頁找找" imageName:@"empty_focus@2x" imageType:@"png" ifNecessaryForRowCount:0];
    }else{
        NSArray* dataArray = [dictionary objectForKey:@"data"];
        if (kArrayIsEmpty(dataArray)) {
            [self.collectionView collectionViewDisplayWitMsg:@"暫無訪客,快去緣分頁找找" imageName:@"empty_focus@2x" imageType:@"png" ifNecessaryForRowCount:0];
        } else {
            NSMutableArray* temp = [[NSMutableArray alloc]init];
            for (NSDictionary* item in dataArray) {
                NSString* imgPath = [NSString stringWithFormat:@"%@",[item objectForKey:@"avatar"]];
                    [temp addObject:imgPath];
            }
            _collectionView.dataArray = temp;
        }
        
    }
    
    [_collectionView reloadData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"未开通VIP访客页面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"未开通VIP访客页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupView];
}


- (void)setupView{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = NSLocalizedString(@"谁看过我", nil);
    self.isBack = YES;
    [self.view addSubview:self.collectionView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (WhoSeeMeCollectionView *)collectionView{
    if (_collectionView == nil) {
        WhoSeeMeCollectionViewFlowlayout* flowLayout = [WhoSeeMeCollectionViewFlowlayout new];        flowLayout.sectionInset = UIEdgeInsetsMake(24, 32.5, 0, 32.5);
        _collectionView = [[WhoSeeMeCollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:flowLayout];
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        [_collectionView.mj_header beginRefreshing];
    }
    return _collectionView;
}

- (void)dealloc{
    NSLog(@"dealloc");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
