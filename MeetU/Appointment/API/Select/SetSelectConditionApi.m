//
//  SetSelectConditionApi.m
//  Appointment
//
//  Created by feiwu on 16/7/16.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "SetSelectConditionApi.h"

@implementation SetSelectConditionApi
{
    NSString *_area;
    NSString *_minage;
    NSString *_maxage;
    NSString *_minht;
    NSString *_maxht;
}
- (id)initWithArea:(NSString *)area Minage:(NSString *)minage Maxage:(NSString *)maxage Minht:(NSString *)minht Maxht:(NSString *)maxht{
    self = [super init];
    if (self) {
        _area = area;
        _minage = minage;
        _maxage = maxage;
        _minht = minht;
        _maxht = maxht;
    }
    return self;
}

- (NSString *)requestUrl {
    
    NSString *url = @"/iOS/Mine/setPartnerAPP";
    
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
     LogOrange(@"apiapiapi请求的参数区域:%@  小身高:%@  大身高:%@ 小年龄:%@  大年龄:%@",_area,_minht,_maxht,_minage,_maxage);
    return @{
             @"area"  : _area ? _area : @"广东",
             @"minage" : _minage ? _minage : @"",
             @"maxage" : _maxage ? _maxage : @"",
             @"minheight" : _minht ? _minht : @"",
             @"maxheight" : _maxht ? _maxht : @""
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
