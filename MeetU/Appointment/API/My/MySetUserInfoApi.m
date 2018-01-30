//
//  MySetUserInfoApi.m
//  Appointment
//
//  Created by feiwu on 16/7/15.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MySetUserInfoApi.h"
#import "LXFileManager.h"
@implementation MySetUserInfoApi

{
    NSDictionary *_info;
}
- (id)initWithInfo:(NSDictionary *)info{
    self = [super init];
    if (self) {
        _info = info;
    }
    return self;
}

- (NSString *)requestUrl {
    
    NSString *url = @"/iOS/Mine/setInfo";
    
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    if (_info) {
        return _info;
    } else {
        return @{
                 
                 };
    }
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
