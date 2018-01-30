//
//  SecondViewController.h
//  Test
//
//  Created by feiwu on 16/7/7.
//  Copyright © 2016年 mazhiyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "SelectTableView.h"
#import "MJRefresh.h"
@interface SelectViewController : CustomViewController
@property(nonatomic,strong)SelectTableView *tableView;
@property(nonatomic,strong)NSMutableArray *selectDataArray;
@property(nonatomic,strong)NSMutableArray *selectedArray;//已打招呼
@property(nonatomic,assign)BOOL isRefresh;
@property(nonatomic,assign)NSInteger page;
@end
