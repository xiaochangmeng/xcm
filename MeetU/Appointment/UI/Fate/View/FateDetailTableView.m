//
//  FateTableView.m
//  Appointment
//
//  Created by feiwu on 16/7/16.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "FateDetailTableView.h"
#import "FateDetailSpaceCell.h"
#import "FateDetailHeadCell.h"
#import "FateDetailConditionCell.h"
#import "NSString+MZYExtension.h"
#import "FateDetailViewController.h"
#import "MyFeedBackViewController.h"
#import "NSObject+XWAdd.h"
@implementation FateDetailTableView

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
    WS(weakSelf);
    self.separatorStyle = UITableViewCellSelectionStyleNone;//隐藏cell分割线
    self.backgroundColor = [UIColor clearColor];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
    self.dataSource = self;
    //点击基本信息更多
    self.isOpen = NO;
    [self xw_addNotificationForName:@"fateDetailTableViewOpenStatusChange" block:^(NSNotification *notification) {
        weakSelf.isOpen = YES;
        [weakSelf reloadData];
    }];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public Methods
//公有方法

#pragma mark - Event Responses
//事件响应方法
#
#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = 5;
            break;
        case 1:
        {
            if (_isOpen) {
                rows = 11;
            } else {
                rows = 1;
            }
        }
            break;
        case 2:
            rows = 1;
            break;
            
        default:
            break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 ) {
        if (!_isOpen) {
            //基本信息不展开
            static NSString *fateDetailConditionCell = @"FateDetailConditionCell";
            FateDetailConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:fateDetailConditionCell];
            if (cell == nil) {
                cell = [[FateDetailConditionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:fateDetailConditionCell];
            }
            return cell;
        } else {
            //基本信息展开
            static NSString *fateDetailSpaceCell = @"FateDetailSpaceCell";
            FateDetailSpaceCell *cell = [tableView dequeueReusableCellWithIdentifier:fateDetailSpaceCell];
            if (cell == nil) {
                cell = [[FateDetailSpaceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:fateDetailSpaceCell];
            }
            //基本信息
            switch (indexPath.row) {
                case 0:
                {
                    cell.typeLabel.text = NSLocalizedString(@"性别", nil);
                    if ([_fateUserModel.sex isEqualToString:@"0"]) {
                        cell.detailLabel.text = NSLocalizedString(@"女", nil);
                    } else if ([_fateUserModel.sex isEqualToString:@"1"]) {
                        cell.detailLabel.text = NSLocalizedString(@"男", nil);
                    } else {
                        cell.detailLabel.text = @"";
                    }
                }
                    break;
                case 1:
                {
                    cell.typeLabel.text = NSLocalizedString(@"学历", nil);
                    if (![_fateUserModel.education isEqualToString:@""]) {
                        cell.detailLabel.text = _fateUserModel.education;
                    } else {
                        cell.detailLabel.text = @"";
                    }
                }
                    break;
                case 2:
                {
                    cell.typeLabel.text =NSLocalizedString(@"月收入", nil);
                    if (![_fateUserModel.monthly_income isEqualToString:@""]) {
                        cell.detailLabel.text = _fateUserModel.monthly_income;
                    } else {
                        cell.detailLabel.text = @"";
                    }
                }
                    break;
                    
                case 3:
                {
                    cell.typeLabel.text = NSLocalizedString(@"职业", nil);
                    if (![_fateUserModel.occupation isEqualToString:@""]) {
                        cell.detailLabel.text = _fateUserModel.occupation;
                    } else {
                        cell.detailLabel.text = @"";
                    }
                }
                    break;
                    
                case 4:
                {
                    cell.typeLabel.text = NSLocalizedString(@"年龄", nil);
                    if (![_fateUserModel.age isEqualToString:@""]) {
                        cell.detailLabel.text = [NSString stringWithFormat:@"%@%@",_fateUserModel.age,NSLocalizedString(@"岁", nil)];
                    } else {
                        cell.detailLabel.text = @"";
                    }
                }
                    break;
                    
                case 5:
                {
                    cell.typeLabel.text = NSLocalizedString(@"身高", nil);
                    if (![_fateUserModel.height isEqualToString:@""]) {
                        cell.detailLabel.text = [NSString stringWithFormat:@"%@cm",_fateUserModel.height];
                    } else {
                        cell.detailLabel.text = @"";
                    }
                }
                    break;
                    
                case 6:
                {
                    cell.typeLabel.text = NSLocalizedString(@"体重", nil);
                    if (![_fateUserModel.weight isEqualToString:@""]) {
                        cell.detailLabel.text = [NSString stringWithFormat:@"%@kg",_fateUserModel.weight];
                    } else {
                        cell.detailLabel.text = @"";
                    }
                }
                    break;
                    
                case 7:
                {
                    cell.typeLabel.text = NSLocalizedString(@"星座", nil);
                    if (![_fateUserModel.constellation isEqualToString:@""]) {
                        cell.detailLabel.text = _fateUserModel.constellation;
                    } else {
                        cell.detailLabel.text = @"";
                    }
                }
                    break;
                    
                case 8:
                {
                    cell.typeLabel.text = NSLocalizedString(@"血型", nil);
                    if (![_fateUserModel.blood_type isEqualToString:@""]) {
                        cell.detailLabel.text = _fateUserModel.blood_type;
                    } else {
                        cell.detailLabel.text = @"";
                    }
                }
                    break;
                    
                case 9:
                {
                    cell.typeLabel.text = NSLocalizedString(@"兴趣爱好", nil);
                    if (![_fateUserModel.hobby isEqualToString:@""]) {
                        cell.detailLabel.text = _fateUserModel.hobby;
                    } else {
                        cell.detailLabel.text = @"";
                    }
                }
                    break;
                    
                case 10:
                {
                    cell.typeLabel.text = NSLocalizedString(@"个人特征", nil);
                    if (![_fateUserModel.features isEqualToString:@""]) {
                        cell.detailLabel.text = _fateUserModel.features;
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
    } else  if (indexPath.section == 2) {
        static NSString *fateDetailConditionCell = @"FateDetailConditionCell";
        FateDetailConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:fateDetailConditionCell];
        if (cell == nil) {
            cell = [[FateDetailConditionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:fateDetailConditionCell];
        }
        return cell;
        
    } else
    {
        static NSString *fateDetailSpaceCell = @"FateDetailSpaceCell";
        FateDetailSpaceCell *cell = [tableView dequeueReusableCellWithIdentifier:fateDetailSpaceCell];
        if (cell == nil) {
            cell = [[FateDetailSpaceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:fateDetailSpaceCell];
        }
        switch (indexPath.section) {
            case 0:
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        cell.typeLabel.text = NSLocalizedString(@"最近上线时间", nil);
                        //在线信息
                        cell.detailLabel.text = _fateUserModel.online_content;
                    }
                        break;
                    case 1:
                    {
                        cell.typeLabel.text = NSLocalizedString(@"交友目的", nil);
                        if (![_fateUserModel.making_friends isEqualToString:@""]) {
                            cell.detailLabel.text = _fateUserModel.making_friends;
                        } else {
                            cell.detailLabel.text = @"";
                        }
                    }
                        break;
                    case 2:
                    {
                        cell.typeLabel.text = NSLocalizedString(@"恋爱观念", nil);
                        if (![_fateUserModel.love_concept isEqualToString:@""]) {
                            cell.detailLabel.text = _fateUserModel.love_concept;
                        } else {
                            cell.detailLabel.text = @"";
                        }
                    }
                        break;
                    case 3:
                    {
                        cell.typeLabel.text = NSLocalizedString(@"首次见面希望", nil);
                        if (![_fateUserModel.first_meeting_hope isEqualToString:@""]) {
                            cell.detailLabel.text = _fateUserModel.first_meeting_hope;
                        } else {
                            cell.detailLabel.text = @"";
                        }
                    }
                        break;
                    case 4:
                    {
                        cell.typeLabel.text = NSLocalizedString(@"最喜欢的爱爱地点", nil);
                        if (![_fateUserModel.love_place isEqualToString:@""]) {
                            cell.detailLabel.text = _fateUserModel.love_place;
                        } else {
                            cell.detailLabel.text = @"";
                        }
                        
                        
                    }
                        break;
                    default:
                        break;
                }
                
            }
                break;
            default:
                break;
        }
        
        return cell;
    }
}

#pragma mark UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *fateDetailHeadCellSection = @"FateDetailHeadCell";
    FateDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:fateDetailHeadCellSection];
    if (cell == nil) {
        cell = [[FateDetailHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:fateDetailHeadCellSection];
    }
    cell.indexpath = section;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( (indexPath.section == 1 && !_isOpen) || ( indexPath.section == 2)   ) {
        FateDetailConditionCell *conditionCell = (FateDetailConditionCell *)cell;
        if (_fateUserModel) {
            conditionCell.indexpath = indexPath;
            conditionCell.fateUserModel = _fateUserModel;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowWidth = 0;
    switch (indexPath.section) {
        case 0:
        case 2:
            rowWidth = 50;
            break;
        case 1:
        {
            if (_isOpen) {
                rowWidth = 50;
            } else {
                CGFloat width = 0;
                for (int i = 0; i < 6; i++) {
                    switch (i) {
                        case 0:
                        {
                            //职业
                            if (![_fateUserModel.occupation isEqualToString:@""]) {
                                CGFloat buttonWidth = [_fateUserModel.occupation textWidthWithContentHeight:30 font:[UIFont systemFontOfSize:kPercentIP6(14)]] + 15;
                                width += buttonWidth + 5;
                            }
                            
                        }
                            break;
                        case 1:
                        {
                            //收入
                            if (![_fateUserModel.monthly_income isEqualToString:@""]) {
                                CGFloat buttonWidth = [_fateUserModel.monthly_income textWidthWithContentHeight:30 font:[UIFont systemFontOfSize:kPercentIP6(14)]] + 15;
                                width += buttonWidth + 5;
                            }
                            
                        }
                            break;
                        case 2:
                        {
                            //体重
                            if (![_fateUserModel.weight isEqualToString:@""]) {
                                NSString *weight = [NSString stringWithFormat:@"%@kg",_fateUserModel.weight];
                                CGFloat buttonWidth = [weight textWidthWithContentHeight:30 font:[UIFont systemFontOfSize:kPercentIP6(14)]] + 15;
                                width += buttonWidth + 5;
                            }
                            
                        }
                            break;
                        case 3:
                        {
                            //血型
                            if (![_fateUserModel.blood_type isEqualToString:@""]) {
                                CGFloat buttonWidth = [_fateUserModel.blood_type textWidthWithContentHeight:30 font:[UIFont systemFontOfSize:kPercentIP6(14)]] + 15;
                                width += buttonWidth + 5;
                            }
                            
                        }
                            break;
                        case 4:
                        {
                            //星座
                            if (![_fateUserModel.constellation isEqualToString:@""]) {
                                CGFloat buttonWidth = [_fateUserModel.constellation textWidthWithContentHeight:30 font:[UIFont systemFontOfSize:kPercentIP6(14)]] + 15;
                                CGFloat cuttentWidth = ScreenWidth - 40 - width;
                                if (cuttentWidth <  buttonWidth + 5) {
                                    rowWidth = 87.5;
                                } else {
                                    width += buttonWidth + 5;
                                }
                            }
                            
                        }
                            break;
                        case 5:
                        {
                            CGFloat cuttentWidth = ScreenWidth - 40 - width;
                            if (cuttentWidth <  73) {
                                rowWidth = 87.5;
                            } else {
                                rowWidth = 50;
                            }
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
                
            }
        }
            break;
        default:
            break;
    }
    return rowWidth;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - Getters And Setters
@end
