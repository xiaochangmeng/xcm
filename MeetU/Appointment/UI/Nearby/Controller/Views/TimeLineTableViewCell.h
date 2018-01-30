//
//  TimeLineTableViewCell.h
//  TimeLine
//
//  Created by oujinlong on 16/6/12.
//  Copyright © 2016年 oujinlong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeModel.h"
#import "UIView+SDAutoLayout.h"
@interface TimeLineTableViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView*)tableView;
@property (nonatomic, strong) TimeModel* model;

@property (nonatomic, copy) void(^showallClickBlock)(NSIndexPath* indexPath);

@end
