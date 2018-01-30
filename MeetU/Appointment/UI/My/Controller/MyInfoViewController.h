//
//  MyInfoViewController.h
//  Appointment
//
//  Created by feiwu on 16/7/18.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "UserInfoModel.h"
#import "MyBaseInfoTableView.h"
#import "MyHobbyInfoTableView.h"
#import "MyDetailInfoTableView.h"
#import "MyInfoTabView.h"
@interface MyInfoViewController : CustomViewController<UIScrollViewDelegate>
@property(nonatomic,strong)MyBaseInfoTableView *baseTableView;
@property(nonatomic,strong)MyHobbyInfoTableView *hobbyTableView;
@property(nonatomic,strong)MyDetailInfoTableView *detailTableView;
@property(nonatomic,strong)UIScrollView *infoScrollView;
@property(nonatomic,strong)MyInfoTabView *tabView;
@property(nonatomic,strong)UILabel *tipLabel;

@property(nonatomic,strong)UILabel *baseLabel;
@property(nonatomic,strong)UILabel *hobbyLabel;
@property(nonatomic,strong)UILabel *detailLabel;
@property(nonatomic,strong)UIButton *saveButton;

@property(nonatomic,strong)UserInfoModel *oldinfoModel;
@property(nonatomic,strong)UserInfoModel *newinfoModel;

@property (nonatomic,strong)NSDate *selectedDate;

- (void)prefrect:(UserInfoModel*)model;
@end
