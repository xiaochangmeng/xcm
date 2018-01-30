//
//  StatisticalApi.m
//  Appointment
//
//  Created by feiwu on 16/9/24.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "StatisticalApi.h"
#import "SimulateIDFA.h"
@implementation StatisticalApi
- (NSString *)requestUrl {
    
    NSString *url = @"/iOS/AppPre/firstOpen";
    
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];//版本号
    if ( appVersion == nil) {
        appVersion = @"1.0";
    }
    
    NSString *idfa = [FWUserInformation sharedInstance].idfa;//设备标识
    if ( idfa == nil || [idfa isEqualToString:@""]) {
        idfa = [SimulateIDFA createSimulateIDFA];
        [FWUserInformation sharedInstance].idfa = idfa;
        [[FWUserInformation sharedInstance] saveUserInformation];
    }
    
    NSString *ditch = [FWUserInformation sharedInstance].ditch;//渠道
    if ([ditch isEqualToString:@""] || ditch == nil) {
        ditch = @"AppStore";
    }
    return @{
             @"idfa" : idfa,
             @"version" : appVersion,
             @"ditch" : ditch ,
             @"appname" : @"MeetU"
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
