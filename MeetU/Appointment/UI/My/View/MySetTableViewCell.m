//
//  MySetTableViewCell.m
//  Appointment
//
//  Created by feiwu on 16/7/16.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MySetTableViewCell.h"
@implementation MySetTableViewCell

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
    [self addSubview:self.typeLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.lineView];

}

#pragma mark 布局
- (void)makeConstraints
{
    WS(weakSelf);
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(130, 20));
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.arrowImageView.mas_left).offset(-10);
        make.left.mas_equalTo(weakSelf.typeLabel.mas_right).offset(15);
        make.centerY.mas_equalTo(weakSelf);
        make.height.mas_equalTo(20);
    }];

    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(6, 10));
    }];

       
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.bottom.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 24, 1));
    }];
}
#pragma mark - Getters And Setters
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
        _typeLabel.font = kFont15;
        _typeLabel.textColor = Color10(51,51,51, 1);
    }
    return _typeLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.font = kFont15;
        _detailLabel.textColor = Color10(153,153,153, 1);

        
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


@end
