//
//  CircleAwardAiBeiApi.m
//  Appointment
//
//  Created by feiwu on 2017/2/14.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "CircleAwardAiBeiApi.h"

@implementation CircleAwardAiBeiApi
{
    NSString *_artice_id;//文章id
    NSString *_smid;//被打赏人id
    NSString *_simg_id; //图片id
}
- (id)initWithArtice_id:(NSString *)artice_id Smid:(NSString *)smid Simg_id:(NSString *)simg_id{
    self = [super init];
    if (self) {
        _artice_id = artice_id;
        _smid = smid;
        _simg_id = simg_id;
    }
    return self;
}

- (NSString *)requestUrl {
    
    NSString *url = @"/WebApi/Beipay/index.html";
    
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
    
    NSString *mid = [FWUserInformation sharedInstance].mid;
    if ([mid isEqualToString:@""] || mid == nil) {
        mid = @"";
    }
    NSLog(@"贝付通mid；%@  文章id:%@  版本:%@  渠道：%@ 图片id:%@",_smid,_artice_id,appVersion,ditch,_simg_id);
    
    return @{
             @"ditch" : ditch,
             @"version" : appVersion,
             @"tag" :  @"ios",
             @"action" : @"reward",
             @"from" : @"circle-award",
             @"smid" : _smid ? _smid : @"",
             @"mid" : mid,
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
