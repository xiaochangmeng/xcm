//
//  LoginApi.h
//  Appointment
//
//  Created by feiwu on 16/7/12.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "BaseRequest.h"

@interface LoginApi : BaseRequest
- (id)initWithUser_id:(NSString *)user_id Password:(NSString *)password;
@end
