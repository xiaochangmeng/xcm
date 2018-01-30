//
//  FateDetailConditionCell.m
//  Appointment
//
//  Created by feiwu on 16/9/19.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "FateDetailConditionCell.h"
#import "NSString+MZYExtension.h"
#import "FateDetailTableView.h"
@implementation FateDetailConditionCell

#pragma mark - Life Cycle
//生命周期方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - Private Methods
//私有方法
#pragma mark 初始化
#pragma mark 布局

#pragma mark - Public Methods
//公有方法
#pragma mark 选中方法
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


#pragma mark - Notification Responses

#pragma mark - Event Response
//基本信息更多
- (void)handleOpenAction:(UIButton *)button
{
    for (int i = 0; i < _baseInfoArray.count; i++) {
        UIButton *button = _baseInfoArray[i];
        [button removeFromSuperview];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fateDetailTableViewOpenStatusChange" object:nil];
}

#pragma mark - Getters And Setters

- (void)setFateUserModel:(FateUserModel *)fateUserModel
{
    UIView *lastView = nil;
    CGFloat width = 0;
    WS(weakSelf);
    if (_fateUserModel != fateUserModel) {
        _fateUserModel = fateUserModel;
        if (_indexpath.section == 1 ) {
            CGFloat sumWidth = 0;
            //清除已显示基本信息
            for (int i = 0; i < _baseInfoArray.count; i++) {
                UIButton *button = (UIButton *)_baseInfoArray[i];
                [button removeFromSuperview];
            }
            
            if (!_baseInfoArray) {
                _baseInfoArray = [NSMutableArray array];
            }
            for (int i = 0; i < 6; i++) {
                UIButton *button;
                if (i  < _baseInfoArray.count) {
                    button = (UIButton *)_baseInfoArray[i];
                } else {
                    button = [[UIButton alloc] init];
                    [_baseInfoArray addObject:button];
                }
                
                button.titleLabel.font = [UIFont systemFontOfSize:kPercentIP6(14)];
                [button setTitleColor:Color16(0x999999) forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"common_hobbyBackground@2x" ImageType:@"png"withTop:5 andLeft:10] forState:UIControlStateNormal];
                switch (i) {
                    case 0:
                    {
                        //职业
                        if (![_fateUserModel.occupation isEqualToString:@""]) {
                            [self addSubview:button];
                            [button setTitle:_fateUserModel.occupation forState:UIControlStateNormal];
                            CGFloat buttonWidth = [_fateUserModel.occupation textWidthWithContentHeight:30 font:[UIFont systemFontOfSize:kPercentIP6(14)]] + 15;
                            [button mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.width.mas_equalTo(buttonWidth);
                                make.top.mas_equalTo(7.5);
                                make.left.mas_equalTo(20);
                                make.height.mas_equalTo(30);
                            }];
                            width += buttonWidth + 5;
                            sumWidth += buttonWidth + 5;
                        }
                        
                    }
                        break;
                    case 1:
                    {
                        //收入
                        if (![_fateUserModel.monthly_income isEqualToString:@""]) {
                            [self addSubview:button];
                            [button setTitle:_fateUserModel.monthly_income forState:UIControlStateNormal];
                            CGFloat buttonWidth = [_fateUserModel.monthly_income textWidthWithContentHeight:30 font:[UIFont systemFontOfSize:kPercentIP6(14)]] + 15;
                            [button mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.width.mas_equalTo(buttonWidth);
                                make.top.mas_equalTo(7.5);
                                make.left.mas_equalTo(weakSelf).offset(20 + width);
                                make.height.mas_equalTo(30);
                            }];
                            width += buttonWidth + 5;
                            sumWidth += buttonWidth + 5;
                        }
                        
                    }
                        break;
                    case 2:
                    {
                        //体重
                        if (![_fateUserModel.weight isEqualToString:@""]) {
                            [self addSubview:button];
                            NSString *weight = [NSString stringWithFormat:@"%@kg",_fateUserModel.weight];
                            [button setTitle:weight forState:UIControlStateNormal];
                            CGFloat buttonWidth = [weight textWidthWithContentHeight:30 font:[UIFont systemFontOfSize:kPercentIP6(14)]] + 15;
                            [button mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.width.mas_equalTo(buttonWidth);
                                make.top.mas_equalTo(7.5);
                                make.left.mas_equalTo(weakSelf).offset(20 + width);
                                make.height.mas_equalTo(30);
                            }];
                            width += buttonWidth + 5;
                            sumWidth += buttonWidth + 5;
                        }
                        
                    }
                        break;
                    case 3:
                    {
                        //血型
                        if (![_fateUserModel.blood_type isEqualToString:@""]) {
                            [self addSubview:button];
                            [button setTitle:_fateUserModel.blood_type forState:UIControlStateNormal];
                            CGFloat buttonWidth = [_fateUserModel.blood_type textWidthWithContentHeight:30 font:[UIFont systemFontOfSize:kPercentIP6(14)]] + 15;
                            CGFloat currentWidth = ScreenWidth - 40 - buttonWidth - sumWidth - 5;
                            [button mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.width.mas_equalTo(buttonWidth);
                                make.top.mas_equalTo(currentWidth >= 0 ? 7.5 : 42);
                                make.left.mas_equalTo(weakSelf).offset(currentWidth >= 0 ? 20 + width : 20);
                                make.height.mas_equalTo(30);
                            }];
                            
                            if (currentWidth >= 0) {
                                width += buttonWidth + 5;
                            } else {
                                width  = buttonWidth + 5;
                            }
                            sumWidth += buttonWidth + 5;
                            
                        }
                        
                    }
                        break;
                    case 4:
                    {
                        //星座
                        if (![_fateUserModel.constellation isEqualToString:@""]) {
                            [self addSubview:button];
                            [button setTitle:_fateUserModel.constellation forState:UIControlStateNormal];
                            CGFloat buttonWidth = [_fateUserModel.constellation textWidthWithContentHeight:30 font:[UIFont systemFontOfSize:kPercentIP6(14)]] + 15;
                            CGFloat topWidth = ScreenWidth - 40 - buttonWidth - sumWidth - 5;
                            CGFloat leftWidth = ScreenWidth - 40 - buttonWidth - width - 5;
                            [button mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.width.mas_equalTo(buttonWidth);
                                make.top.mas_equalTo(topWidth >= 0 ? 7.5 : 42);
                                make.left.mas_equalTo(weakSelf).offset(leftWidth >= 0 ? 20 + width : 20);
                                make.height.mas_equalTo(30);
                            }];
                            if (leftWidth >= 0) {
                                width += buttonWidth + 5;
                            } else {
                                width  = buttonWidth + 5;
                            }
                            sumWidth += buttonWidth + 5;
                        }
                        
                    }
                        break;
                    case 5:
                    {
                        //更多
                        [self addSubview:button];
                        sumWidth += 68 + 5;
                        [button setBackgroundImage:LOADIMAGE(NSLocalizedString(@"fate_detail_more", nil), @"png") forState:UIControlStateNormal];
                        [button addTarget:self action:@selector(handleOpenAction:) forControlEvents:UIControlEventTouchUpInside];
                        CGFloat currentWidth = ScreenWidth - 40 - 68 - width - 5;
                        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.width.mas_equalTo(68);
                            make.top.mas_equalTo(sumWidth > ScreenWidth - 40 ? 42 : 7.5);
                            make.left.mas_equalTo(weakSelf).offset(currentWidth >= 0 ? 20 + width : 20);
                            make.height.mas_equalTo(30);
                        }];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            
        }
    }
    
    //征友条件//
    for (int i = 0; i < _conditionArray.count; i++) {
        UIButton *button = (UIButton *)_conditionArray[i];
        [button removeFromSuperview];
    }

    if (_indexpath.section == 2) {
        if (!_conditionArray) {
            _conditionArray = [NSMutableArray array];
        }
        for (int i = 0; i < 3; i++) {
            UIButton *button;
            if (i < _conditionArray.count) {
                button = (UIButton *)_conditionArray[i];
            } else {
                button = [[UIButton alloc] init];
                [_conditionArray addObject:button];
            }
            [self addSubview:button];
            
            button.titleLabel.font = [UIFont systemFontOfSize:kPercentIP6(14)];
            [button setTitleColor:Color16(0x999999) forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"common_hobbyBackground@2x" ImageType:@"png"withTop:5 andLeft:10] forState:UIControlStateNormal];
            switch (i) {
                case 0:
                {
                    //年龄
                    NSString *age;
                    if (![_fateUserModel.partner_age isEqualToString:@""]) {
                        age = [NSString stringWithFormat:@"%@：%@%@",NSLocalizedString(@"年龄", nil),_fateUserModel.partner_age,NSLocalizedString(@"岁", nil)];
                    } else {
                        age = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"年龄", nil),NSLocalizedString(@"不限", nil)];
                    }
                    [button setTitle:age forState:UIControlStateNormal];
                    CGFloat buttonWidth = [age textWidthWithContentHeight:30 font:[UIFont systemFontOfSize:kPercentIP6(14)]] + 15;
                    [button mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(buttonWidth);
                        make.top.mas_equalTo(7.5);
                        make.left.mas_equalTo(20);
                        make.height.mas_equalTo(30);
                    }];
                    lastView = button;
                    width += buttonWidth + 5;
                    
                    
                }
                    break;
                case 1:
                {
                    //身高
                    NSString *height;
                    if (![_fateUserModel.partner_height isEqualToString:@""]) {
                        height = [NSString stringWithFormat:@"%@：%@cm",NSLocalizedString(@"身高", nil),_fateUserModel.partner_height];
                    } else {
                        height = [NSString stringWithFormat:@"%@： %@",NSLocalizedString(@"身高", nil),NSLocalizedString(@"不限", nil)];
                    }
                    [button setTitle:height forState:UIControlStateNormal];
                    CGFloat buttonWidth = [height textWidthWithContentHeight:30 font:[UIFont systemFontOfSize:kPercentIP6(14)]] + 15;
                    [button mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(buttonWidth);
                        make.top.mas_equalTo(7.5);
                        make.left.mas_equalTo(lastView ? lastView.mas_right : weakSelf).offset(lastView ? 5 : 20);                            make.height.mas_equalTo(30);
                    }];
                    lastView = button;
                    width += buttonWidth + 5;
                    
                    
                }
                    break;
                case 2:
                {
                    //地区
                    NSString *province ;
                    if (![_fateUserModel.partner_province isEqualToString:@""]) {
                        province = [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"地区", nil),_fateUserModel.partner_province];
                    } else {
                        province = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"地区", nil),NSLocalizedString(@"不限", nil)];
                    }
                    [button setTitle:province forState:UIControlStateNormal];
                    CGFloat buttonWidth = [province textWidthWithContentHeight:30 font:[UIFont systemFontOfSize:kPercentIP6(14)]] + 15;
                    [button mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(buttonWidth);
                        make.top.mas_equalTo(7.5 );
                        make.left.mas_equalTo(lastView ? lastView.mas_right : weakSelf).offset(lastView ? 5 : 20);
                        make.height.mas_equalTo(30);
                    }];
                    lastView = button;
                    width += buttonWidth + 5;
                    
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
    //征友条件////
    
}
@end
