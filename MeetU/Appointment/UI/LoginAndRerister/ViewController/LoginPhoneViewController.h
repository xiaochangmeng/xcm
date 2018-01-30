//
//  LoginPhoneViewController.h
//  Appointment
//
//  Created by feiwu on 2017/2/21.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
@interface LoginPhoneViewController : CustomViewController
@property(nonatomic,copy)NSString *sex;//性别
@property(nonatomic,copy)NSString *age;//性别
@property(nonatomic,copy)NSString *uid;//用户名
@property(nonatomic,copy)NSString *password;//密码


- (id)initWithType:(NSString *)type;//1注册 2圈子评论验证 3找回密码

@end
