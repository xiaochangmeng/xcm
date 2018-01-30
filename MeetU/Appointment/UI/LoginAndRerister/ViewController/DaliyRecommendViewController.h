//
//  DaliyRecommendViewController.h
//  Appointment
//
//  Created by feiwu on 16/7/22.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "CXSlidingView.h"
#import "DaliyRecommendGuideView.h"
@interface DaliyRecommendViewController : CustomViewController<CXSlidingViewDelegate,CXSlidingViewDatasouce>
@property(nonatomic,strong)UILabel *titleLabel;//标题
@property(nonatomic,strong)CXSlidingView *pickView;//推荐图片
@property(nonatomic,strong)UIButton *nextButton;//下一个
@property(nonatomic,strong)UIButton *likeButton;//喜欢
@property(nonatomic,strong)UIButton *ignoreButton;//忽略
@property(nonatomic,strong)DaliyRecommendGuideView *daliyGuideView;//引导图

@property (nonatomic,strong)NSMutableArray * imagesArray;//图片数组
@property(nonatomic,assign)NSInteger currentIndex;//当前下标

@property(nonatomic,copy)NSString *likeMids;//喜欢用户
@end
