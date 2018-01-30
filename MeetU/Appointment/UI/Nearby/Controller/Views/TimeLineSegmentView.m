//
//  TimeLineSegmentView.m
//  TimeLine
//
//  Created by oujinlong on 16/6/13.
//  Copyright © 2016年 oujinlong. All rights reserved.
//

#import "TimeLineSegmentView.h"
#define color(r,g,b)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface TimeLineSegmentView ()
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, weak) UIButton* leftButton;
@property (nonatomic, weak) UIButton* rightButton;

@end
@implementation TimeLineSegmentView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMain];
    }
    return self;
}

-(void)setupMain{
    self.backgroundColor = [UIColor blackColor];
    
    self.currentIndex = 0;
    
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton = leftButton;
    [leftButton setTitle:@"个人" forState:UIControlStateNormal];
    [leftButton setTitleColor:color(151, 151, 151) forState:UIControlStateNormal];
    [leftButton setBackgroundColor:color(45, 46, 47)];
    [self addSubview:leftButton];
    leftButton.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width / 2 - 1.5, self.frame.size.height);
    leftButton.tag = 1;
    [leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton = rightButton;
    [rightButton setTitle:@"乐队" forState:UIControlStateNormal];
    [rightButton setTitleColor:color(151, 151, 151) forState:UIControlStateNormal];
    [rightButton setBackgroundColor:color(45, 46, 47)];
    [self addSubview:rightButton];
    rightButton.frame = CGRectMake(CGRectGetMaxX(leftButton.frame) + 3, 0, [UIScreen mainScreen].bounds.size.width /2 - 1.5, self.frame.size.height);
    [rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self refreshButtonState];
}
-(void)refreshButtonState{
    self.leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:self.currentIndex == 0 ? 20 : 15];
    
    self.rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:self.currentIndex == 1 ? 20 : 15];
}
-(void)buttonClick:(UIButton*)button{
    if ([self.delegate respondsToSelector:@selector(TimeLineSegmentViewDidClickButtonWithIndex:)]) {
        if (button.tag == 1) {
            self.currentIndex = 0;
            [self.delegate TimeLineSegmentViewDidClickButtonWithIndex:0];
        }else{
            self.currentIndex = 1;
            [self.delegate TimeLineSegmentViewDidClickButtonWithIndex:1];
        }
        
        [self refreshButtonState];
    }
}

-(void)setCurrentPageIndex:(NSInteger)index{
    self.currentIndex = index;
    [self.delegate TimeLineSegmentViewDidClickButtonWithIndex:index];
    [self refreshButtonState];

}
@end
