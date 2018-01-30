//
//  MyModifyPasswordApi.h
//  Appointment
//
//  Created by feiwu on 16/7/19.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "BaseRequest.h"

@interface MyModifyPasswordApi : BaseRequest
- (id)initWithPassword:(NSString *)password;
@end
