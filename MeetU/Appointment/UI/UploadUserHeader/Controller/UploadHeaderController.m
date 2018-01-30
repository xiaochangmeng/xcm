//
//  UploadHeaderController.m
//  Appointment
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "UploadHeaderController.h"
#import "DaliyRecommendViewController.h"
#import "AppDelegate.h"
#import "FWImageUtils.h"
#import "MyUploadImageApi.h"
#import "LXFileManager.h"
#import "NSDate+MZYExtension.h"

@interface UploadHeaderController ()<FWImageUtilsDelegate>
/**第六个问题 */
@property (strong, nonatomic) UILabel* question_6;
/**跳过按钮 */
@property (strong, nonatomic) UIButton* skipButton;
/**顶部横线 */
@property (strong, nonatomic) UILabel* topLine;
/**头像 */
@property (strong, nonatomic) UIImageView* headerImageView;
/**拍照上传 */
@property (strong, nonatomic) UIButton* openCamera;
/**本地上传 */
@property (strong, nonatomic) UIButton* openLibrary;
/**显示类型 */
@property (strong, nonatomic) NSString* type;

@end

@implementation UploadHeaderController

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
    [MobClick beginLogPageView:@"上传头像页面"];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"上传头像页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    if ([_type isEqualToString:@"login"]) {
        NSString *currentDate = [NSDate getDate:[NSDate date] dateFormatter:@"yyyyMMdd"];
        NSString *mid = [FWUserInformation sharedInstance].mid;
        NSString *key = [NSString stringWithFormat:@"%@%@",currentDate,mid];
        [LXFileManager saveUserData:@"1" forKey:key];
    }
}

/**
 *  初始化试图
 */
- (void)setupView{
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    //注册
    if ([_type isEqualToString:@"register"]) {
        [self.view addSubview:self.question_6];
        [self.view addSubview:self.topLine];
        //女性用户必须上传头像
        if ([[FWUserInformation sharedInstance].sex integerValue] != 0) {
            [self.view addSubview:self.skipButton];
        }
    }
    
    //登录
    if ([_type isEqualToString:@"login"]) {
        [self.view addSubview:self.skipButton];
    }
    
    
    [self.view addSubview:self.headerImageView];
    [self.view addSubview:self.openCamera];
    [self.view addSubview:self.openLibrary];
    
    [self initMakeConstraints];
}

/**
 *  约束
 */
- (void)initMakeConstraints{
    WS(weakSelf);
    if (![_type isEqualToString:@"login"]) {
        [_question_6 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.view).offset(kHeightIP6(39));
            make.left.mas_equalTo(weakSelf.view).offset(22);
            make.width.mas_equalTo(127.5);
            make.height.mas_equalTo(23);
        }];
        
        [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.view).offset(kHeightIP6(84.5));
            make.left.mas_equalTo(weakSelf.view).offset(22.5);
            make.right.mas_equalTo(weakSelf.view).offset(-22.5);
            make.height.mas_equalTo(1);
        }];
        
    }
    
    
    [_skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view).offset(39);
        make.right.mas_equalTo(weakSelf.view).offset(-22);
        make.width.mas_equalTo(kPercentIP6(34.5));
        make.height.mas_equalTo(kHeightIP6(28));
    }];
    
    
    [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view).offset(kHeightIP6(120));
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX).offset(0);
        make.width.mas_equalTo(kPercentIP6(295));
        make.height.mas_equalTo(kHeightIP6(340));
    }];
    
    [_openCamera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.headerImageView.mas_bottom).offset(kHeightIP6(80));
        make.left.mas_equalTo(weakSelf.view).offset(25);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo((ScreenWidth - 80 ) / 2.0);
    }];
    
    [_openLibrary mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.headerImageView.mas_bottom).offset(kHeightIP6(80));
        make.right.mas_equalTo(weakSelf.view).offset(-25);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo((ScreenWidth - 80 ) / 2.0);    }];
}
#pragma mark - Event Responses
/**
 *  跳转到主页
 *
 *  @param sender sender
 */
- (void)skipButtonHandle:(UIButton*)sender{
    if ([_type isEqualToString:@"login"]) {
        //登录
        DaliyRecommendViewController *recommend = [[DaliyRecommendViewController alloc] init];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.window.rootViewController = recommend;
    } else {
        //注册
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.window.rootViewController = [appDelegate.viewControllers objectAtIndex:0];
        
    }
}

/**
 *  开启相册
 *
 *  @param sender sender
 */
- (void)openLibraryHandle:(UIButton*)sender{
    [FWImageUtils sharedInstance].delegate = self;
    [[FWImageUtils sharedInstance] chooseImageForLibiary:self];
}


/**
 *  打开相机
 *
 *  @param sender sender
 */
- (void)openCameraHandle:(UIButton*)sender{
    [FWImageUtils sharedInstance].delegate = self;
    [[FWImageUtils sharedInstance] chooseImageForCamera:self];
}

#pragma mark - Network Data
/**
 *  拍照 或 选择照片之后的地址
 *
 *  @param imagePath 图片地址
 */
- (void)chooseImageEnd:(NSString *)imagePath{
    self.headerImageView.image = [UIImage imageWithContentsOfFile:imagePath];
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    MyUploadImageApi* api = [[MyUploadImageApi alloc] initWithImage:self.headerImageView.image Type:@"img"];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf setUploadImageRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        [weakSelf hideHUD];
        [weakSelf showHUDFail:kNetWorkErrorTitle];
        [weakSelf hideHUDDelay:1];
    }];
}

/**
 *  上传结果
 *
 *  @param dictionary dictionary
 */
- (void)setUploadImageRequestFinish:(NSDictionary*)dictionary{
    NSLog(@"返回值是多少:%@",dictionary);
    if ([[dictionary objectForKey:@"code"] isEqualToString:@"200"]) {//上传成功
        [self hideHUD];
        [self showHUDComplete:NSLocalizedString(@"头像设置成功", @"头像设置成功")];
        [self hideHUDDelay:1];
        [self performSelector:@selector(skipButtonHandle:) withObject:nil afterDelay:2];
        NSString *key = [NSString stringWithFormat:@"%@userImage",[FWUserInformation sharedInstance].mid];
        NSString *value = [dictionary objectForKey:@"data"];
        [LXFileManager saveUserData:value forKey:key];
        
    }else{
        [self hideHUD];
        [self showHUDFail:NSLocalizedString(@"头像设置失败", nil)];
        [self hideHUDDelay:1];
    }
}

#pragma mark - Getters And Setters
/**懒加载初始化各个控件 */
- (UILabel *)question_6{
    if (_question_6 == nil) {
        _question_6 = [UILabel new];
        _question_6.text = [NSString stringWithFormat:@"%@ (5/5)",NSLocalizedString(@"愛情拷問", nil)];
        _question_6.font = [UIFont systemFontOfSize:kPercentIP6(17)];
        _question_6.textColor = Color10(51, 51, 51, 1);
    }
    return _question_6;
}

- (UIButton *)skipButton{
    if (_skipButton == nil) {
        _skipButton = [UIButton new];
        [_skipButton setTitle:NSLocalizedString(@"跳过", nil) forState:UIControlStateNormal];
        _skipButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_skipButton setTitleColor:Color10(204, 204, 204, 1) forState:UIControlStateNormal];
        [_skipButton addTarget:self action:@selector(skipButtonHandle:) forControlEvents:UIControlEventTouchDown];
    }
    return _skipButton;
}

- (UILabel *)topLine{
    if (_topLine == nil) {
        _topLine = [UILabel new];
        _topLine.backgroundColor = Color10(216, 216, 216, 1);
    }
    return _topLine;
}


- (UIImageView *)headerImageView{
    if (_headerImageView == nil) {
        _headerImageView = [UIImageView new];
        if ([[FWUserInformation sharedInstance].sex isEqualToString:@"1"]) {
            _headerImageView.image =LOADIMAGE(NSLocalizedString(@"uploadHeaderDefaultMan", nil), @"png");
        }else{
            _headerImageView.image =LOADIMAGE(@"uploadHeaderDefaultWoman@2x", @"png");
        }
    }
    return _headerImageView;
}

- (UIButton *)openCamera{
    if (_openCamera == nil) {
        _openCamera = [UIButton new];
        [_openCamera setTitle:NSLocalizedString(@"拍照上传", nil) forState:UIControlStateNormal];
        _openCamera.titleLabel.font =[UIFont systemFontOfSize:14];
        [_openCamera setTitleColor:Color16(0xF85F73) forState:UIControlStateNormal];
        _openCamera.layer.borderColor = Color16(0xF85F73).CGColor;
        _openCamera.layer.borderWidth = 0.5;
        [_openCamera addTarget:self action:@selector(openCameraHandle:) forControlEvents:UIControlEventTouchDown];
    }
    return _openCamera;
}

- (UIButton *)openLibrary{
    if (_openLibrary == nil) {
        _openLibrary = [UIButton new];
        [_openLibrary setTitle:NSLocalizedString(@"本地图片上载", nil) forState:UIControlStateNormal];
        _openLibrary.titleLabel.font =[UIFont systemFontOfSize:14];
        [_openLibrary setTitleColor:Color16(0xF85F73) forState:UIControlStateNormal];
        _openLibrary.layer.borderColor = Color16(0xF85F73).CGColor;
        _openLibrary.layer.borderWidth = 0.5;
        [_openLibrary addTarget:self action:@selector(openLibraryHandle:) forControlEvents:UIControlEventTouchDown];
    }
    return _openLibrary;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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
