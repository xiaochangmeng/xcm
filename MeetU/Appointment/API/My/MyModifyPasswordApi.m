//
//  MyModifyPasswordApi.m
//  Appointment
//
//  Created by feiwu on 16/7/19.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MyModifyPasswordApi.h"

@implementation MyModifyPasswordApi
{
    NSString *_password;
}
- (id)initWithPassword:(NSString *)password{
    self = [super init];
    if (self) {
        _password = password;
    }
    return self;
}

- (NSString *)requestUrl {
    
    NSString *url = @"/iOS/Mine/setPasswordApp";
    
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    return @{
             @"newPassword" : _password ? _password : @""
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
