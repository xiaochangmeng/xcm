//
//  QuestionViewController.m
//  Appointment
//
//  Created by feiwu on 16/7/15.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "QuestionViewController.h"
#import "UploadHeaderController.h"
#import "MySetUserInfoApi.h"
#import "AppDelegate.h"
#import "NSObject+XWAdd.h"
@interface QuestionViewController ()

@end

@implementation QuestionViewController

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [MobClick beginLogPageView:@"注册问题页面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"注册问题页面"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideHUD];//隐藏指示器
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WS(weakSelf);
    self.title = NSLocalizedString(@"回答问题", nil);
    [self initView];

    //设置信息
    [self xw_addNotificationForName:@"QuestionViewControllerSetInfo" block:^(NSNotification *notification) {
        NSDictionary *info = [notification object];
        [weakSelf setUserInfoRequest:info];
    }];

}

- (void)initView {
    WS(weakSelf);
    [self.view addSubview:self.questionTableView];
    [self.questionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, ScreenHeight));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置用户信息
- (void)setUserInfoRequest:(NSDictionary *)info {
    WS(weakSelf);
    NSLog(@"用戶選擇的信息是:%@",info);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    MySetUserInfoApi *api = [[MySetUserInfoApi alloc] initWithInfo:info];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf hideHUD];
        [weakSelf setUserInfoRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"设置用户信息请求失败:%@",request.responseString);
        [weakSelf hideHUD];
        [weakSelf showHUDFail:kNetWorkErrorTitle];
        [weakSelf hideHUDDelay:1];
    }];
}

- (void)setUserInfoRequestFinish:(NSDictionary *)result{
    LogOrange(@"设置用户信息请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        UploadHeaderController* uploadHeaderController = [[UploadHeaderController alloc]initWithType:@"register"];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.window.rootViewController = uploadHeaderController;
    }else {
        [self hideHUD];
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
    }
}

#pragma mark - Getters And Setters
- (QuestionTableView *)questionTableView {
    if (!_questionTableView) {
        _questionTableView = [[QuestionTableView alloc] init];
        _questionTableView.backgroundColor = [UIColor whiteColor];
    }
    return _questionTableView;
}
@end
