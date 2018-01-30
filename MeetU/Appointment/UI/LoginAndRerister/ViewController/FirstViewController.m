//
//  FirstViewController.m
//  taiwantongcheng
//
//  Created by feiwu on 2016/11/23.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "FirstViewController.h"
#import "FacebookLoginApi.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "CustomNavigationController.h"
#import "LXFileManager.h"
#import "JPUSHService.h"
#import "QuestionViewController.h"
#import "AppDelegate.h"
#import "NSString+MZYExtension.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"app首页"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"app首页"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
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
    
    [self.view addSubview:self.facebookButton];
    [self.view addSubview:self.registerButton];
    
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.tipLabel];
    
    [_loginBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view).offset(0);
        make.left.mas_equalTo(weakSelf.view).offset(0);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, ScreenHeight));
    }];
    
    [_facebookButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.view).offset(-134.5);
        make.left.mas_equalTo(weakSelf.view).offset(33.5);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 67, 42));
    }];
    
    [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.view).offset(-75);
        make.left.mas_equalTo(weakSelf.view).offset(33.5);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 67, 42));
    }];
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.view).offset(-37);
        make.centerX.mas_equalTo(weakSelf.view).offset(40);
        make.size.mas_equalTo(CGSizeMake(120, 16.5));
        
    }];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.view).offset(-38);
        make.right.mas_equalTo(weakSelf.loginButton.mas_left);
        
    }];

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
             NSLog(@"错误信息:%@",error);
         }
         
     }];
}

- (void)loginAction:(UIButton *)button
{
    LoginViewController *login = [[LoginViewController alloc] init];
    [self presentViewController:login animated:NO completion:^{
        
    }];

}

- (void)registerAction:(UIButton *)button
{
    RegisterViewController *reg = [[RegisterViewController alloc] init];
    [self presentViewController:reg animated:NO completion:^{
        
    }];

}
#pragma mark - Network Data
#pragma mark - 第三方登录
- (void)thirdLoginRequest:(NSString *)user_id Nickname:(NSString *)nickname Sex:(NSString *)sex Photo:(NSString *)photo Age:(NSString *)age Third_id:(NSString *)third_id Locale:(NSString *)locale Tag:(NSString *)tag{
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
      NSString  *mid = [NSString stringWithFormat:@"%@",[[result objectForKey:@"data"] objectForKey:@"user_id"]];
        //头像
        NSString *userImage = [NSString stringWithFormat:@"%@",[[result objectForKey:@"data"] objectForKey:@"photo"]];
        [LXFileManager saveUserData:userImage forKey:[NSString stringWithFormat:@"%@userImage",mid]];

      
        //存储用户信息
        FWUserInformation* information = [FWUserInformation sharedInstance];
        information.sex = sex;
        information.age = age;
        information.mid = mid;
        [information saveUserInformation];
        
        //存储 PHPSESSID
        [LXFileManager saveUserData:[result objectForKey:kUserPHPSESSID] forKey:kUserPHPSESSID];
        
        NSString *valid = [NSString stringWithFormat:@"%ld", time(NULL)];
        NSString *validKey = [NSString stringWithFormat:@"%@%@",mid,kUserPHPSESSID];
        [LXFileManager saveUserData:valid forKey:validKey];
        
        //极光推送设置别名
        [JPUSHService setTags:[NSSet setWithObjects:age,sex, nil] alias:mid fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            NSLog(@"ialias:%@",iAlias);
        }];

        //跳转
        [self pushQuestion];
        
    } else if ([code intValue] == kNetWorkNoSetSexCode) {
        [self hideHUD];
    } else {
        [self hideHUD];
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
    }
}
- (void)pushQuestion
{
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
        _loginBackgroundView.image =  LOADIMAGE(@"first_bg", @"jpg");
        _loginBackgroundView.contentMode = UIViewContentModeScaleToFill;
    }
    return _loginBackgroundView;
}


- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] init];
        [_loginButton setTitle:NSLocalizedString(@"点击登入", nil) forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.titleLabel.font = kFont12;
         [_loginButton setTitleColor:Color16(0x407CED) forState:UIControlStateNormal];
}
    return _loginButton;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = kFont12;
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.text = NSLocalizedString(@"还没有账号", nil);
        [_tipLabel sizeToFit];
//                _tipLabel.backgroundColor = [UIColor orangeColor];
    }
    return _tipLabel;
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
            _facebookButton.hidden = YES;
        } else {
            _facebookButton.hidden = NO;
        }
    }
    return _facebookButton;
}

- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [[UIButton alloc] init];
        [_registerButton setTitle:NSLocalizedString(@"注册成为会员", nil) forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
        _registerButton.titleLabel.font = kFont14;
        _registerButton.backgroundColor = [UIColor lightGrayColor];
        [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        _registerButton.backgroundColor = Color16(0xFF6478);
        _registerButton.layer.cornerRadius = 5;
    }
    return _registerButton;
}


@end
