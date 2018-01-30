//
//  CircleMarqueeApi.m
//  Appointment
//
//  Created by feiwu on 2017/2/27.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "CircleMarqueeApi.h"

@implementation CircleMarqueeApi
- (NSString *)requestUrl {
    
    NSString *url = @"/WebApi/Moments/getNearOrderList.html";
    
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
