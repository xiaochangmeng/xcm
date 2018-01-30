//
//  MySetViewController.m
//  Appointment
//
//  Created by feiwu on 16/7/14.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MySetViewController.h"
#import "MySetTableViewCell.h"
#import "ModifyPasswordViewController.h"
#import "MyFeedBackViewController.h"
@implementation MySetViewController
#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的设置页面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的设置页面"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideHUD];//隐藏指示器
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"设置中心", nil);
    self.isCancel = YES;
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify_SetCell = @"MySetTableViewCell";
    MySetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify_SetCell];
    if (cell == nil) {
        cell = [[MySetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify_SetCell];
    }
    if (indexPath.row == 0) {
        cell.detailLabel.hidden = YES;
        cell.typeLabel.text = NSLocalizedString(@"修改密码", nil);
    }
//    else if (indexPath.row == 1) {
//        cell.detailLabel.hidden = YES;
//        cell.typeLabel.text = NSLocalizedString(@"安全中心", nil);
//    }
    else if (indexPath.row == 1) {
        cell.detailLabel.hidden = YES;
        cell.typeLabel.text = NSLocalizedString(@"用户反饋", nil);
    }

    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    if (indexPath.row == 0) {
        //修改密码
        ModifyPasswordViewController *modify = [[ModifyPasswordViewController alloc] init];
        [self.navigationController pushViewController:modify animated:YES];
        
    }
//    else if (indexPath.row == 1) {
//        //安全中心
//        [MobClick event:@"myFeedback"];
//        MyFeedBackViewController *feed = [[MyFeedBackViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/iOS/SafeCenter/index",BaseUrl]];
//        feed.titleStr = NSLocalizedString(@"安全中心", nil);
//        [self.navigationController pushViewController:feed animated:YES];
//    }
    else if (indexPath.row == 1) {
        //用戶反饋
        MyFeedBackViewController *feed = [[MyFeedBackViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/iOS/Feedback/feedback?tag=ios",BaseUrl]];
        feed.titleStr = NSLocalizedString(@"用户反饋", nil);
        [self.navigationController pushViewController:feed animated:YES];
    }

}

#pragma mark - Getters And Setters
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;//隐藏cell分割线
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
	}
	return _tableView;
}
@end
