//
//  SquareTableViewSection.m
//  fanszone
//  广场TableViewSection
//  Created by 叶建超 on 22/5/2016.
//  Copyright © 2016年 广州晌网文化传播有限公司. All rights reserved.
//

#import "MyInfoTableViewSection.h"

@implementation MyInfoTableViewSection

#pragma mark - Life Cycle
//生命周期方法
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
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
    [self addSubview:self.tipLabel];
}

#pragma mark 布局
- (void)makeConstraints
{
    
    WS(weakSelf)
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(15);
        make.centerY.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 20));
    }];
    
}

#pragma mark - Public Methods
//公有方法
#pragma mark 选中方法

#pragma mark - Event Responses

#pragma mark - Network Data
//网络请求处理方法


#pragma mark - Getters And Setters
- (UILabel *)tipLabel {
	if (!_tipLabel) {
		_tipLabel = [[UILabel alloc] init];
        _tipLabel.font = kFont16;
        _tipLabel.textColor = [UIColor lightGrayColor];
//        _tipLabel.backgroundColor = [UIColor orangeColor];
        _tipLabel.textAlignment = NSTextAlignmentLeft;
	}
	return _tipLabel;
}
@end
