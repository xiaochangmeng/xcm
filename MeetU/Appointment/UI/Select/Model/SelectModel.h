//
//  SelectModel.h
//  Appointment
//
//  Created by feiwu on 16/7/19.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXBaseModel.h"
@interface SelectModel : WXBaseModel
@property(nonatomic,copy)NSString *area;//区域
@property(nonatomic,copy)NSString *maxage;//最大年龄
@property(nonatomic,copy)NSString *minage;//最小年龄
@property(nonatomic,copy)NSString *maxheight;//最大身高
@property(nonatomic,copy)NSString *minheight;//最小身高

@end
