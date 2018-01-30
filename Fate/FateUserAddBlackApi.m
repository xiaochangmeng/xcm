//
//  FateUserAddBlackApi.m
//  Appointment
//
//  Created by feiwu on 16/7/22.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "FateUserAddBlackApi.h"

@implementation FateUserAddBlackApi
{
    NSString *_mid;
}
- (id)initWithMid:(NSString *)mid{
    self = [super init];
    if (self) {
        _mid = mid;
        
    }
    return self;
}

- (NSString *)requestUrl {
    
    NSString *url = @"/iOS/user/addBlacklist";
    
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    return @{
             @"user_id"  : _mid ? _mid : @""
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
