//
//  BaseRequest.m
//  Api的基类，对头部传的参数做了统一处理
//  Appointment
//
//  Created by feiwu on 16/7/12.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.


#import "BaseRequest.h"
#import "HttpHeaderUtil.h"

@implementation BaseRequest

#pragma mark 
- (NSDictionary *)requestHeaderFieldValueDictionary{
   return [HttpHeaderUtil requestHeaderFieldValueDictionary];
}

@end
