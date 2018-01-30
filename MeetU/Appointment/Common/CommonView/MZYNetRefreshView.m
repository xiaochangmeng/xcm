//
//  FUCenterNetRefreshView.m
//  SportIM
//
//  Created by Mac-apple on 15/11/10.
//  Copyright © 2015年 广州晌网文化传播有限公司. All rights reserved.
//

#import "MZYNetRefreshView.h"

@implementation MZYNetRefreshView

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

#pragma mark - Private Methods

- (void)initSubviews{
    //遮罩层
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.frame = self.frame;
    backgroundView.backgroundColor = Color10(231, 232, 234, 1);
    
    [self addSubview:backgroundView];
    
    _refreshLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.center.y - 73, ScreenWidth, 16)];
    _refreshLabel.text = NSLocalizedString(@"页面加载失败,请点击下方按钮重新刷新", @"页面加载失败,请点击下方按钮重新刷新");
    _refreshLabel.textColor = Color16(0x999999);
    _refreshLabel.font = kFont14;
    _refreshLabel.textAlignment = NSTextAlignmentCenter;
    [backgroundView addSubview:_refreshLabel];
    
    _refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(self.center.x - 77.5, _refreshLabel.frame.origin.y + 45 , 155, 41)];
    [_refreshButton addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventTouchUpInside];
    [_refreshButton setTitleColor:Color10(235,98,0, 1) forState:UIControlStateNormal];
    _refreshButton.titleLabel.font = kFont16;
    [_refreshButton setBackgroundImage:LOADIMAGE(NSLocalizedString(@"common_refresh@2x", nil), @"png") forState:UIControlStateNormal];
    [backgroundView addSubview:_refreshButton];
    
}

#pragma mark - Event Responses

- (void)handleRefresh
{
    if (_refreshBlock) {
        _refreshBlock();
    }
}
@end
