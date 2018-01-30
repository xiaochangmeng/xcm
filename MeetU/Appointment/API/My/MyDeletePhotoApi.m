//
//  MyDeletePhotoApi.m
//  Appointment
//
//  Created by feiwu on 16/7/30.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MyDeletePhotoApi.h"

@implementation MyDeletePhotoApi
{
    NSString *_url;
}
- (id)initWithUrl:(NSString *)url{
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}

- (NSString *)requestUrl {
    
    NSString *url = @"/iOS/Mine/deleteAlbum";
    
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    return @{
             @"url" : _url ? _url : @""
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
