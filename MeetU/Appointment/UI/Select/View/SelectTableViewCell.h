//
//  SelectTableViewCell.h
//  Appointment
//
//  Created by feiwu on 16/7/8.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FateModel.h"
@class SelectViewController;
@class NearbyViewController;
@class MyAddentionViewController;
@class MyVisitorViewController;
@interface SelectTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *userImageView;
@property(nonatomic,strong)UIImageView *userMaskView;
@property(nonatomic,strong)UILabel *nickLabel;
@property(nonatomic,strong)UILabel *ageAndLocationLabel;
@property(nonatomic,strong)UILabel *heightLabel;
@property(nonatomic,strong)UIButton *greetButton;
@property(nonatomic,strong)UIButton *tagButton;
@property(nonatomic,strong)UIButton *characterButton;
@property(nonatomic,strong)UIImageView *vipImageView;
@property(nonatomic,strong)UIImageView *phogoImageView;
@property(nonatomic,strong)UILabel *photoLabel;
@property(nonatomic,strong)UIView *lineView;

@property(nonatomic,strong)FateModel *model;
//附近页面独有
@property(nonatomic,strong)UIImageView *locationImageView;
@property(nonatomic,strong)UILabel *locationLabel;
@end
