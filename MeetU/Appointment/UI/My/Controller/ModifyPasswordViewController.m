//
//  ModifyPasswordViewController.m
//  Appointment
//
//  Created by feiwu on 16/7/16.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "RegexKitLite.h"
#import "MyModifyPasswordApi.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "LXFileManager.h"
@interface ModifyPasswordViewController ()
{
    NSString *_userCount;
    NSString *_userPassword;
}
@end

@implementation ModifyPasswordViewController

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initRrightBarItem];
    [MobClick beginLogPageView:@"修改密码页面"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //移除底部弹窗视图
    [MobClick endLogPageView:@"修改密码页面"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideHUD];//隐藏指示器
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"修改密码", nil);
    self.isBack = YES;
    
    //获取登录信息
    NSString *mid = [FWUserInformation sharedInstance].mid;
    NSDictionary *dic = [LXFileManager readUserDataForKey:[NSString stringWithFormat:@"%@password",mid]];
    _userCount = [dic objectForKey:@"user_id"];
    _userPassword = [dic objectForKey:@"password"];
    LogOrange(@"保存的注册信息:%@",dic);
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 导航栏右侧按钮
- (void)initRrightBarItem{
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64/2, 64/2)];
    [self.rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.titleLabel.font = kFont14;
    [self.rightButton setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
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

- (void)initView {
    WS(weakSelf);
    [self.view addSubview:self.userCountLabel];
    [self.view addSubview:self.userCountText];
    [self.view addSubview:self.userCountLineView];
    [self.view addSubview:self.userPasswordLabel];
    [self.view addSubview:self.userPasswordText];
    [self.view addSubview:self.userPasswordLineView];
    [self.view addSubview:self.userTwicePasswordLabel];
    [self.view addSubview:self.userTwicePasswordText];
    [self.view addSubview:self.userTwicePasswordLineView];
    
    [_userCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(15);
        make.top.mas_equalTo(weakSelf.view).offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    [_userCountText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.view).offset(-20);
        make.top.mas_equalTo(weakSelf.view).offset(10);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 125, 20));
    }];
    
    [_userCountLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(12);
        make.top.mas_equalTo(weakSelf.userCountText.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 24, 1));
    }];
    
    [_userPasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(15);
        make.top.mas_equalTo(weakSelf.userCountLineView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(130, 20));
    }];
    
    [_userPasswordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.view).offset(-20);
        make.top.mas_equalTo(weakSelf.userCountLineView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 175, 20));
    }];
    
    [_userPasswordLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(12);
        make.top.mas_equalTo(weakSelf.userPasswordText.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 24, 1));
    }];
    
    [_userTwicePasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(15);
        make.top.mas_equalTo(weakSelf.userPasswordLineView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(130, 20));
    }];
    
    [_userTwicePasswordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.view).offset(-20);
        make.top.mas_equalTo(weakSelf.userPasswordLineView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 175, 20));
    }];
    
    [_userTwicePasswordLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(12);
        make.top.mas_equalTo(weakSelf.userTwicePasswordText.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 24, 1));
    }];

    
}
#pragma mark - Event Responses

- (void)clickRightButton:(UIButton *)button
{
    [_userPasswordText resignFirstResponder];
    [_userTwicePasswordText resignFirstResponder];
    [self validatorPassword];
}

#pragma mark 密码验证
- (void)validatorPassword
{
    if(_userPasswordText.text == nil || [_userPasswordText.text isEqualToString:@""]){
        [self showHUDFail:NSLocalizedString(@"密碼不能為空！", @"密碼不能為空！")];
        [self hideHUDDelay:1];
        return;
    }
    
    NSString *regex = @"\\s+";
    NSArray *array = [_userPasswordText.text componentsMatchedByRegex:regex];
    if (array.count > 0 ) {
        [self showHUDFail:NSLocalizedString(@"密碼不能有空格!", @"密碼不能有空格！")];
        [self hideHUDDelay:1];
        return;
    }
    
    if(_userPasswordText.text.length<6 || _userPasswordText.text.length>16){
        [self showHUDFail:NSLocalizedString(@"密码必须为6至16个字符！", @"密码必须为6至16个字符！")];
        [self hideHUDDelay:1];
        return;
    }
    regex = @"^(?![A-Z]+$)(?![a-z]+$)(?!\\d+$)(?![\\W_]+$)\\S+$";
    array = [_userPasswordText.text componentsMatchedByRegex:regex];
    if (array.count == 0 ) {
        [self showHUDFail:NSLocalizedString(@"密码必须为数字、字母和符号其中两种以上的组合！ , 密码必须为数字、字母和符号其中两种以上的组合！", nil)];
        [self hideHUDDelay:1];
        return;
    }
    
    if(_userTwicePasswordText.text == nil || [_userTwicePasswordText.text isEqualToString:@""]){
        [self showHUDFail:NSLocalizedString(@"确认密码不能为空！", nil)];
        [self hideHUDDelay:1];
        return;
    }
    
    if(![_userTwicePasswordText.text isEqualToString:_userPasswordText.text]){
        [self showHUDFail:NSLocalizedString(@"两次输入不相同！", nil)];
        [self hideHUDDelay:1];
        return;
    }

    
  
//    if ([_userPassword isEqualToString:_userPasswordText.text]) {
//        [self showHUDFail:NSLocalizedString(@"不能和原密码相同！", nil)];
//        [self hideHUDDelay:1];
//        return;
//    }
    
    [self setPasswordRequest];
}

#pragma mark - Network Data
#pragma mark - 修改密码
- (void)setPasswordRequest {
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    MyModifyPasswordApi *api = [[MyModifyPasswordApi alloc] initWithPassword:_userPasswordText.text];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf hideHUD];
        [weakSelf setPasswordRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"修改密码请求失败:%@",request.responseString);
        [weakSelf hideHUD];
        [weakSelf showHUDFail:kNetWorkErrorTitle];
        [weakSelf hideHUDDelay:1];
    }];
}

- (void)setPasswordRequestFinish:(NSDictionary *)result{
            LogOrange(@"修改密码请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        //存储登录信息
        NSDictionary *dic = @{@"user_id":_userCount,@"password":_userPasswordText.text};
        [LXFileManager saveUserData:dic forKey:[NSString stringWithFormat:@"%@password",_userCount]];
        
        //令牌
        [LXFileManager saveUserData:[result objectForKey:kUserPHPSESSID] forKey:kUserPHPSESSID];
        [self showHUDComplete:NSLocalizedString(@"修改密碼成功", nil)];
        [self hideHUDDelay:1];
        
        [self performSelector:@selector(popView) withObject:nil afterDelay:1];
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
    LoginViewController *login = [[LoginViewController alloc] init];
    login.isNoLogin = YES;
    [self presentViewController:login animated:NO completion:^{
        
    }];
}

- (void)popView
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_userPasswordText resignFirstResponder];
}

#pragma mark - Getters And Setters

- (UILabel *)userCountLabel {
    if (!_userCountLabel) {
        _userCountLabel = [[UILabel alloc] init];
        _userCountLabel.text = NSLocalizedString(@"用户帐号", nil);
        _userCountLabel.textAlignment = NSTextAlignmentLeft;
        _userCountLabel.font = kFont15;
        _userCountLabel.textColor = Color10(153, 153, 153, 1);
        //        _userCountLabel.backgroundColor = [UIColor orangeColor];
    }
    return _userCountLabel;
}
- (UILabel *)userCountText {
    if (!_userCountText) {
        _userCountText = [[UILabel alloc] init];
        _userCountText.text = _userCount;
        _userCountText.font = kFont15;
        _userCountText.textColor = Color10(51, 51, 51, 1);
        //        _userCountText.backgroundColor = [UIColor yellowColor];
    }
    return _userCountText;
}
- (UIView *)userCountLineView {
    if (!_userCountLineView) {
        _userCountLineView = [[UIView alloc] init];
        _userCountLineView.backgroundColor = Color10(239, 239, 239, 1);
    }
    return _userCountLineView;
}
- (UILabel *)userPasswordLabel {
    if (!_userPasswordLabel) {
        _userPasswordLabel = [[UILabel alloc] init];
        _userPasswordLabel.text = NSLocalizedString(@"新密码", nil);
        _userPasswordLabel.textAlignment = NSTextAlignmentLeft;
        _userPasswordLabel.font = kFont15;
        _userPasswordLabel.textColor = Color10(153, 153, 153, 1);
        //        _userPasswordLabel.backgroundColor = [UIColor orangeColor];
        
    }
    return _userPasswordLabel;
}

- (UITextField *)userPasswordText {
    if (!_userPasswordText) {
        _userPasswordText = [[UITextField alloc] init];
        _userPasswordText.secureTextEntry = YES;
        _userPasswordText.delegate = self;
        //        _userPasswordText.backgroundColor = [UIColor yellowColor];
    }
    return _userPasswordText;
}
- (UIView *)userPasswordLineView {
    if (!_userPasswordLineView) {
        _userPasswordLineView = [[UIView alloc] init];
        _userPasswordLineView.backgroundColor = Color10(239, 239, 239, 1);
    }
    return _userPasswordLineView;
}

- (UILabel *)userTwicePasswordLabel {
	if (!_userTwicePasswordLabel) {
		_userTwicePasswordLabel = [[UILabel alloc] init];
        _userTwicePasswordLabel.text = NSLocalizedString(@"确认密码", nil);
        _userTwicePasswordLabel.textAlignment = NSTextAlignmentLeft;
        _userTwicePasswordLabel.font = kFont15;
        _userTwicePasswordLabel.textColor = Color10(153, 153, 153, 1);

	}
	return _userTwicePasswordLabel;
}

- (UITextField *)userTwicePasswordText {
	if (!_userTwicePasswordText) {
		_userTwicePasswordText = [[UITextField alloc] init];
        _userTwicePasswordText.secureTextEntry = YES;
        _userTwicePasswordText.delegate = self;
	}
	return _userTwicePasswordText;
}

- (UIView *)userTwicePasswordLineView {
    if (!_userTwicePasswordLineView) {
        _userTwicePasswordLineView = [[UIView alloc] init];
        _userTwicePasswordLineView.backgroundColor = Color10(239, 239, 239, 1);
    }
    return _userTwicePasswordLineView;
}
@end
