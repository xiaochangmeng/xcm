//
//  FUTabView.m
//  UTalkSport
//
//  Created by feiwu on 16/7/20.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MZYTabView.h"
#import "MZYLabel.h"

#define kTabWidth 53.33

@implementation MZYTabView

#pragma mark - Life Cycle

- (id)init{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        [self initSubViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self initSubViews];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.userInteractionEnabled = YES;
    [self initSubViews];
}

#pragma mark - Private Methods

- (void)initSubViews{
    self.backgroundColor = Color10(255, 255, 255, 1);
    _scrollView.delegate = self;
}

#pragma mark - Public Methods

#pragma mark 代码轻拍某一项
- (void)tabIndex:(int)index{
    for (int j = 0; j < _labelArray.count; j++) {
        MZYLabel *myLabel = (MZYLabel *)_labelArray[j];
        UIView *myLineView = (UIView *)_lineViewArray[j];
        if (myLabel.tag == index) {
            myLabel.textColor = Color10(138,113,204, 1);
            myLineView.hidden = NO;
        }else {
            myLabel.textColor = Color10(51,51,51, 1);
            myLineView.hidden = YES;
        }
    }
    
    if (self.tabBlock) {
        self.tabBlock(index);
    }
}

#pragma mark - Getters And Settes

#pragma mark 设置标题数组时做初始化
-(void)setTitleArray:(NSArray *)titleArray{
    
    if (_titleArray!=titleArray) {
        _titleArray = titleArray;
    }
    
    
    //设置滚动视图
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.bounds.size.height)];
    _scrollView.userInteractionEnabled = YES;
    _scrollView.backgroundColor = Color10(255, 255, 255, 1);
    _scrollView.pagingEnabled = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.scrollsToTop = NO;
    [_scrollView setContentSize:CGSizeMake(_titleArray.count * kTabWidth , self.bounds.size.height)];
    [self addSubview:_scrollView];
    
    
    _labelArray = [NSMutableArray arrayWithCapacity:_titleArray.count];
    
    _lineViewArray = [NSMutableArray arrayWithCapacity:_titleArray.count];
    
    
    int tabWidth = kTabWidth;
    
    if (_titleArray.count < 6) {
        tabWidth = ScreenWidth / _titleArray.count;
    }
    for (int i = 0; i < self.titleArray.count; i++) {
        MZYLabel *label = [[MZYLabel alloc] initWithFrame:CGRectMake(i * tabWidth, 0,tabWidth, 64)];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, self.bounds.size.height - 2, tabWidth - 10, 12)];
        
#warning lineView BackgroundColor
        lineView.backgroundColor = Color10(138,113,204, 1);
        label.text = (NSString *)self.titleArray[i];
        label.font = kFont16;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            label.textColor = Color10(138,113,204, 1);
            lineView.hidden = NO;
        }else{
            label.textColor = Color10(51,51,51, 1);
            lineView.hidden = YES;
        }
        
        label.tag = i;
        [label addSubview:lineView];
        [_labelArray addObject:label];
        [_lineViewArray addObject:lineView];
        
        
        [_scrollView addSubview:label];
        
        
        
        
        __weak MZYLabel *thisLabel = label;
        __weak UIView *thisLineView = lineView;
        WS(weakSelf);
        label.touchBlock = ^{
            for (int j = 0; j < weakSelf.labelArray.count; j++) {
                if (thisLabel.tag == j) {
                    thisLabel.textColor = Color10(138,113,204, 1);
                    thisLineView.hidden = NO;
                }else{
                    MZYLabel *myLabel = (MZYLabel *)weakSelf.labelArray[j];
                    UIView *myLineView = (UIView *)weakSelf.lineViewArray[j];
                    myLabel.textColor = Color10(51,51,51, 1);
                    myLineView.hidden = YES;
                }
            }
            
            if (weakSelf.tabBlock) {
                weakSelf.tabBlock(i);
            }
        };
    }
    
}


@end
