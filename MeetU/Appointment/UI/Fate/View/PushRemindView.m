//
//  PushRemindView.m
//  Appointment
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "PushRemindView.h"
#import "LXFileManager.h"
typedef enum{
    PUSHREMINDVIEW_OPENBUTTON,            //开启
    PUSHREMINDVIEW_CANCLEBUTTON,        //不开启
    PUSHREMINDVIEW_NOREMIDDBUTTON     //不在提醒
}PushRemindViewButton;

#define SpaceForMargin [self spaceForMargin]

@interface PushRemindView()

/**半透明试图 */
@property (strong, nonatomic) UIView* alphaView;

/**提醒框试图 */
@property (strong, nonatomic) UIView* remindView;

/**内容label */
@property (strong, nonatomic) UILabel* contentLabel;

/**取消按钮 */
@property (strong, nonatomic) UIButton* cancleButton;

/**开启按钮 */
@property (strong, nonatomic) UIButton* openButton;

/**不在提醒按钮 */
@property (strong, nonatomic) UIButton* noRemindButton;


@property (strong, nonatomic) UILabel* horLine_1;
@property (strong, nonatomic) UILabel* horLine_2;
@property (strong, nonatomic) UILabel* verLine;

@end
@implementation PushRemindView


- (void)clickButtonHandle:(UIButton*)sender{
    
    switch (sender.tag) {
        case PUSHREMINDVIEW_OPENBUTTON:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            [self removeFromSuperview];
        }
            break;
        case PUSHREMINDVIEW_CANCLEBUTTON:
        {
            [self removeFromSuperview];
        }
            break;
        case PUSHREMINDVIEW_NOREMIDDBUTTON:
        {
            [self removeFromSuperview];
            [LXFileManager setUserChooseOfPush:YES];
            
        }
            break;
        default:
            break;
    }
}


+(instancetype)sharedInstance{
    static PushRemindView *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
        sharedAccountManagerInstance.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    });
    return sharedAccountManagerInstance;
}

- (instancetype)init{
    if (self = [super init]) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    //    self.backgroundColor = [UIColor blackColor];
    
    [self addSubview:self.alphaView];
    
    [self addSubview:self.remindView];
    
    [self addSubview:self.contentLabel];
    
    [self addSubview:self.horLine_1];
    
    [self addSubview:self.verLine];
    
    [self addSubview:self.horLine_2];
    
    [self addSubview:self.openButton];
    
    [self addSubview:self.cancleButton];
    
    [self addSubview:self.noRemindButton];
    
    [self makeConstraints];
}

- (void)makeConstraints{
    WS(weakSelf);
    //半透明背景
    [_alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf);
        make.left.mas_equalTo(weakSelf);
        make.bottom.mas_equalTo(weakSelf);
        make.right.mas_equalTo(weakSelf);
    }];
    
    //弹窗试图
    [_remindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(SpaceForMargin);
        make.right.mas_equalTo(weakSelf).offset(-SpaceForMargin);
        make.height.mas_equalTo(174);
        make.centerY.mas_equalTo(weakSelf).offset(-40);
    }];
    
    //内容
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.remindView).offset(24.5);
        make.right.mas_equalTo(weakSelf.remindView).offset(-24.5);
        make.height.mas_equalTo(45.5);
        make.top.mas_equalTo(weakSelf.remindView).offset(23.5);
    }];
    
    //水平线 1
    [_horLine_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.contentLabel.mas_bottom).offset(16.5);
        make.left.mas_equalTo(weakSelf.remindView);
        make.right.mas_equalTo(weakSelf.remindView);
        make.height.mas_equalTo(1);
    }];
    
    //开启按钮
    [_openButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.horLine_1.mas_bottom);
        make.left.mas_equalTo(weakSelf.remindView);
        make.width.mas_equalTo((ScreenWidth - SpaceForMargin * 2) / 2 - 0.5);
        make.height.mas_equalTo(43.5);
    }];
    
    //竖直线
    [_verLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.horLine_1.mas_bottom);
        make.left.mas_equalTo(weakSelf.openButton.mas_right);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(43.5);
    }];
    
    //取消按钮
    [_cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.horLine_1.mas_bottom);
        make.right.mas_equalTo(weakSelf.remindView.mas_right);
        make.width.mas_equalTo((ScreenWidth - SpaceForMargin * 2) / 2 - 0.5);
        make.height.mas_equalTo(43.5);
    }];
    
    //水平线2
    [_horLine_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.openButton.mas_bottom);
        make.left.mas_equalTo(weakSelf.remindView);
        make.right.mas_equalTo(weakSelf.remindView);
        make.height.mas_equalTo(1);
    }];
    
    //不在提醒按钮
    [_noRemindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.horLine_2.mas_bottom);
        make.left.mas_equalTo(weakSelf.remindView);
        make.right.mas_equalTo(weakSelf.remindView);
        make.bottom.mas_equalTo(weakSelf.remindView);
    }];
}

- (UIView *)alphaView{
    if (_alphaView == nil) {
        _alphaView = [UIView new];
        _alphaView.backgroundColor = [UIColor blackColor];
        _alphaView.alpha = 0.5;
    }
    return _alphaView;
}

- (UIView *)remindView{
    if (_remindView == nil) {
        _remindView = [UIView new];
        _remindView.backgroundColor = [UIColor whiteColor];
        _remindView.layer.cornerRadius = 5;
        _remindView.layer.masksToBounds = YES;
        
    }
    return _remindView;
}

- (UILabel *)contentLabel{
    if (_contentLabel == nil) {
        _contentLabel = [UILabel new];
        _contentLabel.text = NSLocalizedString(@"你的手机没有有开启消息推送会导致不能及时查看Ta的来信。要开启推送？", nil);
        _contentLabel.font = [UIFont systemFontOfSize:kPercentIP6(14)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.minimumScaleFactor = 0.5;
        _contentLabel.textColor = Color10(3, 3, 3, 1);
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLabel;
}

- (UIButton *)openButton{
    if (_openButton == nil) {
        _openButton = [UIButton new];
        [_openButton setTitle:NSLocalizedString(@"立刻设置", nil) forState:UIControlStateNormal];
        [_openButton setTitleColor:Color10(0, 118, 255, 1) forState:UIControlStateNormal];
        _openButton.tag = 0;
        [_openButton addTarget:self action:@selector(clickButtonHandle:) forControlEvents:UIControlEventTouchDown];
    }
    return _openButton;
}

- (UIButton *)cancleButton{
    if (_cancleButton == nil) {
        _cancleButton = [UIButton new];
        [_cancleButton setTitle:NSLocalizedString(@"稍后提醒", nil) forState:UIControlStateNormal];
        [_cancleButton setTitleColor:Color10(0, 118, 255, 1) forState:UIControlStateNormal];
        _cancleButton.tag = 1;
        [_cancleButton addTarget:self action:@selector(clickButtonHandle:) forControlEvents:UIControlEventTouchDown];
    }
    return _cancleButton;
}



- (UIButton *)noRemindButton{
    if (_noRemindButton == nil) {
        _noRemindButton = [UIButton new];
        [_noRemindButton setTitle:NSLocalizedString(@"不在提醒", nil) forState:UIControlStateNormal];
        [_noRemindButton setImage:LOADIMAGE(@"push_check@2x", @"png") forState:UIControlStateNormal];
        [_noRemindButton setTitleColor:Color10(153, 153, 153, 1) forState:UIControlStateNormal];
        _noRemindButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _noRemindButton.tag = 2;
        [_noRemindButton addTarget:self action:@selector(clickButtonHandle:) forControlEvents:UIControlEventTouchDown];
    }
    return _noRemindButton;
}


- (UILabel *)horLine_1{
    if (_horLine_1 == nil) {
        _horLine_1 = [UILabel new];
        _horLine_1.backgroundColor = Color10(203, 199, 203, 1);
    }
    return _horLine_1;
}

- (UILabel *)horLine_2{
    if (_horLine_2 == nil) {
        _horLine_2 = [UILabel new];
        _horLine_2.backgroundColor = Color10(203, 199, 203, 1);
    }
    return _horLine_2;
}


- (UILabel *)verLine{
    if (_verLine == nil) {
        _verLine = [UILabel new];
        _verLine.backgroundColor = Color10(203, 199, 203, 1);
    }
    return _verLine;
}

/**
 *  不同屏幕距离边界的距离
 *
 *  @return 边界距离
 */
- (CGFloat)spaceForMargin{
    if (ScreenWidth < 330) {
        return 16;
    }else{
        return 52;
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
