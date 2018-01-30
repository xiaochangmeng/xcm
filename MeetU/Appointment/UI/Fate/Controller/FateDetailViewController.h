//
//  FateDetailViewController.h
//  Appointment
//
//  Created by feiwu on 16/7/16.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "FateDetailTableView.h"
#import "FateDetailHeadView.h"
#import "FateModel.h"
#import "FateUserModel.h"
#import "MWPhotoBrowser.h"
#import "MZYImageView.h"
#import "MZYActionSheet.h"
#import "FateDetailBottomButtonView.h"
#import "FateDetailRechargeMaskView.h"
typedef void(^SelectedBlock)(NSMutableArray *selected);
typedef void(^CancelAddentionBlock)();
@interface FateDetailViewController : CustomViewController<MWPhotoBrowserDelegate>
@property(nonatomic, strong)FateDetailTableView *tableView;
@property(nonatomic, strong)FateDetailHeadView *headView;
//头部按钮
@property(nonatomic,strong)UIView *navigationView;
@property(nonatomic,strong)UIButton *backButton;
@property(nonatomic,strong)UIButton *moreButton;
//底部视图
@property(nonatomic,strong)FateDetailBottomButtonView* fateDetailBottomButtonView;
@property (nonatomic, strong) MZYImageView *backgroundView;//菜单背景
@property (nonatomic, strong) MZYActionSheet *actionSheet;//“相片选取”菜单视图
//弹出视图
@property (nonatomic, strong) FateDetailRechargeMaskView* fateDetailRechargeMaskView;



@property(nonatomic, strong)FateModel *fateModel;
@property(nonatomic, strong)FateUserModel *fateUserModel;
@property(nonatomic, strong)NSMutableArray *picArray;
@property(nonatomic, strong)NSMutableArray *selectedArray;
@property(nonatomic, strong)NSMutableArray *titleArray;//更多标题

@property(nonatomic, copy)NSString *mid;//用户id
@property(nonatomic, copy)NSString *ios_tell;//是否開通寫信
@property(nonatomic, copy)NSString *ios_vip;//是否開通VIP
@property(nonatomic, copy)SelectedBlock selectedBlock;
@property(nonatomic, copy)CancelAddentionBlock cancelAddentionBlock;

@end
