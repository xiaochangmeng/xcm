//
//  CustomHua.h
//  OneBuy
//
//  Created by JH.Liu on 14/12/2.
//  Copyright (c) 2014年 LiuJH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomHua : NSObject
@property (strong,nonatomic)UIView *huaView;

+ (instancetype)sharedInstance;
- (void)pleaseWaitUs;

- (void)startloaddata:(UIView *)view withString:(NSString *)string;
//- (void)LPPopupalert:(UIView *)view andString:(NSString *)string;
- (void)stoploaddata:(UIView *)view;
- (void)AlertSomethingTitle:(NSString *)titleString message:(NSString *)messageString;



@end
