//
//  LoginPhoneViewController.m
//  Appointment
//  手机号码登录
//  Created by feiwu on 2017/2/21.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "LoginPhoneViewController.h"
#import "RegisterVerifyPhoneCodeApi.h"
#import "RegisPhoneCodeApi.h"
#import "RegexKitLite.h"
#import "RegisterApi.h"
#import "LoginApi.h"
#import "SetSexAndAgeApi.h"
#import "LXFileManager.h"
#import "JPUSHService.h"
#import "AppDelegate.h"
#import "QuestionViewController.h"
#import "CustomNavigationController.h"
typedef enum{
    SendVerificationButtonNormal,   //普通  不可以点击
    SendVerificationButtonSend,     //点击发送验证码
    SendVerificationButtonCalculate//倒计时
}SendVerificationButtonStyle;

typedef enum{
    CommitButtonNormal,              //普通  不可以点击
    CommitButtonValidation,          //可以开始验证
    CommitButtonValidationing,      //验证中
    CommitButtonValidationSuccess//验证成功
}CommitButtonStyle;

@interface LoginPhoneViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) UITextField* phoneTextField;

@property (strong, nonatomic) UITextField* verificationTextField;

@property (strong, nonatomic) UIButton* sendVerificationButton;

@property (strong, nonatomic) UIButton* commitButton;

@property (copy, nonatomic) NSString* type;
@end

@implementation LoginPhoneViewController

#pragma mark - Life Cycle
- (id)initWithType:(NSString *)type
{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"手机认证页面"];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [MobClick endLogPageView:@"手机认证页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isCancel = YES;
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupView{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.title = @"手机认证";
    
    [self.view addSubview:self.phoneTextField];
    
    [self.view addSubview:self.verificationTextField];
    
    [self.view addSubview:self.commitButton];
    
    self.phoneTextField.delegate = self;
    
    self.verificationTextField.delegate = self;
}

#pragma mark - Private Methods
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    BOOL isMatch = [mobileNum isMatchedByRegex:phoneRegex];
    return isMatch;
}
#pragma mark - 设置发送验证码按钮状态
- (void)changeSendVerificationButtonStyle:(SendVerificationButtonStyle)buttonStyle{
    
    //边框颜色
    UIColor* borderColor = buttonStyle == SendVerificationButtonNormal ? Color10(229, 229, 229, 1) : Color10(138, 113, 204, 1);
    _sendVerificationButton.layer.borderColor = borderColor.CGColor;
    
    //标题颜色
    UIColor* titleColor = buttonStyle == SendVerificationButtonNormal ? Color10(153, 153, 153, 1) : Color10(138, 113, 204, 1);
    [_sendVerificationButton setTitleColor:titleColor forState:UIControlStateNormal];
    
    //标题
    NSString* title = buttonStyle == SendVerificationButtonCalculate ? @"" :@"发送验证码";
    [self.sendVerificationButton setTitle:title forState:UIControlStateNormal];
    
    //是否可以点击
    self.sendVerificationButton.enabled = buttonStyle == SendVerificationButtonSend ? YES : NO;
}

#pragma mark - Network Data
#pragma mark - 获取验证码
- (void)sendVerificationButtonHandle:(UIButton*)sender{
    
    if (![self isMobileNumber:self.phoneTextField.text]) {
        [self showHUDFail:@"请正确输入手机号"];
        [self hideHUDDelay:1];
        return;
    }
    [self calculateCountdown:60];
    sender.enabled = NO;
    NSString* phone = self.phoneTextField.text;
    
    RegisPhoneCodeApi* getCodeApi = [[RegisPhoneCodeApi alloc] initWithPhoneNumber:phone];
    [getCodeApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [self showHUDComplete:@"验证码已发送"];
        [self hideHUDDelay:2];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"发送验证码失败:%@",request.responseString);
    }];

}

#pragma mark - 验证验证码
- (void)commitButtonHandle:(UIButton*)sender{
    if (self.phoneTextField.text.length != 11) {
        [self showHUDFail:@"请确保手机号正确"];
        [self hideHUDDelay:1];
        return;
    }
    
    [self.view endEditing:YES];
    
    [self changeCommitButtonStyle:CommitButtonValidationing];
    RegisterVerifyPhoneCodeApi* verifyPhoneApi = [[RegisterVerifyPhoneCodeApi alloc] initWithPhoneCode:self.verificationTextField.text];
    
    [verifyPhoneApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self verifyRequestFinish:request.responseJSONObject];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self changeCommitButtonStyle:CommitButtonValidation];
    }];
}

- (void)verifyRequestFinish:(NSDictionary*)dictionary{
    NSLog(@"手机验证码验证成功:%@",dictionary);
    if ([[dictionary objectForKey:@"code"] isEqualToString:@"200"]) {
        [self changeCommitButtonStyle:CommitButtonValidationSuccess];
        if ([_type isEqualToString:@"1"]) {
            [self registerRequest];//注册
        } else if ([_type isEqualToString:@"2"]) {
            //设置已验证手机号
            NSString *key = [NSString stringWithFormat:@"%@phone",[FWUserInformation sharedInstance].mid];
            [LXFileManager saveUserData:@"1" forKey:key];

            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
      
    }else{
        [self changeCommitButtonStyle:CommitButtonValidation];
        [self showHUDFail:@"验证失败"];
        [self hideHUDDelay:1];
    }
}

#pragma mark - 注册
- (void)registerRequest {
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    RegisterApi*api = [[RegisterApi alloc] init];
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
        _uid = [userinfo objectForKey:@"uid"];
        _password = [userinfo objectForKey:@"password"];
        [LXFileManager saveUserData:userinfo forKey:[NSString stringWithFormat:@"%@password",_uid]];
        
        FWUserInformation* information = [FWUserInformation sharedInstance];
        [information saveUserInformation];
        //登录
        [self loginRequesWithUserName:_uid Password:_password];
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
        NSString *mid = [NSString stringWithFormat:@"%@",[[result objectForKey:@"data"] objectForKey:@"mid"]];
        
        //手机号验证
        NSString *key = [NSString stringWithFormat:@"%@phone",mid];
        [LXFileManager saveUserData:@"1" forKey:key];
        
        //个人信息初始化
        FWUserInformation* info = [FWUserInformation sharedInstance];
        info.sex = sex;
        info.age = age;
        info.mid = mid;
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
        //设置性别与年龄
        [self setRequesWithSex:_sex Age:_age];
    } else {
        [self hideHUD];
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
    }
}

#pragma mark - 设置性别与年龄
- (void)setRequesWithSex:(NSString *)sex Age:(NSString *)age {
    WS(weakSelf);
    LogOrange(@"性别是：%@, 年龄：%@",sex,age);
    SetSexAndAgeApi*api = [[SetSexAndAgeApi alloc] initWithSex:sex Age:age Mobile:_phoneTextField.text];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf setRequesFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"设置性别请求失败:%@",request.responseString);
        [weakSelf hideHUD];
        [weakSelf showHUDFail:kNetWorkErrorTitle];
        [weakSelf hideHUDDelay:1];
    }];
}

- (void)setRequesFinish:(NSDictionary *)result{
    LogOrange(@"设置性别请求成功:%@",result);
    [self hideHUD];
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        NSString *age = [NSString stringWithFormat:@"%@",[[result objectForKey:@"data"] objectForKey:@"age"]];
        NSString *sex = [NSString stringWithFormat:@"%@",[[result objectForKey:@"data"] objectForKey:@"sex"]];
        NSString *mid = [NSString stringWithFormat:@"%@",[[result objectForKey:@"data"] objectForKey:@"mid"]];
        
        //设置已验证手机号
        NSString *key = [NSString stringWithFormat:@"%@phone",mid];
        [LXFileManager saveUserData:@"1" forKey:key];
        
        //个人信息初始化
        FWUserInformation* info = [FWUserInformation sharedInstance];
        info.sex = sex;
        info.age = age;
        info.mid = mid;
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

    }else {
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


#pragma mark - commitButton的状态
- (void)changeCommitButtonStyle:(CommitButtonStyle)buttonStyle{
    NSString* title = nil;
    UIColor* backColor = nil;
    BOOL enable = NO;
    switch (buttonStyle) {
        case CommitButtonNormal:{
            title = @"验证";
            backColor = Color10(229, 229, 229, 1);
            enable = NO;
            break;
        }
        case CommitButtonValidation:{
            title = @"验证";
            backColor = Color10(138, 113, 204, 1);
            enable = YES;
            break;
        }
        case CommitButtonValidationing:{
            title = @"正在验证中...";
            backColor = Color10(138, 113, 204, 1);
            enable = NO;
            break;
        }
        case CommitButtonValidationSuccess:{
            title = @"恭喜!验证通过";
            backColor = NavColor;
            enable = NO;
            break;
        }
    }
    [self.commitButton setTitle:title forState:UIControlStateNormal];
    [self.commitButton setBackgroundColor:backColor];
    self.commitButton.enabled = enable;
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.phoneTextField) {
        NSString* phone = [textField.text stringByAppendingString:string];
        if ([string isEqualToString:@""]) {
            phone = [phone substringToIndex:phone.length - 1];
        }
        if (phone.length == 11) {
            [self changeSendVerificationButtonStyle:SendVerificationButtonSend];
        }else{
            [self changeSendVerificationButtonStyle:SendVerificationButtonNormal];
        }
    }else if (textField == self.verificationTextField){
        NSString* verification = [textField.text stringByAppendingString:string];
        if ([string isEqualToString:@""]) {
            verification = [verification substringToIndex:verification.length - 1];
        }
        if (verification.length >= 4) {
            [self changeCommitButtonStyle:CommitButtonValidation];
        }else{
            [self changeCommitButtonStyle:CommitButtonNormal];
        }
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark - 验证码输入框 右侧按钮视图
- (void)setSendVerificationButtonToVerificationTextField{
    
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 79.5 + 16, _verificationTextField.frame.size.height)];
    backView.userInteractionEnabled = YES;
    _sendVerificationButton = [[UIButton alloc]initWithFrame:CGRectMake(0, backView.frame.size.height / 2 - 16.75, 79.5, 33.5)];
    
    [_sendVerificationButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    
    [_sendVerificationButton setTitleColor:Color10(153, 153, 153, 1) forState:UIControlStateNormal];
    
    _sendVerificationButton.enabled = NO;
    
    _sendVerificationButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _sendVerificationButton.layer.cornerRadius = 5;
    _sendVerificationButton.layer.masksToBounds = YES;
    _sendVerificationButton.layer.borderColor = Color10(242, 242, 242, 1).CGColor;
    _sendVerificationButton.layer.borderWidth = 1;
    [_sendVerificationButton addTarget:self action:@selector(sendVerificationButtonHandle:) forControlEvents:UIControlEventTouchDown];
    [backView addSubview:_sendVerificationButton];
    
    _verificationTextField.rightViewMode = UITextFieldViewModeAlways;
    _verificationTextField.rightView = backView;
    
}

#pragma mark - calculateCountdown倒计时
- (void)calculateCountdown:(NSInteger)time{
    __weak typeof(self) weakSelf = self;
    __block int timeout = (int)time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf changeSendVerificationButtonStyle:SendVerificationButtonSend];
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%02ds",timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [weakSelf.sendVerificationButton setTitle:strTime forState:UIControlStateNormal];
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - Getters And Setters
- (UITextField *)phoneTextField{
    if (_phoneTextField == nil) {
        _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        _phoneTextField.font = [UIFont systemFontOfSize:15];
        _phoneTextField.textColor = Color10(51, 51, 51, 1);
        _phoneTextField.placeholder = @"点此输入";
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        UILabel* leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 97, _phoneTextField.frame.size.height)];
        leftLabel.text = @"手机号码";
        leftLabel.font = [UIFont systemFontOfSize:13];
        leftLabel.textColor = Color10(153, 153, 153, 1);
        leftLabel.textAlignment = NSTextAlignmentCenter;
        _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
        _phoneTextField.leftView = leftLabel;
        
        //底部划线
        UILabel* bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, _phoneTextField.frame.size.height - 1, _phoneTextField.frame.size.width, 1)];
        [bottomLine setBackgroundColor:Color10(246, 246, 246, 1)];
        [_phoneTextField addSubview:bottomLine];
        
    }
    return _phoneTextField;
}

- (UITextField *)verificationTextField{
    if (_verificationTextField == nil) {
        _verificationTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, _phoneTextField.frame.size.height, _phoneTextField.frame.size.width, _phoneTextField.frame.size.height)];
        _verificationTextField.font = [UIFont systemFontOfSize:15];
        _verificationTextField.textColor = Color10(51, 51, 51, 1);
        _verificationTextField.placeholder = @"点此输入";
        _verificationTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        UILabel* leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 97, _phoneTextField.frame.size.height)];
        leftLabel.text = @"验证码";
        leftLabel.font = [UIFont systemFontOfSize:13];
        leftLabel.textColor = Color10(153, 153, 153, 1);
        leftLabel.textAlignment = NSTextAlignmentCenter;
        _verificationTextField.leftViewMode = UITextFieldViewModeAlways;
        _verificationTextField.leftView = leftLabel;
        
        [self setSendVerificationButtonToVerificationTextField];
        
        //底部划线
        UILabel* bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, _verificationTextField.frame.size.height - 1, _verificationTextField.frame.size.width, 1)];
        [bottomLine setBackgroundColor:Color10(246, 246, 246, 1)];
        [_verificationTextField addSubview:bottomLine];
    }
    return _verificationTextField;
}

- (UIButton *)commitButton{
    if (_commitButton == nil) {
        _commitButton = [[UIButton alloc] initWithFrame:CGRectMake(15, _verificationTextField.frame.size.height + _verificationTextField.frame.origin.y + 15, ScreenWidth - 30, 44)];
        
        [_commitButton setTitle:@"验证" forState:UIControlStateNormal];
        [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _commitButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_commitButton setBackgroundColor:NavColor];
        _commitButton.layer.cornerRadius = 6;
        _commitButton.layer.masksToBounds = YES;
        
        [_commitButton addTarget:self action:@selector(commitButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}

#pragma mark 图片拉伸
+ (UIImage *)imageNamed:(NSString *)name ImageType:(NSString *)type withTop:(float)top andLeft:(float)left
{
    CGFloat bottom = top; // 底端盖高度
    CGFloat right = left; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    UIImage *image = LOADIMAGE(name, type);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    return image;
}
/** Proxy class for AVAudioSession that adds a locking mechanism similar to
 *  AVCaptureDevice. This is used to that interleaving configurations between
 *  WebRTC and the application layer are avoided. Only setter methods are
 *  currently proxied. Getters can be accessed directly off AVAudioSession.
 *
 *  RTCAudioSession also coordinates activation so that the audio session is
 *  activated only once. See |setActive:error:|.
 */
/*
 在iOS开发过程中，如果要使用到一些跟特定系统版本特性有关的功能，或者要适配低版本系统的用户，还有一些方法是新版本系统才有的，有一些方法在新版本中已经弃用了，这都需要对不同系统版本的设备进行分别的处理，而这有个前提就是判断系统的版本号。
 
 判断系统版本号有多种方法，这里都列出来供大家和自己在开发中需要时进行选择使用。
 CFBundleVersion，标识（发布或未发布）的内部版本号。这是一个单调增加的字符串，包括一个或多个时期分隔的整数。
 
 CFBundleShortVersionString  标识应用程序的发布版本号。该版本的版本号是三个时期分隔的整数组成的字符串。第一个整数代表重大修改的版本，如实现新的功能或重大变化的修订。第二个整数表示的修订，实现较突出的特点。第三个整数代表维护版本。该键的值不同于“CFBundleVersion”标识。
 
 版本号的管理是一个谨慎的事情，希望各位开发者了解其中的意义。
 
 比较小白，更新应用的时候遇到版本号CFBundleShortVersionString命名的错误，导致无法更新，后来看了文档研究下发现是这样，希望给不了解的人以启示；
 */
-(void)versiontTEST{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    //手机序列号
    //    NSString* identifierNumber = [[UIDevice currentDevice] uniqueIdentifier];
    NSLog(@"手机序列号: %@",@"identifierNumberidentifierNumberidentifierNumberidentifierNumberidentifierNumber");
    //手机别名： 用户定义的名称
    NSString* userPhoneName = [[UIDevice currentDevice] name];
    NSLog(@"手机别名: %@", userPhoneName);
    //设备名称
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    NSLog(@"设备名称: %@",deviceName );
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本: %@", phoneVersion);
    //手机型号
    NSString* phoneModel = [[UIDevice currentDevice] model];
    NSLog(@"手机型号: %@",phoneModel );
    //地方型号 （国际化区域名称）
    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    NSLog(@"国际化区域名称: %@",localPhoneModel );
    
    NSDictionary *infoDictionary1 = [[NSBundle mainBundle] infoDictionary];
    // 当前应用名称
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"当前应用名称：%@",appCurName);
    // 当前应用软件版本 比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    // 当前应用版本号码  int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"当前应用版本号码：%@",appCurVersionNum); }

@end
