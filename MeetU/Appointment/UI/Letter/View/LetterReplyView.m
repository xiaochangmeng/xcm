//
//  PrivateLetterDetailEnterView.m
//  fanszone
//
//  Created by feiwu on 16/7/20.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "LetterReplyView.h"

@implementation LetterReplyView

#pragma mark - Life Cycle
//生命周期方法
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
    [self addSubview:self.lineView];
    [self addSubview:self.videoButton];
    [self addSubview:self.sendButton];
    [self addSubview:self.textFieldBGButton];
    [self addSubview:self.descTextView];
}

- (void)makeConstraints
{
    WS(weakSelf)
    
    //底线
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.left.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 0.5));
    }];
    
    //底线
    [self.videoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.left.equalTo(weakSelf).offset(8);
        make.size.mas_equalTo(CGSizeMake(43, 30));
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.right.equalTo(weakSelf.mas_right).offset(-16/2);
        make.size.mas_equalTo(CGSizeMake(66/2, 66/2));
    }];
    
    [self.textFieldBGButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(20/2);
        make.left.equalTo(weakSelf).offset(16/2+59);
        make.right.equalTo(weakSelf.sendButton.mas_left).offset(-16/2);
        make.height.mas_equalTo(70/2);
    }];
    
    //内容
    [self.descTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.textFieldBGButton).offset(0.5);
        make.left.equalTo(weakSelf.textFieldBGButton).offset(16/2);
        make.right.equalTo(weakSelf.textFieldBGButton.mas_right).offset(-16/2);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark - Public Methods
//公有方法

#pragma mark - Event Responses
//事件响应方法
- (void)clickSendButton:(UIButton *)sender
{
    if (_descTextView.text != nil && ![_descTextView.text isEqualToString:@""]) {
        [self.descTextView resignFirstResponder];
        if (_sendBlock) {
            _sendBlock(_descTextView.text);
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Notification Responses
//通知响应方法

#pragma mark - Network Data
//网络请求处理方法


#pragma mark - Getters And Setters
//getter 和 setter 方法

- (UIView *)lineView
{
    if (!_lineView) {
        //底线
        _lineView = [UIView new];
        _lineView.backgroundColor = Color10(224,224,224, 1);
        
    }
    
    return _lineView;
}


- (UIButton *)textFieldBGButton
{
    if (!_textFieldBGButton) {
        _textFieldBGButton = [UIButton new];
//        [_textFieldBGButton setBackgroundImage:[UIImage imageNamed:@"common_keyboardbackground.png" withTop:5 andLeft:5] forState:UIControlStateNormal];
//        [_textFieldBGButton setBackgroundImage:[UIImage imageNamed:@"common_keyboardbackground.png" withTop:5 andLeft:5] forState:UIControlStateHighlighted];
        }
    return _textFieldBGButton;
}

- (UITextField *)descTextView
{
    if (!_descTextView) {
        _descTextView = [UITextField new];
        _descTextView.backgroundColor = [UIColor clearColor];
        _descTextView.font = kFont16;
//        _descTextView.textColor = Color10(204,204,204, 1);
        _descTextView.textColor = [UIColor blackColor];
        _descTextView.delegate = self;
    }
    return _descTextView;
}

- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [UIButton new];
        
        [_sendButton setBackgroundImage:LOADIMAGE(@"letter_detail_send@2x", @"png") forState:UIControlStateNormal];
        [_sendButton setBackgroundImage:LOADIMAGE(@"letter_detail_send@2x", @"png") forState:UIControlStateSelected];
        
        [_sendButton addTarget:self action:@selector(clickSendButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

/**
 视频按钮
 
 @return 返回视频按钮
 */
- (UIButton *)videoButton{
    if (_videoButton == nil) {
        _videoButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_videoButton addTarget:self action:@selector(clickVideoButton:) forControlEvents:UIControlEventTouchUpInside];
        [_videoButton setImage:LOADIMAGE(@"letter_video@2x", @"png") forState:UIControlStateNormal];
        [_videoButton setImage:LOADIMAGE(@"letter_video@2x", @"png") forState:UIControlStateSelected];
        
    }
    return _videoButton;
}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    if (titleStr) {
        _descTextView.placeholder = [NSString stringWithFormat:@"%@%@",kLocalizedString(@"回復"),titleStr];
    }
}

/**
 点击视频按钮
 */
- (void)clickVideoButton:(UIButton *)sender
{
    if (_sendVodeoBlock) {
        _sendVodeoBlock();
    }
   
}
@end
