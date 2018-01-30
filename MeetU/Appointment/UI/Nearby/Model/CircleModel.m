//
//  CircleModel.m
//  Appointment
//
//  Created by feiwu on 2017/2/7.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "CircleModel.h"

@implementation CircleModel

- (NSDictionary *)attributeMapDictionary {
    return @{
             @"author"        : @"author",
             @"avatar"        : @"avatar",
             @"content"       : @"content",
             @"from"          : @"from",
             @"comment_id"    : @"id",
             @"hits_count"    : @"hits_count",
             @"like_count"    : @"like_count",
             @"past_time"     : @"send_time",
             @"comment_list"  : @"comment",
             @"isLike"        : @"isLike",
             @"comment_count" : @"comment_count",
             @"pics_url"      : @"albums",
             @"publish_id"    : @"mid",
             @"dashang_num"   : @"dashang_num",
             @"nickname"   : @"nickname",
             @"dashang_list"  : @"dashang_list"
             };
}
@end
