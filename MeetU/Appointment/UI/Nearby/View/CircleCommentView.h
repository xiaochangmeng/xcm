//
//  CircleCommentView.h
//  Appointment
//
//  Created by feiwu on 2017/2/7.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SendCommentMessageBlock) (NSString *message);
@interface CircleCommentView : UIView<UITextFieldDelegate>

@property (strong, nonatomic) UIView* alphaView;
@property (nonatomic, strong) UIView *textBGView;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UITextField *descTextView;
@property (nonatomic, copy) SendCommentMessageBlock commentBlock;
@end
