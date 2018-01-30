//
//  LoginApi.m
//  Appointment
//
//  Created by feiwu on 16/7/12.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "LoginApi.h"
#import "SimulateIDFA.h"
@implementation LoginApi
{
    NSString *_user_id;
    NSString *_password;
}

- (id)initWithUser_id:(NSString *)user_id Password:(NSString *)password{
    self = [super init];
    if (self) {
        _user_id = user_id;
        _password = password;
    }
    return self;
}

- (NSString *)requestUrl {
    
    NSString *url = @"/iOS/Login/login";

    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    //版本
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (appVersion == nil) {
        appVersion = @"1.0";
    }
    // 包名
    NSString *bundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    
    //渠道
    NSString *ditch = [FWUserInformation sharedInstance].ditch;//渠道
    //if ([ditch isEqualToString:@""] || ditch == nil) {
    ditch = [NSString stringWithFormat:@"%@_AppStore",bundleID];
    //}
    
    //idfa
    NSString *idfa = [FWUserInformation sharedInstance].idfa;//设备标识
    if ( idfa == nil || [idfa isEqualToString:@""]) {
        idfa = [SimulateIDFA createSimulateIDFA];
        [FWUserInformation sharedInstance].idfa = idfa;
        [[FWUserInformation sharedInstance] saveUserInformation];
    }
    
    NSString *country = [FWUserInformation sharedInstance].country;//设备标识
    NSString *province = [FWUserInformation sharedInstance].province;//设备标识
    NSString *city = [FWUserInformation sharedInstance].city;//设备标识
    return @{
             @"userId" : _user_id ? _user_id : @"",
             @"password" : _password ? _password : @"",
             @"packName" : bundleID==nil?@"":bundleID,
             @"appName" : @"MeetU",
             @"ditchName" : ditch ,
             @"versionName" : appVersion,
             @"deviceId" : idfa,
             @"country" : country==nil?@"":country,
             @"province" : province==nil?@"":province,
             @"city" : city==nil?@"":city,
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
