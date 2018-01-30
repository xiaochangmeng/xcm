//
//  MyDetailInfoTableView.h
//  Appointment
//
//  Created by feiwu on 16/8/23.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"
@class MyInfoViewController;
@interface MyDetailInfoTableView : UITableView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *baseArray;
@property(nonatomic,strong)UserInfoModel *infoModel;
@end
