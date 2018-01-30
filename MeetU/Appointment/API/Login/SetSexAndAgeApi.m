//
//  MiscShareApi.m
//  Appointment
//
//  Created by feiwu on 16/10/18.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "SetSexAndAgeApi.h"

@implementation SetSexAndAgeApi
{
    NSString *_sex;
    NSString *_age;
     NSString *_mobile;
}

- (id)initWithSex:(NSString *)sex Age:(NSString *)age Mobile:(NSString *)mobile{
    self = [super init];
    if (self) {
        _sex = sex;
        _age = age;
        _mobile = mobile;
    }
    return self;
}

- (NSString *)requestUrl {

    NSString *url = @"/WebApi/Mine/setSexAge.html";
    
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    return @{
             @"sex" : _sex ? _sex : @"1",
             @"age" : _age ? _age : @"24",
             @"openVirtualVideo" : @"1",
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
