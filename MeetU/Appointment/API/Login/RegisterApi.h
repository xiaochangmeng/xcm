//
//  RegisterApi.h
//  Appointment
//
//  Created by feiwu on 16/7/12.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "BaseRequest.h"

@interface RegisterApi : BaseRequest
- (id)initWithSex:(NSString *)sex Age:(NSString *)age;
@end
