//
//  LunboWebController.m
//  iOSdemo
//
//  Created by wanchangwen on 17/5/13.
//
//

#import "LunboWebController.h"

#import <JavaScriptCore/JavaScriptCore.h>


//#import "LoginViewViewController.h"
@interface LunboWebController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIActivityIndicatorView *activity;
@property(nonatomic,strong)UILabel * label;
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,copy)NSString *sumscrore;
@end

@implementation LunboWebController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString *baseUrlString = [NSString stringWithFormat:@"%@?platform=ios",self.webstr];
    
//    NSLog(@"%@",baseUrlString);
   
    [self createNator];
    // Do any additional setup after loading the view.
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH-15)];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.scalesPageToFit =YES;
    self.webView.delegate =self;
    
    _activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 64, 64)];
    [_activity setCenter:self.view.center];
    [_activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [_activity startAnimating];
    [self.webView addSubview:_activity];     //加在webView的话，不用担心action被webView遮盖
    
    if (self.webstr != nil) {
        NSURL *url = [[NSURL alloc]initWithString:self.webstr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
        [self.view addSubview:self.webView];
    }
    
    
//    // 2.加载网页
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test1" withExtension:@"html"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [webView loadRequest:request];
    
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"enterPay"] = ^() {
        //NSLog(@"当前线程 - %@",[NSThread currentThread]);
        NSArray *params = [JSContext currentArguments];
        for (JSValue *Param in params) {
            NSLog(@"%@", Param); // 打印结果就是JS传递过来的参数
        }
        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:[NSString stringWithFormat:@"js调用oc原生代码成功!"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
            
            
            
        });
        //JSValue *this = [JSContext currentThis];
    };
    
   
}
#pragma mark - 创建导航栏
-(void)createNator{
    //    登陆label
     self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.label.textAlignment = NSTextAlignmentCenter;
//    self.label.text = self.navstr;
    self.label.font = [UIFont boldSystemFontOfSize:20];
    self.label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.label;
    //    设置导航栏背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏背景"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    
    //    导航栏左边按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"顶部箭头"] forState:UIControlStateNormal];
    //    添加点击事件
    [leftButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(0, 0,22,22);
    UIBarButtonItem *leftItemCustom = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItemCustom;
    
    
    if ([self.biaoqian isEqualToString:@"1"]) {
        //    导航栏右边按钮
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [rightButton setTitle:@"分享" forState:UIControlStateNormal];
        [rightButton setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:17];
        //    添加点击事件
        [rightButton addTarget:self action:@selector(RightbuttonClick2) forControlEvents:UIControlEventTouchUpInside];
        rightButton.frame = CGRectMake(0, 0, 40, 20);
        UIBarButtonItem *rightItemCustom = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightItemCustom;
    }
    
    
}
#pragma mark - 导航栏左边按钮
-(void)buttonClick{
    if ([self.zhimabiaoshi isEqualToString:@"1"]) {
       [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
     [self.navigationController popViewControllerAnimated:YES];
    }
   
}
-(void)viewWillAppear:(BOOL)animated{
   
    [super viewWillAppear:animated];
    if ([self.Biaozhi isEqualToString:@"1"]) {
        [self.navigationItem setHidesBackButton:YES];
        self.automaticallyAdjustsScrollViewInsets =NO;
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        self.tabBarController.hidesBottomBarWhenPushed = NO;
    }else{
        self.automaticallyAdjustsScrollViewInsets =YES;
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        self.tabBarController.hidesBottomBarWhenPushed = YES;
    }
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_activity startAnimating] ;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
     _label.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [_activity stopAnimating];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求不成功，请查看网络连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = [request URL];
    NSLog(@"2123128888%@",url);
    NSString * urlStr2 = [url absoluteString];
    if ([urlStr2 rangeOfString:@"result=SUCCESS&zmScore="].length > 0) {
        NSArray *array = [urlStr2 componentsSeparatedByString:@"zmScore="];
        NSString * scrore = array[1];
        NSArray *array2 = [scrore componentsSeparatedByString:@"&message"];
       self.sumscrore = array2[0];
        HSKStorage *storage = [[HSKStorage alloc]initWithPath:AccountPath];
        [storage hsk_setObject:self.sumscrore forKey:@"zhimascrore"];
        [self upSeSame];
        [self checkXindate];
    }
    
    NSString * str1 = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    _label.text = str1;
    
    NSString *urlStr = url.absoluteString;
    if ([urlStr rangeOfString:@"LoginActivity"].location != NSNotFound) {
        
//
        [self loginCount];
        return NO;
    
        
//        enterPayDeskActivity
    }else
        
        if ([urlStr rangeOfString:@"enterPay"].location != NSNotFound){
//       [self RightbuttonClick];
        [self enterPayDeskActivity];
        return NO;
    }
    
     return YES;
}



-(void)enterPayDeskActivity{
    NSLog(@"222222dndhskbjsbs");
    
    
}



-(void)upSeSame{
//
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",nil];
//    NSString * url = [NSString stringWithFormat:@"%@/api/users/upSeSame.json",codeUrl];
//
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString * userId = [userDefaults objectForKey:USER_NAME_KEY];
//    if (userId == nil) {
//        userId = @"";
//    };
//
//    NSString * token = [userDefaults objectForKey:TOKEN];
//    if (token == nil) {
//        token = @"";
//    };
//    if (self.sumscrore == nil) {
//        self.sumscrore = @"";
//    }
//    NSDictionary * dic = @{@"userId":userId,@"sesame":self.sumscrore};
//
//    NSLog(@"%@",dic);
//    [manager POST:url parameters:dic success: ^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
//
//
//    }failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error);
//
//    }];
}




-(void)checkXindate{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",nil];
//    NSString * url = [NSString stringWithFormat:@"%@/api/users/checkXin.json",codeUrl];
//
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString * userId = [userDefaults objectForKey:USER_NAME_KEY];
//    if (userId == nil) {
//        userId = @"";
//    };
//
//
//    NSDictionary * dic = @{@"userId":userId,@"type":@"4"};
//
//    NSLog(@"%@",dic);
//    [manager POST:url parameters:dic success: ^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
//        NSString * code = responseObject[@"code"];
//
//        if ([code isEqualToString:@"0"]) {
//
//
//
//        }else {
//
//
//        }
//
//
//    }failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error);
//
//
//    }];
    
}
-(void)loginCount{
    
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString * userId = [userDefaults objectForKey:USER_NAME_KEY];
//
//    if (userId == nil) {
//        userId = @"";
//    }
//
//
//    if ([userId isEqualToString:@""]) {
////        LoginViewViewController * LoginViewVC = [[LoginViewViewController alloc] init];
////        [self.navigationController pushViewController:LoginViewVC animated:YES];
////        self.tabBarController.hidesBottomBarWhenPushed = YES;
//    }else{
//        BOOL isReveiw = [[NSUserDefaults standardUserDefaults] objectForKey:KIsReviewKey];
//        if (!isReveiw) {
//
//        }else{
//
//        }
//
//    }
//
//}
//
//
//-(void)RightbuttonClick{
//
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString * userId = [userDefaults objectForKey:USER_NAME_KEY];
//
//    if (userId == nil) {
//        userId = @"";
//    }
//
//    NSString * endname;
//    NSString *namestr = [userDefaults objectForKey:@"namestr"];
//    if (namestr == nil || [namestr isEqualToString:@""]) {
//        NSString *namestr = [userDefaults objectForKey:@"namestr2"];
//        endname =namestr;
//    }else{
//        endname =namestr;
//    }
//
////
////    NSString *requesticonstr = [userDefaults objectForKey:@"requesticonstr"];
//    NSString *baseUrlString;
//    if ([self.webstr rangeOfString:@"http://pages.hz.weiduanxian.com/chooseTutorApp.html"].length > 0) {
//         baseUrlString= [NSString stringWithFormat:@"http://pages.hz.weiduanxian.com/chooseTutorApp.html?platform=else"];
//    }else{
//     baseUrlString= [NSString stringWithFormat:@"%@?platform=else",self.webstr];
//    }
//
//
//    //将网址转化为UTF8编码
////    NSString *urlStringUTF8 = [baseUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//
//
//    //        if ([_shareImg isEqualToString:@""]) {
//    NSArray* imageArray = @[[UIImage imageNamed:@"logo.png"]];
//
//    if (imageArray) {
//
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:@"花镇，专注两性情感服务"
//                                         images:imageArray
//                                            url:[NSURL URLWithString:baseUrlString]
//                                          title:[NSString stringWithFormat:@"您有一份价值299元的爱情导师咨询体验待领取，速速   来>>"]
//                                           type:SSDKContentTypeAuto];
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                 items:nil
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//
//
//                       switch (state) {
//                           case SSDKResponseStateSuccess:
//                           {
//                               if ([self.webstr rangeOfString:@"http://pages.hz.weiduanxian.com/chooseTutorApp.html"].length > 0) {
//                                   self.webstr = [NSString stringWithFormat:@"http://pages.hz.weiduanxian.com/chooseTutorApp.html?shareSuccess=true"];
//                                   NSURL *url = [[NSURL alloc]initWithString:self.webstr];
//                                   NSURLRequest *request = [NSURLRequest requestWithURL:url];
//                                   [self.webView loadRequest:request];
//
//                               }
//                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                   message:nil
//                                                                                  delegate:nil
//                                                                         cancelButtonTitle:@"确定"
//                                                                         otherButtonTitles:nil];
//                               [alertView show];
//                               break;
//                           }
//                           case SSDKResponseStateFail:
//                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:[NSString stringWithFormat:@"%@",error]
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               [alert show];
//                               break;
//                           }
//                           default:
//                               break;
//                       }
//                   }
//         ];}
}





-(void)RightbuttonClick2{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString * userId = [userDefaults objectForKey:USER_NAME_KEY];
//
//    if (userId == nil) {
//        userId = @"";
//    }
//
//
//    if (self.shareImgUrl != nil) {
//        NSArray* imageArray = @[self.shareImgUrl];
//
//        if (imageArray) {
//
//            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//            [shareParams SSDKSetupShareParamsByText:nil
//                                             images:imageArray
//                                                url:[NSURL URLWithString:self.webstr]
//                                              title:self.shareTextWriter
//                                               type:SSDKContentTypeAuto];
//            //2、分享（可以弹出我们的分享菜单和编辑界面）
//            [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                     items:nil
//                               shareParams:shareParams
//                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//
//
//                           switch (state) {
//                               case SSDKResponseStateSuccess:
//                               {
//                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                       message:nil
//                                                                                      delegate:nil
//                                                                             cancelButtonTitle:@"确定"
//                                                                             otherButtonTitles:nil];
//                                   [alertView show];
//                                   break;
//                               }
//                               case SSDKResponseStateFail:
//                               {
//                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                                   message:[NSString stringWithFormat:@"%@",error]
//                                                                                  delegate:nil
//                                                                         cancelButtonTitle:@"OK"
//                                                                         otherButtonTitles:nil, nil];
//                                   [alert show];
//                                   break;
//                               }
//                               default:
//                                   break;
//                           }
//                       }
//             ];}
//
//
//    }
//


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
