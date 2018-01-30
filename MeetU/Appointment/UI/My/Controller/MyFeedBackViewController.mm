//
//  MyFeedBackViewController.m
//  Appointment
//
//  Created by feiwu on 16/7/18.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MyFeedBackViewController.h"
#import<IapppayKit/IapppayKit.h>
#import<IapppayKit/IapppayOrderUtils.h>
#import "StatisticalPayApi.h"
@interface MyFeedBackViewController () <IapppayKitPayRetDelegate>
{
    NSString *mAppId;//应用id
    NSString *mChannel;//渠道号
}
@property (nonatomic, strong) NSString *mCheckResultKey;    //验签密钥
@end

@implementation MyFeedBackViewController
{
    NSString *_url;
}

#pragma mark - Life Cycle
- (id)initWithUrl:(NSString *)url{
    self = [super init];
    if(self){
        _url = url;
    }
    
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    
    //买点
    [self setStatisticalPayRequest:_pushType];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideHUD];//隐藏指示器
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    //爱贝云初始化SDK信息
    mAppId = mOrderUtilsAppId;
    
    mChannel = mOrderUtilsChannel;
    
    self.mCheckResultKey = mOrderUtilsCheckResultKey;
    
    [[IapppayKit sharedInstance] setAppId:mAppId mACID:mChannel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Event Responses
- (void)handleBack
{
    if ([_backType isEqualToString:@"back"]) {
        [_webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma  mark - 客户端下单
- (void)onceOrderMid:(NSString *)mid Price:(NSString *)price WaresName:(NSString *)waresName Private:(NSString *)private
{
    /*
     trandInfo:支付的订单信息串。
     tokenValue(新增):使用 OpenIDSDK 登录的用户 ID,如果没有使用 OpenIDSDK 登录传 nil。
     payDelegate:支付结果处理对象。
     */
    
    //按次
    IapppayOrderUtils *orderInfo = [[IapppayOrderUtils alloc] init];
    orderInfo.appId         = mOrderUtilsAppId;
    orderInfo.cpPrivateKey  = mOrderUtilsCpPrivateKey;
    orderInfo.notifyUrl     = mOrderUtilsNotifyurl;
    orderInfo.cpOrderId     = [self generateTradeNO];
    orderInfo.waresId       = @"1";//商品编号编号
    orderInfo.price         = price;//商品金额
    orderInfo.appUserId     = mid;//用户唯一标识（mid）
    orderInfo.waresName     = waresName;//商品名称
    orderInfo.cpPrivateInfo = private;//商户私有信息
    
    NSString *trandInfo = [orderInfo getTrandData];
    [[IapppayKit sharedInstance] makePayForTrandInfo:trandInfo
                                    openIDTokenValue:nil
                                   payResultDelegate:self];
}

#pragma mark - 获取订单号
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}


#pragma mark - IapppayKitPayRetDelegate
- (void)iapppayKitRetPayStatusCode:(IapppayKitPayRetCode)statusCode
                        resultInfo:(NSDictionary *)resultInfo
{
    NSLog(@"statusCode : %d, resultInfo : %@", (int)statusCode, resultInfo);
    
    if (statusCode == IapppayPayRetSuccessCode) {
        BOOL isSuccess = [IapppayOrderUtils checkPayResult:resultInfo[@"Signature"]
                                                withAppKey:mOrderUtilsCheckResultKey];
        if (isSuccess) {
            //支付成功，验签成功
            [self hideHUD];
            [self showHUDComplete:@"支付成功，验签成功"];
            [self hideHUDDelay:1];
            
        } else {
            //支付成功，验签失败
            [self hideHUD];
            [self showHUDFail:@"支付成功，验签失败"];
            [self hideHUDDelay:1];
            
        }
        [self performSelector:@selector(popView) withObject:nil afterDelay:1];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"VipAndWriterStatusChange" object:_type];
        
        //开通vip成功
        if ([_type isEqualToString:@"vip"]) {
            //个人信息初始化
            FWUserInformation* info = [FWUserInformation sharedInstance];
            info.flag_vip = @"1";
            [info saveUserInformation];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VIPStatusChange" object:nil];
        }
        //友盟付费统计
        [MobClickGameAnalytics pay:[_price doubleValue] source:2 item:_productName amount:1 price:[_price doubleValue]];
        
    } else if (statusCode == IapppayPayRetFailedCode) {
        //支付失败
        [self hideHUD];
        [self showHUDFail:@"支付失败"];
        [self hideHUDDelay:1];
        
    } else {
        //支付取消
        [self hideHUD];
        [self showHUDFail:@"支付取消"];
        [self hideHUDDelay:1];
        
    }
}

- (void)popView
{
    [self.navigationController popViewControllerAnimated:YES];
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
    [self showHUD:@"正在加载" isDim:NO mode:MBProgressHUDModeIndeterminate];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideHUD];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideHUD];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = [[request URL] absoluteString];//js跳转的url，事先约定好的
    NSString *mid = [FWUserInformation sharedInstance].mid;
    
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
    //买点
    NSString *typeStr;
    if ([_pushType isEqualToString:@"center-vip"] || [_pushType isEqualToString:@"center-write"] ) {
        typeStr = [NSString stringWithFormat:@"%@-button-",_pushType];
    } else  if ([_pushType isEqualToString:@"chat-button"]  ){
        typeStr = @"chat-write-button-";
    } else  if ([_pushType isEqualToString:@"user-write"]  ){
        typeStr = @"user-write-button-";
    } else  if ([_pushType isEqualToString:@"user-vip"]  ){
        typeStr = @"user-vip-button-";
    } else  if ([_pushType isEqualToString:@"activity"]  ){
        typeStr = @"activity-write-button-";
    }
    
    if ([url rangeOfString:@"write_12"].location != NSNotFound) {
        //短信回复包一年(198)
        [MobClick event:@"webWriter12"];
        NSString *paytype = [NSString stringWithFormat:@"%@198",typeStr];
        NSDictionary  *dic = @{@"id":@"9",@"from":paytype};
        [self onceOrderMid:mid Price:write_12 WaresName:@"365天写信包年" Private:[self ObjectToJson:dic]];
        _type = @"writer";
        _price = write_12;
        _productName = @"365天写信包年";
        //买点
        [self setStatisticalPayRequest:paytype];
    } else if ([url rangeOfString:@"write_3"].location != NSNotFound) {
        //短信回复包三月(100)
        [MobClick event:@"webWriter3"];
        NSString *paytype = [NSString stringWithFormat:@"%@100",typeStr];
        NSDictionary  *dic = @{@"id":@"4",@"from":paytype};
        [self onceOrderMid:mid Price:write_3 WaresName:@"90天写信包月" Private:[self ObjectToJson:dic]];
        _type = @"writer";
        _price = write_3;
        _productName = @"90天写信包月";
        //买点
        [self setStatisticalPayRequest:paytype];
    } else if ([url rangeOfString:@"write_1"].location != NSNotFound) {
        //短信回复包一月(50)
        [MobClick event:@"webWriter1"];
        NSString *paytype = [NSString stringWithFormat:@"%@50",typeStr];
        NSDictionary  *dic = @{@"id":@"5",@"from":paytype};
        [self onceOrderMid:mid Price:write_1 WaresName:@"30天写信包月" Private:[self ObjectToJson:dic]];
        _type = @"writer";
        _price = write_1;
        _productName = @"30天写信包月";
        //买点
        [self setStatisticalPayRequest:paytype];
    } else if ([url rangeOfString:@"vip_90"].location != NSNotFound) {
        //vip会员三个月(100)
        [MobClick event:@"webVip90"];
        NSString *paytype = [NSString stringWithFormat:@"%@100",typeStr];
        NSDictionary  *dic = @{@"id":@"1",@"from":paytype};
        [self onceOrderMid:mid Price:vip_90 WaresName:@"90天会员" Private:[self ObjectToJson:dic]];
        _type = @"vip";
        _price = vip_90;
        _productName = @"90天会员";
        //买点
        [self setStatisticalPayRequest:paytype];
    } else if ([url rangeOfString:@"vip_30"].location != NSNotFound) {
        //vip会员一个月(50)
        [MobClick event:@"webVip30"];
        NSString *paytype = [NSString stringWithFormat:@"%@50",typeStr];
        NSDictionary  *dic = @{@"id":@"2",@"from":paytype};
        [self setStatisticalPayRequest:@""];
        [self onceOrderMid:mid Price:vip_30 WaresName:@"30天会员" Private:[self ObjectToJson:dic]];
        _type = @"vip";
        _price = vip_30;
        _productName = @"30天会员";
        //买点
        [self setStatisticalPayRequest:paytype];
        
    } else if([url rangeOfString:@"activity_back"].location != NSNotFound) {
        //话费活动返回
        [self handleBack];
    }
    
    
    return YES;
}
#pragma mark - json字符串
- (NSString*)ObjectToJson:(id )obj
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

@end
