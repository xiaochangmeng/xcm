//
//  RegisterViewController.h
//  Appointment
//
//  Created by feiwu on 16/7/13.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "MZYImageView.h"
@class LoginViewController;

@interface RegisterViewController : CustomViewController<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong)UIImageView *loginBackgroundView;
@property(nonatomic,strong)UILabel *titleLabel;//标题
@property(nonatomic,strong)UIButton *boyButton;//男
@property(nonatomic,strong)UIButton *girlButton;//女
@property(nonatomic,strong)UIButton *loginButton;//登录
@property(nonatomic,strong)UILabel *tipLabel;//提示Label
@property(nonatomic,strong)UIButton *protocolButton;//协议
@property(nonatomic,copy)NSString *sex;//性别
@property(nonatomic,copy)NSString *age;//性别

@property(nonatomic,strong)MZYImageView *ageBackgroundView;
@property(nonatomic,strong)UIPickerView *pickerView;//年龄选择
@property(nonatomic,strong)UIView *ageView;
@property(nonatomic,strong)UILabel *ageLabel;
@property(nonatomic,strong)UIButton *ageButton;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)NSArray *ageArray;

@end
