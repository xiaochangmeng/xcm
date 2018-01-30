//
//  NearbyViewController.h
//  Appointment
//
//  Created by feiwu on 16/7/8.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "NearbyTableView.h"
#import "MJRefresh.h"
@interface NearbyViewController : CustomViewController
@property(nonatomic,strong)NearbyTableView *nearbyTableView;
@property(nonatomic,strong)UIButton *helloButton;//群打招呼
@property(nonatomic,strong)NSMutableArray *nearbyDataArray;
@property(nonatomic,strong)NSMutableArray *selectedArray;//已打招呼

@end
