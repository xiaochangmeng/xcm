//
//  FateCollectionHeadView.m
//  Appointment
//
//  Created by feiwu on 16/8/29.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "FateCollectionHeadView.h"
#import "FateViewController.h"
#import "MyFeedBackViewController.h"
@implementation FateCollectionHeadView
#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initSubviews];
    }
    return self;
}

#pragma mark - Private Methods
- (void)initSubviews{
    [self addSubview:self.headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}


#pragma mark - Event Responses

#pragma mark - Getters And Setters
- (MZYImageView *)headImageView {
    if (!_headImageView) {
        WS(weakSelf);
        _headImageView = [[MZYImageView alloc] init];
        _headImageView.contentMode = UIViewContentModeScaleToFill;
        _headImageView.image = LOADIMAGE(@"fate_activity_one", @"jpg");
        _headImageView.touchBlock =^(){
            [MobClick event:@"fate_activity"];
            FateViewController *fate = (FateViewController *)weakSelf.viewController;
            //短信包月
            MyFeedBackViewController *feed = [[MyFeedBackViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/WebApi/Activity/apple_recharge_100_v1.html?first=yes",BaseUrl]];
            feed.titleStr = NSLocalizedString(@"话费活动", nil);
            feed.pushType = @"activity-write";
            [fate.navigationController pushViewController:feed animated:YES];
        };
        _headImageView.backgroundColor = [UIColor clearColor];
    }
    return _headImageView;
}

@end
