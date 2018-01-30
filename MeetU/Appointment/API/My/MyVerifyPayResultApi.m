//
//  MyPayApi.m
//  Appointment
//
//  Created by feiwu on 2016/10/25.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MyVerifyPayResultApi.h"

@implementation MyVerifyPayResultApi
{
    NSString *_receipt;
    NSString *_tid;
    NSString *_pid;
    NSString *_from;
    NSString *_time;
}

- (id)initWithReceipt:(NSString *)receipt Transactionid:(NSString *)tid Productid:(NSString *)pid From:(NSString *)from Time:(NSString *)time{
    self = [super init];
    if (self) {
        _receipt = receipt;
        _tid = tid;
        _pid = pid;
        _from = from;
        _time = time;
    }
    return self;
}

- (NSString *)requestUrl {
    
    NSString *url = @"/iOS/Payment/iapVerify";
    
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    
    NSString *user_id = [FWUserInformation sharedInstance].mid;
    if ([user_id isEqualToString:@""] || user_id == nil) {
        user_id = @"";
    }
    //版本
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (appVersion == nil) {
        appVersion = @"1.0";
    }
    
    //渠道
    NSString *ditch = [FWUserInformation sharedInstance].ditch;//渠道
    if ([ditch isEqualToString:@""] || ditch == nil) {
        ditch = @"AppStore";
    }

    return @{
             @"receipt" : _receipt ? _receipt : @"",
             @"transactionId" : _tid ? _tid : @"",
             @"user_id" :  user_id,
             @"p_id" : _pid ? _pid : @"",
             @"ditch" : ditch,
             @"version" : appVersion,
             @"from" : _from ? _from : @"",
             @"time" : _time ? _time : @"",
             };
}

//- (id)jsonValidator {
//    return @{
//             @"state_code": [NSString class]
//            };
//}

//- (NSMutableArray *)matchList {
//    return [[[self responseJSONObject] objectForKey:@"userId"] stringValue];
//}


//- (NSInteger)cacheTimeInSeconds {
//    return 60 * 3;
//}

@end
