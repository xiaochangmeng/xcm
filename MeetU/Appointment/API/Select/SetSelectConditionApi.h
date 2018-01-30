//
//  SetSelectConditionApi.h
//  Appointment
//
//  Created by feiwu on 16/7/16.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "BaseRequest.h"

@interface SetSelectConditionApi : BaseRequest
- (id)initWithArea:(NSString *)area Minage:(NSString *)minage Maxage:(NSString *)maxage Minht:(NSString *)minht Maxht:(NSString *)maxht;
@end
