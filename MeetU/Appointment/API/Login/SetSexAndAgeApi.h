//
//  MiscShareApi.h
//  Appointment
//
//  Created by feiwu on 16/10/18.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//


#import "BaseRequest.h"

@interface SetSexAndAgeApi : BaseRequest

- (id)initWithSex:(NSString *)sex Age:(NSString *)age Mobile:(NSString *)mobile ;

@end
