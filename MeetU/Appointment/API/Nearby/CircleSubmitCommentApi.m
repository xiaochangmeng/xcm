//
//  CircleSubmitCommentApi.m
//  Appointment
//
//  Created by feiwu on 2017/2/7.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "CircleSubmitCommentApi.h"

@implementation CircleSubmitCommentApi
{
    NSString *_comment_id;
    NSString *_content;
}
- (id)initWithCommentID:(NSString *)commentID Content:(NSString *)content{
    self = [super init];
    if (self) {
        _comment_id = commentID;
        _content = content;
        
    }
    return self;
}

- (NSString *)requestUrl {
    
    NSString *url = @"/iOS/circle/addComment";
    
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    return @{
             @"moment_id" : _comment_id ? _comment_id : @"",
             @"content" : _content ? _content : @""
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
