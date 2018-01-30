//
//  RecommentItem.h
//  Appointment
//
//  Created by feiwu on 16/7/25.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "CXSlidingViewItem.h"

@interface RecommentItem : CXSlidingViewItem
@property (nonatomic,strong) UIImageView * imageView;//图片
@property (nonatomic,strong) UIView * infoView;
@property (nonatomic,strong) UILabel * nickLabel;//昵称
@property (nonatomic,strong) UILabel * ageLabel;//年龄
@end
