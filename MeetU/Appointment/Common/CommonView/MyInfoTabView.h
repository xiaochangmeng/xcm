//
//  FansTabView.h
//  Created by feiwu on 16/7/20.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZYTabView.h"

@interface MyInfoTabView : UIView

//选项卡视图
@property (strong, nonatomic) MZYTabView *tabView;  

@property (assign, nonatomic) int index;

@property (nonatomic, strong) UIView *lineView;

@end
