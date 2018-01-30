//
//  MyHobbyInfoTableView.m
//  Appointment
//
//  Created by feiwu on 16/8/23.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MyHobbyInfoTableView.h"
#import "MyInfoViewController.h"
#import "MyHobbyInfoOneCell.h"
#import "MyHobbyInfoTwoCell.h"
@implementation MyHobbyInfoTableView
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
    self.dataSource =self;
    
    
}

#pragma mark - Public Methods
//公有方法


#pragma mark - Event Responses
//事件响应方法

#pragma mark UITableViewDataSource
#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *hobbyInfoTableViewOneCell = @"MyHobbyInfoTableViewOneCell";
        MyHobbyInfoOneCell *cell = [tableView dequeueReusableCellWithIdentifier:hobbyInfoTableViewOneCell];
        if (cell == nil) {
            cell = [[MyHobbyInfoOneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hobbyInfoTableViewOneCell];
        }
        cell.infoModel = _infoModel;
        return cell;
        
    } else {
        
        static NSString *hobbyInfoTwoCell = @"MyHobbyInfoTableViewTwoCell";
        MyHobbyInfoTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:hobbyInfoTwoCell];
        if (cell == nil) {
            cell = [[MyHobbyInfoTwoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hobbyInfoTwoCell];
        }
        cell.infoModel = _infoModel;
        return cell;
        
    }
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 310;
}



@end
