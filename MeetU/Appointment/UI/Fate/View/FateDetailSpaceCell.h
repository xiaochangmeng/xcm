//
//  FateDetailSpaceCell.h
//  Appointment
//
//  Created by feiwu on 16/9/18.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FateUserModel.h"
@interface FateDetailSpaceCell : UITableViewCell
@property(nonatomic,strong)UILabel  *typeLabel;//类别
@property(nonatomic,strong)UILabel  *detailLabel;//详情
@property(nonatomic,strong)UIView *lineView;//最底部竖线

@property(nonatomic, strong)FateUserModel *fateUserModel;
@end
