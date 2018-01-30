//
//  VoiceIntroducedApi.m
//  Appointment
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "VoiceIntroducedApi.h"

@implementation VoiceIntroducedApi
{
    NSData *_voiceData;
    NSUInteger _duration;
}

- (instancetype)initWithVoiceData:(NSData *)data duration:(NSUInteger)duration{
    if (self = [super init]) {
        _voiceData = data;
        _duration = duration;
    }
    return self;
}
- (id)requestArgument {
    return @{
             @"voice" : _voiceData ? _voiceData : @"",
             @"length" :  [NSNumber numberWithUnsignedInteger:_duration]
             };
}

- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        // 1) 取当前系统时间
        NSDate *date = [NSDate date];
        // 2) 使用日期格式化工具
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        // 3) 指定日期格式
        [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
        NSString *dateStr = [formatter stringFromDate:date];

        NSString *name = dateStr;
        NSString *formKey = @"voice";
        NSString *type = @"audio/basic";
        [formData appendPartWithFileData:_voiceData name:formKey fileName:name mimeType:type];
    };
}

- (NSString *)requestUrl{
    return @"/iOS/Voice/uploadVoiceInfo";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

@end
