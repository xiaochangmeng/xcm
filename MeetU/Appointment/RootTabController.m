//
//  RootTabController.m
//  YPTabBarController
//
//  Created by 喻平 on 15/8/11.
//  Copyright (c) 2015年 YPTabBarController. All rights reserved.
//

#import "RootTabController.h"
#import "FateViewController.h"
#import "LetterViewController.h"
#import "LetterDetailViewController.h"
#import "NearbyViewController.h"
#import "MyViewController.h"
#import "NewFateViewController.h"
#import "NewnearbyVController.h"


#import "LBTabBar.h"
#import "UIImage+Image.h"
@interface RootTabController ()<UITabBarControllerDelegate>
@property (nonatomic,strong)UIButton *button;
@end

@implementation RootTabController
@synthesize button;
- (void)viewDidLoad {
    
    [super viewDidLoad];
     self.delegate=self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tiaozhuang) name:@"loginViewTiaozhuang" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTabBarVC];
    
    
  
}


#pragma mark - LBTabBarDelegate
//点击中间按钮的代理方法
- (void)tabBarPlusBtnClick:(LBTabBar *)tabBar
{

//    NewConsultVController *NewConsultVC = [[NewConsultVController alloc] init];
//    NewConsultVC.biaozhi = @"1";
//    NewConsultVC.view.backgroundColor = [self randomColor];
//
//    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:NewConsultVC];
//    [self presentViewController:navVc animated:YES completion:nil];
    
}


- (UIColor *)randomColor
{
    CGFloat r = arc4random_uniform(256);
    CGFloat g = arc4random_uniform(256);
    CGFloat b = arc4random_uniform(256);
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    
}

+ (void)initialize
{
    UITabBarItem *tabBarItem = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    
    NSMutableDictionary *dictNormal = [NSMutableDictionary dictionary];
    dictNormal[NSForegroundColorAttributeName] = [UIColor grayColor];
    dictNormal[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    
    NSMutableDictionary *dictSelected = [NSMutableDictionary dictionary];
    dictSelected[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    dictSelected[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    
    [tabBarItem setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:dictSelected forState:UIControlStateSelected];
    
}

-(void)tiaozhuang{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shoucitiaozhuang" object:nil];
}



-(void)pressChange:(id)sender
{
    self.selectedIndex=1;
    button.selected=YES;
}

#pragma mark- TabBar Delegate

//  换页和button的状态关联上

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (self.selectedIndex==1) {
        button.selected=YES;
    }else
    {
        button.selected=NO;
    }
}


-(void)addButtonNotifation{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(buttonHidden) name:@"buttonNotifationCenter" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(buttonNotHidden) name:@"buttonNotHidden" object:nil];
}
-(void)buttonNotHidden{
    button.hidden=NO;
}
-(void)buttonHidden{
    button.hidden=YES;
}
// 初始化所有子控制器
- (void)setTabBarVC{

    
    [self setTabBarChildController:[[NewFateViewController alloc] init] title:@"缘分" image:@"fate_normal" selectImage:@"Fate_selected"];
    
    
    //本地有值，说明在审核状态，否则是普通状态
    [self setTabBarChildController:[[LetterViewController alloc] init] title:@"私信" image:@"Message_normal" selectImage:@"Message_selected"];
    
//    NearbyViewController
    
             [self setTabBarChildController:[[NewnearbyVController alloc] init] title:@"附近" image:@"Moments_normal" selectImage:@"Moments_selected"];
    
  
  
   
    [self setTabBarChildController:[[MyViewController alloc] init] title:@"我的" image:@"Mine_normal" selectImage:@"Mine_selected"];
    
}


// 添加tabbar的子viewcontroller
- (void)setTabBarChildController:(UIViewController*)controller title:(NSString*)title image:(NSString*)imageStr selectImage:(NSString*)selectImageStr{
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
    nav.tabBarItem.title = title;
    nav.tabBarItem.image = [[UIImage imageNamed:imageStr]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    nav.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageStr]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [nav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName: UIColorFromRGB(0x737373)} forState:UIControlStateNormal];
    [nav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:UIColorFromRGB(0xf8485e)} forState:UIControlStateSelected];
    [self addChildViewController:nav];
    nav.navigationBarHidden = YES;
}


-(void)setHidesBottomBarWhenPushed:(BOOL)hidesBottomBarWhenPushed{
    self.tabBar.hidden = hidesBottomBarWhenPushed;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];


    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

@end
