//
//  FacebookLoginApi.m
//  taiwantongcheng
//
//  Created by feiwu on 2016/11/25.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "FacebookLoginApi.h"
#import "SimulateIDFA.h"
@implementation FacebookLoginApi
{
    NSString *_user_id;
    NSString *_nickname;
    NSString *_sex;
    NSString *_photo;
    NSString *_age;
    NSString *_third_id;
    NSString *_locale;
    NSString *_tag;
}

- (id)initWithUser_id:(NSString *)user_id Nickname:(NSString *)nickname Sex:(NSString *)sex Photo:(NSString *)photo Age:(NSString *)age Third_id:(NSString *)third_id Locale:(NSString *)locale Tag:(NSString *)tag {
    self = [super init];
    if (self) {
        _user_id = user_id;
        _nickname = nickname;
        _sex = sex;
        _photo = photo;
        _age = age;
        _third_id = third_id;
        _locale = locale;
        _tag = tag;
    }
    return self;
}

- (NSString *)requestUrl {
    
    NSString *url = @"/iOS/LoginFaceBook/login";
    
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
    
    //渠道
    NSString *ditch = [FWUserInformation sharedInstance].ditch;//渠道
    if ([ditch isEqualToString:@""] || ditch == nil) {
        ditch = @"AppStore";
    }
    
    //idfa
    NSString *idfa = [FWUserInformation sharedInstance].idfa;//设备标识
    if ( idfa == nil || [idfa isEqualToString:@""]) {
        idfa = [SimulateIDFA createSimulateIDFA];
        [FWUserInformation sharedInstance].idfa = idfa;
        [[FWUserInformation sharedInstance] saveUserInformation];
    }
    NSLog(@"年龄是:%@",_age);
    
    return @{
             @"id" : _user_id ? _user_id : @"",
             @"name" : _nickname ? _nickname : @"",
             @"sex" : _sex ? _sex : @"",
             @"photo" : _photo ? _photo : @"",
             @"age" : _age ? _age : @"",
             @"third_party_id" : _third_id ? _third_id : @"",
             @"locale" : _locale ? _locale : @"",
              @"tag" : _tag ? _tag : @"",
              @"idfa" : idfa,
              @"version" : appVersion,
             @"ditch" : ditch,
             @"appname" : @"MeetU",
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
