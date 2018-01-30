//
//  MyVisitorViewController.h
//  Appointment
//
//  Created by feiwu on 16/8/24.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "MJRefresh.h"
#import "UserInfoModel.h"
@interface MyVisitorViewController : CustomViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *visitorDataArray;
@property(nonatomic,assign)BOOL isRefresh;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSMutableArray *selectedArray;//已打招呼
@property(nonatomic,strong)NSMutableArray *midArray;//已经显示用户
@end
