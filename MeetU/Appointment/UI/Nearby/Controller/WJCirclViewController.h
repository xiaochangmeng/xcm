//
//  NearbyViewController.h
//  Appointment
//
//  Created by feiwu on 16/7/8.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "CircleTableView.h"


@interface WJCirclViewController : CustomViewController <UIScrollViewDelegate, UIWebViewDelegate>

/**
 圈子模块: 左侧圈子tableView
 */
@property (nonatomic, strong) CircleTableView *circleTableView;
/**
 返回顶部
 */
@property (nonatomic, strong) UIButton *backTopButton;

@end

