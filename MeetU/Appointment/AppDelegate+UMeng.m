//
//  AppDelegate+UMeng.m
//  Appointment
//
//  Created by feiwu on 16/9/1.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "AppDelegate+UMeng.h"
#import "UMMobClick/MobClick.h"

@implementation AppDelegate (UMeng)
- (void)umengTrack {
    
    //设置版本
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    //设置参数
    NSString *ditch = [FWUserInformation sharedInstance].ditch;//渠道
    if ([ditch isEqualToString:@""] || ditch == nil) {
        ditch = @"AppStore";
    }
//appkey  58301bd1c62dca4e840017d4
    UMConfigInstance.appKey = @"58301bd1c62dca4e840017d4";
    UMConfigInstance.channelId = ditch;
    UMConfigInstance.eSType =  E_UM_GAME;
    [MobClick startWithConfigure:UMConfigInstance];
}



@end
