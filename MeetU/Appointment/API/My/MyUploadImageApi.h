//
//  MySetUserImageApi.h
//  Appointment
//
//  Created by feiwu on 16/7/18.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "BaseRequest.h"
@interface MyUploadImageApi : BaseRequest
- (id)initWithImage:(UIImage *)image Type:(NSString *)type;
@end
