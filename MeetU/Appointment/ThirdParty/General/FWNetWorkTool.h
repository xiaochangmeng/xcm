//
//  CKNetWorkTool.h
//  yijia
//
//  Created by apple on 16/5/28.
//  Copyright © 2016年 apple. All rights reserved.
//


#import "AFHTTPSessionManager.h"

@interface FWNetWorkTool : AFHTTPSessionManager

///网络请求单例
+(instancetype)sharedNetWorkTool;

///POST网络请求
-(void)requestPOST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;

//GET网络请求
-(void)requestGET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

@end
