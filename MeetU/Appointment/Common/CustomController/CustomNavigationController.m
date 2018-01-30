//
//  CustonNavigationViewController.m
//  Test
//
//  Created by feiwu on 16/7/7.
//  Copyright © 2016年 mazhiyuan. All rights reserved.
//

#import "CustomNavigationController.h"
@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //设置状态栏为亮色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置标题颜色
    [self.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //去掉导航栏下面那条线
    if ([UINavigationBar instancesRespondToSelector:@selector(setShadowImage:)])
    {
        [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(ScreenWidth, 3)]];
    }
    
    self.view.backgroundColor = [UIColor clearColor];
    
    //加载主题导航栏背景
    [self loadNavigationBarBackground];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods


#pragma mark 加载默认背景图片
- (void)loadNavigationBarBackground{
    
    [self barBackgroundImageWithColor:Color16(0xF85F73)];
}

- (void)barBackgroundImageWithColor:(UIColor *)color{
    
    UIImage *image = [UIImage imageWithColor:color size:CGSizeMake(ScreenWidth,64)];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    
}

@end
