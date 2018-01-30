//
//  QuestionViewApi.m
//  Appointment
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "QuestionViewApi.h"

@implementation QuestionViewApi


- (NSString *)requestUrl{
    return @"/iOS/Recommend/getQuestion";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}


@end
