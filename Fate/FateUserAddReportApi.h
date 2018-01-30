//
//  FateUserAddReportApi.h
//  Appointment
//
//  Created by feiwu on 16/7/22.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//


#import "BaseRequest.h"
@interface FateUserAddReportApi : BaseRequest
- (id)initWithMid:(NSString *)mid Content:(NSString *)content;
@end
