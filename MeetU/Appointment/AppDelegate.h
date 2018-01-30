//
//  AppDelegate.h
//  Appointment
//
//  Created by feiwu on 16/7/8.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,JPUSHRegisterDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,strong)CLLocationManager *locationMgr;
@property (nonatomic,strong)NSMutableArray *viewControllers;
@property (nonatomic,assign)BOOL isLetter;

@end

