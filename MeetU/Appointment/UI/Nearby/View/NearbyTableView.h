//
//  NearbyTableView.h
//  Appointment
//
//  Created by feiwu on 16/7/11.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
@class NearbyViewController;
@interface NearbyTableView : UITableView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *nearbyDataArray;
- (void)getNearbyListRequest;
@end
