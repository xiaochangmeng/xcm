//
//  MyTableViewCell.m
//  Appointment
//
//  Created by feiwu on 16/7/18.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MyTableViewCell.h"
@implementation MyTableViewCell

#pragma mark - Life Cycle
//生命周期方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
        [self makeConstraints];
    }
    return self;
}

#pragma mark - Private Methods
//私有方法
#pragma mark 初始化
- (void)initView
{
    [self addSubview:self.typeImageView];
    [self addSubview:self.typeLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.lineView];
    
}

#pragma mark 布局
- (void)makeConstraints
{
    WS(weakSelf);
    [_typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.typeImageView.mas_right).offset(20);
        make.centerY.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(160, 20));
    }];
    
    
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(6, 10));
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.arrowImageView.mas_left).offset(-10);
        make.centerY.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(160, 20));
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.bottom.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 24, 1));
    }];
}
#pragma mark - Getters And Setters
- (UIImageView *)typeImageView {
    if (!_typeImageView) {
        _typeImageView = [[UIImageView alloc] init];
        //        _typeImageView.backgroundColor = [UIColor orangeColor];
    }
    return _typeImageView;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = LOADIMAGE(@"common_arrow@2x", @"png");
        //        _arrowImageView.backgroundColor = [UIColor orangeColor];
    }
    return _arrowImageView;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        //        _typeLabel.backgroundColor = [UIColor lightGrayColor];
        _typeLabel.font = kFont16;
        _typeLabel.textColor = Color10(102, 102, 102, 1);
        
    }
    return _typeLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        //        _detailLabel.backgroundColor = [UIColor lightGrayColor];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.font = kFont15;
        _detailLabel.textColor = Color10(153, 153, 153, 1);
        
    }
    return _detailLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = Color10(239, 239, 239, 1);
    }
    return _lineView;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    if (_indexPath != indexPath) {
        _indexPath = indexPath;
        switch (indexPath.section) {
            case 0:
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        _typeLabel.text = NSLocalizedString(@"写信包月", nil);
                        _detailLabel.hidden = NO;
                        _typeImageView.image = LOADIMAGE(@"my_write@2x", @"png");
                    }
                        break;
                    case 1:
                    {
                        _typeLabel.text = NSLocalizedString(@"VIP会员", nil);
                        _detailLabel.hidden = NO;
                        _typeImageView.image = LOADIMAGE(@"my_vip@2x", @"png");
                    }
                        break;
                        
                        
                    default:
                        break;
                }
                
            }
                break;
            case 1:
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        _typeLabel.text = NSLocalizedString(@"最近访客", nil);
                        _detailLabel.hidden = NO;
                        _typeImageView.image = LOADIMAGE(@"my_visitor@2x", @"png");
                        
                    }
                        break;
                        
                    case 1:
                    {
                        _typeLabel.text = NSLocalizedString(@"我的关注", nil);
                        _detailLabel.hidden = NO;
                        _typeImageView.image = LOADIMAGE(@"my_attention@2x", @"png");
                        
                    }
                        break;
                    case 2:
                    {
                        _typeLabel.text = NSLocalizedString(@"客服中心", nil);
                        _detailLabel.hidden = YES;
                        _typeImageView.image = LOADIMAGE(@"my_condition@2x", @"png");
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
    }
}
@end
