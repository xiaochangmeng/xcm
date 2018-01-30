//
//  AppDelegate+ShareSDK.m
//  Appointmenttaiwan
//
//  Created by feiwu on 2016/11/21.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "AppDelegate+ShareSDK.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <FacebookConnector/FacebookConnector.h>


@implementation AppDelegate (ShareSDK)

- (void)setShareSDK
{

    [ShareSDK registerApp:@"1937dc6eb7b38"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeFacebook)]
                 onImport:nil
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeFacebook:
                 //设置facebook应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupFacebookByApiKey:@"1474739059215209" appSecret:@"a2015c8eb328bf185cde36c0847ad99e" authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
    
       
}

@end
