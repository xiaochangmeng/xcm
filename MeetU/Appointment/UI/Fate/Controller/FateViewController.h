//
//  FirstViewController.h
//  Test
//
//  Created by feiwu on 16/7/7.
//  Copyright © 2016年 mazhiyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "FateCollectionView.h"
#import "MJRefresh.h"
#import "NearbyTableView.h"
@interface FateViewController : CustomViewController
@property(nonatomic,strong)FateCollectionView *collection;
@property(nonatomic,strong)NSMutableArray *fateDataArray;
@property(nonatomic,strong)NSMutableArray *selectedArray;//已打招呼
@property(nonatomic,assign)BOOL isRefresh;
@property(nonatomic,assign)NSInteger page;


@property(nonatomic,strong)UIScrollView *fateScrollView;
@property(nonatomic,strong)UIButton *helloButton;//群打招呼
@property(nonatomic,strong)NearbyTableView *nearbyTableView;//附近

@end
