//
//  CircleAwardApi.m
//  Appointment
//
//  Created by feiwu on 2017/2/8.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "CircleAwardAlipayApi.h"

@implementation CircleAwardAlipayApi
{
    NSString *_artice_id;
    NSString *_smid;
    NSString *_simg_id;
}

- (id)initWithArtice_id:(NSString *)artice_id  Smid:(NSString *)smid Simg_id:(NSString *)simg_id{
    self = [super init];
    if (self) {
        _artice_id = artice_id;
        _smid = smid;
        _simg_id = simg_id;
    }
    return self;
}

- (NSString *)requestUrl {
    
    NSString *url = @"/WebApi/Alipay/reward.html";
    
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if ( appVersion == nil) {
        appVersion = @"1.0";
    }
    
    NSString *ditch = [FWUserInformation sharedInstance].ditch;
    if ([ditch isEqualToString:@""] || ditch == nil) {
        ditch = @"AppStore";
    }
    NSLog(@"支付宝mid；%@  文章id:%@  版本:%@  渠道：%@ 图片id:%@",_smid,_artice_id,appVersion,ditch,_simg_id);
    
    return @{
             @"pid" : @"1",//1打赏 2充值
             @"ditch" : ditch,
             @"version" : appVersion,
             @"from" : @"circle-award",
             @"tag" :  @"ios",
             @"smid" : _smid ? _smid : @"",
             @"artice_id" : _artice_id ? _artice_id : @"",
             @"simg_id" : _simg_id ? _simg_id : @""
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
