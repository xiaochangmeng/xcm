//
//  LoginViewController.h
//  Appointment
//
//  Created by feiwu on 16/7/13.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
@class RegisterViewController;
typedef void(^LoginBlock)();
@interface LoginViewController : CustomViewController<UITextFieldDelegate>
@property(nonatomic,strong)UIImageView *loginBackgroundView;
@property(nonatomic,strong)UIButton *backButton;
@property(nonatomic,strong)UIImageView *userImageView;
@property(nonatomic,strong)UITextField *userTextField;
@property(nonatomic,strong)UIImageView *passwordImageView;
@property(nonatomic,strong)UITextField *passwordTextField;
@property(nonatomic,strong)UIView *userLineView;
@property(nonatomic,strong)UIView *passwordLineView;
@property(nonatomic,strong)UIButton *loginButton;//登录
@property(nonatomic,strong)UIButton *facebookButton;//facebook登錄
@property(nonatomic,strong)UIButton *registerButton;//註冊button
@property(nonatomic,strong)UILabel *tipLabel;//提示Label

@property(nonatomic,copy)NSString *username;//用户名
@property(nonatomic,copy)NSString *password;//密码
@property(nonatomic,copy)NSString *mid;//用户id
@property(nonatomic,copy)NSString *userImage;//用户头像
@property(nonatomic,assign)BOOL isNoLogin;//没有登录

@property(nonatomic,copy)LoginBlock loginBlock;
@end
