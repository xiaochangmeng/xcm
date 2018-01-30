//
//  ModifyPasswordViewController.h
//  Appointment
//
//  Created by feiwu on 16/7/16.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
@interface ModifyPasswordViewController : CustomViewController<UITextFieldDelegate>
@property(nonatomic,strong)UILabel *userCountLabel;
@property(nonatomic,strong)UILabel *userPasswordLabel;
@property(nonatomic,strong)UILabel *userTwicePasswordLabel;
@property(nonatomic,strong)UILabel *userCountText;
@property(nonatomic,strong)UITextField *userPasswordText;
@property(nonatomic,strong)UITextField *userTwicePasswordText;
@property(nonatomic,strong)UIView *userCountLineView;
@property(nonatomic,strong)UIView *userPasswordLineView;
@property(nonatomic,strong)UIView *userTwicePasswordLineView;
@end
