//
//  CircleTableViewCell.h
//  Appointment
//
//  Created by feiwu on 2017/2/5.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleModel.h"
#import "CircleButton.h"
#import "MWPhotoBrowser.h"
#import "CirclePhotoView.h"

@class NearbyViewController;

@interface CircleTableViewCell : UITableViewCell <MWPhotoBrowserDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UIImageView *userMaskView;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UIImageView *sexImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *pageviewsLabel;
@property (nonatomic, strong) CircleButton *commentView;
@property (nonatomic, strong) CircleButton *likeView;
@property (nonatomic, strong) UIButton *morebutton;
@property (nonatomic, strong) UIView *awardView;
@property (nonatomic, strong) UILabel *awardLabel;
@property (nonatomic, strong) UIImageView *awardImageView;
@property (nonatomic, strong) UIView *middleLineView;
@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, strong) CircleModel *model;
@property (nonatomic, strong) NSIndexPath *indexpath;//下标
@property (nonatomic, strong) NSMutableArray *labelArray;//存储评论label
@property (nonatomic, strong) NSMutableArray *picArray;//存储图片
@property (nonatomic, copy) NSString *index;//查看图片小标

@end
