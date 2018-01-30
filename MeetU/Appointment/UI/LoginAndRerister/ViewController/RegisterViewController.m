//
//  RegisterViewController.m
//  Appointment
//
//  Created by feiwu on 16/7/13.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterApi.h"
#import "LoginApi.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "QuestionViewController.h"
#import "CustomNavigationController.h"
#import "JPUSHService.h"
#import "RegisterProtocolViewController.h"
#import "LXFileManager.h"
@implementation RegisterViewController
#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"注册页面"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"注册页面"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideHUD];//隐藏指示器
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.ageArray = @[@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60",@"61",@"62",@"63",@"64",@"65"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIPickerViewDataSource

//指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 48;
}

#pragma mark UIPickerViewDelegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString * title = nil;
    _age = self.ageArray[row];
    title = self.ageArray[row];
    return title;
}
#pragma mark - Private Methods
//私有方法
- (void)initView
{
    WS(weakSelf);
    [self.view addSubview:self.loginBackgroundView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.boyButton];
    [self.view addSubview:self.girlButton];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.protocolButton];
    
    [_loginBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view).offset(0);
        make.left.mas_equalTo(weakSelf.view).offset(0);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, ScreenHeight));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(0);
        make.right.mas_equalTo(weakSelf.view).offset(0);
        make.top.mas_equalTo(ScreenHeight * 120 / 480.0 );
        make.height.mas_equalTo(35);
    }];
    
    [_girlButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).offset(80);
        make.centerX.mas_equalTo(weakSelf.view).offset(60);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    
    [_boyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).offset(80);
        make.centerX.mas_equalTo(weakSelf.view).offset(-60);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.boyButton.mas_bottom).offset(30);
        make.centerX.mas_equalTo(weakSelf.view).offset(40);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.boyButton.mas_bottom).offset(31);
        make.right.mas_equalTo(weakSelf.loginButton.mas_left).offset(0);
    }];

    
    [_protocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-30);
        make.centerX.mas_equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(300, 20));
    }];
    
    
}

- (void)showPickerView
{
    FWUserInformation* info = [FWUserInformation sharedInstance];
    info.sex = _sex;
    [info saveUserInformation];
    
    if (_ageBackgroundView == nil) {
        WS(weakSelf);
        _ageBackgroundView = [[MZYImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight)];
        _ageBackgroundView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_ageBackgroundView];
        _ageBackgroundView.touchBlock = ^(){
            [weakSelf.ageBackgroundView removeFromSuperview];

        };
        
        _ageView = [[UIView alloc] initWithFrame:CGRectMake(40, self.view.center.y - 110, ScreenWidth - 80, 230)];
        _ageView.backgroundColor = [UIColor whiteColor];
        _ageView.layer.masksToBounds = YES;
        _ageView.layer.cornerRadius = 5;
        [_ageBackgroundView addSubview:_ageView];
        
        _ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 80, 35)];
        _ageLabel.backgroundColor = [UIColor whiteColor];
        _ageLabel.text = NSLocalizedString(@"年龄", nil);
        _ageLabel.textAlignment = NSTextAlignmentCenter;
        [_ageView addSubview:_ageLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 34, ScreenWidth - 80, 1)];
        _lineView.backgroundColor = Color10(224,224,224, 1);
        [_ageView addSubview:_lineView];
        
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 35, ScreenWidth - 80, 150)];
        //指定数据源和委托
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [_pickerView selectRow:6 inComponent:0 animated:NO];
        
        [_ageView addSubview:self.pickerView];
        
        _ageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 185, ScreenWidth - 80, 45)];
        [_ageButton setTitle:@"確定" forState:UIControlStateNormal];
        [_ageButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _ageButton.backgroundColor = Color10(191, 123, 196, 1);
        [_ageView addSubview:_ageButton];
        
        
    } else {
        [self.view addSubview:_ageBackgroundView];
         [_pickerView selectRow:6 inComponent:0 animated:NO];
    }
    
}
#pragma mark - Event Response
- (void)loginAction:(UIButton *)button
{
        LoginViewController *login = [[LoginViewController alloc] init];
        [self presentViewController:login animated:NO completion:^{
            
        }];

}

- (void)protocolAction:(UIButton *)button
{
    RegisterProtocolViewController *protocol = [[RegisterProtocolViewController alloc] init];
    CustomNavigationController *navigation = [[CustomNavigationController alloc] initWithRootViewController:protocol];
    [self presentViewController:navigation animated:YES completion:^{
        
    }];

}

- (void)boyAction:(UIButton *)button
{
    _sex = @"1";
    [self showPickerView];
}

- (void)girlAction:(UIButton *)button
{
    _sex = @"0";
    
    [self showPickerView];
}

- (void)registerAction:(UIButton *)button
{
    [_ageBackgroundView removeFromSuperview];
    
    //注册
    [self registerReques];
}


#pragma mark - 注册
- (void)registerReques {
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    RegisterApi*api = [[RegisterApi alloc] initWithSex:_sex Age:_age];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf registerRequesFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"注册请求失败:%@",request.responseString);
        [weakSelf hideHUD];
        [weakSelf showHUDFail:kNetWorkErrorTitle];
        [weakSelf hideHUDDelay:1];
    }];
}

- (void)registerRequesFinish:(NSDictionary *)result{
    LogOrange(@"注册请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        //注册成功后存储登录信息
        NSDictionary *userinfo = [result objectForKey:@"data"];
        NSString *mid = [userinfo objectForKey:@"user_id"];
        [LXFileManager saveUserData:userinfo forKey:[NSString stringWithFormat:@"%@password",mid]];
        
        FWUserInformation* information = [FWUserInformation sharedInstance];
        information.addentionCount = @"";
        [information saveUserInformation];
        //登录
        [self loginRequesWithUserName:[userinfo objectForKey:@"user_id"] Password:[userinfo objectForKey:@"password"]];
    }else {
        [self hideHUD];
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
    }
}

#pragma mark - 登录
- (void)loginRequesWithUserName:(NSString *)username Password:(NSString *)password {
    LogOrange(@"用户名:%@， 密码：%@",username,password);
    WS(weakSelf);
    LoginApi*api = [[LoginApi alloc] initWithUser_id:username Password:password];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf loginRequesFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"登录请求失败:%@",request.responseString);
        [weakSelf hideHUD];
        [weakSelf showHUDFail:kNetWorkErrorTitle];
        [weakSelf hideHUDDelay:1];
    }];
}

- (void)loginRequesFinish:(NSDictionary *)result{
    LogOrange(@"登录请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        [self hideHUD];
        NSString *age = [NSString stringWithFormat:@"%@",[[result objectForKey:@"data"] objectForKey:@"age"]];
        NSString *sex = [NSString stringWithFormat:@"%@",[[result objectForKey:@"data"] objectForKey:@"sex"]];
        NSString *mid = [NSString stringWithFormat:@"%@",[[result objectForKey:@"data"] objectForKey:@"user_id"]];
        NSString *token = [NSString stringWithFormat:@"%@",[[result objectForKey:@"data"] objectForKey:@"token"]];
        
        //个人信息初始化
        FWUserInformation* info = [FWUserInformation sharedInstance];
        info.sex = sex;
        info.age = age;
        info.mid = mid;
        info.token=token;
        
        [info saveUserInformation];
        
        //令牌
        [LXFileManager saveUserData:[result objectForKey:kUserPHPSESSID] forKey:kUserPHPSESSID];
        NSString *valid = [NSString stringWithFormat:@"%ld", time(NULL)];
        NSString *validKey = [NSString stringWithFormat:@"%@%@",mid,kUserPHPSESSID];
        [LXFileManager saveUserData:valid forKey:validKey];

        
        //极光推送设置别名
        [JPUSHService setTags:[NSSet setWithObjects:age,sex, nil] alias:mid fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            NSLog(@"ialias:%@",iAlias);
        }];

        //跳转到问题页面
        [self pushQuestion];

        
    } else if ([code intValue] == kNetWorkNoSetSexCode) {
       
     
    } else {
        [self hideHUD];
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
    }
}



- (void)pushQuestion
{
    //事件统计
    [MobClick event:@"userRegister"];
    //切换根视图
    QuestionViewController *question = [[QuestionViewController alloc] init];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = question;

}

#pragma mark - Getters And Setters
- (UIImageView *)loginBackgroundView {
    if (!_loginBackgroundView) {
        _loginBackgroundView = [[UIImageView alloc] init];
        _loginBackgroundView.userInteractionEnabled = YES;
        _loginBackgroundView.image = LOADIMAGE(@"register_bg", @"jpg");
        _loginBackgroundView.contentMode = UIViewContentModeScaleToFill;
    }
    return _loginBackgroundView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"MeetU";
        _titleLabel.font = kFont30;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _titleLabel;
}

- (UIButton *)boyButton {
    if (!_boyButton) {
        _boyButton = [[UIButton alloc] init];
        //_boyButton.backgroundColor=[UIColor redColor];
        [_boyButton addTarget:self action:@selector(boyAction:) forControlEvents:UIControlEventTouchUpInside];
        [_boyButton setBackgroundImage:LOADIMAGE(@"register_btn_male_normal@2x", @"png") forState:UIControlStateNormal];
        [_boyButton setBackgroundImage:LOADIMAGE(@"register_btn_male_press@2x", @"png") forState:UIControlStateHighlighted];
       
    }
    return _boyButton;
}

- (UIButton *)girlButton {
    if (!_girlButton) {
        _girlButton = [[UIButton alloc] init];
        [_girlButton addTarget:self action:@selector(girlAction:) forControlEvents:UIControlEventTouchUpInside];
        [_girlButton setBackgroundImage:LOADIMAGE(@"register_btn_female_normal@2x", @"png") forState:UIControlStateNormal];
        [_girlButton setBackgroundImage:LOADIMAGE(@"register_btn_female_press@2x", @"png") forState:UIControlStateHighlighted];
    }
    return _girlButton;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] init];
        [_loginButton setTitle:NSLocalizedString(@"直接登入", nil) forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.titleLabel.font = kFont14;
        [_loginButton setTitleColor:Color16(0x407CED) forState:UIControlStateNormal];
    }
    return _loginButton;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = kFont14;
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.text = @"已有賬號?";
        [_tipLabel sizeToFit];
//                _tipLabel.backgroundColor = [UIColor orangeColor];
    }
    return _tipLabel;
}

- (UIButton *)protocolButton {
    if (!_protocolButton) {
        _protocolButton = [[UIButton alloc] init];
        [_protocolButton setTitle:@"通過註冊表示同意本應用使用協議" forState:UIControlStateNormal];
        [_protocolButton addTarget:self action:@selector(protocolAction:) forControlEvents:UIControlEventTouchUpInside];
        _protocolButton.titleLabel.font = kFont16;
//        _protocolButton.backgroundColor = [UIColor lightGrayColor];
        
        
    }
    return _protocolButton;
}

@end
