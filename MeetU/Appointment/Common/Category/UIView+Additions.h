//
//  UIView+Additions.h
//  MyWeiBo20131118
//  给UIView加的一个类目方法，通过View可以拿到ViewController
//  Appointment
//  Created by feiwu on 16/7/12.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.



#import <UIKit/UIKit.h>
#import "CustomViewController.h"

@interface UIView (Additions)

- (UIViewController *)viewController;


- (CustomViewController *)baseViewController;

@end
