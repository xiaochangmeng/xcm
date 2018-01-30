//
//  FULabel.m
//  Created by feiwu on 16/7/20.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.//

#import "MZYLabel.h"

@implementation MZYLabel

#pragma mark - Life Cycle

- (id)init{
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (id)initWithCircleWidth:(float)width
{
    self = [self init];
    if (self) {
        self.layer.cornerRadius = width/2;
        self.layer.masksToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initSubviews];
}


#pragma mark - Private Methods

- (void)initSubviews{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tapGesture];
}

#pragma mark - Event Responses

- (void)tapAction:(UITapGestureRecognizer *)gesture
{
    if (self.touchBlock) {
        _touchBlock();
    }
}


@end
