//
//  MyViewController.m
//  Appointment
//
//  Created by feiwu on 16/7/8.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MyViewController.h"
#import "TabBarView.h"
#import "MyFeedBackViewController.h"
#import "SelectConditionViewController.h"
#import "CustomNavigationController.h"
#import "MyTableViewCell.h"
#import "MyGetInfoApi.h"
#import "GetLetterCountApi.h"
#import "MyAddentionViewController.h"
#import "LoginViewController.h"
#import "LXFileManager.h"
#import "MyVisitorViewController.h"
#import "WhoSeeMeController.h"
#import "MySetViewController.h"
#import "QuestionOfBottomView.h"
#import "NSObject+XWAdd.h"
@interface MyViewController ()

@end

@implementation MyViewController

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initRrightBarItem];
    [[[UIApplication sharedApplication].windows lastObject] addSubview:[QuestionOfBottomView sharedManager]];
    
    if (_infoModel) {
        _infoModel.me_attention_num = [FWUserInformation sharedInstance].addentionCount;
        [_tableView reloadData];
    }
    [MobClick beginLogPageView:@"我的页面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //移除底部弹窗视图
    [[QuestionOfBottomView sharedManager] removeFromSuperview];
    [MobClick endLogPageView:@"我的页面"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideTitleView];
    [self hideHUD];//隐藏指示器
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WS(weakSelf);
    self.title = NSLocalizedString(@"我的", nil);
    [self initTabBarView];
    [self.view addSubview:self.tableView];
    
    [self getInfoRequest];//我的信息
    [self getLetterCountRequest];//未读消息数
    
    //相册改变
    [self xw_addNotificationForName:@"MyHandleAlbumChange" block:^(NSNotification *notification) {
        NSDictionary *dic = [notification object];
        weakSelf.infoModel.albums = [dic objectForKey:@"albums"];
        weakSelf.infoModel.albums_original = [dic objectForKey:@"albums_original"];
        weakSelf.infoModel.albums_urlencode = [dic objectForKey:@"albums_urlencode"];
        weakSelf.headView.infoModel = weakSelf.infoModel;
    }];
    
    
    //短信包月VIP通知
    [self xw_addNotificationForName:@"VipAndWriterStatusChange" block:^(NSNotification *notification) {
        [weakSelf getInfoRequest];//重新请求一次
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initTabBarView{
    WS(weakSelf);
    TabBarView *tabBarView = [[TabBarView alloc] initWithIndex:3];
    [self.view addSubview:tabBarView];
    
    [tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(49);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
    }];
}
#pragma mark - 导航栏右侧按钮
- (void)initRrightBarItem{
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64/2, 64/2)];
    [self.rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setImage: LOADIMAGE(@"my_set@2x", @"png") forState:UIControlStateNormal];
    [self.rightButton setImage: LOADIMAGE(@"my_set@2x", @"png") forState:UIControlStateHighlighted];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    
    negativeSpacer.width = -5;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightItem, nil];
}

#pragma mark - Event Responses

- (void)clickRightButton:(UIButton *)button
{
    [MobClick event:@"mySet"];
    MySetViewController *set = [[MySetViewController alloc] init];
    CustomNavigationController *navigation = [[CustomNavigationController alloc] initWithRootViewController:set];
    [self presentViewController:navigation animated:YES completion:^{
        
    }];
    
}


#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return  2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = 2;
            break;
        case 1:
            rows = 2;
            break;
        default:
            break;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"MyTableViewCell";
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[MyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.indexPath = indexPath;
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        if ([_infoModel.ios_tell integerValue] > 0) {
            cell.detailLabel.text = NSLocalizedString(@"已开通", nil);
        } else {
            cell.detailLabel.text = NSLocalizedString(@"未开通", nil);
        }
    } else if (indexPath.row == 1 && indexPath.section == 0) {
        if ([_infoModel.ios_vip integerValue] > 0) {
            cell.detailLabel.text = NSLocalizedString(@"已开通", nil);
        } else {
            cell.detailLabel.text = NSLocalizedString(@"未开通", nil);
        }
    } else if (indexPath.row == 0 && indexPath.section == 1) {
        if ([_infoModel.lately_visitor_num integerValue] > 0) {
            cell.detailLabel.text = [NSString stringWithFormat:@"%@",_infoModel.lately_visitor_num];
        } else {
            cell.detailLabel.text = @"";
        }
        
    } else if (indexPath.row == 1 && indexPath.section == 1) {
        if ([_infoModel.me_attention_num integerValue] > 0) {
            cell.detailLabel.text = [NSString stringWithFormat:@"%@",_infoModel.me_attention_num];
        } else {
            cell.detailLabel.text = @"";
        }
    } else {
        cell.detailLabel.text = @"";
    }
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else {
        return 5;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //短信包月
                    [MobClick event:@"myWriter"];
                    MyFeedBackViewController *feed = [[MyFeedBackViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/iOS/Buy/write_v1",BaseUrl]];
                    feed.titleStr = NSLocalizedString(@"写信包月", nil);
                    feed.pushType = @"center-write";
                    [self.navigationController pushViewController:feed animated:YES];
                }
                    break;
                    
                case 1:
                {
                    //VIP会员
                    [MobClick event:@"myVip"];
                    MyFeedBackViewController *feed = [[MyFeedBackViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/iOS/Buy/vip_v1",BaseUrl]];
                    feed.titleStr = NSLocalizedString(@"VIP会员", nil);
                    feed.pushType = @"center-vip";
                    [self.navigationController pushViewController:feed animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //最近访客
                    [MobClick event:@"myVisitor"];
                    if ([_infoModel.ios_vip isEqualToString:@"0"]) {
                        WhoSeeMeController*  whoSeeMeController = [[WhoSeeMeController alloc]init];
                        whoSeeMeController.pushType = @"mine-visitors-vip";
                        [self.navigationController pushViewController:whoSeeMeController animated:YES];
                    }else{
                        //最近访客
                        MyVisitorViewController *visitor = [[MyVisitorViewController alloc] init];
                        [self.navigationController pushViewController:visitor animated:YES];
                    }
                }
                    break;
                case 1:
                {
                    //我的关注
                    [MobClick event:@"myaddention"];
                    MyAddentionViewController *addention = [[MyAddentionViewController alloc] init];
                    [self.navigationController pushViewController:addention animated:YES];
                }
                    break;
                case 2:
                {
                    //客服中心
                    [MobClick event:@"myFeedback"];
                    MyFeedBackViewController *feed = [[MyFeedBackViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/iOS/Buy/service",BaseUrl]];
                    feed.titleStr = NSLocalizedString(@"客服中心", nil);
                    [self.navigationController pushViewController:feed animated:YES];
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
        default:
            break;
    }
    
}


#pragma mark - Network Data
#pragma mark - 获取我的页面信息
- (void)getInfoRequest {
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    MyGetInfoApi *api = [[MyGetInfoApi alloc] init];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf hideHUD];
        [weakSelf getInfoRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"获取我的页面信息请求失败:%@",request.responseString);
        [weakSelf hideHUD];
        [weakSelf showNetRefresh:^{
            [weakSelf hideNetRefresh];
            [weakSelf getInfoRequest];
        }];
        
    }];
}

- (void)getInfoRequestFinish:(NSDictionary *)result{
    LogOrange(@"获取我的页面信息请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        NSMutableDictionary *infoDic  = [result objectForKey:@"data"];
        //是否有数据
        if ((NSNull *)infoDic != [NSNull null] && infoDic.count > 0)  {
            _infoModel = [[UserInfoModel alloc] initWithDataDic:infoDic];
            _headView.infoModel = _infoModel;
            [_tableView reloadData];
            FWUserInformation* information = [FWUserInformation sharedInstance];
            information.addentionCount = _infoModel.me_attention_num;
            information.percent = [infoDic objectForKey:@"percent"];
            [information saveUserInformation];
        }
        
    }else if([code intValue] == kNetWorkNoLoginCode){
        //没有登录
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
        [self performSelector:@selector(login) withObject:nil afterDelay:1];
        
    } else {
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
    }
}

- (void)login{
    WS(weakSelf);
    LoginViewController *login = [[LoginViewController alloc] init];
    login.isNoLogin = YES;
    login.loginBlock = ^(){
        [weakSelf getInfoRequest];;
    };
    [self presentViewController:login animated:NO completion:^{
        
    }];
}

#pragma mark - 未读私信数量
- (void)getLetterCountRequest{
    WS(weakSelf);
    GetLetterCountApi *api = [[GetLetterCountApi alloc] init];
    [api startWithCompletionBlockWithSuccess:^( YTKBaseRequest *request) {
        [weakSelf getLetterCountRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        if ([[request.responseJSONObject objectForKey:@"code"] integerValue] == 200) {
            [weakSelf getLetterCountRequestFinish:request.responseJSONObject];
        }
    }];
}

- (void)getLetterCountRequestFinish:(NSDictionary *)result{
    LogOrange(@"未读私信请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    if ([code intValue] == kNetWorkSuccCode){
        NSDictionary *dic = [result objectForKey:@"data"];
        NSInteger visitor = [[dic objectForKey:@"lately_total"] integerValue];
        NSInteger letter = [[dic objectForKey:@"letter_total"] integerValue];
        NSString *newCount = [NSString  stringWithFormat:@"%ld",visitor + letter];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LetterCountChange" object:newCount];
        NSString *userid = [NSString stringWithFormat:@"%@%@",[FWUserInformation sharedInstance].mid,kUserLetterCount];
        [LXFileManager saveUserData:newCount forKey:userid];
        
        if ([newCount integerValue] > 0) {
            [self showLetterCount:newCount];
        }
        
    } else if ([code intValue] == kNetWorkNoSetSexCode) {
        
    } else {
    }
}

#pragma mark - Getters And Setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 49 - 64)];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;//隐藏cell分割线
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _headView = [[MyHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 201)];
        _tableView.tableHeaderView = _headView;
        
    }
    return _tableView;
}

@end
