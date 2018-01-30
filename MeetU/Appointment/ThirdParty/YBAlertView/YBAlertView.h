//
//  YBAlertView.h
//  YBAlertView_Demo
//
//  Created by Jason on 16/1/12.
//  Copyright © 2016年 www.jizhan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"

#define kScreenH ([UIScreen mainScreen].bounds.size.height)
#define kScreenW ([UIScreen mainScreen].bounds.size.width)
typedef void(^EconomicCalendarClick2)();
@interface YBAlertView : UIView

@property (nonatomic,copy)EconomicCalendarClick2 EconomicCalendarClick2;
- (void)show;
- (void)close;


@end
