//
//  MySetViewController.h
//  Appointment
//
//  Created by feiwu on 16/7/14.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
@interface MySetViewController : CustomViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@end
