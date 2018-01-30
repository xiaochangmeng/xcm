//
//  PushRemindUtils.h
//  Appointment
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushRemindUtils : NSObject
/**
 *  是否开启了推送
 *
 *  @return YES开启了
 */
+ (BOOL)isAllowedNotification;
@end
