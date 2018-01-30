//
//  LetterViewController.h
//  Appointment
//
//  Created by feiwu on 16/7/8.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "LetterTableView.h"
#import "LetterPerfectInfoView.h"
#import "MJRefresh.h"
@interface LetterViewController : CustomViewController
@property(nonatomic,strong)LetterTableView *letterTableView;
@property(nonatomic,strong)LetterPerfectInfoView *perfectInfoView;

@property(nonatomic,strong)NSMutableArray *letterDataArray;
@property(nonatomic,strong)NSMutableArray *letterMidArray;
@property(nonatomic,assign)BOOL isRefresh;
@property(nonatomic,copy)NSString *visitor_num;//未讀訪客
@property(nonatomic, copy)NSString *ios_vip;//是否開通VIP
@property(nonatomic, copy)NSString *ios_tell;//是否開通写信
@property(nonatomic,assign)NSInteger page;

@end
