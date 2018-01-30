//
//  CheckStatusApi.m
//  Appointment
//
//  Created by feiwu on 16/8/6.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "CheckStatusApi.h"

@implementation CheckStatusApi

- (NSString *)requestUrl {
    
    NSString *url = @"/WebApi/Setting/iosAudit";
    
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (appVersion == nil) {
        appVersion = @"1.0";
    }
    return @{
             @"version" : appVersion
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
