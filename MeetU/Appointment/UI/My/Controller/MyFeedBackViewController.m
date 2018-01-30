//
//  MyFeedBackViewController.m
//  Appointment
//
//  Created by feiwu on 16/7/18.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MyFeedBackViewController.h"
#import "StatisticalPayApi.h"
#import "MyVerifyPayResultApi.h"
#import "LXFileManager.h"
@interface MyFeedBackViewController ()
@end

@implementation MyFeedBackViewController
{
    NSString *_url;
}

#pragma mark - Life Cycle
- (id)initWithUrl:(NSString *)url{
    self = [super init];
    if(self){
        _url = [NSString stringWithFormat:@"%@?%@%@&%@%@",url,@"token=",[FWUserInformation sharedInstance].token,@"country=",[FWUserInformation sharedInstance].globalizationStr];
        _url = [_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initLeftBarItem];
    [MobClick beginLogPageView:@"web页面"];
    // 通过观察者监听交易状态
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"web页面"];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideHUD];//隐藏指示器
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self showHUD:@"正在加载" isDim:NO mode:MBProgressHUDModeIndeterminate];
    //买点
    if (![_pushType isEqualToString:@""] && _pushType != nil) {
        [self setStatisticalPayRequest:_pushType];
    }
    self.title = _titleStr;
    _webView = [[UIWebView alloc] init];
    _webView.backgroundColor = [UIColor clearColor];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    NSURL *URL = [NSURL URLWithString:_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [_webView loadRequest:request];
    WS(weakSelf);
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 导航栏左侧侧按钮
- (void)initLeftBarItem{
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 32, 32)];
    [self.leftButton setBackgroundImage:LOADIMAGE(@"common_back_default@2x", @"png") forState:UIControlStateNormal];
    [self.leftButton setBackgroundImage: LOADIMAGE(@"common_back_highlighted@2x", @"png") forState:UIControlStateHighlighted];
    [self.leftButton addTarget:self action:@selector(handleBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.leftButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -10;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, backItem, nil];
}

#pragma mark - Event Responses
- (void)handleBack
{
    if ([_backType isEqualToString:@"back"]) {
        [_webView goBack];
    } else {
        //返回方式
        if (self.navigationController.viewControllers.count>1) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:^{
            }];
            //返回方式
        }
    }
    
}

#pragma mark - 支付路径
- (void)setStatisticalPayRequest:(NSString *)action{
    WS(weakSelf);
    StatisticalPayApi *api = [[StatisticalPayApi alloc] initWithAction:action];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf setStatisticalPayRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"设置支付路径失败:%@",request.responseString);
    }];
}

- (void)setStatisticalPayRequestFinish:(NSDictionary *)result{
    LogOrange(@"设置支付路径成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    if ([code intValue] == kNetWorkSuccCode){
        
    } else {
        
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self hideHUD];
    if ([_showType isEqualToString:@"pay"]) {
        if ([SKPaymentQueue canMakePayments]) {
            [self showHUD:NSLocalizedString(@"正在处理支付，请稍后", nil) isDim:NO mode:MBProgressHUDModeIndeterminate];
        } else {
            [self showHUDFail:NSLocalizedString(@"用户禁止应用内购买", nil)];
            [self hideHUDDelay:1];
        };
        
    } else {
        [self showHUD:NSLocalizedString(@"正在加载", nil) isDim:NO mode:MBProgressHUDModeIndeterminate];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideHUD];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideHUD];
    if ([_showType isEqualToString:@"pay"]) {
        if ([SKPaymentQueue canMakePayments]) {
            [self showHUD:NSLocalizedString(@"正在处理支付，请稍后", nil) isDim:NO mode:MBProgressHUDModeIndeterminate];
        }
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = [[request URL] absoluteString];//js跳转的url，事先约定好的
    NSLog(@"当前的网址:%@",url);
    //返回类型
    NSArray *typeArray = [url componentsSeparatedByString:@"?"];
    if (typeArray.count > 1) {
        NSString *temp = [typeArray lastObject];
        if ([temp containsString:@"&"]) {
            NSArray *typeArray = [url componentsSeparatedByString:@"&"];
            _backType = [typeArray lastObject];
        } else {
            _backType = [typeArray lastObject];
        }
        
    } else {
        _backType = @"";
    }
    //买点路径
    NSString *typeStr = [NSString stringWithFormat:@"%@-button-",_pushType];
    
    if ([url rangeOfString:@"write_12"].location != NSNotFound) {
        //短信回复包一年(198)
        [MobClick event:@"webWriter12"];
        NSString *paytype = [NSString stringWithFormat:@"%@890",typeStr];
        _productID = @"8";
        _productFrom = paytype;
        //买点
        [self setStatisticalPayRequest:paytype];
        _type = @"writer";
        _price = write_12;
        _productName = NSLocalizedString(@"365天写信包年", nil);
        _showType = @"pay";
        // 向苹果服务器请求可卖的商品
        if ([SKPaymentQueue canMakePayments]) {
            [self requestProducts:@"taiwantongcheng_writer365"];
        }
    }
    else if ([url rangeOfString:@"write_3"].location != NSNotFound) {
        //短信回复包三月(98)
        [MobClick event:@"webWriter3"];
        NSString *paytype = [NSString stringWithFormat:@"%@450",typeStr];
        _productID = @"7";
        _productFrom = paytype;
        //买点
        [self setStatisticalPayRequest:paytype];
        _type = @"writer";
        _price = write_3;
        _productName = NSLocalizedString(@"90天写信包月", nil);
        _showType = @"pay";
        if ([SKPaymentQueue canMakePayments]) {
            [self requestProducts:@"taiwantongcheng_writer90"];
        }
    }
    else if ([url rangeOfString:@"write_1"].location != NSNotFound) {
        //短信回复包一月(50)
        [MobClick event:@"webWriter1"];
        NSString *paytype = [NSString stringWithFormat:@"%@240",typeStr];
        _productID = @"6";
        _productFrom = paytype;
        //买点
        [self setStatisticalPayRequest:paytype];
        _type = @"writer";
        _price = write_1;
        _productName = NSLocalizedString(@"30天写信包月", nil);
        _showType = @"pay";
        if ([SKPaymentQueue canMakePayments]) {
            [self requestProducts:@"taiwantongcheng_writer30"];
        }
    }
    else if ([url rangeOfString:@"vip_365"].location != NSNotFound) {
        //vip会员365(118)
        [MobClick event:@"webVip365"];
        NSString *paytype = [NSString stringWithFormat:@"%@540",typeStr];
        _productID = @"5";
        _productFrom = paytype;
        //买点
        [self setStatisticalPayRequest:paytype];
        _type = @"vip";
        _price = vip_12;
        _productName = NSLocalizedString(@"365天会员", nil);
        _showType = @"pay";
        if ([SKPaymentQueue canMakePayments]) {
            [self requestProducts:@"taiwantongcheng_vip365"];
        }
       
    }
    else if ([url rangeOfString:@"vip_90"].location != NSNotFound) {
        //vip会员三个月(60)
        [MobClick event:@"webVip90"];
        NSString *paytype = [NSString stringWithFormat:@"%@270",typeStr];
        _productID = @"4";
        _productFrom = paytype;
        //买点
        [self setStatisticalPayRequest:paytype];
        _type = @"vip";
        _price = vip_3;
        _productName = NSLocalizedString(@"90天会员", nil);
        _showType = @"pay";
        if ([SKPaymentQueue canMakePayments]) {
            [self requestProducts:@"taiwantongcheng_vip90"];
        }
        
    }
    else if ([url rangeOfString:@"vip_30"].location != NSNotFound) {
        //vip会员三个月(60)
        [MobClick event:@"webVip30"];
        NSString *paytype = [NSString stringWithFormat:@"%@270",typeStr];
        _productID = @"3";
        _productFrom = paytype;
        //买点
        [self setStatisticalPayRequest:paytype];
        _type = @"vip";
        _price = vip_1;
        _productName = NSLocalizedString(@"30天会员", nil);
        _showType = @"pay";
        if ([SKPaymentQueue canMakePayments]) {
            [self requestProducts:@"taiwantongcheng_vip30"];
        }
        
    }
    else if([url rangeOfString:@"activity_back"].location != NSNotFound) {
        //话费活动返回
        [self handleBack];
    }
    
    
    return YES;
}

#pragma mark -- 内购
/**
 *  请求可卖商品
 */
- (void)requestProducts:(NSString *)productId
{
    
    // 1.获取productid的set(集合中)
    NSSet *set = [NSSet setWithObjects:productId, nil];
    
    // 2.向苹果发送请求,请求可卖商品
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    /*
     for (SKProduct *product in response.products) {
     NSLog(@"价格:%@", product.price);
     NSLog(@"标题:%@", product.localizedTitle);
     NSLog(@"秒速:%@", product.localizedDescription);
     NSLog(@"productid:%@", product.productIdentifier);
     }
     */
    
    NSLog(@"商品的數量:%@",response.products);
    // 1.取出模型
    SKProduct *product = [response.products firstObject];
    // 2.购买商品
    if (product) {
        [self buyProduct:product];
    } else {
        [self showHUDFail:NSLocalizedString(@"无法获取产品信息", nil)];
        [self hideHUDDelay:1];
    }
    
}

//查询失败后的回调
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    [self hideHUD];
}

#pragma mark - 购买商品
- (void)buyProduct:(SKProduct *)product
{
    // 1.创建票据
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    // 2.将票据加入到交易队列中
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - 实现观察者回调的方法
/**
 *  当交易队列中的交易状态发生改变的时候会执行该方法
 *
 *  @param transactions 数组中存放了所有的交易
 */
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    /*
     SKPaymentTransactionStatePurchasing, 正在购买
     SKPaymentTransactionStatePurchased, 购买完成(销毁交易)
     SKPaymentTransactionStateFailed, 购买失败(销毁交易)
     SKPaymentTransactionStateRestored, 恢复购买(销毁交易)
     SKPaymentTransactionStateDeferred 最终状态未确定
     */
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"用户正在购买");
                break;
            case SKPaymentTransactionStatePurchased:
            {
                NSLog(@"购买成功");
                [self hideHUD];
                [self showHUD:NSLocalizedString(@"正在验证支付结果", nil) isDim:NO mode:MBProgressHUDModeIndeterminate];
                NSData *data =  [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                NSString *receipt = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//凭证
                NSString *mid = [FWUserInformation sharedInstance].mid;//用户id
                NSString *key = [NSString stringWithFormat:@"%@inAppBuy",mid];//key
                NSString *dateString = [NSString stringWithFormat:@"%ld",time(NULL)];//时间戳
                NSDictionary *dic =[ NSDictionary dictionaryWithObjectsAndKeys:
                                    receipt, @"receipt", dateString, @"date", mid, @"user_id", transaction.transactionIdentifier, @"transactionId", _productID, @"product_id",_productFrom, @"from", nil];//保存的信息防止漏单
                [LXFileManager saveUserData:dic forKey:key];
                [queue finishTransaction:transaction];
                
                [self verifyPayResultRequest:receipt TransactionId:transaction.transactionIdentifier Time:dateString];
            }
                break;
            case SKPaymentTransactionStateFailed:
            {
                NSLog(@"购买失败");
                [self hideHUD];
                NSString *error = [transaction.error.userInfo objectForKey:@"NSLocalizedDescription"];
                if (![error isEqualToString:@""]) {
                    [self showHUDFail:error];
                    [self hideHUDDelay:2];
                }
                [queue finishTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"恢复购买");
                [self hideHUD];
                [queue finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateDeferred:
                NSLog(@"最终状态未确定");
                [self hideHUD];
                break;
            default:
                break;
        }
    }
}
#pragma mark -- 内购

#pragma mark - 验证支付结果
- (void)verifyPayResultRequest:(NSString *)receipt TransactionId:(NSString *)tid  Time:(NSString *)time{
    WS(weakSelf);
    NSLog(@"订单号:%@",tid);
    MyVerifyPayResultApi *api = [[MyVerifyPayResultApi alloc] initWithReceipt:receipt Transactionid:tid Productid:_productID From:_productFrom Time:time];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf hideHUD];
        [weakSelf verifyPayResultRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"验证订单信息请求失败:%@",request.responseString);
    }];
}
- (void)verifyPayResultRequestFinish:(NSDictionary *)result{
    LogOrange(@"验证订单信息请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    if ([code intValue] == kNetWorkSuccCode){
        //移除订单信息
        NSString *mid = [FWUserInformation sharedInstance].mid;//用户id
        NSString *key = [NSString stringWithFormat:@"%@inAppBuy",mid];//key
        [LXFileManager removeUserDataForkey:key];
        //调服务端接口，告知支付成功
        [self performSelector:@selector(popView) withObject:nil afterDelay:1];
        //短信包月VIP通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"VipAndWriterStatusChange" object:_type];
        
        //友盟付费统计
        [MobClickGameAnalytics pay:[_price doubleValue] source:2 item:_productName amount:1 price:[_price doubleValue]];
        
    }else {
    }
}
- (void)popView
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
