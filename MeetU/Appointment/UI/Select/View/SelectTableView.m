//
//  SelectTableView.m
//  Appointment
//
//  Created by feiwu on 16/7/8.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "SelectTableView.h"
#import "SelectTableViewCell.h"
#import "FateDetailViewController.h"
#import "SelectViewController.h"
@implementation SelectTableView

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
    
}


#pragma mark - Public Methods
//公有方法

#pragma mark - Event Responses
//事件响应方法

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selectDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify_SelectCell = @"SelectTableViewCell";
    SelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify_SelectCell];
    if (cell == nil) {
        cell = [[SelectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify_SelectCell];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectDataArray.count > 0) {
        SelectTableViewCell *selectCell = (SelectTableViewCell *)cell;
        selectCell.model = _selectDataArray[indexPath.row];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [MobClick event:@"selectEnterUserDetail"];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    FateModel *model = _selectDataArray[indexPath.row];
   __weak SelectViewController *select = (SelectViewController *)self.viewController;
    WS(weakSelf);
    FateDetailViewController *detail = [[FateDetailViewController alloc] init];
    detail.fateModel = model;
    detail.selectedArray = select.selectedArray;
    detail.selectedBlock = ^(NSMutableArray *selected){
        NSMutableArray *temp = [NSMutableArray array];
        select.selectedArray = selected;//已经选中数组
        for (FateModel *model in select.selectDataArray) {
            if ([select.selectedArray containsObject:model.user_id]) {
                model.helloed = @"2";
            }
            [temp addObject:model];
        }
        select.selectDataArray = temp;//列表数据重新赋予
        [weakSelf reloadData];
    };

    [select.navigationController pushViewController:detail animated:YES];
}



#pragma mark - Getters And Setters

@end

