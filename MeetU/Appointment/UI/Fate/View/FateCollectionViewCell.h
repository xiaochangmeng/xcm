//
//  FateCell.h
//  Appointment
//
//  Created by feiwu on 16/7/13.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FateModel.h"
@class FateViewController;
@interface FateCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *userImageView;
@property(nonatomic,strong)UIButton *likeButton;
@property(nonatomic,strong)FateModel *model;
@property (strong, nonatomic) UILabel* nameLabel;
@property (strong, nonatomic) UIImageView* maskImageView;
@property (strong, nonatomic) UIImageView* hotImageView;
@property (strong, nonatomic) UIImageView* vipImageView;

@end
