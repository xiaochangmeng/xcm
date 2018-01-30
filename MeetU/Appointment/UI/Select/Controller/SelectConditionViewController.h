//
//  TestViewController.h
//  Appointment
//
//  Created by feiwu on 16/7/11.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "ConditionButton.h"
#import "SelectModel.h"
@interface SelectConditionViewController : CustomViewController
@property(nonatomic, strong)UIView *conditionView;
@property(nonatomic, strong)ConditionButton *locationButton;
@property(nonatomic, strong)ConditionButton *ageButton;
@property(nonatomic, strong)ConditionButton *heightButton;
@property(nonatomic, strong)UIButton *saveButton;

@property(nonatomic, copy)NSString *area;
@property(nonatomic, copy)NSString *age;
@property(nonatomic, copy)NSString *height;
@property(nonatomic, copy)NSDictionary *selectDic;

@property(nonatomic, strong)SelectModel *selectModel;
@end
