//
//  CustomViewController.h
//  Appointment
//
//  Created by feiwu on 16/7/8.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UMMobClick/MobClick.h"
#import "UMMobClick/MobClickGameAnalytics.h"
#import "MZYNetRefreshView.h"
#import "CustomLoadingView.h"
@interface CustomViewController : UIViewController
{
 
@protected
    
    UIView *_titleBackgroundView;
    UIView *_titleView;
    
    UIWindow *_tipsWindow;
    
    UILabel *_backGroupTipsLabel;
    
    UIImageView *_backgroundImageView;
}
typedef void(^RightButtonBlock)(void);

typedef void (^NavCancelBlock)(void);

typedef void (^NavBackBlock)(void);

typedef void (^RefreshBlock)(void);


#pragma mark 弹出提示向上移动的位置
@property (nonatomic, assign) CGFloat yOffset;

@property (nonatomic,strong)MBProgressHUD *hud;
@property (nonatomic,assign)BOOL isBack;//是否返回
@property (nonatomic,assign)BOOL isCancel;//是否取消
@property (nonatomic,assign)BOOL isClose;//是否关闭
@property (nonatomic,assign)BOOL isText;//是否文字
@property (nonatomic,strong)UIButton *leftButton;
@property (nonatomic,strong)UIButton *rightButton;
@property (nonatomic,strong)MZYNetRefreshView *netRetreshView;
@property (nonatomic,strong)CustomLoadingView *loadingView;

@property (nonatomic,copy)RightButtonBlock rightButtonBlock;
@property (nonatomic,copy)NavCancelBlock   navCancelBlock;
@property (nonatomic,copy)NavBackBlock   navBackBlock;

#pragma mark 显示网络异常视图
- (void)showNetRefresh:(RefreshBlock )refreshBlock;

#pragma mark 隐藏网络异常视图
- (void)hideNetRefresh;
#pragma mark 沒有發消息視圖
- (void)showNoLetter;
#pragma mark 私信提示
- (void)showLetterCount:(NSString *)count;

#pragma 隐藏提醒
- (void)hideTitleView;

#pragma mark 自定义标题提示
- (void)showTitle:(NSString *)title autoHidden:(BOOL)isAutoHidden;

#pragma mark 提示框
- (void)showHUD:(NSString *)title isDim:(BOOL)isDim mode:(MBProgressHUDMode)mode;

#pragma mark 提示已完成操作
- (void)showHUDComplete:(NSString *)title;

#pragma mark 提示操作失败
- (void)showHUDFail:(NSString *)title;

#pragma mark 隐藏提示框
- (void)hideHUD;

#pragma mark 延迟隐藏提标框
- (void)hideHUDDelay:(int)scecond;

#pragma mark 加载到指定位置
- (void )showLoadingWith:(UIView *)view;

#pragma mark 加载到指定视图
- (void )showLoadingWithWindow;

#pragma mark 隐藏在加载视图
- (void)hideLoadingView;

#pragma mark 截全屏
- (NSString *)saveAllScreenImage;

#pragma mark 是否开启推送
- (BOOL)isAllowedNotification;

#pragma mark - 当前控制器是否显示
- (BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController;

@end
