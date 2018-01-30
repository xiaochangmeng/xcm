//
//  FateDetailSpaceCell.m
//  Appointment
//
//  Created by feiwu on 16/9/18.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "FateDetailSpaceCell.h"
@implementation FateDetailSpaceCell

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
    //类别
    [self addSubview:self.typeLabel];
    
    //详情
    [self addSubview:self.detailLabel];

    //最底部线
    [self addSubview:self.lineView];
}

#pragma mark 布局
- (void)makeConstraints
{
    WS(weakSelf);
    //类型
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(weakSelf).offset(1);
        make.bottom.mas_equalTo(weakSelf).offset(-1);
        make.width.mas_equalTo(200);
    }];
    
    //详情
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(weakSelf).offset(1);
        make.bottom.mas_equalTo(weakSelf).offset(-1);
        make.width.mas_equalTo(ScreenWidth - 30 - 110);
    }];

    //最底部线
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(weakSelf).offset(0);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - Public Methods
//公有方法
#pragma mark 选中方法
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


#pragma mark - Getters And Setters
- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = kFont14;
//        _typeLabel.text = @"最近上线时间";
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        _typeLabel.textColor = Color16(0x999999);
//        _typeLabel.backgroundColor = [UIColor orangeColor];
    }
    return _typeLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = kFont14;
//        _detailLabel.text = @"查看在线时间";
        _detailLabel.textColor = Color16(0x666666);
        _detailLabel.textAlignment = NSTextAlignmentRight;
//        _detailLabel.backgroundColor = [UIColor orangeColor];
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
