//
//  LetterRefuseVideoApi.m
//  Appointment
//
//  Created by feiwu on 2017/1/21.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "LetterRefuseVideoApi.h"

@implementation LetterRefuseVideoApi
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
    
    NSString *url = @"/WebApi/VirtualVideoChat/reject.html";
    
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



@end
