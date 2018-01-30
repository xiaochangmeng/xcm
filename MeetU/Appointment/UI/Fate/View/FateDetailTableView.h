//
//  FateTableView.h
//  Appointment
//
//  Created by feiwu on 16/7/16.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FateUserModel.h"
#import "FateDetailVipMaskView.h"
@class FateDetailViewController;
@interface FateDetailTableView : UITableView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)FateUserModel *fateUserModel;
@property(nonatomic, assign)BOOL isOpen;//是否点击基本信息更多
@property(nonatomic,strong)FateDetailVipMaskView *vipMaskView;//vip视图
@end
