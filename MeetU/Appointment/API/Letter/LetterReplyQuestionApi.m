//
//  LetterReplyQuestionApi.m
//  Appointment
//
//  Created by feiwu on 16/7/20.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "LetterReplyQuestionApi.h"

@implementation LetterReplyQuestionApi
{
    NSString *_other_id;
    NSString *_greet_id;
    NSString *_select_id;
}

- (id)initWithOther_id:(NSString *)other_id Greet_id:(NSString *)greet_id Select_id:(NSString *)select_id{
    self = [super init];
    if (self) {
        _other_id = other_id;
        _greet_id = greet_id;
        _select_id = select_id;
    }
    return self;
}

- (NSString *)requestUrl {
    
    NSString *url = @"/iOS/Chat/buttonOption";
    
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    return @{
             @"other_id": _other_id ? _other_id : @"",
             @"greet_id": _greet_id ? _greet_id : @"",
             @"select_id": _select_id ? _select_id : @""
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
