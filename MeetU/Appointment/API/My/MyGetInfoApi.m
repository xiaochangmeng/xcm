//
//  MygetInfoApi.m
//  Appointment
//
//  Created by feiwu on 16/7/19.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MyGetInfoApi.h"

@implementation MyGetInfoApi
- (NSString *)requestUrl {
    
    NSString *url = @"/iOS/Mine/getInfo";
    
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
