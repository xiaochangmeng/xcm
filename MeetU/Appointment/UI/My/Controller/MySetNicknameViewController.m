//
//  MySetInfoViewController.m
//  Appointment
//
//  Created by feiwu on 16/7/18.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MySetNicknameViewController.h"
#import "MySetDetailInfoApi.h"
#import "RegexKitLite.h"
@interface MySetNicknameViewController ()

@end

@implementation MySetNicknameViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initRrightBarItem];
    [MobClick beginLogPageView:@"修改昵称页面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"修改昵称页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"設置";
    self.isBack = YES;
    [self initView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideHUD];//隐藏指示器
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 导航栏右侧按钮
- (void)initRrightBarItem{
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64/2, 64/2)];
    [self.rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.titleLabel.font = kFont14;
    [self.rightButton setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    
    negativeSpacer.width = -5;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightItem, nil];
}

- (void)initView {
    WS(weakSelf);
    [self.view addSubview:self.userCountText];
    [self.view addSubview:self.userCountLineView];
    
    [_userCountText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.view).offset(-30);
        make.top.mas_equalTo(weakSelf.view).offset(10);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 60, 30));
    }];
    
    [_userCountLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(12);
        make.top.mas_equalTo(weakSelf.userCountText.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 24, 1));
    }];
    
}
#pragma mark 昵称验证
- (void)validatForNickname
{
    if(_userCountText.text == nil || [_userCountText.text isEqualToString:@""]){
        [self showHUDFail:NSLocalizedString(@"昵称不能为空", nil)];
        [self hideHUDDelay:1];
        return;
    }
    NSString *regex = @"\\s+";
    NSArray *array = [_userCountText.text componentsMatchedByRegex:regex];
    if (array.count > 0 ) {
        [self showHUDFail:NSLocalizedString(@"昵称不能有空格！", nil)];
        [self hideHUDDelay:1];
        return;
    }
    
        if(_userCountText.text.length < 2 || _userCountText.text.length > 10){
            [self showHUDFail:NSLocalizedString(@"暱稱必須為2至10個字符！", @"暱稱必須為2至10個字符！")];
            [self hideHUDDelay:1];
            return;
        }
    

    if ([_userCountText.text isEqualToString:_InfoModel.name]) {
        [self showHUDFail:NSLocalizedString(@"您未做任何修改", nil)];
        [self hideHUDDelay:1];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    if (_modifyNameBlock) {
        _modifyNameBlock(_userCountText.text);
    }
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![_userCountText isExclusiveTouch]) {
        [_userCountText resignFirstResponder];
    }
}

#pragma mark - Event Responses

- (void)clickRightButton:(UIButton *)button
{
    [self validatForNickname];
}



#pragma mark - Getters And Setters

- (UITextField *)userCountText {
    if (!_userCountText) {
        _userCountText = [[UITextField alloc] init];
        _userCountText.text = _InfoModel.name;
    }
    _userCountText.font = kFont14;
    _userCountText.delegate = self;
    //        _userCountText.backgroundColor = [UIColor yellowColor];
    return _userCountText;
}
- (UIView *)userCountLineView {
    if (!_userCountLineView) {
        _userCountLineView = [[UIView alloc] init];
        _userCountLineView.backgroundColor = Color10(239, 239, 239, 1);
    }
    return _userCountLineView;
}

@end
