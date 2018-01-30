//
//  RegisterProtocolViewController.m
//  Appointment
//
//  Created by feiwu on 16/8/9.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "RegisterProtocolViewController.h"
#import "NSString+MZYExtension.h"
@interface RegisterProtocolViewController ()

@end

@implementation RegisterProtocolViewController
#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"注册协议页面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"注册协议页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isCancel = YES;
    self.title = NSLocalizedString(@"注册协议", nil);
    [self initWithView];
    
}
- (void)initWithView
{
    WS(weakSelf);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.procotolScroll];
    [self.procotolScroll addSubview:self.procotolLabel];
    
    [_procotolScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view).offset(0);
        make.left.mas_equalTo(weakSelf.view).offset(5);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 5, ScreenHeight - 64));
    }];
    
    NSString *contentPath = [[NSBundle mainBundle] pathForResource:@"protocol" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:contentPath encoding:NSUTF8StringEncoding error:nil];
    
    CGFloat procotolHeight = [content textHeightWithContentWidth:ScreenWidth - 5 font:kFont14] + 20;
    _procotolLabel.text = content;
    [_procotolScroll setContentSize:CGSizeMake(ScreenWidth - 5, procotolHeight)];
    
    [_procotolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.procotolScroll).offset(0);
        make.left.mas_equalTo(weakSelf.procotolScroll).offset(0);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 5, procotolHeight));
    }];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters And Setters
- (UIScrollView *)procotolScroll {
	if (!_procotolScroll) {
		_procotolScroll = [[UIScrollView alloc] init];
        _procotolScroll.backgroundColor = [UIColor whiteColor];
        
	}
	return _procotolScroll;
}
- (UILabel *)procotolLabel {
	if (!_procotolLabel) {
		_procotolLabel = [[UILabel alloc] init];
        _procotolLabel.font = kFont14;
        _procotolLabel.textColor = [UIColor lightGrayColor];
        _procotolLabel.numberOfLines = 0;
        _procotolLabel.backgroundColor = [UIColor whiteColor];
	}
	return _procotolLabel;
}
@end
