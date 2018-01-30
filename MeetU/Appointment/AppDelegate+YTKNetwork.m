//
//  AppDelegate+YTKNetwork.m
//  Appointment
//
//  Created by feiwu on 16/7/12.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "AppDelegate+YTKNetwork.h"
#import "YTKNetworkConfig.h"
#import "YTKUrlArgumentsFilter.h"
#import "SimulateIDFA.h"
@implementation AppDelegate (YTKNetwork)

#pragma mark - YTKNetwork
#pragma mark 设置请求过滤
- (void)setupRequestFilters {
    YTKNetworkConfig *config = [YTKNetworkConfig sharedInstance];
    config.baseUrl = BaseUrl;
    config.cdnUrl = BaseUrl;
    
    //全局参数
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];//版本号
    if (appVersion == nil) {
        appVersion = @"1.0";
    }
    
    NSString *os_version = [UIDevice currentDevice].systemVersion;//系统版本
    if (os_version == nil) {
        os_version = @"10.0";
    }
    
    NSString *idfa = [FWUserInformation sharedInstance].idfa;//设备标识
    if ( idfa == nil || [idfa isEqualToString:@""]) {
        idfa = [SimulateIDFA createSimulateIDFA];
        [FWUserInformation sharedInstance].idfa = idfa;
        [[FWUserInformation sharedInstance] saveUserInformation];
    }
    
    NSString *device_name = [UIDevice currentDevice].name;//设备名称
    if (device_name == nil) {
        device_name = @"夏天";
    }
    
    NSString *device_type = [UIDevice currentDevice].model;//设备类型
    if (device_type == nil) {
        device_type = @"iPhone6";
    }
    
    NSString *jailbreak = @"";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
        jailbreak = @"1";
    } else {
        jailbreak = @"0";
    }
    NSString *ditch = [FWUserInformation sharedInstance].ditch;//渠道
    if ([ditch isEqualToString:@""] || ditch == nil) {
        ditch = @"AppStore";
    }
    NSString * globalization =[FWUserInformation sharedInstance].globalizationStr;
    if ( globalization == nil) {
        globalization = @"";
    }

    
    
    YTKUrlArgumentsFilter *urlFilter = [YTKUrlArgumentsFilter filterWithArguments:@{@"language" :  globalization,@"app_version" :  appVersion,@"platform" : @"iOS",@"device_name" : device_name,@"os_version" : os_version,@"idfa" : idfa,@"channel" : ditch,@"is_jailbreak" : jailbreak,@"is_appstore" : @"1" ,@"device_type" : device_type,@"jpush_appkey" : @"e1ee30d819da5e773504f967"}];
    [config addUrlFilter:urlFilter];
    
}


@end
