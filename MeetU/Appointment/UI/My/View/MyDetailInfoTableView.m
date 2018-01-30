//
//  MyDetailInfoTableView.m
//  Appointment
//
//  Created by feiwu on 16/8/23.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MyDetailInfoTableView.h"
#import "MyInfoViewController.h"
#import "MySetTableViewCell.h"
#import "ActionSheetPicker.h"
#import "AbstractActionSheetPicker+Interface.h"
@implementation MyDetailInfoTableView
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
    
//    _baseArray = @[@"學歷",@"職業",@"收入",@"交友目的",@"戀愛觀念",@"首次見面希望",@"喜歡的約會地點"];
    _baseArray = @[NSLocalizedString(@"学历", nil),NSLocalizedString(@"职业", nil),NSLocalizedString(@"收入", nil),NSLocalizedString(@"交友目的", nil),NSLocalizedString(@"恋爱观念", nil),NSLocalizedString(@"首次见面希望", nil),NSLocalizedString(@"最喜欢的约会地点", nil)];
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
    return  7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify_InfoCell = @"MyDetailInfoTableViewCell";
    MySetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify_InfoCell];
    if (cell == nil) {
        cell = [[MySetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify_InfoCell];
    }
    cell.typeLabel.text = _baseArray[indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            //学历
            if ([_infoModel.education intValue] > 0) {
                if ([_infoModel.education intValue] == 1) {
                    cell.detailLabel.text = @"國中";
                } else  if ([_infoModel.education intValue] == 2) {
                    cell.detailLabel.text = @"高中/高職";
                } else  if ([_infoModel.education intValue] == 3) {
                    cell.detailLabel.text = @"學院/大學";
                } else  if ([_infoModel.education intValue] == 4) {
                    cell.detailLabel.text = @"研究所及以上";
                }
                
            } else {
                cell.detailLabel.text = @"";
            }
        }
            break;
        case 1:
        {
            //职业
            if (![_infoModel.occupation isEqualToString:@""]) {
                cell.detailLabel.text = _infoModel.occupation;
            } else {
                cell.detailLabel.text = @"";
            }
        }
            break;
        case 2:
        {
            //收入
            if (![_infoModel.monthly_income isEqualToString:@""]) {
                cell.detailLabel.text = _infoModel.monthly_income;
            } else {
                cell.detailLabel.text = @"";
            }
            
        }
            break;
               case 3:
        {
            //交友目的
            if (![_infoModel.making_friends isEqualToString:@""]) {
                cell.detailLabel.text = _infoModel.making_friends;
            } else {
                cell.detailLabel.text = @"";
            }
        }
            break;
        case 4:
        {
            //恋爱观念
            if (![_infoModel.love_concept isEqualToString:@""]) {
                cell.detailLabel.text = _infoModel.love_concept;
            } else {
                cell.detailLabel.text = @"";
            }

        }
            break;

        case 5:
        {
            //首次见面希望
            if (![_infoModel.first_meeting_hope isEqualToString:@""]) {
                cell.detailLabel.text = _infoModel.first_meeting_hope;
            } else {
                cell.detailLabel.text = @"";
            }
        }
            break;

        case 6:
        {
            //喜欢约会地点
            if (![_infoModel.love_place isEqualToString:@""]) {
                cell.detailLabel.text = _infoModel.love_place;
            } else {
                cell.detailLabel.text = @"";
            }

        }
            break;
        default:
            break;
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
    WS(weakSelf);
    __weak MyInfoViewController *info = (MyInfoViewController *)self.viewController;
    switch (indexPath.row) {
        case 0:
        {
            //学历
            NSArray *dataArr = @[NSLocalizedString(@"国中", nil),
                                 NSLocalizedString(@"高中/高职", nil),
                                 NSLocalizedString(@"学院/大学", nil),
                                 NSLocalizedString(@"研究所及以上", nil)];
            ActionSheetStringPicker *actionPicker = [[ActionSheetStringPicker alloc]initWithTitle:NSLocalizedString(@"选择学历", nil) rows:dataArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                //*********一组点击确认按钮做处理************
                weakSelf.infoModel.education = [NSString stringWithFormat:@"%ld", selectedIndex + 1];
                info.newinfoModel.education = [NSString stringWithFormat:@"%ld", selectedIndex + 1];
                [weakSelf reloadData];
                 [info prefrect:info.newinfoModel];
                
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:info.view];
            [actionPicker customizeInterface];
            [actionPicker showActionSheetPicker];
            
        }
            break;
        case 1:
        {
            //职业
            NSArray *dataArr = @[NSLocalizedString(@"电脑/互联网/通信，", nil),
                                 NSLocalizedString(@"公务员/事业单位，", nil),
                                 NSLocalizedString(@"学生，", nil),
                                 NSLocalizedString(@"自由职业者，", nil),
                                 NSLocalizedString(@"生产/工艺/制造，", nil),
                                 NSLocalizedString(@"商业/服务业/个体经营，", nil),
                                 NSLocalizedString(@"金融/银行/投资/保险，", nil),
                                 NSLocalizedString(@"文化/广告/媒体", nil),
                                 NSLocalizedString(@"娱乐/艺术/表演", nil),
                                 NSLocalizedString(@"医药/护理/制药，", nil),
                                 NSLocalizedString(@"律师/法务，", nil),
                                 NSLocalizedString(@"教育/培训", nil),
                                 NSLocalizedString(@"其它", nil)];
            ActionSheetStringPicker *actionPicker = [[ActionSheetStringPicker alloc]initWithTitle:NSLocalizedString(@"选择职业", nil) rows:dataArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                //*********一组点击确认按钮做处理************
                weakSelf.infoModel.occupation = (NSString *)selectedValue;
                info.newinfoModel.occupation = (NSString *)selectedValue;
                [weakSelf reloadData];
                 [info prefrect:info.newinfoModel];
                
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:info.view];
            [actionPicker customizeInterface];
            [actionPicker showActionSheetPicker];
            
        }
            break;
        case 2:
        {
            //收入
            NSArray *dataArr = @[@"小於30000台幣/月",@"30000~50000台幣/月",@"50000~100000台幣/月",@"100000~200000台幣/月",@"大於200000台幣/月"];
            ActionSheetStringPicker *actionPicker = [[ActionSheetStringPicker alloc]initWithTitle:NSLocalizedString(@"选择收入", nil) rows:dataArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                //*********一组点击确认按钮做处理************
                weakSelf.infoModel.monthly_income = (NSString *)selectedValue;
                info.newinfoModel.monthly_income = (NSString *)selectedValue;
                [weakSelf reloadData];
                 [info prefrect:info.newinfoModel];
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:info.view];
            [actionPicker customizeInterface];
            [actionPicker showActionSheetPicker];
            
        }
            break;
                  case 3:
        {
        //交友目的
//            NSArray *dataArr = @[@"週末約會",@"尋找另一半",@"尋找刺激",@"假日X夥伴",@"找個情人",@"希望援助",@"都可以啦"];
            NSArray *dataArr = @[NSLocalizedString(@"周末约会", nil),NSLocalizedString(@"寻找另一半", nil),NSLocalizedString(@"寻找刺激", nil),NSLocalizedString(@"寻找x伙伴", nil),NSLocalizedString(@"找个情人", nil),NSLocalizedString(@"希望援助", nil),NSLocalizedString(@"都可以啦", nil)];
           
            ActionSheetStringPicker *actionPicker = [[ActionSheetStringPicker alloc]initWithTitle:NSLocalizedString(@"交友目的", nil) rows:dataArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                //*********一组点击确认按钮做处理************
                weakSelf.infoModel.making_friends = (NSString *)selectedValue;
                info.newinfoModel.making_friends = (NSString *)selectedValue;
                [weakSelf reloadData];
                [info prefrect:info.newinfoModel];
                
                
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:info.view];
            [actionPicker customizeInterface];
            [actionPicker showActionSheetPicker];

        }
            break;
        case 4:
        {
            //恋爱观念
            NSArray *dataArr = @[NSLocalizedString(@"开放", nil),NSLocalizedString(@"保守", nil),NSLocalizedString(@"寻找刺激", nil),NSLocalizedString(@"顺其自然", nil),NSLocalizedString(@"大胆开放", nil),NSLocalizedString(@"看感觉", nil),NSLocalizedString(@"有性有爱", nil),NSLocalizedString(@"好聚好散", nil),NSLocalizedString(@"有性有爱", nil),NSLocalizedString(@"私密交流", nil),NSLocalizedString(@"深入沟通", nil),NSLocalizedString(@"循序渐进", nil),NSLocalizedString(@"传统", nil),NSLocalizedString(@"都可以", nil),NSLocalizedString(@"我还年轻，还想玩", nil),NSLocalizedString(@"以对方为中心", nil),NSLocalizedString(@"想要刻骨铭心的", nil),NSLocalizedString(@"不影响个人生活", nil),NSLocalizedString(@"开心最重要", nil),NSLocalizedString(@"不谈情,只说爱", nil),NSLocalizedString(@"双方必须保密", nil),NSLocalizedString(@"以我为中心", nil),NSLocalizedString(@"不为一片树叶放弃一片森林", nil)];
            ActionSheetStringPicker *actionPicker = [[ActionSheetStringPicker alloc]initWithTitle:NSLocalizedString(@"选择恋爱观念", nil) rows:dataArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                //*********一组点击确认按钮做处理************
                weakSelf.infoModel.love_concept = (NSString *)selectedValue;
                info.newinfoModel.love_concept = (NSString *)selectedValue;
                [weakSelf reloadData];
                [info prefrect:info.newinfoModel];
                
                
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:info.view];
            [actionPicker customizeInterface];
            [actionPicker showActionSheetPicker];

        }
            break;

        case 5:
        {
           //首次见面希望
            NSArray *dataArr = @[NSLocalizedString(@"拥抱", nil),NSLocalizedString(@"接吻", nil),NSLocalizedString(@"爱爱", nil),NSLocalizedString(@"看电影", nil),NSLocalizedString(@"一场旅行", nil),NSLocalizedString(@"如果喜欢可以开房爱爱", nil),NSLocalizedString(@"喝喝茶", nil),NSLocalizedString(@"吃饭", nil),NSLocalizedString(@"逛街", nil),NSLocalizedString(@"浪漫的夜晚", nil),NSLocalizedString(@"烛光晚餐", nil),NSLocalizedString(@"AA制", nil),NSLocalizedString(@"一份礼物", nil),NSLocalizedString(@"电影版的相遇", nil),NSLocalizedString(@"夜猫子", nil),NSLocalizedString(@"男A女B", nil),NSLocalizedString(@"各种吃", nil),NSLocalizedString(@"随心所欲", nil),NSLocalizedString(@"其它", nil)];
            ActionSheetStringPicker *actionPicker = [[ActionSheetStringPicker alloc]initWithTitle:NSLocalizedString(@"首次见面希望", nil) rows:dataArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                //*********一组点击确认按钮做处理************
                weakSelf.infoModel.first_meeting_hope = (NSString *)selectedValue;
                info.newinfoModel.first_meeting_hope = (NSString *)selectedValue;
                [weakSelf reloadData];
                [info prefrect:info.newinfoModel];
                
                
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:info.view];
            [actionPicker customizeInterface];
            [actionPicker showActionSheetPicker];

        }
            break;

        case 6:
        {
          //喜欢约会地点
            NSArray *dataArr = @[NSLocalizedString(@"家里", nil),
                                 NSLocalizedString(@"野外", nil),
                                 NSLocalizedString(@"宾馆", nil),
                                 NSLocalizedString(@"在户外", nil),
                                 NSLocalizedString(@"旅游景点", nil),
                                 NSLocalizedString(@"在车上", nil),
                                 NSLocalizedString(@"你家里", nil),
                                 NSLocalizedString(@"便捷式酒店", nil),
                                 NSLocalizedString(@"茶餐厅", nil),
                                 NSLocalizedString(@"咖啡厅", nil),
                                 NSLocalizedString(@"高级宾馆", nil),
                                 NSLocalizedString(@"酒吧", nil),
                                 NSLocalizedString(@"商场", nil),
                                 NSLocalizedString(@"电影院", nil),
                                 NSLocalizedString(@"浪漫的地方", nil),
                                 NSLocalizedString(@"演唱会", nil),
                                 NSLocalizedString(@"游乐场", nil),
                                 NSLocalizedString(@"广场", nil),
                                 NSLocalizedString(@"不限", nil)];
            ActionSheetStringPicker *actionPicker = [[ActionSheetStringPicker alloc]initWithTitle:NSLocalizedString(@"选择约会地点", nil) rows:dataArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                //*********一组点击确认按钮做处理************
                weakSelf.infoModel.love_place = (NSString *)selectedValue;
                info.newinfoModel.love_place = (NSString *)selectedValue;
                [weakSelf reloadData];
                [info prefrect:info.newinfoModel];
                
                
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:info.view];
            [actionPicker customizeInterface];
            [actionPicker showActionSheetPicker];

        }
            break;

        default:
            break;
    }
    
    
}


@end
