//
//  MyPhotoDetailViewController.h
//  Appointment
//
//  Created by feiwu on 16/7/30.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
@interface MyPhotoDetailViewController : CustomViewController<UIScrollViewDelegate>
@property(nonatomic,strong)NSMutableArray *photoArray;//处理图
@property(nonatomic,strong)NSMutableArray *photoOriginalArray;//原始图
@property(nonatomic,strong)NSMutableArray *photoDeleteArray;//删除参数数组
@property(nonatomic,strong)NSMutableArray *imageViewArray;//视图数组

@property(nonatomic,assign)NSInteger index;

@property(nonatomic,strong)UIScrollView *photoScroll;

@property(nonatomic, strong)UIButton *setheadButton;//设为头像
@property(nonatomic, strong)UIButton *deleteButton;//删除
@property(nonatomic, strong)UIView *lineView;//竖线
@property(nonatomic, strong)UIView *bottomView;//底部视图

@end
