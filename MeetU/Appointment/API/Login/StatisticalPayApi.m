//
//  StatisticalPayApi.m
//  Appointment
//
//  Created by feiwu on 16/9/27.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "StatisticalPayApi.h"

@implementation StatisticalPayApi
{
    NSString *_action;
}

- (id)initWithAction:(NSString *)action{
    self = [super init];
    if (self) {
        _action = action;
    }
    return self;
}

- (NSString *)requestUrl {
    
    NSString *url = @"/iOS/Click/index";
    
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];//版本号
    if (appVersion == nil) {
        appVersion = @"1.0";
    }

    NSString *ditch = [FWUserInformation sharedInstance].ditch;//渠道
    if ([ditch isEqualToString:@""] || ditch == nil) {
        ditch = @"AppStore";
    }

    return @{
             @"action" : _action ? _action : @"",
             @"channel" : ditch ,
             @"version" : appVersion,
             @"platform" : @"ios",
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
