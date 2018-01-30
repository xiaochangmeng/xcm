//
//  PrivateLetterDetailLeftTableViewCell.h
//  Appointment
//  私信详情左方Cell(聊天界面对方的Cell)
//  Created by feiwu on 16/7/20.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZYImageView.h"
@class LetterDetailViewController;
@interface LetterDetailLeftTableViewCell : UITableViewCell

@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UIImageView *timeImageView;
@property (nonatomic, strong) MZYImageView *logoImageView;
@property (nonatomic, strong) UIImageView *logoMaskView;
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, assign) float textWidth;
@end
