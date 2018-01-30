//
//  CircleCommentListApi.h
//  Appointment
//
//  Created by feiwu on 2017/2/7.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "BaseRequest.h"

@interface CircleCommentListApi : BaseRequest
- (id)initWithCommentID:(NSString *)commentID Page:(NSString *)page;
@end
