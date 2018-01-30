//
//  CollectionViewController.m
//  TYPagerControllerDemo
//
//  Created by tany on 16/5/17.
//  Copyright © 2016年 tanyang. All rights reserved.
//

#import "CollectionViewController.h"
#import "NewfateModel.h"
#import "newfateCell.h"
#import "FateDetailViewController.h"
#import "FateModel.h"
@interface CollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)NSMutableArray * dateArray;
@property(nonatomic,assign)NSInteger currentindex;
@end

static NSString *const cellId = @"collectCellId";

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dateArray = [NSMutableArray array];
    self.currentindex = 0;
    [self addCollectionView];
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
//    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _collectionView.frame = CGRectMake(10, 0, self.view.size.width-20, self.view.size.height);
}

- (void)addCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((CGRectGetWidth(self.view.frame)-40)/3, (CGRectGetWidth(self.view.frame)-40)/3);
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    _collectionView = collectionView;
      [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([newfateCell class]) bundle:nil] forCellWithReuseIdentifier:@"newfatecell"];
    
    
    
    __weak __typeof(self) weakSelf = self;
    // 下拉刷新
    self.collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.currentindex = 0;
            [weakSelf yuanfenloadDate];
        });
        
        
    }];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.currentindex ++;
            [weakSelf yuanfenloadDate];
        });
        
    }];
      [self yuanfenloadDate];
}




-(void)yuanfenloadDate{
      HSKStorage *storage = [[HSKStorage alloc]initWithPath:AccountPath];
  
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",nil];
    NSString * url = [NSString stringWithFormat:@"%@/iOS/Fate/getList",BaseUrl];
    

    NSString * page = [NSString stringWithFormat:@"%ld",self.currentindex];
    //3.请求
    NSDictionary * dic = @{@"num":@"20",@"page":page};
    [manager POST:url parameters:dic success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * code = responseObject[@"code"];
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView.mj_footer endRefreshing];
        if ([code isEqualToString:@"200"]) {
            NSMutableArray * datearray = [NSMutableArray array];
            datearray = responseObject[@"data"];
            
            if ([page isEqualToString:@"0"]) {
                if (self.dateArray.count != 0) {
                    [self.dateArray removeAllObjects];
                }
                for (int i = 0;i< datearray.count ; i++) {
                    NewfateModel * model = [[NewfateModel alloc] init];
                    [model mj_setKeyValues:datearray[i]];
                    [self.dateArray addObject:model];
                }
                
            }else{
                for (int i = 0;i< datearray.count ; i++) {
                    NewfateModel * model = [[NewfateModel alloc] init];
                    [model mj_setKeyValues:datearray[i]];
                    [self.dateArray addObject:model];
                }
                
                
            }
            if (datearray.count != 0) {
                [storage hsk_setObject:datearray forKey:@"fatearray"];
            }
        }
        
       
        
                [self.collectionView reloadData];
    }failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView.mj_footer endRefreshing];
        NSMutableArray * fatearray = (NSMutableArray *)[storage hsk_objectForKey:@"fatearray"];
        if (fatearray.count != 0) {
            if (self.dateArray.count != 0) {
                [self.dateArray removeAllObjects];
            }
            for (int i = 0;i< fatearray.count ; i++) {
                NewfateModel * model = [[NewfateModel alloc] init];
                [model mj_setKeyValues:fatearray[i]];
                [self.dateArray addObject:model];
            }
            [self.collectionView reloadData];
        }
        
    }];
    
    
    
}
#pragma mark - UIViewControllerDisplayViewDelegate

- (UIScrollView *)displayView
{
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dateArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    newfateCell *cell = (newfateCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"newfatecell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"newfatecell" owner:self options:nil]firstObject];
    }
    
    if (self.dateArray.count != 0) {
        NewfateModel * model = self.dateArray[indexPath.row];
        cell.model = model;
    }
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [MobClick event:@"fateEnterUserDetail"];
    if (self.dateArray.count != 0) {
        FateDetailViewController *detail = [[FateDetailViewController alloc] init];
        NewfateModel * model = self.dateArray[indexPath.row];
        detail.fateModel = (FateModel *)model;
        [self.navigationController pushViewController:detail animated:YES];
    }
 
 
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
