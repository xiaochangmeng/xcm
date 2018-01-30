//
//  CirclePhotoView.m
//  Appointment
//
//  Created by feiwu on 2017/2/13.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "CirclePhotoView.h"

@implementation CirclePhotoView

- (id)init
{
    self = [super init];
    if (self) {
        [self initView];
        [self makeConstraints];
    }
    return self;
    
}

#pragma mark - Private Methods
//私有方法
- (void)initView
{
    //锁头
    [self addSubview:self.lockView];
    
}

- (void)makeConstraints
{
    WS(weakSelf)
    
    [_lockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf);
        make.centerY.mas_equalTo(weakSelf);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(12);
    }];
    
}

#pragma mark - Event Responses

#pragma mark - Getters And Setters

- (UIImageView *)lockView {
    if (!_lockView) {
        _lockView = [[UIImageView alloc] init];
        _lockView.image = LOADIMAGE(@"fate_detail_lock@2x", @"png");
        //        _lockView.backgroundColor = [UIColor orangeColor];
    }
    return _lockView;
}

@end
