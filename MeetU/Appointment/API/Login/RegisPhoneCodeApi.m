//
//  RegisPhoneCodeApi.m
//  Appointment
//
//  Created by feiwu on 2017/2/21.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "RegisPhoneCodeApi.h"

@implementation RegisPhoneCodeApi
{
    NSString *_mobile;
}

- (id)initWithPhoneNumber:(NSString *)mobile{
    self = [super init];
    if (self) {
        _mobile = mobile;
    }
    return self;
}

- (NSString *)requestUrl {
    
    NSString *url = @"/WebApi/Register/mobilePhoneVerify.html";
    
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
       return @{
                @"mobile" : _mobile ? _mobile : @""
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
