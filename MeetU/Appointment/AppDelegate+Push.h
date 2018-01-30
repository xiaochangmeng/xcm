//
//  AppDelegate+Push.h
//  Appointment
//
//  Created by feiwu on 16/7/12.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Push)<UIAlertViewDelegate>

- (void)setUpPushWithOptions:(NSDictionary *)launchOptions;
- (void)getLetterCountRequest;


@end
