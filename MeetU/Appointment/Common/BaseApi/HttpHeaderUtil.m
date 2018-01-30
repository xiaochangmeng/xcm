//
//  HttpHeaderUtil.m
//  生成Http请求头的工具类
//  Appointment
//  Created by feiwu on 16/7/12.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.

#import "HttpHeaderUtil.h"
#import "LXFileManager.h"
@implementation HttpHeaderUtil

+ (NSDictionary *)requestHeaderFieldValueDictionary{
    //令牌
    NSString *PHPSESSID = @"";
    NSString *phpsessid = [LXFileManager readUserDataForKey:kUserPHPSESSID];
    
    if (phpsessid != nil && phpsessid.length > 5) {
        PHPSESSID = phpsessid;
    }
    LogYellow(@"当前用户的标识:%@",PHPSESSID);
    return @{
             @"PHPSESSID":PHPSESSID
             };
}


@end
