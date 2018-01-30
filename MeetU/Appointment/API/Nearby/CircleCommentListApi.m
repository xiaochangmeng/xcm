//
//  CircleCommentListApi.m
//  Appointment
//
//  Created by feiwu on 2017/2/7.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "CircleCommentListApi.h"

@implementation CircleCommentListApi
{
    NSString *_comment_id;
    NSString *_page;
}
- (id)initWithCommentID:(NSString *)commentID Page:(NSString *)page{
    self = [super init];
    if (self) {
        _comment_id = commentID;
        _page = page;
        
    }
    return self;
}

- (NSString *)requestUrl {
    
    NSString *url = @"/iOS/circle/getList";
    
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    return @{
             @"moment_id" : _comment_id ? _comment_id : @"",
             @"page" : _page ? _page : @"0",
             @"num" : @"10"
             };
}


@end
