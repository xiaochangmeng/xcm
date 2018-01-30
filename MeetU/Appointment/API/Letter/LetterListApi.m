//
//  LetterListApi.m
//  Appointment
//
//  Created by feiwu on 16/7/15.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "LetterListApi.h"

@implementation LetterListApi
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
    
    NSString *url = @"/iOS/Chat/getLetterList";
    
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    return @{
             @"page": _page ? _page : @"0",
             @"limit" : @"20"
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
