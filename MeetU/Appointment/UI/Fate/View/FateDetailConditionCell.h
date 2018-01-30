//
//  FateDetailConditionCell.h
//  Appointment
//
//  Created by feiwu on 16/9/19.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FateUserModel.h"
@class FateDetailTableView;
@interface FateDetailConditionCell : UITableViewCell
@property(nonatomic,strong)FateUserModel *fateUserModel;
@property(nonatomic,strong)NSIndexPath *indexpath;//下标
@property(nonatomic,strong)NSMutableArray *baseInfoArray;//基本信息数组
@property(nonatomic,strong)NSMutableArray *conditionArray;//征友条件数组
@end
