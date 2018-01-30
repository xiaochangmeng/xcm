//
//  LetterCell.h
//  Appointment
//
//  Created by feiwu on 16/7/14.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FateModel.h"
#import "MZYImageView.h"
@class LetterViewController;
@interface LetterTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *userImageView;
@property(nonatomic,strong)MZYImageView *userMaskView;
@property(nonatomic,strong)UILabel *nickLabel;
@property(nonatomic,strong)UILabel *messageLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIImageView *viewImageView;
@property(nonatomic,strong)UIButton *visitorNumber;
@property(nonatomic,strong)UIImageView *likeImageView;
@property(nonatomic,strong)UILabel *likeLabel;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UIImageView *vipImageView;
@property(nonatomic,strong)UIImageView *statusView;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)FateModel *model;
@end
