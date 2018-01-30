//
//  FansTabView.m
//  Created by feiwu on 16/7/20.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MyInfoTabView.h"

@implementation MyInfoTabView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    
    _tabView = [[MZYTabView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
    _tabView.titleArray = [NSArray arrayWithObjects:NSLocalizedString(@"基本档案", @"基本档案"),NSLocalizedString(@"个人爱好", @"个人爱好"),NSLocalizedString(@"详细档案", @"详细档案"),nil];
    [self addSubview:_tabView];
    
    [_tabView tabIndex:0];
    
    //底线
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 89.5, ScreenWidth, 0.5)];
    _lineView.backgroundColor = Color10(224,224,224, 1);
    [self addSubview:_lineView];

    
}

- (void)dealloc {
}
@end
