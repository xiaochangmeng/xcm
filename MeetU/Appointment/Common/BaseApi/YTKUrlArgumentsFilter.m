//
// Created by Chenyu Lan on 8/27/14.
// Copyright (c) 2014 Fenbi. All rights reserved.
//

#import "YTKUrlArgumentsFilter.h"
#import "YTKNetworkPrivate.h"

@implementation YTKUrlArgumentsFilter {
    NSDictionary *_arguments;
}

+ (YTKUrlArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments {
    return [[self alloc] initWithArguments:arguments];
}

- (id)initWithArguments:(NSDictionary *)arguments {
    self = [super init];
    if (self) {
        _arguments = arguments;
    }
    return self;
}

- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request {
    NSString *url =[YTKNetworkPrivate urlStringWithOriginUrlString:originUrl appendParameters:_arguments];
    LogRed(@"url是多少:%@%@",BaseUrl,url);
    return url;
}

@end
