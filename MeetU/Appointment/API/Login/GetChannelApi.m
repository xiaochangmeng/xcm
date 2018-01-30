//
//  GetChannelApi.m
//  Appointment
//
//  Created by feiwu on 16/9/8.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "GetChannelApi.h"

@implementation GetChannelApi
- (NSString *)requestUrl {
    
    NSString *url = @"/iOS/DynamicDitch/getDitch";
    
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    return @{
        
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
