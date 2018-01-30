//
//  XWWEBViewController.m
//  noble metal
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "XWWEBViewController.h"
//#import "DirectSeedingViewController.h"
@interface XWWEBViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *MyWebView;
@property(nonatomic,strong)UILabel * label;

@end

@implementation XWWEBViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"咨询详情"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"咨询详情"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNator];
    
    self.MyWebView = [[UIWebView alloc] init];
    self.MyWebView.delegate = self;
    self.MyWebView.frame = CGRectMake(0, 64, screenW, screenH-60);
    NSLog(@"1111111%@",_string);
    
    //    NSString * string = [NSString stringWithFormat:@"%@?user_id=&a=%@&c=%@&platform=iOS&v=1.5&s=%@",_string,@"activate",curDev.identifierForVendor.UUIDString,chaanel];
    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:_string]];
    [self.MyWebView reload];
    [self.MyWebView loadRequest:req];
    
    self.MyWebView.scrollView.bounces = NO;
    
    [self.view addSubview:self.MyWebView];
}
#pragma mark - 创建导航栏
-(void)createNator{
    
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"nabg"];
    imageView.frame = CGRectMake(0, 0, screenW, 64);
    [self.view addSubview:imageView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake((screenW-200)/2, 30, 200, 20)];
    _label.textAlignment = NSTextAlignmentCenter;
    //    _label.text = @"资讯";
    _label.font = [UIFont boldSystemFontOfSize:20];
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_label];
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    //    添加点击事件
    [leftButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(10, 20, 15, 30);
    
    [self.view addSubview:leftButton];
    
    
    
}
#pragma mark - 左边按钮点击事件
-(void)buttonClick{//取消按钮跳到第一个页面
    
    //    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = [request URL];
    NSLog(@"2123121%@",url);
    NSString * str1 = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    _label.text = str1;
    
    NSString *urlStr = url.absoluteString;
    if ([urlStr rangeOfString:@"http://newapp1.4001881788.com/index"].location != NSNotFound) {
        
        
        //        [self.navigationController popViewControllerAnimated:YES];
//        self.tabBarController.selectedIndex = 2;
   
      [self dismissViewControllerAnimated:YES completion:nil];
//        [self disablesAutomaticKeyboardDismissal];
        
        return NO;
        
    }else if ([urlStr rangeOfString:@"open_index=3"].location != NSNotFound){
        
        
//        self.tabBarController.selectedIndex = 3;
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
        
        
        
        
        return NO;
    }
    
    return YES;
}
-(void) webViewDidFinishLoad:(UIWebView *)webView {
    
    _label.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
