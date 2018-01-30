//
//  MyAddentionApi.m
//  Appointment
//
//  Created by feiwu on 16/8/9.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MyAddentionApi.h"

@implementation MyAddentionApi
{
    NSString *_p;
}

- (id)initWithP:(NSString *)p{
    self = [super init];
    if (self) {
        _p = p;
    }
    return self;
}

- (NSString *)requestUrl {
    
    NSString *url = @"/iOS/Mine/getMeAttentionList";
    
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    return @{
             @"page": _p ? _p : @"1",
             @"num" : @"10"
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
