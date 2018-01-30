//
//  MyPayApi.h
//  Appointment
//
//  Created by feiwu on 2016/10/25.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "BaseRequest.h"

@interface MyVerifyPayResultApi : BaseRequest
- (id)initWithReceipt:(NSString *)receipt Transactionid:(NSString *)tid Productid:(NSString *)pid From:(NSString *)from Time:(NSString *)time;
@end
