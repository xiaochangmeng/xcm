//
//  UIView+Additions.m
//  MyWeiBo20131118

//  Appointment
//  Created by feiwu on 16/7/12.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.


#import "UIView+Additions.h"

@implementation UIView (Additions)

#pragma mark 给UIView加的一个类目方法，通过View可以拿到ViewController
- (UIViewController *)viewController{
    UIResponder *next = [self nextResponder];
    do{
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
        
    }while (next!=nil);
        
    return nil;
}

#pragma mark 给UIView加的一个类目方法，通过View可以拿到BaseViewController
- (CustomViewController *)baseViewController
{
    UIResponder *next = [self nextResponder];
    do{
        if ([next isKindOfClass:[CustomViewController class]]) {
            return (CustomViewController *)next;
        }
        next = [next nextResponder];
        
    }while (next!=nil);
    
    return nil;
}

@end
