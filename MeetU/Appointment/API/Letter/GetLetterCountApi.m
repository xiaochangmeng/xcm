//
//  GetLetterCountApi.m
//  Appointment
//
//  Created by feiwu on 16/7/20.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "GetLetterCountApi.h"

@implementation GetLetterCountApi


- (NSString *)requestUrl {
    
    NSString *url = @"/iOS/Chat/newsMsgNum";
    
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
//             @"PHPSESSID": [NSString class],
//             @"code": [NSString class],
//             @"data": [NSString class],
//             @"msg": [NSString class]
//            };
//}

//- (NSMutableArray *)matchList {
//    return [[[self responseJSONObject] objectForKey:@"userId"] stringValue];
//}


//- (NSInteger)cacheTimeInSeconds {
//    return 60 * 3;
//}

@end
