//
//  QuestionTableViewCell.m
//  Appointment
//
//  Created by feiwu on 16/7/15.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "QuestionTableViewCell.h"
#import "LXFileManager.h"
#import "AppDelegate.h"
@implementation QuestionTableViewCell

#pragma mark - Life Cycle
//生命周期方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
        [self makeConstraints];
    }
    return self;
}

#pragma mark - Private Methods
//私有方法
#pragma mark 初始化
- (void)initView
{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    [self addSubview:self.pageLabel];
    [self addSubview:self.cancelButton];
    [self addSubview:self.topLineView];
    [self addSubview:self.userImageView];
    [self addSubview:self.questionButton];
    [self addSubview:self.questionLabel];
    [self addSubview:self.bottomLineView];
    [self addSubview:self.tipLabel];
    
}

#pragma mark 布局
- (void)makeConstraints
{
    WS(weakSelf);
    
    [_pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(23.5);
        make.top.mas_equalTo(weakSelf).offset(19);
    }];

    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf).offset(0);
        make.top.mas_equalTo(weakSelf).offset(10);
        make.size.mas_equalTo(CGSizeMake(70, 40));
    }];
    
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf).offset(-23.5);
        make.left.mas_equalTo(weakSelf).offset(23.5);
        make.top.mas_equalTo(weakSelf.pageLabel.mas_bottom).offset(22.5);
        make.height.mas_equalTo(0.5);
    }];

    [_userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(23.5);
        make.top.mas_equalTo(weakSelf.pageLabel.mas_bottom).offset(55);
        make.size.mas_equalTo(CGSizeMake(132, 132));
    }];
    
    [_questionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.userImageView.mas_right).offset(15);
        make.top.mas_equalTo(weakSelf.userImageView.mas_top).offset(6);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 180, 120));
    }];
    
    [_questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.userImageView.mas_right).offset(35);
        make.top.mas_equalTo(weakSelf.questionButton.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 210, 80));
    }];
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf).offset(0);
        make.left.mas_equalTo(weakSelf).offset(0);
        make.top.mas_equalTo(weakSelf.userImageView.mas_bottom).offset(35);
        make.height.mas_equalTo(0.5);
    }];

    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf.userImageView.mas_bottom).offset(76);
    }];
    
    
    
}

#pragma mark - Public Methods
//公有方法
#pragma mark 选中方法
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Event Responses
- (void)handleSelect:(UIButton *)button
{
    //答案保存到本地
    NSInteger buttonIndex = button.tag - 2000;//选择选项
    NSString *index = [_questionDic objectForKey:@"index"];
    NSArray *buttonArray = [_questionDic objectForKey:@"answers"];//标题数组
    NSString *type = [_questionDic objectForKey:@"type"];
    
    if (!_infoDic) {
        _infoDic = [NSMutableDictionary dictionary];
    }
    [_infoDic setObject:[buttonArray objectAtIndex:buttonIndex] forKey:type];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"QuestionTableViewNotification" object:@{index :_infoDic}];
}

- (void)handleCancelAction:(UIButton *)button
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = [appDelegate.viewControllers objectAtIndex:0];
    
}


#pragma mark - "控件代理方法"
//控件代理方法

#pragma mark - Notification Responses
//通知响应方法

#pragma mark - Network Data
//网络请求处理方法

#pragma mark - Getters And Setters
- (UIImageView *)userImageView {
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.contentMode = UIViewContentModeScaleToFill;
        _userImageView.layer.masksToBounds = YES;
        _userImageView.layer.cornerRadius = 5.0;
    }
    return _userImageView;
}

- (UIButton *)questionButton {
    if (!_questionButton) {
        _questionButton = [[UIButton alloc] init];
        [_questionButton setBackgroundImage:[UIImage imageNamed:@"reg_qa_icon_left_bubble@2x" ImageType:@"png" withTop:10 andLeft:20] forState:UIControlStateNormal];
         [_questionButton setBackgroundImage:[UIImage imageNamed:@"reg_qa_icon_left_bubble@2x" ImageType:@"png" withTop:10 andLeft:20] forState:UIControlStateHighlighted];
    }
    return _questionButton;
}
- (UILabel *)questionLabel {
    if (!_questionLabel) {
        _questionLabel = [[UILabel alloc] init];
        _questionLabel.textAlignment = NSTextAlignmentLeft;
        _questionLabel.font = kFont14;
        _questionLabel.numberOfLines = 0;
        _questionLabel.textColor = Color10(102, 102, 102, 1);
    }
    return _questionLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = kFont14;
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        _tipLabel.textColor = Color10(153, 153, 153, 1);
        _tipLabel.text = @"選擇如下選項，回答TA的問題";
        [_tipLabel sizeToFit];
    }
    return _tipLabel;
}

- (UILabel *)pageLabel {
	if (!_pageLabel) {
		_pageLabel = [[UILabel alloc] init];
        _pageLabel.font = kFont17;
        _pageLabel.textColor = Color10(51, 51, 51, 1);
        _pageLabel.text = [NSString stringWithFormat:@"%@ ",NSLocalizedString(@"爱情拷问 (1/5)", nil)];
        [_pageLabel sizeToFit];
	}
	return _pageLabel;
}

- (UIButton *)cancelButton {
	if (!_cancelButton) {
		_cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitle:NSLocalizedString(@"跳过", nil) forState:UIControlStateNormal];
        [_cancelButton setTitle:NSLocalizedString(@"跳过", nil) forState:UIControlStateHighlighted];
        [_cancelButton setTitleColor:Color10(204, 204, 204, 1) forState:UIControlStateNormal];
        [_cancelButton setTitleColor:Color10(204, 204, 204, 1) forState:UIControlStateHighlighted];
        _cancelButton.titleLabel.font = kFont14;
        [_cancelButton addTarget:self action:@selector(handleCancelAction:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _cancelButton;
}

- (UIView *)topLineView {
	if (!_topLineView) {
		_topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = Color10(216, 216, 216, 1);
	}
	return _topLineView;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = Color10(216, 216, 216, 1);
    }
    return _bottomLineView;
}
- (void)setQuestionDic:(NSDictionary *)questionDic {
    if (_questionDic != questionDic) {
        _questionDic = questionDic;
        WS(weakSelf);
        if (!_reuseArray) {
            _reuseArray = [NSMutableArray array];
        }
        
        for (int i = 0; i < _reuseArray.count; i++) {
            UIButton *button = (UIButton *)_reuseArray[i];
            [button removeFromSuperview];
            button = nil;
        }
        
        _userImageView.image = LOADIMAGE([_questionDic objectForKey:@"img"], @"jpg");
        _questionLabel.text = [_questionDic objectForKey:@"question"];
        _pageLabel.text = [NSString stringWithFormat:@"%@ (%@/5)",NSLocalizedString(@"爱情拷问", nil), [_questionDic objectForKey:@"index"]];
        
        UIView *lastView = nil;
        NSArray *buttonArray = [_questionDic objectForKey:@"answers"];
        for (int i = 0; i < buttonArray.count; i++) {
            UIButton *question = [[UIButton alloc] init];
            question.tag = 2000 + i;
            [question addTarget:self action:@selector(handleSelect:) forControlEvents:UIControlEventTouchUpInside];
            [question setTitle:[buttonArray objectAtIndex:i] forState:UIControlStateNormal];
            question.titleLabel.font = kFont14;
            question.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            [question setTitleColor:Color10(191, 123, 196, 1) forState:UIControlStateNormal];
            [question setTitleColor:Color10(191, 123, 196, 1) forState:UIControlStateHighlighted];
            
            [question setBackgroundImage:[UIImage imageNamed:@"common_button_white_normal@2x" ImageType:@"png" withTop:5 andLeft:5] forState:UIControlStateNormal];
            [question setBackgroundImage:[UIImage imageNamed:@"common_button_white_press@2x" ImageType:@"png" withTop:5 andLeft:5] forState:UIControlStateHighlighted];
            
            [self addSubview:question];
            
            [question mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(weakSelf).offset(15);
                if (!lastView) {
                   make.top.mas_equalTo( weakSelf.tipLabel.mas_bottom).offset(43);
                } else {
                  make.top.mas_equalTo(lastView.mas_bottom ).offset(10);
                }
              
                make.size.mas_equalTo(CGSizeMake(ScreenWidth - 30, 44));
            }];
            
            lastView = question;
            [_reuseArray addObject:question];
            
        }
    }
}


@end
