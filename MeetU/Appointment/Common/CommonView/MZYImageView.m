//
//  FUImageView.m
//  Created by feiwu on 16/7/20.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MZYImageView.h"

@implementation MZYImageView

#pragma mark - Life Cycle

- (id)init{
    self = [super init];
    if (self) {
        [self initSubViews];
        
    }
    
    return self;
}

#pragma mark 手写代码时调这里
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

#pragma mark 从XIB中唤醒
- (void)awakeFromNib{
    [super awakeFromNib];
    [self initSubViews];
}

#pragma mark - Private Methods

- (void)initSubViews{
//    self.contentMode = UIViewContentModeScaleAspectFill;
    self.userInteractionEnabled = YES;
    //轻拍手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tapGesture];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionDown|UISwipeGestureRecognizerDirectionUp];
    [self addGestureRecognizer:swipeGesture];
    
    
}

#pragma mark - Event Responses

- (void)tapAction:(UITapGestureRecognizer *)gesture
{
    if (self.touchBlock) {
        _touchBlock();
    }
}

#pragma mark - Public Methods


@end
