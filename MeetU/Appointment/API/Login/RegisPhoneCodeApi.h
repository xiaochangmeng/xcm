//
//  RegisPhoneCodeApi.h
//  Appointment
//
//  Created by feiwu on 2017/2/21.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "BaseRequest.h"

@interface RegisPhoneCodeApi : BaseRequest
- (id)initWithPhoneNumber:(NSString *)mobile;
@end
