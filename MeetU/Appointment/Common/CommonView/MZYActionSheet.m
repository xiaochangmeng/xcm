//
//  FUActionSheet.m
//  Created by feiwu on 16/7/20.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MZYActionSheet.h"


@implementation MZYActionSheet

#pragma mark - Life Cycle

- (id)init{
    self = [super init];
    if (self) {
        self.backgroundColor = Color10(237, 237, 237, 1);
        
        [self initView];
    }
    return self;
}



- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Color10(237, 237, 237, 1);
        
        [self initView];
    }
    return self;
}

#pragma mark - Private Methods

- (void)initView
{
    WS(weakSelf)
    
    UIImage *defaultButtonImage = [UIImage imageNamed:@"common_actionsheet_button_normal@2x"ImageType:@"png"  withTop:5 andLeft:5];
    
    UIImage *highlightedButtonImage = [UIImage imageNamed:@"common_actionsheet_button_highlight@2x" ImageType:@"png" withTop:5 andLeft:5];
    
    //取消
    _cancelButton = [UIButton new];
    _cancelButton.layer.borderColor = Color10(224,224,224, 1).CGColor;
    _cancelButton.layer.borderWidth = 0.5f;
    _cancelButton.tag = 100;
    [_cancelButton setBackgroundImage:defaultButtonImage forState:UIControlStateNormal];
    [_cancelButton setBackgroundImage:highlightedButtonImage forState:UIControlStateHighlighted];
    [_cancelButton setTitleColor:Color10(119,119,119, 1) forState:UIControlStateNormal];
    [_cancelButton setTitle:NSLocalizedString(@"取消", @"取消") forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelButton];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf);
        make.left.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 49));
    }];

}

- (void)setTitle:(NSString *)title otherButtonTitle:(NSArray *)other
{
    WS(weakSelf)
    UIImage *defaultButtonImage = [UIImage imageNamed:@"common_actionsheet_button_normal@2x" ImageType:@"png" withTop:5 andLeft:5];
    
    UIImage *highlightedButtonImage = [UIImage imageNamed:@"common_actionsheet_button_highlight@2x" ImageType:@"png" withTop:5 andLeft:5];
    
    int count = (int)other.count + 1;
    
    if (!_titleColor) {
        _titleColor = Color10(235,98,0, 1);
    }
    
    if (title) {
        
        count +=1;
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.layer.borderColor = Color10(224,224,224, 1).CGColor;
        titleLabel.layer.borderWidth = 0.5f;
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.text = title;
        titleLabel.font = kFont12;
        titleLabel.textColor = _titleColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 2;
        [self addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_cancelButton.mas_top).offset(-10 - ((other.count ) * 48.5));
            make.left.equalTo(weakSelf);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 49));
        }];
    }
    
    UIView *lastView = nil;
    if (other) {
        for (int i = 0; i <other.count; i ++) {
            _otherTitleButton = [UIButton new];
            _otherTitleButton.layer.borderColor = Color10(224,224,224, 1).CGColor;
            _otherTitleButton.layer.borderWidth = 0.5f;
            _otherTitleButton.tag = i;
            [_otherTitleButton setBackgroundImage:defaultButtonImage forState:UIControlStateNormal];
            [_otherTitleButton setBackgroundImage:highlightedButtonImage forState:UIControlStateHighlighted];
            [_otherTitleButton setTitleColor:_titleColor forState:UIControlStateNormal];
            [_otherTitleButton setTitle:other[i] forState:UIControlStateNormal];
            [_otherTitleButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_otherTitleButton];
            
            [_otherTitleButton mas_makeConstraints:^(MASConstraintMaker *make) {
                if (lastView) {
                    make.top.equalTo(lastView.mas_bottom).offset(-0.5);
                }else{
                    make.bottom.equalTo(_cancelButton.mas_top).offset(-10 - ((other.count -1) * 48.5));
                }
                make.left.equalTo(weakSelf);
                make.size.mas_equalTo(CGSizeMake(ScreenWidth, 49));
            }];
            
            lastView = _otherTitleButton;
        }
    }
    
    self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 48.5 *count + 10);
}

- (void)setTitle:(NSString *)title titleColor:(UIColor *)titleColor otherButtonTitle:(NSArray *)other otherTitleColor:(NSArray *)color
{
    WS(weakSelf)
    UIImage *defaultButtonImage = [UIImage imageNamed:@"common_actionsheet_button_normal@2x" ImageType:@"png" withTop:5 andLeft:5];
    
    UIImage *highlightedButtonImage = [UIImage imageNamed:@"common_actionsheet_button_highlight@2x" ImageType:@"png" withTop:5 andLeft:5];
    
    int count = (int)other.count + 1;
    
    if (!_titleColor) {
        _titleColor = Color10(235,98,0, 1);
    }
    
    if (title) {
        
        count +=1;
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.layer.borderColor = Color10(224,224,224, 1).CGColor;
        titleLabel.layer.borderWidth = 0.5f;
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.text = title;
        titleLabel.font = kFont12;
        if (titleColor == nil) {
           titleLabel.textColor = _titleColor;
        } else {
        titleLabel.textColor = titleColor;
        }
        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 2;
        [self addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_cancelButton.mas_top).offset(-10 - ((other.count ) * 48.5));
            make.left.equalTo(weakSelf);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 49));
        }];
    }
    
    UIView *lastView = nil;
    if (other) {
        for (int i = 0; i <other.count; i ++) {
            _otherTitleButton = [UIButton new];
            _otherTitleButton.layer.borderColor = Color10(224,224,224, 1).CGColor;
            _otherTitleButton.layer.borderWidth = 0.5f;
            _otherTitleButton.tag = i ;
            [_otherTitleButton setBackgroundImage:defaultButtonImage forState:UIControlStateNormal];
            [_otherTitleButton setBackgroundImage:highlightedButtonImage forState:UIControlStateHighlighted];
            if (color == nil) {
                [_otherTitleButton setTitleColor:Color10(248, 181, 0, 1) forState:UIControlStateNormal];
            } else {
                if (color.count != other.count) {
                    if (i < color.count) {
                        [_otherTitleButton setTitleColor:color[i] forState:UIControlStateNormal];
                    } else {
                        [_otherTitleButton setTitleColor:Color10(248, 181, 0, 1) forState:UIControlStateNormal];
                    }
                } else {
                    [_otherTitleButton setTitleColor:color[i] forState:UIControlStateNormal];
                }
            }
            
            [_otherTitleButton setTitle:other[i] forState:UIControlStateNormal];
            [_otherTitleButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_otherTitleButton];
            
            [_otherTitleButton mas_makeConstraints:^(MASConstraintMaker *make) {
                if (lastView) {
                    make.top.equalTo(lastView.mas_bottom).offset(-0.5);
                }else{
                    make.bottom.equalTo(_cancelButton.mas_top).offset(-10 - ((other.count -1) * 48.5));
                }
                make.left.equalTo(weakSelf);
                make.size.mas_equalTo(CGSizeMake(ScreenWidth, 49));
            }];
            
            lastView = _otherTitleButton;
        }
    }
    
    self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 48.5 *count + 10);
    
}

#pragma mark - Event Responses

- (void)buttonAction:(id)sender {
    
    UIButton *butten = sender;
    int tag = (int)butten.tag;
    if (self.buttonBlock) {
        _buttonBlock(tag);
    }
}


@end
