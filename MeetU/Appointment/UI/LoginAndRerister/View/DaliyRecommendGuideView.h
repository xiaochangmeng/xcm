//
//  DaliyRecommendGuideView.h
//  Appointment
//
//  Created by feiwu on 16/8/22.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DaliyGuideBlock)();
@interface DaliyRecommendGuideView : UIImageView
@property(nonatomic,strong)UIImageView *likeView;//左手
@property(nonatomic,strong)UIImageView *dislikeView;//右手
@property(nonatomic,strong)UIImageView *leftImageView;//不喜欢
@property(nonatomic,strong)UIImageView *rightImageView;//喜欢
@property(nonatomic,strong)UILabel *leftTipLabel;//左提示
@property(nonatomic,strong)UILabel *rightTipLabel;//右提示
@property(nonatomic,strong)UILabel *cancalLabel;//取消
@property(nonatomic,copy)DaliyGuideBlock daliyGuideBlock;

@end
