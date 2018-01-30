//
//  MyVisitorApi.m
//  Appointment
//
//  Created by feiwu on 16/8/24.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MyVisitorApi.h"

@implementation MyVisitorApi
{
    NSString *_p;
    NSString *_vip;
    
}

- (id)initWithP:(NSString *)p Flag_vip:(NSString *)vip{
    self = [super init];
    if (self) {
        _p = p;
        _vip = vip;
    }
    return self;
}

- (NSString *)requestUrl {
    
    NSString *url = @"/iOS/Mine/getLtvsmeList";
    
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    NSString *number;
    if ([_vip integerValue] == 1) {
        number = @"20";
    } else {
        number = @"8";
    }
    return @{
             @"page": _p ? _p : @"1",
             @"num" : number
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
