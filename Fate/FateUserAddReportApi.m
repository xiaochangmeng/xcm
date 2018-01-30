//
//  FateUserAddReportApi.m
//  Appointment
//
//  Created by feiwu on 16/7/22.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "FateUserAddReportApi.h"

@implementation FateUserAddReportApi
{
    NSString *_mid;
    NSString *_content;
}
- (id)initWithMid:(NSString *)mid Content:(NSString *)content{
    self = [super init];
    if (self) {
        _mid = mid;
        _content = content;
        
    }
    return self;
}

- (NSString *)requestUrl {
    
    NSString *url = @"/iOS/user/addReportApp";
    
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    return @{
             @"user_id"  : _mid ? _mid : @"",
             @"content"  : _content ? _content : @"",
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
