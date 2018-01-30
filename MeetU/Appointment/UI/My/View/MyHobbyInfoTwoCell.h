//
//  MyHobbyInfoTwoCell.h
//  Appointment
//
//  Created by feiwu on 16/8/23.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"
@class MyInfoViewController;
@interface MyHobbyInfoTwoCell : UITableViewCell
@property(nonatomic,strong)UILabel *typeLabel;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)NSMutableArray *buttonArray;
@property(nonatomic,strong)UserInfoModel *infoModel;
@end
