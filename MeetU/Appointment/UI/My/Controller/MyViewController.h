//
//  MyViewController.h
//  Appointment
//
//  Created by feiwu on 16/7/8.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "MyHeadView.h"
#import "UserInfoModel.h"
@interface MyViewController : CustomViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)MyHeadView *headView;
@property(nonatomic,strong)UserInfoModel *infoModel;
@end
