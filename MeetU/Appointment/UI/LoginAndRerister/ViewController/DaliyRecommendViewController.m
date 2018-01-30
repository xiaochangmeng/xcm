//
//  DaliyRecommendViewController.m
//  Appointment
//
//  Created by feiwu on 16/7/22.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "DaliyRecommendViewController.h"
#import "AppDelegate.h"
#import "RecommentItem.h"
#import "DaliyRecommendApi.h"
#import "FateHelloApi.h"
#import "FateModel.h"
#import "NSDate+MZYExtension.h"
#import "LXFileManager.h"
#import "LoginViewController.h"
@interface DaliyRecommendViewController ()

@end

@implementation DaliyRecommendViewController

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"每日推荐页面"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"每日推荐页面"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideHUD];//隐藏指示器
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Color16(0xF85F73);
    self.title = NSLocalizedString(@"每日推荐", nil);
    _currentIndex = 0;
    _likeMids = @"";
    
    [self initView];
    
    //设置当前是否显示每日推荐
    
    NSString *currentDate = [NSDate getDate:[NSDate date] dateFormatter:@"yyyyMMdd"];
    NSString *mid = [FWUserInformation sharedInstance].mid;
    NSString *key = [NSString stringWithFormat:@"%@%@",currentDate,mid];
    [LXFileManager saveUserData:@"1" forKey:key];
    
    [self getRecommendListRequest];//每日推荐
    
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
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.pickView];
    [self.view addSubview:self.nextButton];
    [self.view addSubview:self.likeButton];
    [self.view addSubview:self.ignoreButton];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.centerX.mas_equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    [_pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).offset(kPercentIP6(40));
        make.centerX.mas_equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - (IS_IPHONE_4S ? 130 : 80), ScreenHeight - 260 - kPercentIP6(20)));
    }];
    
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.pickView.mas_bottom).offset(50);
        make.left.mas_equalTo(weakSelf.pickView.mas_left);
        make.size.mas_equalTo(CGSizeMake(74, 74));
    }];
    
    [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.pickView.mas_bottom).offset(50);
        make.right.mas_equalTo(weakSelf.pickView.mas_right);
        make.size.mas_equalTo(CGSizeMake(74, 74));
    }];
    
    [_ignoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.view).offset(-20);
        make.centerX.mas_equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 150, 40));
    }];
    
    
}

#pragma 移除引导页
- (void)removeGuideView {
    [LXFileManager saveUserData:@"1" forKey:@"guideDaliy"];
    [_daliyGuideView removeFromSuperview];
    _daliyGuideView = nil;
}


#pragma mark - Event Response
- (void)nextAction:(UIButton *)button
{
    [_pickView removeTopViewWithType:MoveToLeft];
}

- (void)likeAction:(UIButton *)button
{
    [_pickView removeTopViewWithType:MoveToRight];
}

- (void)ignoreAction:(UIButton *)button
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = [appDelegate.viewControllers objectAtIndex:0];
    
}
#pragma mark - CXSlidingViewDatasouce

- (NSInteger)numberOfItemInSlidingView:(CXSlidingView *)slidingView {
    return _imagesArray.count;
}

- (CXSlidingViewItem *)slidingView:(CXSlidingView *)slidingView itemWithNumber:(NSInteger )index {
    static NSString * itemID = @"RecommentItem";
    RecommentItem * item = (RecommentItem *)[slidingView dequeueReusableItemWithIdentifier:itemID];
    if (!item) {
        item = [[RecommentItem alloc] initWithIdentifier:itemID];
    }
    FateModel *model = _imagesArray[index];
    [item.imageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:LOADIMAGE(NSLocalizedString(@"fate_headPlaceholder", nil), @"png")];
    item.nickLabel.text = model.name;
    item.ageLabel.text = [NSString stringWithFormat:@"%@ %@",model.age,model.region_name];
    
    
    return item;
}

#pragma mark - CXSlidingViewDelegate
- (void)topViewRemovedFromSupperView:(CXSlidingView *)slidingView slidingViewItem:(CXSlidingViewItem *)item {
    _currentIndex = item.index + 1;
    
    //是否右滑
    if (item.moveType == MoveToRight) {
        FateModel *model = _imagesArray[item.index];
        if ([model.helloed isEqualToString:@"0"]) {
            _likeMids = [NSString stringWithFormat:@"%@,%@",_likeMids,model.user_id];
        }
    }
    
    //切换根视图控制器
    if (item.index == 6) {
        if (_likeMids.length > 3) {
            NSString *mids = [_likeMids substringFromIndex:1];
            //切换到首页加载慢,先不处理
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                FateHelloApi *api = [[FateHelloApi alloc] initWithMid:mids];
                [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
                    LogBlue(@"群打招呼:%@",request.responseString);
                } failure:^(YTKBaseRequest *request) {
                    LogYellow(@"群打招呼请求失败:%@",request.responseString);
                }];
                
            });
            
            
        }
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.window.rootViewController = [appDelegate.viewControllers objectAtIndex:0];
        
    }
}


- (BOOL)lastSlidingViewCanMove
{
    return YES;
}
- (BOOL)cycleWithSlidingView:(CXSlidingView *)slidingView
{
    return NO;
}


#pragma mark - Network Data
#pragma mark - 每日推荐
- (void)getRecommendListRequest {
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    DaliyRecommendApi *api = [[DaliyRecommendApi alloc] init];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf hideHUD];
        [weakSelf getRecommendListRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        [weakSelf hideHUD];
        [weakSelf showHUDFail:kNetWorkErrorTitle];
        [weakSelf hideHUDDelay:1];
        LogYellow(@"每日推荐请求失败:%@",request.responseString);
//        [weakSelf getRecommendListRequest];
    }];
}

- (void)getRecommendListRequestFinish:(NSDictionary *)result{
    LogOrange(@"每日推荐请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        
        NSMutableArray *recommendArray = [NSMutableArray arrayWithArray:[result objectForKey:@"data"]];
        //是否有数据
        if ((NSNull *)recommendArray != [NSNull null] && recommendArray.count > 0)  {
            if (!_imagesArray) {
                _imagesArray = [NSMutableArray array];
            }
            for (NSDictionary *dic in recommendArray) {
                FateModel *model = [[FateModel alloc] initWithDataDic:dic];
                [_imagesArray addObject:model];
            }
            
            [_pickView reloadSlidingView];
            
            NSString *guide = [LXFileManager readUserDataForKey:@"guideDaliy"];
            if (![guide isEqualToString:@"1"]) {
                [self.view addSubview:self.daliyGuideView];
                [self performSelector:@selector(removeGuideView) withObject:nil afterDelay:5];
            }
            
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
        [weakSelf getRecommendListRequest];
    };
    [self presentViewController:login animated:NO completion:^{
    }];
}


#pragma mark - Getters And Setters

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = NSLocalizedString(@"Ta是你喜欢的类型吗？", nil);
        _titleLabel.font = kFont17;
        _titleLabel.textColor = [UIColor whiteColor];
        //        _titleLabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _titleLabel;
}

- (CXSlidingView *)pickView {
    if (!_pickView) {
        _pickView = [[CXSlidingView alloc] init];
        _pickView.datasouce = self;
        _pickView.delegate = self;
        //        _pickView.backgroundColor = [UIColor orangeColor];
    }
    return _pickView;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
        [_nextButton setBackgroundImage:LOADIMAGE(@"recommend_button_dislike@2x", @"png") forState:UIControlStateNormal];
        //        _nextButton.backgroundColor = [UIColor orangeColor];
    }
    return _nextButton;
}

- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [[UIButton alloc] init];
        [_likeButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        [_likeButton setBackgroundImage:LOADIMAGE(@"recommend_button_like@2x", @"png") forState:UIControlStateNormal];
            //        _likeButton.backgroundColor = [UIColor orangeColor];
    }
    return _likeButton;
}

- (UIButton *)ignoreButton {
    if (!_ignoreButton) {
        _ignoreButton = [[UIButton alloc] init];
        [_ignoreButton addTarget:self action:@selector(ignoreAction:) forControlEvents:UIControlEventTouchUpInside];
        [_ignoreButton setTitle:NSLocalizedString(@"跳过,寻找我的缘分", nil) forState:UIControlStateNormal];
        [_ignoreButton setTitle:NSLocalizedString(@"跳过,寻找我的缘分", nil) forState:UIControlStateHighlighted];
        _ignoreButton.titleLabel.font = kFont14;
        [_ignoreButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        //        _ignoreButton.backgroundColor = [UIColor yellowColor];
    }
    return _ignoreButton;
}

- (DaliyRecommendGuideView *)daliyGuideView {
    if (!_daliyGuideView) {
        _daliyGuideView = [[DaliyRecommendGuideView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _daliyGuideView.userInteractionEnabled = YES;
        _daliyGuideView.backgroundColor = Color10(0, 0, 0, 0.6);
        WS(weakSelf);
        _daliyGuideView.daliyGuideBlock = ^(){
            [LXFileManager saveUserData:@"1" forKey:@"guideDaliy"];
            [weakSelf.daliyGuideView removeFromSuperview];
            weakSelf.daliyGuideView = nil;
        };
        
    }
    return _daliyGuideView;
}

@end

