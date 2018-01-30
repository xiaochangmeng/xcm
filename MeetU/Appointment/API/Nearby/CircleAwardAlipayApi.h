//
//  CircleAwardApi.h
//  Appointment
//
//  Created by feiwu on 2017/2/8.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "BaseRequest.h"

@interface CircleAwardAlipayApi : BaseRequest
- (id)initWithArtice_id:(NSString *)artice_id  Smid:(NSString *)smid Simg_id:(NSString *)simg_id;
@end
