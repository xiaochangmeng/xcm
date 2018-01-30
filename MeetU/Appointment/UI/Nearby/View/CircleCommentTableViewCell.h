//
//  CircleCommentTableViewCell.h
//  Appointment
//
//  Created by apple on 17/2/9.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleCommnetModel.h"
@interface CircleCommentTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *userImageView;
@property(nonatomic,strong)UIImageView *userMaskView;
@property(nonatomic,strong)UILabel *nickLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIImageView *vipImageView;
@property(nonatomic,strong)UIView *lineView;

@property(nonatomic,strong)CircleCommnetModel *model;

@end
