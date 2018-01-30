//
//  MyFeedBackViewController.h
//  Appointment
//
//  Created by feiwu on 16/7/18.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import <StoreKit/StoreKit.h>
@interface MyFeedBackViewController : CustomViewController<UIWebViewDelegate,SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,copy)NSString *titleStr;
@property(nonatomic,copy)NSString *type;//支付类型
@property(nonatomic,copy)NSString *price;//商品价格
@property(nonatomic,copy)NSString *productName;//商品名称
@property(nonatomic,copy)NSString *productID;//商品id
@property(nonatomic,copy)NSString *productFrom;//商品路径


@property(nonatomic,copy)NSString *backType;//返回类型
@property(nonatomic,copy)NSString *pushType;//进入类型类型
@property(nonatomic,copy)NSString *showType;//展示提示类型


- (id)initWithUrl:(NSString *)url;
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
@end
