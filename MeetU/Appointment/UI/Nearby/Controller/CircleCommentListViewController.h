//
//  CircleCommentListViewController.h
//  Appointment
//
//  Created by feiwu on 2017/2/9.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "MJRefresh.h"
#import "CircleModel.h"
@interface CircleCommentListViewController : CustomViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *commentDataArray;
@property(nonatomic,assign)BOOL isRefresh;
@property(nonatomic,assign)int page;
@property(nonatomic,strong)CircleModel *model;
@property (nonatomic, strong) UIView *textBGView;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UITextField *descTextView;
@end
