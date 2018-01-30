//
//  CKNetWorkTool.m
//  yijia
//
//  Created by apple on 16/5/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "FWNetWorkTool.h"

@implementation FWNetWorkTool

static FWNetWorkTool * _instance;

///网络单例工具
+(instancetype)sharedNetWorkTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //设置baseURL
        NSURL * baseURL = [NSURL URLWithString:@"http://iosapi.itcast.cn/"];
        _instance = [[FWNetWorkTool alloc] initWithBaseURL:baseURL];
        //添加数据解析参数text/plain
        _instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        //设置JSON请求--否则无法获取数据
//        [_instance setSecurityPolicy:[NetWorkManager customSecurityPolicy]];
        _instance.requestSerializer = [AFJSONRequestSerializer serializer];
    });
    
    return _instance;
}

///POST网络请求--二次封装
-(void)requestPOST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure {
    [self POST:URLString parameters:parameters success:success failure:failure];
}

//GET网络请求
-(void)requestGET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure {
    [self GET:URLString parameters:parameters success:success failure:failure];
}




@end
