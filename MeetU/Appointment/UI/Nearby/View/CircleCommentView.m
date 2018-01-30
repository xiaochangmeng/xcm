//
//  CircleCommentView.m
//  Appointment
//
//  Created by feiwu on 2017/2/7.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "CircleCommentView.h"

@implementation CircleCommentView

#pragma mark - Life Cycle
//生命周期方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self makeConstraints];
        //控制键盘显隐
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];


    }
    return self;
}

#pragma mark - Private Methods
//私有方法
- (void)initView
{
    [self addSubview:self.alphaView];
    [self addSubview:self.textBGView];
    [self.textBGView addSubview:self.descTextView];
    [self.textBGView addSubview:self.sendButton];
}

- (void)makeConstraints
{
    WS(weakSelf)
    [_alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf).offset(0);
        make.left.mas_equalTo(weakSelf).offset(0);
        make.bottom.mas_equalTo(weakSelf).offset(0);
        make.right.mas_equalTo(weakSelf).offset(0);
    }];
    
    [self.textBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).offset(0);
        make.left.equalTo(weakSelf).offset(0);
        make.right.equalTo(weakSelf).offset(0);
        make.height.mas_equalTo(100/2.0);
    }];
    
    //内容
    [self.descTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.textBGView.mas_top).offset(9);
        make.left.equalTo(weakSelf.textBGView).offset(15);
        make.right.equalTo(weakSelf.sendButton.mas_left).offset(-15);
        make.bottom.equalTo(weakSelf.textBGView.mas_bottom).offset(-9);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.textBGView);
        make.right.equalTo(weakSelf.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(120/2, 64/2));
    }];

}

#pragma mark - Public Methods
//公有方法

#pragma mark - Event Responses
/**
 点击发送消息按钮
 */
- (void)clickSendButton:(UIButton *)sender
{
    if (_descTextView.text != nil && ![_descTextView.text isEqualToString:@""]) {
        [self.descTextView resignFirstResponder];
        if (_commentBlock) {
            _commentBlock(_descTextView.text);
        }
        [self removeFromSuperview];
    }
}
/**
 点击半透明背景视图  移除
 
 @param tapGestureRecognizer 点击事件
 */
- (void)tapGestureRecognizerHandle:(UITapGestureRecognizer*)tapGestureRecognizer{
    [self removeFromSuperview];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Notification Responses
#pragma mark 键盘显示
- (void) keyboardWillShowNotification:(NSNotification*) notification {
    WS(weakSelf)
    //键盘高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    [self.textBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).offset(-keyboardHeight);
        make.left.equalTo(weakSelf).offset(0);
        make.right.equalTo(weakSelf).offset(0);
        make.height.mas_equalTo(100/2.0);
    }];
    
}

#pragma mark 键盘隐藏
- (void) keyboardWillHideNotification:(NSNotification*) notification {
    WS(weakSelf)
    [self.textBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).offset(0);
        make.left.equalTo(weakSelf).offset(0);
        make.right.equalTo(weakSelf).offset(0);
        make.height.mas_equalTo(100/2.0);
    }];
}


#pragma mark - Network Data
//网络请求处理方法


#pragma mark - Getters And Setters
/**
 底部黑色背景
 */
- (UIView *)alphaView{
    if (_alphaView == nil) {
        _alphaView = [UIView new];
        _alphaView.backgroundColor = Color10(0, 0, 0, 0.75f);
        UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerHandle:)];
        [_alphaView addGestureRecognizer:tapGestureRecognizer];
    }
    return _alphaView;
}


- (UIView *)textBGView
{
    if (!_textBGView) {
        _textBGView = [UIView new];
        _textBGView.backgroundColor = Color16(0xF4F4F4);
    }
    return _textBGView;
}

- (UITextField *)descTextView
{
    if (!_descTextView) {
        _descTextView = [UITextField new];
        _descTextView.font = kFont14;
        _descTextView.textColor = Color16(0x333333);
        _descTextView.delegate = self;
        _descTextView.placeholder = @"请输入评论内容";
        [_descTextView setBorderStyle:UITextBorderStyleRoundedRect];
        [_descTextView becomeFirstResponder];
    }
    return _descTextView;
}

- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [UIButton new];
        [_sendButton setBackgroundImage:LOADIMAGE(@"circle_sendDefault@2x", @"png") forState:UIControlStateNormal];
        [_sendButton setBackgroundImage:LOADIMAGE(@"circle_sendSelect@2x", @"png") forState:UIControlStateSelected];
        [_sendButton addTarget:self action:@selector(clickSendButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}


@end
