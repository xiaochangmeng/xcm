//
//  CircleTableView.h
//  Appointment
//
//  Created by feiwu on 2017/2/5.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@class NearbyViewController;

@interface CircleTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *circleDataArray;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, assign) int page;

- (void)getCircleListRequest:(NSString *)page;

@end
