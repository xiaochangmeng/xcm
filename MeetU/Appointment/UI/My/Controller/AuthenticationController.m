//
//  AuthenticationController.m
//  Appointment
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "AuthenticationController.h"
#import "AuthenticationFlowLayout.h"
#import "AuthenticationCollectionView.h"

@interface AuthenticationController ()
@property (strong, nonatomic) AuthenticationCollectionView* authenticationCollectionView;
@end

@implementation AuthenticationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

/**
 视图初始化
 */
- (void)setupView{
    self.view.backgroundColor = [UIColor whiteColor];
    //去掉返回按钮的文字只保留剪头
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.title = @"诚信认证";
    [self.view addSubview:self.authenticationCollectionView];
}


#pragma mark - authenticationCollectionView懒加载
- (AuthenticationCollectionView *)authenticationCollectionView{
    if (_authenticationCollectionView == nil) {
         AuthenticationFlowLayout* flowLayout = [[AuthenticationFlowLayout alloc]init];
        _authenticationCollectionView = [[AuthenticationCollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) collectionViewLayout:flowLayout];
    }
    return _authenticationCollectionView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
