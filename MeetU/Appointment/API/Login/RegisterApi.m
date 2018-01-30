//
//  RegisterApi.m
//  Appointment
//
//  Created by feiwu on 16/7/12.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "RegisterApi.h"
#import "SimulateIDFA.h"
@implementation RegisterApi
{
    NSString *_sex;//0女 1男
    NSString *_age;
}
- (id)initWithSex:(NSString *)sex Age:(NSString *)age{
    self = [super init];
    if (self) {
        _sex = sex;
        _age = age;
    }
    return self;
}

- (NSString *)requestUrl {
    
    NSString *url = @"/iOS/Login/register";
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
             @"sex" : _sex ? _sex : @"1",
             @"age" : _age ? _age : @"24",
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
