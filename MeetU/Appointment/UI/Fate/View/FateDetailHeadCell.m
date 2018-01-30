//
//  FateDetailHeadCell.m
//  Appointment
//
//  Created by feiwu on 16/9/18.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "FateDetailHeadCell.h"

@implementation FateDetailHeadCell

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
    self.backgroundColor = [UIColor whiteColor];
    //类别
    [self addSubview:self.typeLabel];
}

#pragma mark 布局
- (void)makeConstraints
{
    WS(weakSelf);
    //类型
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(weakSelf).offset(18);
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
         _typeLabel.text = NSLocalizedString(@"个人空间", nil);
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        [_typeLabel sizeToFit];
        _typeLabel.textColor = Color16(0x333333);
        //        _typeLabel.backgroundColor = [UIColor orangeColor];
    }
    return _typeLabel;
}

- (void)setIndexpath:(NSInteger )indexpath
{
    if (_indexpath != indexpath) {
        _indexpath = indexpath;
        
        switch (_indexpath) {
            case 0:
                _typeLabel.text = NSLocalizedString(@"个人空间", nil);
                break;
            case 1:
                _typeLabel.text = NSLocalizedString(@"基本档案", nil);
                break;
            case 2:
                _typeLabel.text = NSLocalizedString(@"征友条件", nil);
                break;
            default:
                break;
        }
    }

}
@end
