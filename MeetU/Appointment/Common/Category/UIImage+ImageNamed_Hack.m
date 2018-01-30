//
//  UIImage+ImageNamed_Hack.m
//  Appointment
//  Created by feiwu on 16/7/12.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.

#import "UIImage+ImageNamed_Hack.h"

@implementation UIImage (ImageNamed_Hack)


+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size

{
    
    @autoreleasepool {
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        UIGraphicsBeginImageContext(rect.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context,
                                       
                                       color.CGColor);
        
        CGContextFillRect(context, rect);
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        
        
        return img;
        
    }
    
}

#pragma mark 图片拉伸
+ (UIImage *)imageNamed:(NSString *)name ImageType:(NSString *)type withTop:(float)top andLeft:(float)left
{
    CGFloat bottom = top; // 底端盖高度
    CGFloat right = left; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    UIImage *image = LOADIMAGE(name, type);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    return image;
}


@end
