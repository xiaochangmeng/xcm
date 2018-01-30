//
//  QuestionAnswerApi.m
//  Appointment
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "QuestionAnswerApi.h"

@implementation QuestionAnswerApi
{
    NSString *_mid;
    NSString *_qId;
    NSUInteger _sId;
}

- (instancetype)initWithMid:(NSString *)mid qId:(NSString *)qId sId:(NSUInteger)sId{
    if (self = [super init]) {
        _mid = mid;
        _qId = qId;
        _sId = sId;
    }
    return self;
}

- (NSString *)requestUrl{
    return @"/Ios/Recommend/replyQuestion.html";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}
- (id)requestArgument {
    return @{
             @"user_id"  : _mid ? _mid : @"",
             @"id" : _qId ? _qId : @"",
             @"select" :[NSNumber numberWithUnsignedLong:_sId],
             };
}

@end
