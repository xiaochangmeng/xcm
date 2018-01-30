//
//  CircleCommnetModel.m
//  Appointment
//
//  Created by feiwu on 2017/2/10.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "CircleCommnetModel.h"

@implementation CircleCommnetModel
- (NSDictionary *)attributeMapDictionary {
    return @{
             @"content" : @"content",
             @"avatar" : @"avatar",
             @"moment_id" : @"moment_id",
             @"create_time" : @"create_time",
             @"to_mid" : @"to_mid",
             @"mid" : @"mid",
             @"sex" : @"sex",
             @"nickname" : @"nickname",
             @"vip_grade" : @"vip_grade"
             };
}

@end
