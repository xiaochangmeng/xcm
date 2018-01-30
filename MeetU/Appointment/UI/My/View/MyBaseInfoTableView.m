//
//  MyBaseInfoTableView.m
//  Appointment
//
//  Created by feiwu on 16/8/23.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MyBaseInfoTableView.h"
#import "MySetTableViewCell.h"
#import "MyInfoTableViewSection.h"
#import "MySetNicknameViewController.h"
#import "ActionSheetPicker.h"
#import "AbstractActionSheetPicker+Interface.h"
#import "MyInfoViewController.h"
#import "NSDate+MZYExtension.h"
@implementation MyBaseInfoTableView
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
    
    _baseArray = @[
                   NSLocalizedString(@"昵称", nil),
                   NSLocalizedString(@"生日", nil),
                   NSLocalizedString(@"年龄", nil),
                   NSLocalizedString(@"居住地", nil),
                   NSLocalizedString(@"身高", nil),
                   NSLocalizedString(@"体重", nil),
                   NSLocalizedString(@"血型", nil)];
}

#pragma mark - Public Methods
//公有方法
#pragma mark - 选择时间
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    MyInfoViewController *info = (MyInfoViewController *)self.viewController;

    NSString *dateString = [NSDate getDate:selectedDate dateFormatter:@"yyyy-MM-dd"];
    NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
    _infoModel.birth_year = [dateArray firstObject];
    _infoModel.birth_month = [dateArray objectAtIndex:1];
    _infoModel.birth_day = [dateArray lastObject];
    
    info.newinfoModel.birth_year = [dateArray firstObject];
    info.newinfoModel.birth_month = [dateArray objectAtIndex:1];
    info.newinfoModel.birth_day = [dateArray lastObject];
    
    LogOrange(@"选择的日期:%@",dateString);
    
    //计算年龄
    _infoModel.age = [NSString stringWithFormat:@"%ld",(long)-[NSDate getDateDifferent:selectedDate].year];
    [self reloadData];
     [info prefrect:info.newinfoModel];
}


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
    static NSString *identify_InfoCell = @"MyBaseInfoTableViewCell";
    MySetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify_InfoCell];
    if (cell == nil) {
        cell = [[MySetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify_InfoCell];
    }
    cell.typeLabel.text = _baseArray[indexPath.row];
    switch (indexPath.row) {
      
        case 0:
        {
            //昵称
            if (_infoModel.name.length > 0) {
                cell.detailLabel.text = _infoModel.name;
            } else {
                cell.detailLabel.text = @"";
            }

        }
            break;
        case 1:
        {
            //生日
            cell.detailLabel.text = [NSString stringWithFormat:@"%@-%@-%@",_infoModel.birth_year,_infoModel.birth_month,_infoModel.birth_day];
        }
            break;
        case 2:
        {
            //年龄
            if (_infoModel.age.length > 0) {
                cell.detailLabel.text = [NSString stringWithFormat:@"%@%@",_infoModel.age,NSLocalizedString(@"岁", nil)];
            } else {
                cell.detailLabel.text = @"";
            }
        }
            break;
        case 3:
        {
            //地区
            if (_infoModel.city.length > 0) {
                cell.detailLabel.text = _infoModel.city;
            } else {
                cell.detailLabel.text = @"";
            }

        }
            break;
        case 4:
        {
            //身高
            if (_infoModel.height.length > 0) {
                cell.detailLabel.text = [NSString stringWithFormat:@"%@cm",_infoModel.height];
            } else {
                cell.detailLabel.text = @"";
            }

        }
            break;
        case 5:
        {
            //体重
            if (_infoModel.weight.length > 0) {
                cell.detailLabel.text = [NSString stringWithFormat:@"%@kg",_infoModel.weight];
            } else {
                cell.detailLabel.text = @"";
            }
            
        }
            break;
        case 6:
        {
            //血型
            if (_infoModel.blood_type.length > 0) {
                cell.detailLabel.text = _infoModel.blood_type;
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
            //昵称
            MySetNicknameViewController *setInfo = [[MySetNicknameViewController alloc] init];
            setInfo.InfoModel = _infoModel;
            setInfo.modifyNameBlock = ^(NSString *name){
                weakSelf.infoModel.name = name;
                info.newinfoModel.name = name;
                [weakSelf reloadData];
                [info prefrect:info.newinfoModel];
                
            };
            
            [info.navigationController pushViewController:setInfo animated:YES];
        }
            break;
        case 1:
        {
            //生日
            NSString* minDateString = @"19500101";
            NSString * maxDateString = @"19981231";
            NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init] ;
            [inputFormatter setDateFormat:@"yyyyMMdd"];
            NSDate *minDate = [inputFormatter dateFromString:minDateString];
            NSDate *maxDate = [inputFormatter dateFromString:maxDateString];
            ActionSheetDatePicker *actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"請選擇日期" datePickerMode:UIDatePickerModeDate selectedDate:info.selectedDate                                                              target:self action:@selector(dateWasSelected:element:) origin:info.view];
            actionSheetPicker.minimumDate = minDate;
            actionSheetPicker.maximumDate = maxDate;
            [actionSheetPicker customizeInterface];
            [actionSheetPicker showActionSheetPicker];
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            //居住地
            NSArray *dataArr = @[NSLocalizedString(@"臺北", nil),
                                 NSLocalizedString(@"桃園", nil),
                                 NSLocalizedString(@"台中", nil),
                                 NSLocalizedString(@"台南", nil),
                                 NSLocalizedString(@"高雄", nil),
                                 NSLocalizedString(@"基隆", nil),
                                 NSLocalizedString(@"新竹", nil),
                                 NSLocalizedString(@"嘉義", nil),
                                 NSLocalizedString(@"苗栗", nil),
                                 NSLocalizedString(@"彰化", nil),
                                 NSLocalizedString(@"南投", nil),
                                 NSLocalizedString(@"雲林", nil),
                                 NSLocalizedString(@"屏東", nil),
                                 NSLocalizedString(@"宜蘭", nil),
                                 NSLocalizedString(@"花蓮", nil),
                                 NSLocalizedString(@"台東", nil),
                                 NSLocalizedString(@"金門", nil),
                                 NSLocalizedString(@"連江", nil),
                                 NSLocalizedString(@"澎湖", nil),
                                 NSLocalizedString(@"新北", nil)
];
                        ActionSheetStringPicker *actionPicker = [[ActionSheetStringPicker alloc]initWithTitle:NSLocalizedString(@"居住地", nil) rows:self.province_arr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                //*********一组点击确认按钮做处理************
                weakSelf.infoModel.city = (NSString *)selectedValue;
                info.newinfoModel.city = (NSString *)selectedValue;
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
            //身高
            NSMutableArray *dataArr = [NSMutableArray array];
            for (int i = 140; i < 231; i++) {
                NSString *weight = [NSString stringWithFormat:@"%d",i];
                [dataArr addObject:weight];
            }
            
            ActionSheetStringPicker *actionPicker = [[ActionSheetStringPicker alloc]initWithTitle:@"身高(cm)" rows:dataArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                //*********一组点击确认按钮做处理************
                weakSelf.infoModel.height = (NSString *)selectedValue;
                info.newinfoModel.height = (NSString *)selectedValue;
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
            //体重
            NSMutableArray *dataArr = [NSMutableArray array];
            for (int i = 35; i < 151; i++) {
                NSString *weight = [NSString stringWithFormat:@"%d",i];
                [dataArr addObject:weight];
            }
            ActionSheetStringPicker *actionPicker = [[ActionSheetStringPicker alloc]initWithTitle:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"体重", nil),@"(kg)"] rows:dataArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                //*********一组点击确认按钮做处理************
                weakSelf.infoModel.weight = (NSString *)selectedValue;
                info.newinfoModel.weight = (NSString *)selectedValue;
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
            //血型
            NSArray *dataArr = @[@"A",@"B",@"AB",@"O"];
            ActionSheetStringPicker *actionPicker = [[ActionSheetStringPicker alloc]initWithTitle:NSLocalizedString(@"血型", nil) rows:dataArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                //*********一组点击确认按钮做处理************
                NSString *blood_type = (NSString *)selectedValue;
                info.newinfoModel.blood_type = blood_type;
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

-(NSMutableArray *)province_arr{
    if (!_province_arr) {
        _province_arr = [NSMutableArray new];
    }
    return _province_arr;
}


@end
