//
//  FateListApi.m
//  Appointment
//
//  Created by feiwu on 16/7/13.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "FateListApi.h"

@implementation FateListApi
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
    
    NSString *url = @"/iOS/Fate/getList";

    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    NSLog(@"当前的页码是:%@",_page);
    
    return @{
             @"num"  : @"15",
             @"page" : _page ? _page : @"1"
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
