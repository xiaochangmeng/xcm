//
//  CircleListApi.m
//  Appointment
//
//  Created by feiwu on 2017/2/7.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "CircleListApi.h"
@implementation CircleListApi
{
    NSString *_page;
}
- (id)initWithPage:(NSString *)page{
    self = [super init];
    if (self) {
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
             @"page" : _page ? _page : @"1",
             @"num" : @"10",
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
