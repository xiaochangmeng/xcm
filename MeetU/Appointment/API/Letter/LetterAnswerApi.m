//
//  LetterAnswerApi.m
//  Appointment
//
//  Created by feiwu on 2017/2/7.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "LetterAnswerApi.h"

@implementation LetterAnswerApi
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
    
    NSString *url = @"/WebApi/VirtualVideoChat/accept.html";
    
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    return @{
             @"mid" :  _mid ? _mid : @""
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
