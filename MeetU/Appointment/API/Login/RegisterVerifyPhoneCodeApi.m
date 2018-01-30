//
//  RegisterVerifyPhoneCodeApi.m
//  Appointment
//
//  Created by feiwu on 2017/2/21.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "RegisterVerifyPhoneCodeApi.h"

@implementation RegisterVerifyPhoneCodeApi
{
    NSString *_code;
}

- (id)initWithPhoneCode:(NSString *)code{
    self = [super init];
    if (self) {
        _code = code;
    }
    return self;
}

- (NSString *)requestUrl {
    
    NSString *url = @"/WebApi/Register/mobilePhoneVerifyCode.html";
    
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    return @{
             @"code" : _code ? _code : @""
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
