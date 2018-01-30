//
//  UIImage+ImageNamed_Hack.h
//  Appointment
//  Created by feiwu on 16/7/12.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.

#import <UIKit/UIKit.h>

@interface UIImage (ImageNamed_Hack)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)imageNamed:(NSString *)name ImageType:(NSString *)type withTop:(float)top andLeft:(float)left;
@end
