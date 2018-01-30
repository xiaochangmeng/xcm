//
//  MyTabBarView.m
//  Appointment
//
//  Created by feiwu on 16/7/7.
//  Copyright © 2016年 mazhiyuan. All rights reserved.

#import "TabBarView.h"
#import "AppDelegate.h"
#import "LXFileManager.h"
#import "NSObject+XWAdd.h"
#define kButtonWidth ScreenWidth/4 //60
#define kButtonHeight 25
#define kPadding 0 //30
#define kPadding2 0//(ScreenWidth - (kButtonWidth * 4 + kPadding * 2))/3
#define kCountLabelWidth 8.f

@implementation TabBarView

#pragma mark - Life Cycle

- (id)initWithIndex:(int)index
{
    self = [self init];
    if (self) {
        _index = index;
    }
    return self;
}


- (id)init {
    self = [super init];
    if (!self) return nil;
    [self initSubviews];
    WS(weakSelf);
    [self xw_addNotificationForName:@"LetterCountChange" block:^(NSNotification *notification) {
        NSString *count = [notification object];
        if ([count integerValue] > 0) {
            weakSelf.countLabel.hidden = NO;
            weakSelf.countLabel.text = count;
        } else {
            weakSelf.countLabel.hidden = YES;
        }
    }];
    
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    UIButton *btn = (UIButton *)[self viewWithTag:_index + 2000];
    btn.highlighted = YES;
    UILabel *label = (UILabel *)[self viewWithTag:_index + 3000];
    label.textColor = Color16(0xF85F73);
}
#pragma mark - Private Methods

- (void)initSubviews{
    UIView *superview = self;
    __weak TabBarView *this = self;
    
    WS(weakSelf)
    
    //背景
    UIImageView *backgroundImageView = [UIImageView new];
    backgroundImageView.backgroundColor = Color10(255,255,255, 1);
    [self addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(49);
        make.top.mas_equalTo(superview.mas_top).offset(0);
        make.left.mas_equalTo(superview.mas_left);
    }];
    
    
    //线视图
    UIView *lineView = [UIView new];
    lineView.backgroundColor =  Color10(216,216,216, 1);
    [backgroundImageView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(0.3);
        make.top.mas_equalTo(backgroundImageView.mas_top);
        make.left.mas_equalTo(0);
    }];
    
    //缘份
    _fateButton = [UIButton new];
    [_fateButton setImage:LOADIMAGE(@"first_normal@2x", @"png") forState:UIControlStateNormal];
    [_fateButton setImage:LOADIMAGE(@"first_selected@2x", @"png") forState:UIControlStateHighlighted];
    
    _fateButton.tag = 2000;
    
    [_fateButton addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_fateButton];
    
    
    
    MZYLabel *fateLabel = [MZYLabel new];
    fateLabel.backgroundColor = [UIColor clearColor];
    fateLabel.text = NSLocalizedString(@"缘份", nil);
    fateLabel.font = kFont12;
    fateLabel.textColor =  Color10(134,134,134, 1);
    fateLabel.textAlignment = NSTextAlignmentCenter;
    fateLabel.tag = 3000;
    [self addSubview:fateLabel];
    fateLabel.touchBlock = ^(){
        [this selectedLabel:0];
    };
    
    
    
    [_fateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kButtonWidth);
        make.height.mas_equalTo(kButtonHeight);
        make.top.mas_equalTo(superview.mas_top).offset(5);
        make.left.mas_equalTo(superview.mas_left).offset(kPadding);
    }];
    
    [fateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakSelf.fateButton.mas_width);
        make.height.mas_equalTo(12);
        
        make.top.mas_equalTo(weakSelf.fateButton.mas_bottom).offset(2);
        make.left.mas_equalTo(weakSelf.fateButton.mas_left);
    }];
    
    
    
    
    //私信
    _letterButton = [UIButton new];
    [_letterButton setImage: LOADIMAGE(@"third_normal@2x", @"png") forState:UIControlStateNormal];
    [_letterButton setImage:LOADIMAGE(@"third_selected@2x", @"png") forState:UIControlStateHighlighted];
    _letterButton.tag = 2001;
    
    [_letterButton addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_letterButton];
    
    MZYLabel *letterLabel = [MZYLabel new];
    letterLabel.backgroundColor = [UIColor clearColor];
    letterLabel.text = NSLocalizedString(@"私信", @"訊息");
    letterLabel.font = kFont12;
    letterLabel.textColor = Color10(134,134,134, 1);
    letterLabel.textAlignment = NSTextAlignmentCenter;
    letterLabel.tag = 3001;
    [self addSubview:letterLabel];
    letterLabel.touchBlock = ^(){
        [this selectedLabel:1];
    };
    NSString *userid = [NSString stringWithFormat:@"%@%@",[FWUserInformation sharedInstance].mid,kUserLetterCount];
    NSString *oldCount = [LXFileManager readUserDataForKey:userid];
    
    _countLabel = [MZYLabel new];
    _countLabel.backgroundColor = Color10(242,92,53, 1);
    _countLabel.font = kFont10;
    _countLabel.textColor = Color10(255,255,255, 1);
    _countLabel.layer.masksToBounds = YES;
    _countLabel.layer.cornerRadius = 7.5;
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.text = oldCount;
    [self addSubview:_countLabel];
    
    if ([oldCount integerValue] > 0) {
        _countLabel.hidden = NO;
        
    } else {
        _countLabel.hidden = YES;
    }
    
    [letterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakSelf.letterButton.mas_width);
        make.height.mas_equalTo(12);
        make.top.mas_equalTo(weakSelf.letterButton.mas_bottom).offset(2);
        make.left.mas_equalTo(weakSelf.letterButton.mas_left);
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
        make.top.mas_equalTo(weakSelf.letterButton.mas_top).offset(0);
        make.left.mas_equalTo(weakSelf.letterButton.mas_left).offset(ScreenWidth / 5 / 2.0 + 10);
    }];
    
    
    [_letterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakSelf.fateButton.mas_width);
        make.height.mas_equalTo(weakSelf.fateButton.mas_height);
        make.top.mas_equalTo(weakSelf.fateButton.mas_top);
        make.left.mas_equalTo(weakSelf.fateButton.mas_right).offset(kPadding2);
    }];
    
    //附近
    _nearbyButton = [UIButton new];
    [_nearbyButton setImage: LOADIMAGE(@"fourth_normal@2x", @"png") forState:UIControlStateNormal];
    [_nearbyButton setImage: LOADIMAGE(@"fourth_selected@2x", @"png") forState:UIControlStateHighlighted];
    _nearbyButton.tag = 2002;
    [_nearbyButton addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_nearbyButton];
    
    MZYLabel *nearbyLabel = [MZYLabel new];
    nearbyLabel.backgroundColor = [UIColor clearColor];
    nearbyLabel.text = NSLocalizedString(@"圈子", @"圈子");
    nearbyLabel.font = kFont12;
    nearbyLabel.textColor = Color10(134,134,134, 1);
    nearbyLabel.textAlignment = NSTextAlignmentCenter;
    nearbyLabel.tag = 3002;
    [self addSubview:nearbyLabel];
    nearbyLabel.touchBlock = ^(){
        [this selectedLabel:2];
    };
    
    
    [nearbyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakSelf.nearbyButton.mas_width);
        make.height.mas_equalTo(12);
        make.top.mas_equalTo(weakSelf.nearbyButton.mas_bottom).offset(2);
        make.left.mas_equalTo(weakSelf.nearbyButton.mas_left);
    }];
    
    [_nearbyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakSelf.fateButton.mas_width);
        make.height.mas_equalTo(weakSelf.fateButton.mas_height);
        make.top.mas_equalTo(weakSelf.fateButton.mas_top);
        make.left.mas_equalTo(weakSelf.letterButton.mas_right).offset(kPadding2);
    }];
    
    
    //我的
    _myButton = [UIButton new];
    [_myButton setImage: LOADIMAGE(@"fifth_normal@2x", @"png") forState:UIControlStateNormal];
    [_myButton setImage: LOADIMAGE(@"fifth_selected@2x", @"png") forState:UIControlStateHighlighted];
    
    _myButton.tag = 2003;
    
    [_myButton addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_myButton];
    
    MZYLabel *myLabel = [MZYLabel new];
    myLabel.backgroundColor = [UIColor clearColor];
    myLabel.text = NSLocalizedString(@"我的", @"我的");
    myLabel.font = kFont12;
    myLabel.textColor = Color10(134,134,134, 1);
    myLabel.textAlignment = NSTextAlignmentCenter;
    myLabel.tag = 3003;
    [self addSubview:myLabel];
    myLabel.touchBlock = ^(){
        [this selectedLabel:3];
    };
    
    
    [myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakSelf.myButton.mas_width);
        make.height.mas_equalTo(12);
        
        make.top.mas_equalTo(weakSelf.myButton.mas_bottom).offset(2);
        make.left.mas_equalTo(weakSelf.myButton.mas_left);
    }];
    
    [_myButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakSelf.fateButton.mas_width);
        make.height.mas_equalTo(weakSelf.fateButton.mas_height);
        make.top.mas_equalTo(weakSelf.fateButton.mas_top);
        make.left.mas_equalTo(weakSelf.nearbyButton.mas_right).offset(kPadding2);
    }];
    
    
}

#pragma mark - Event Responses

#pragma mark 点击Tabbar按钮触发
- (void)selectedButton:(UIButton *)btn
{
    if (_index != btn.tag - 2000) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.window.rootViewController = [appDelegate.viewControllers objectAtIndex:btn.tag - 2000];
    }else{
        [self setNeedsLayout ];
    }
}

#pragma mark 点击标签触发
- (void)selectedLabel:(int)index{
    if (_index != index) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.window.rootViewController = [appDelegate.viewControllers objectAtIndex:index];
    }else{
        [self setNeedsLayout];
    }
    
}


@end
