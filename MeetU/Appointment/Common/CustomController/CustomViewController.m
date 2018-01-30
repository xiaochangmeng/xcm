//
//  CustomViewController.m
//  Appointment
//
//  Created by feiwu on 16/7/8.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "CustomViewController.h"
#import "AppDelegate.h"
#define INTERVAL 15
@interface CustomViewController ()

@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor  = Color10(237, 237, 237, 1);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && _isBack) {
        
        _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(INTERVAL, 0, 32, 32)];
        
        [_leftButton setBackgroundImage:LOADIMAGE(@"common_back_default@2x", @"png") forState:UIControlStateNormal];
        [_leftButton setBackgroundImage: LOADIMAGE(@"common_back_highlighted@2x", @"png") forState:UIControlStateHighlighted];
        [_leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_leftButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:_leftButton];
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        /**
         *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
         *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
         */
        negativeSpacer.width = -10;
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, backItem, nil];
        
        
        
    }
    
    else if (_isCancel)
    {
        _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(INTERVAL, 0, 32, 32)];
        [_leftButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [_leftButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateHighlighted];
        
        [_leftButton setTitleColor:Color10(255, 255, 255, 1) forState:UIControlStateNormal];
        [_leftButton setTitleColor:Color10(0,0,0, 0.05) forState:UIControlStateHighlighted];
        _leftButton.titleLabel.font = kFont14;
        [_leftButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_leftButton];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        /**
         *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
         *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
         */
        negativeSpacer.width = -10;
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, leftItem, nil];
        
    } else  if(_isText){
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(INTERVAL, 0, 60, 44)];
        [_rightButton setTitleColor:Color10(255, 255, 255, 1) forState:UIControlStateNormal];
        [_rightButton setTitleColor:Color10(0,0,0, 0.05) forState:UIControlStateHighlighted];
        _rightButton.titleLabel.font = kFont14;
        //        _rightButton.height = 44;
        [_rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
        
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

}

#pragma mark - Event Responses
- (void)backAction
{
    if (self.isBack ) {
        if(_navBackBlock){
            _navBackBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:^(void){
        WS(weakSelf);
        if (weakSelf.navCancelBlock) {
            weakSelf.navCancelBlock();
        }

    }];
}

- (void)rightButtonAction{
    if (_rightButtonBlock) {
        self.rightButtonBlock();
    }
}
#pragma mark - 网路异常
/**
 *  显示网络异常视图
 */
- (void)showNetRefresh:(RefreshBlock )refreshBlock
{
    if (_netRetreshView != nil) {
        [_netRetreshView removeFromSuperview];
    }
    
    if ([[self.navigationController.viewControllers firstObject] isEqual:self]) {
        //判断是否是模态跳转
        if (self.navigationController.isBeingPresented || self.isCancel) {
            _netRetreshView = [[MZYNetRefreshView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
        } else {
            _netRetreshView = [[MZYNetRefreshView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 49)];
        }
        
    }
    else {
        _netRetreshView = [[MZYNetRefreshView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    }
    
    _netRetreshView.refreshBlock = refreshBlock;
    [_netRetreshView setNeedsLayout];
    [self.view addSubview:_netRetreshView];
    
}

/**
 *  隐藏网络异常视图
 */
- (void)hideNetRefresh
{
    if (_netRetreshView != nil) {
        [_netRetreshView removeFromSuperview];
    }
}
#pragma mark - 显示未读私信数目
- (void)showNoLetter {
    if ([_titleView superview]!=nil) {
        [_titleView removeFromSuperview];
    }
    
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 75)];
    _titleView.extBottom = 0;
    
    //提示语的Label
    UIImageView *tipView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 75)];
    tipView.image =  LOADIMAGE(NSLocalizedString(@"letter_sendView", nil), @"png");
    [_titleView addSubview:tipView];
    
    if (![_titleView superview]) {
        [self.view addSubview:_titleView];
        //显示的动画
        [UIView animateWithDuration:0.7 animations:^{
            [UIView setAnimationRepeatCount:0];
            _titleView.extTop = 0;
        } completion:^(BOOL finished){
            if (finished) {
                
            }
        }];
        
    }
    
}

#pragma mark - 显示未读私信数目
- (void)showLetterCount:(NSString *)count {
    if ([_titleView superview]!=nil) {
        [_titleView removeFromSuperview];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLetter:)];
    
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
    _titleView.extBottom = 0;
    _titleView.backgroundColor = Color16(0xE666AF);
    [_titleView addGestureRecognizer:tap];
    
    
    //提示语的Label
    UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, ScreenWidth-45, 35)];
    loadLabel.textAlignment = NSTextAlignmentCenter;
    loadLabel.backgroundColor = [UIColor clearColor];
    loadLabel.text = [NSString stringWithFormat:@"%@ %@ %@",NSLocalizedString(@"你有", nil),count,NSLocalizedString(@"条讯息？点击查看", nil)];
    loadLabel.font = kFont14;
    loadLabel.textColor = [UIColor whiteColor];
    loadLabel.numberOfLines = 2;
    [_titleView addSubview:loadLabel];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 40, 0, 35, 35)];
    [cancelButton addTarget:self action:@selector(handleCancel:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setImage:LOADIMAGE(@"common_hint_icon_dismiss@2x", @"png") forState:UIControlStateNormal];
    [_titleView addSubview:cancelButton];
    
    
    if (![_titleView superview]) {
        [self.view addSubview:_titleView];
        //显示的动画
        __weak CustomViewController *this = self;
        [UIView animateWithDuration:0.7 animations:^{
            [UIView setAnimationRepeatCount:0];
            _titleView.extTop = 0;
        } completion:^(BOOL finished){
            if (finished) {
                [this performSelector:@selector(hideTitleView) withObject:nil afterDelay:3];
            }
        }];

    }
    
}

- (void)handleLetter:(UITapGestureRecognizer *)tap
{
    LogYellow(@"跳转到私信页");
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = [appDelegate.viewControllers objectAtIndex:1];
    [self hideTitleView];
}
- (void)handleCancel:(UIButton *)button
{
    [self hideTitleView];
}

#pragma mark - 显示头部指示器
- (void)showTitle:(NSString *)title autoHidden:(BOOL)isAutoHidden{
    if ([_titleBackgroundView superview]!=nil) {
        [_titleBackgroundView removeFromSuperview];
    }
    
    _titleBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
    _titleView.extBottom = 0;//ScreenHeight-20-44+kTipsHeight;
    //        _loadView.bottom = 0;
    _titleView.backgroundColor = [UIColor grayColor];
    _titleView.alpha = 0.7;
    [_titleBackgroundView addSubview:_titleView];
    
    //提示语的Label
    UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, ScreenWidth-10, 35)];
    loadLabel.textAlignment = NSTextAlignmentCenter;
    loadLabel.backgroundColor = [UIColor clearColor];
    loadLabel.text = title;
    loadLabel.font = kFont14;
    loadLabel.textColor = [UIColor whiteColor];
    loadLabel.numberOfLines = 2;
    [_titleView addSubview:loadLabel];
    
    
    if (![_titleBackgroundView superview]) {
        [self.view addSubview:_titleBackgroundView];
        
        //显示的动画
        __weak CustomViewController *this = self;
        [UIView animateWithDuration:0.7 animations:^{
            [UIView setAnimationRepeatCount:0];
            _titleView.extTop = 0;
        } completion:^(BOOL finished){
            if (finished && isAutoHidden) {
                [this performSelector:@selector(hideTitleView) withObject:nil afterDelay:1];
            }
        }];
    }
    
}

#pragma mark - 隐藏头部指示器
- (void)hideTitleView{
    //隐藏的动画
    [UIView animateWithDuration:0.7 animations:^{
        [UIView setAnimationRepeatCount:0];
        _titleView.extBottom = 0;
    } completion:^(BOOL finished){
        if (finished) {
            [_titleBackgroundView removeFromSuperview];
        }
    }];
    
    
}
#pragma mark - 显示指示器
- (void)showHUD:(NSString *)title isDim:(BOOL)isDim mode:(MBProgressHUDMode)mode
{
    [self hideHUD];
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view ? self.navigationController.view : self.view animated:YES];
    self.hud.yOffset = 0;
    self.hud.mode = mode;
    self.hud.dimBackground = isDim;
    
    self.hud.labelText  = title;
}

#pragma mark - 操作成功
- (void)showHUDComplete:(NSString *)title
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view ? self.navigationController.view : self.view animated:YES];
    self.hud.customView = [[UIImageView alloc] initWithImage: LOADIMAGE(@"MBProgressHUD.bundle/success@2x", @"png")];
    self.hud.userInteractionEnabled = NO;
    self.hud.mode = MBProgressHUDModeCustomView;
    if (title.length > 0)
    {
        self.hud.labelText = title;
    }
}

#pragma mark - 操作失败
- (void)showHUDFail:(NSString *)title
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view ? self.navigationController.view : self.view animated:YES];
    self.hud.yOffset = self.yOffset;
    self.hud.customView = [[UIImageView alloc] initWithImage:LOADIMAGE(@"MBProgressHUD.bundle/error@2x", @"png")];
    self.hud.mode = MBProgressHUDModeCustomView;
    if (title.length > 0)
    {
        self.hud.labelText = title;
    }
}

#pragma mark - 隐藏指示器
- (void)hideHUD
{
    [self.hud hide:YES];
}

#pragma mark - 延时隐藏指示器
- (void)hideHUDDelay:(int)scecond
{
    [self.hud hide:YES afterDelay:scecond];
}

#pragma mark 加载到指定位置
- (void )showLoadingWith:(UIView *)view
{
    if (!_loadingView) {
        _loadingView = [CustomLoadingView showLoadingWith:view];
    }
}

#pragma mark 加载到指定视图
- (void )showLoadingWithWindow
{
    if (!_loadingView) {
        _loadingView = [CustomLoadingView showLoadingWithWindow];
    }
}

#pragma mark 隐藏在加载视图
- (void)hideLoadingView
{
    [_loadingView hideLoadingView];
}

#pragma mark - 截全屏
- (NSString *)saveAllScreenImage{
    float x = 0;
    float y = 0;
    float width = ScreenWidth;
    float height = ScreenHeight;
    
    //如果是视网膜屏就翻倍
    if ([self isRetinaDisplay]) {
        width *= 2;
        height *= 2;
    }
    
    
    //截图
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), YES, 0);
    [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = viewImage.CGImage;
    CGRect rect =CGRectMake(x, y, width, height );//这里可以设置想要截图的区域
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    NSData *imageViewData = UIImagePNGRepresentation(sendImage);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"screenImage.png"];
    //    NSLog(@"%@", savedImagePath);
    [imageViewData writeToFile:savedImagePath atomically:YES];
    CGImageRelease(imageRefRect);
    return savedImagePath;
}

#pragma mark 是否视网膜屏
- (BOOL) isRetinaDisplay
{
    int scale = 1.0;
    UIScreen *screen = [UIScreen mainScreen];
    if([screen respondsToSelector:@selector(scale)])
        scale = screen.scale;
    
    if(scale == 2.0f) return YES;
    else return NO;
}

#pragma mark —— 是否开启推送
- (BOOL)isAllowedNotification {
    if (iOS8) {// system is iOS8
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    } else {//iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 当前控制器是否显示
-(BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController
{
    return (viewController.isViewLoaded && viewController.view.window);
}

@end
