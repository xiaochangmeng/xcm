//
//  LetterTableView.m
//  Appointment
//
//  Created by feiwu on 16/7/13.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "LetterTableView.h"
#import "LetterTableViewCell.h"
#import "LetterDetailViewController.h"
#import "LetterViewController.h"
#import "LXFileManager.h"
#import "MyVisitorViewController.h"
#import "UserInfoModel.h"
#import "WhoSeeMeController.h"
#import "NSObject+XWAdd.h"
#import "MyFeedBackViewController.h"
@implementation LetterTableView
#pragma mark - Life Cycle
//生命周期方法
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - Private Methods
//私有方法
- (void) initView
{
    self.separatorStyle = UITableViewCellSelectionStyleNone;//隐藏cell分割线
    self.backgroundColor = [UIColor clearColor];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
    self.dataSource = self;
    //点击最近访客头像
    WS(weakSelf);
    [self xw_addNotificationForName:@"clickVisitorHeadImage" block:^(NSNotification *notification) {
        //最近访客
        LetterViewController *letter = (LetterViewController *)weakSelf.viewController;
        if ([letter.ios_vip isEqualToString:@"1"]) {
            MyVisitorViewController *visitor = [[MyVisitorViewController alloc] init];
            [letter.navigationController pushViewController:visitor animated:YES];
        }else{
            WhoSeeMeController*  whoSeeMeController = [[WhoSeeMeController alloc]init];
            whoSeeMeController.pushType = @"letter-visitors-vip";
            [letter.navigationController pushViewController:whoSeeMeController animated:YES];
        }
        //刷新最近访客图标
        weakSelf.visitor_num = @"0";
        [weakSelf reloadData];
        
    }];
    
}


#pragma mark - Event Responses
//事件响应方法

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_letterDataArray.count > 0) {
        return _letterDataArray.count + 1;
    } else {
        return _letterDataArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify_SelectCell = @"LetterTableViewCell";
    LetterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify_SelectCell];
    if (cell == nil) {
        cell = [[LetterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify_SelectCell];
    }
    cell.indexPath = indexPath;
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_letterDataArray.count > 0) {
        LetterTableViewCell *letterCell = (LetterTableViewCell *)cell;
        if (indexPath.row != 0) {
            letterCell.model = _letterDataArray[indexPath.row - 1];
        } else {
            FateModel *model = [[FateModel alloc] init];
            model.age = @"";
            model.tag1 = @"";
            model.tag2 = @"";
            model.datetime = @"";
            model.name = NSLocalizedString(@"最近访客", nil);
            model.visitor_num = _visitor_num;
            letterCell.model = model;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MobClick event:@"letterEnterChat"];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    FateModel *model;
    LetterViewController *letter = (LetterViewController *)self.viewController;
    if (indexPath.row != 0) {
        model = _letterDataArray[indexPath.row - 1];
        if ([model.send_id isEqualToString:@"1000000"]) {
            MyFeedBackViewController *feed = [[MyFeedBackViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/iOS/Buy/service",BaseUrl]];
            feed.titleStr = @"MeetU";
           [letter.navigationController pushViewController:feed animated:YES];
            model.status = @"1";
            [self reloadData];
        } else {
            LetterDetailViewController *detail = [[LetterDetailViewController alloc] init];
            detail.flag_writer = [letter.ios_tell intValue];
            detail.model = model;
            [letter.navigationController pushViewController:detail animated:YES];
            //私信
            if ([model.status intValue] == 0) {
                NSString *userid = [NSString stringWithFormat:@"%@%@",[FWUserInformation sharedInstance].mid,kUserLetterCount];
                NSString *count = [LXFileManager readUserDataForKey:userid];
                
                if ([count intValue]  > 0) {
                    [LXFileManager saveUserData:[NSString stringWithFormat:@"%d",[count intValue] - 1] forKey:userid];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LetterCountChange" object:[NSString stringWithFormat:@"%d",[count intValue] - 1]];
                model.status = @"1";
                [self reloadData];
            }

        }
               //私信
    } else {
        //最近访客
        if ([letter.ios_vip isEqualToString:@"1"]) {
            MyVisitorViewController *visitor = [[MyVisitorViewController alloc] init];
            [letter.navigationController pushViewController:visitor animated:YES];
        }else{
            WhoSeeMeController*  whoSeeMeController = [[WhoSeeMeController alloc]init];
            whoSeeMeController.pushType = @"letter-visitors-vip";
            [letter.navigationController pushViewController:whoSeeMeController animated:YES];
        }
        //刷新最近访客图标
        _visitor_num = @"0";
        [self reloadData];
        //最近访客
    }
}



#pragma mark - Getters And Setters

@end
