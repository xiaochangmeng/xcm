//
//  LetterSendMessageApi.m
//  Appointment
//
//  Created by feiwu on 16/7/25.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "LetterSendMessageApi.h"

@implementation LetterSendMessageApi
{
    NSString *_other_id;
    NSString *_content;
}

- (id)initWithOther_id:(NSString *)other_id Content:(NSString *)content{
    self = [super init];
    if (self) {
        _other_id = other_id;
        _content = content;
    }
    return self;
}

- (NSString *)requestUrl {
    NSString *url = @"/iOS/Chat/sendMessage";
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    return @{
             @"other_id": _other_id ? _other_id : @"",
             @"content": _content ? _content : @""
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
