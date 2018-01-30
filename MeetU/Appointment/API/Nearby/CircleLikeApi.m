//
//  CircleLikeApi.m
//  Appointment
//
//  Created by feiwu on 2017/2/7.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "CircleLikeApi.h"

@implementation CircleLikeApi
{
    NSString *_comment_id;
}
- (id)initWithCommentID:(NSString *)commentID{
    self = [super init];
    if (self) {
        _comment_id = commentID;
        
    }
    return self;
}

- (NSString *)requestUrl {
    
    NSString *url = @"/WebApi/Moments/likeApp.html";
    
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    return @{
             @"moment_id" : _comment_id ? _comment_id : @""
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
