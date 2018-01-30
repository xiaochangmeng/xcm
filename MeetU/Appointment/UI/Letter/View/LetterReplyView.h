//
//  PrivateLetterDetailEnterView.h
//  fanszone
//
//  Created by feiwu on 16/7/20.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SendReplyMessageBlock) (NSString *);

@interface LetterReplyView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) NSString *titleStr;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIButton *textFieldBGButton;

@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) UITextField *descTextView;

@property (nonatomic, copy) SendReplyMessageBlock sendBlock;

@property (nonatomic, strong) UIButton *videoButton;  //视频按钮

@property(nonatomic, copy) void (^sendVodeoBlock)(void);
@end
