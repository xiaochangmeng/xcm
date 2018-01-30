//
//  LoginViewController.m
//  Appointment
//
//  Created by feiwu on 16/7/13.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "LoginApi.h"
#import "FacebookLoginApi.h"
#import "RegexKitLite.h"
#import "RegisterViewController.h"
#import "DaliyRecommendViewController.h"
#import "JPUSHService.h"
#import "NSDate+MZYExtension.h"
#import "NSString+MZYExtension.h"
#import "LXFileManager.h"
#import "QuestionOfBottomView.h"
#import "UploadHeaderController.h"
#import "NSObject+XWAdd.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
@implementation LoginViewController

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //移除底部弹窗视图
    [[QuestionOfBottomView sharedManager] removeFromSuperview];
    [MobClick beginLogPageView:@"登录页面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"登录页面"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideHUD];//隐藏指示器
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //获取登录信息
    WS(weakSelf);
    NSString *mid = [FWUserInformation sharedInstance].mid;
    NSDictionary *userinfo = [LXFileManager readUserDataForKey:[NSString stringWithFormat:@"%@password",mid]];
    _username = [userinfo objectForKey:@"user_id"];
    _password = [userinfo objectForKey:@"password"];
    [self initView];
    [self xw_addNotificationForName:@"modifyPasswordFinish" block:^(NSNotification *notification) {
        weakSelf.password = @"";
    }];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Private Methods
//私有方法
- (void)initView
{
    WS(weakSelf);
    [self.view addSubview:self.loginBackgroundView];
    [self.view addSubview:self.backButton];
    
    [self.view addSubview:self.userImageView];
    [self.view addSubview:self.userTextField];
    [self.view addSubview:self.userLineView];
    
    [self.view addSubview:self.passwordImageView];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.passwordLineView];
    
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.facebookButton];
    [self.view addSubview:self.registerButton];
    [self.view addSubview:self.tipLabel];
    [_loginBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view).offset(0);
        make.left.mas_equalTo(weakSelf.view).offset(0);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, ScreenHeight));
    }];
    
    
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view).offset(20);
        make.left.mas_equalTo(weakSelf.view).offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    [_userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view).offset(100);
        make.left.mas_equalTo(weakSelf.view).offset(30);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
    [_userTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view).offset(100);
        make.left.mas_equalTo(weakSelf.userImageView.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 140, 26));
    }];
    
    [_userLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.userImageView.mas_bottom);
        make.left.mas_equalTo(weakSelf.view).offset(30);
        make.right.mas_equalTo(weakSelf.view).offset(-30);
        make.height.mas_equalTo(0.5);
    }];
    
    [_passwordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.userImageView.mas_bottom).offset(30);
        make.left.mas_equalTo(weakSelf.view).offset(30);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.userImageView.mas_bottom).offset(30);
        make.left.mas_equalTo(weakSelf.passwordImageView.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 140, 26));
    }];
    
    [_passwordLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.passwordImageView.mas_bottom);
        make.left.mas_equalTo(weakSelf.view).offset(30);
        make.right.mas_equalTo(weakSelf.view).offset(-30);
        make.height.mas_equalTo(0.5);
    }];
    
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.passwordImageView.mas_bottom).offset(50);
        make.left.mas_equalTo(weakSelf.view).offset(30);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 60, 40));
    }];
    
    [_facebookButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.view).offset(-71);
        make.left.mas_equalTo(weakSelf.view).offset(33.5);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 67, 42));
    }];
    
    
    [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.loginButton.mas_bottom).offset(28);
        make.right.mas_equalTo(weakSelf.view).offset(-35);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.loginButton.mas_bottom).offset(29);
        make.right.mas_equalTo(weakSelf.registerButton.mas_left).offset(0);
    }];
    
}

#pragma mark 登录验证
- (void)validatorLogin
{
    
    if (_userTextField.text == nil || [_userTextField.text isEqualToString:@""]) {
        [self hideHUD];
        [self showHUDFail:NSLocalizedString(@"用户名不能为空！", nil)];
        [self hideHUDDelay:1];
        return;
    }
    
    NSString *regex = @"\\s+";
    NSArray *array = [_userTextField.text componentsMatchedByRegex:regex];
    if (array.count > 0 ) {
        [self hideHUD];
        [self showHUDFail:NSLocalizedString(@"用户名不能有空格！", nil)];
        [self hideHUDDelay:1];
        return;
    }
    
    if (_passwordTextField.text == nil || [_passwordTextField.text isEqualToString:@""]) {
        [self hideHUD];
        [self showHUDFail:NSLocalizedString(@"密码不能为空！", nil)];
        [self hideHUDDelay:1];
        return;
    }
    
    
    regex = @"\\s+";
    array = [_passwordTextField.text componentsMatchedByRegex:regex];
    if (array.count > 0 ) {
        [self hideHUD];
        [self showHUDFail:NSLocalizedString(@"密码不能有空格！", nil)];
        [self hideHUDDelay:1];
        
        return;
    }
    
    if(_passwordTextField.text.length < 6 || _passwordTextField.text.length > 16){
        
        [self hideHUD];
        [self showHUDFail:NSLocalizedString(@"密码必须为6至16个字符！", nil)];
        [self hideHUDDelay:1];
        return;
    }
    
    [self loginRequesWithUser_id:_userTextField.text Password:_passwordTextField.text];
    
}


#pragma mark - Event Response
- (void)facebookAction:(UIButton *)button
{
    
    //facebook登录
    WS(weakSelf);
    [ShareSDK getUserInfo:SSDKPlatformTypeFacebook
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             //性别
             NSString *sex;
             if (user.gender == SSDKGenderMale) {
                 sex = @"1";
             } else  if (user.gender == SSDKGenderFemale) {
                 sex = @"0";
             } else {
                 sex = @"";
             }
             
             //年龄
             NSString *age;
             NSDictionary *age_range = [user.rawData objectForKey:@"age_range"];
             NSString *max = [NSString stringWithFormat:@"%@",[age_range objectForKey:@"max"]];
             NSString *min = [NSString stringWithFormat:@"%@",[age_range objectForKey:@"min"]];
             if ([max intValue] > 0) {
                 age = max;
             } else if ([min intValue] > 0) {
                 age = min;
             } else {
                 age = @"24";
             }
             
             //签名
             NSString *tag = [NSString stringWithFormat:@"%@%@%@",FacebookSecret,user.uid,[user.rawData objectForKey:@"third_party_id"]];
             
             //第三方登录
             [weakSelf thirdLoginRequest:user.uid Nickname:user.nickname Sex:sex Photo:user.icon Age:age Third_id:[user.rawData objectForKey:@"third_party_id"] Locale:[user.rawData objectForKey:@"locale"] Tag:[NSString md5HexDigest:tag]];
         } else {
             NSLog(@"%@",error);
         }
         
     }];
    
}

- (void)loginAction:(UIButton *)button
{
    [_passwordTextField resignFirstResponder];
    [_userTextField resignFirstResponder];
    
    [self validatorLogin];
}

- (void)registerAction:(UIButton *)button
{
    RegisterViewController *reg = [[RegisterViewController alloc] init];
    [self presentViewController:reg animated:NO completion:^{
        
    }];
    
}

- (void)backAction:(UIButton *)button
{
    
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_userTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}
#pragma mark - Network Data
#pragma mark - 第三方登录
- (void)thirdLoginRequest:(NSString *)user_id Nickname:(NSString *)nickname Sex:(NSString *)sex Photo:(NSString *)photo Age:(NSString *)age Third_id:(NSString *)third_id Locale:(NSString *)locale Tag:(NSString *)tag{
    NSLog(@"年龄是多少:%@",age);
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    FacebookLoginApi*api = [[FacebookLoginApi alloc] initWithUser_id:user_id Nickname:nickname Sex:sex Photo:photo Age:age Third_id:third_id Locale:locale Tag:tag];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf thirdLoginRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"第三方登录请求失败:%@",request.responseString);
        [weakSelf hideHUD];
        [weakSelf showHUDFail:kNetWorkErrorTitle];
        [weakSelf hideHUDDelay:1];
    }];
}

- (void)thirdLoginRequestFinish:(NSDictionary *)result{
    LogOrange(@"第三方登录请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        [self hideHUD];
        NSString *age = [NSString stringWithFormat:@"%@",[[result objectForKey:@"data"] objectForKey:@"age"]];
        NSString *sex = [NSString stringWithFormat:@"%@",[[result objectForKey:@"data"] objectForKey:@"sex"]];
        _mid = [NSString stringWithFormat:@"%@",[[result objectForKey:@"data"] objectForKey:@"user_id"]];
        _userImage = [NSString stringWithFormat:@"%@",[[result objectForKey:@"data"] objectForKey:@"photo"]];
        [LXFileManager saveUserData:_userImage forKey:[NSString stringWithFormat:@"%@userImage",_mid]];
        
        //存储用户信息
        FWUserInformation* information = [FWUserInformation sharedInstance];
        information.sex = sex;
        information.age = age;
        information.mid = _mid;
        [information saveUserInformation];
        
        //存储 PHPSESSID
        [LXFileManager saveUserData:[result objectForKey:kUserPHPSESSID] forKey:kUserPHPSESSID];
        
        NSString *valid = [NSString stringWithFormat:@"%ld", time(NULL)];
        NSString *validKey = [NSString stringWithFormat:@"%@%@",_mid,kUserPHPSESSID];
        [LXFileManager saveUserData:valid forKey:validKey];
        
        //极光推送设置别名
        [JPUSHService setTags:[NSSet setWithObjects:age,sex, nil] alias:_mid fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            NSLog(@"ialias:%@",iAlias);
        }];

        //跳转
        [self pushMain];
        
    } else if ([code intValue] == kNetWorkNoSetSexCode) {
        [self hideHUD];
    } else {
        [self hideHUD];
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
    }
}
#pragma mark - 登录
- (void)loginRequesWithUser_id:(NSString *)user_id Password:(NSString *)password {
    LogRed(@"用户名:%@， 密码：%@",user_id,password);
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    LoginApi*api = [[LoginApi alloc] initWithUser_id:user_id Password:password];
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
        _mid = [NSString stringWithFormat:@"%@",[[result objectForKey:@"data"] objectForKey:@"user_id"]];
        _userImage = [NSString stringWithFormat:@"%@",[[result objectForKey:@"data"] objectForKey:@"photo"]];
        [LXFileManager saveUserData:_userImage forKey:[NSString stringWithFormat:@"%@userImage",_mid]];
        
        //存储用户信息
        FWUserInformation* information = [FWUserInformation sharedInstance];
        information.sex = sex;
        information.age = age;
        information.mid = _mid;
        [information saveUserInformation];
        
        //存储 PHPSESSID
        [LXFileManager saveUserData:[result objectForKey:kUserPHPSESSID] forKey:kUserPHPSESSID];
        
        NSString *valid = [NSString stringWithFormat:@"%ld", time(NULL)];
        NSString *validKey = [NSString stringWithFormat:@"%@%@",_mid,kUserPHPSESSID];
        [LXFileManager saveUserData:valid forKey:validKey];
        
        //存储登录信息
        NSDictionary *dic = @{@"user_id" : _userTextField.text ? _userTextField.text : @"",@"password" : _passwordTextField.text ? _passwordTextField.text : @""};
        [LXFileManager saveUserData:dic forKey:[NSString stringWithFormat:@"%@password",_mid]];
        
        //极光推送设置别名
        [JPUSHService setTags:[NSSet setWithObjects:age,sex, nil] alias:_mid fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            NSLog(@"ialias:%@",iAlias);
        }];

        //跳转
        [self pushMain];
        
    } else if ([code intValue] == kNetWorkNoSetSexCode) {
        [self hideHUD];
    } else {
        [self hideHUD];
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
    }
}
- (void)pushMain
{
    //事件统计
    [MobClick event:@"userLogin"];
    //判断是否每天第一次启动
    NSString *currentDate = [NSDate getDate:[NSDate date] dateFormatter:@"yyyyMMdd"];
    NSString *key = [NSString stringWithFormat:@"%@%@",currentDate,_mid];
    NSString *daliy = [LXFileManager readUserDataForKey:key];
    
    if(_isNoLogin) {
        //没有登录
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
        if (_loginBlock) {
            _loginBlock();
        }
    } else {
        //已登录
        if ([daliy isEqualToString:@"1"]) {
            //已启动
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.window.rootViewController = [delegate.viewControllers firstObject];
            
        } else {
            //   没有启动过
            if (_userImage.length < 5) {
                //没有头像
                UploadHeaderController *upload = [[UploadHeaderController alloc] initWithType:@"login"];
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                delegate.window.rootViewController = upload;
            } else {
                //有头像
                DaliyRecommendViewController *recommend = [[DaliyRecommendViewController alloc] init];
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                delegate.window.rootViewController = recommend;
                
            }
            //   没有启动过
            
        }
    }
    _isNoLogin = NO;
    
}

#pragma mark - Getters And Setters

- (UIImageView *)loginBackgroundView {
    if (!_loginBackgroundView) {
        _loginBackgroundView = [[UIImageView alloc] init];
        _loginBackgroundView.userInteractionEnabled = YES;
        
        _loginBackgroundView.image =  LOADIMAGE(@"register_bg", @"jpg");
        _loginBackgroundView.contentMode = UIViewContentModeScaleToFill;
    }
    return _loginBackgroundView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setTitle:NSLocalizedString(@"返回注册", nil) forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        _backButton.titleLabel.font = kFont14;
        //        _backButton.backgroundColor = [UIColor orangeColor];
        _backButton.hidden = _isNoLogin;
        
    }
    return _backButton;
}
- (UIImageView *)userImageView {
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.image = LOADIMAGE(@"login_username@2x", @"png");
        //        _userImageView.backgroundColor = [UIColor yellowColor];
    }
    return _userImageView;
}

- (UITextField *)userTextField {
    if (!_userTextField) {
        _userTextField = [[UITextField alloc] init];
        //        _userTextField.backgroundColor = [UIColor orangeColor];
        _userTextField.delegate = self;
        _userTextField.textColor = [UIColor whiteColor];
        _userTextField.textAlignment = NSTextAlignmentCenter;
        _userTextField.text = _username;
    }
    return _userTextField;
}

- (UIImageView *)passwordImageView {
    if (!_passwordImageView) {
        _passwordImageView = [[UIImageView alloc] init];
        _passwordImageView.image = LOADIMAGE(@"login_password@2x", @"png");
        //        _passwordImageView.backgroundColor = [UIColor yellowColor];
    }
    return _passwordImageView;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] init];
        //        _passwordTextField.backgroundColor = [UIColor orangeColor];
        _passwordTextField.delegate = self;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.text = _password;
        _passwordTextField.textColor = [UIColor whiteColor];
        _passwordTextField.textAlignment = NSTextAlignmentCenter;
    }
    return _passwordTextField;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] init];
        [_loginButton setTitle:NSLocalizedString(@"登入", nil) forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.titleLabel.font = kFont18;
        _loginButton.backgroundColor = [UIColor lightGrayColor];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        _loginButton.backgroundColor =  Color16(0xFF6478);
        _loginButton.layer.cornerRadius = 5;
    }
    return _loginButton;
}

- (UIButton *)facebookButton {
    if (!_facebookButton) {
        _facebookButton = [[UIButton alloc] init];
        [_facebookButton setTitle:NSLocalizedString(@"Facebook登入", nil) forState:UIControlStateNormal];
        [_facebookButton addTarget:self action:@selector(facebookAction:) forControlEvents:UIControlEventTouchUpInside];
        _facebookButton.titleLabel.font = kFont14;
        [_facebookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_facebookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_facebookButton setBackgroundImage:[UIImage imageNamed:@"login_facebook@2x" ImageType:@"png" withTop:20 andLeft:100] forState:UIControlStateNormal];
        if (![ShareSDK isClientInstalled:SSDKPlatformTypeFacebook]) {
            _facebookButton.hidden = NO;
        } else {
            _facebookButton.hidden = NO;
        }
    }
    return _facebookButton;
}


- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [[UIButton alloc] init];
        [_registerButton setTitle:NSLocalizedString(@"点击注册", nil) forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
        _registerButton.titleLabel.font = kFont14;
        [_registerButton setTitleColor:Color16(0x407CED) forState:UIControlStateNormal];
        //        _forgetButton.backgroundColor = [UIColor orangeColor];
    }
    return _registerButton;
}
- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = kFont14;
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.text = NSLocalizedString(@"还没有账号", nil);
        [_tipLabel sizeToFit];
        //        _tipLabel.backgroundColor = [UIColor orangeColor];
    }
    return _tipLabel;
}

- (UIView *)userLineView {
    if (!_userLineView) {
        _userLineView = [[UIView alloc] init];
        _userLineView.backgroundColor = Color10(224,224,224, 1);
    }
    return _userLineView;
}

- (UIView *)passwordLineView {
    if (!_passwordLineView) {
        _passwordLineView = [[UIView alloc] init];
        _passwordLineView.backgroundColor = Color10(224,224,224, 1);
    }
    return _passwordLineView;
}
@end
