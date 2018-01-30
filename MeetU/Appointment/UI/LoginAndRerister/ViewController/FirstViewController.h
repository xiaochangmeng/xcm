//
//  FirstViewController.h
//  taiwantongcheng
//
//  Created by feiwu on 2016/11/23.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
@interface FirstViewController : CustomViewController
@property(nonatomic,strong)UIImageView *loginBackgroundView;

@property(nonatomic,strong)UIButton *loginButton;//登录
@property(nonatomic,strong)UIButton *facebookButton;//facebook登錄
@property(nonatomic,strong)UIButton *registerButton;//注册
@property(nonatomic,strong)UILabel *tipLabel;//提示Label

@end
