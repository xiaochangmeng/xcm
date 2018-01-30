//
//  PushRemindUtils.m
//  Appointment
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "PushRemindUtils.h"

@implementation PushRemindUtils

/**
 *  用户是否开启了推送通知
 *
 *  @return YES开启
 */
+ (BOOL)isAllowedNotification {
    if ([self isSystemVersioniOS8]) {// system is iOS8
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    } else {//iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type)
            return YES;
    }
    return NO;
}

/**
 *  获取当前系统版本号  区分是否大于8
 *
 *  @return YES代表当前系统大于8.0
 */
+ (BOOL)isSystemVersioniOS8 {
    //check systemVerson of device
    UIDevice *device = [UIDevice currentDevice];
    float sysVersion = [device.systemVersion floatValue];
    
    if (sysVersion >= 8.0f) {
        return YES;
    }
    return NO;
}

@end
