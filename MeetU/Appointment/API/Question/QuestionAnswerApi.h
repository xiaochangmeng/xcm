//
//  QuestionAnswerApi.h
//  Appointment
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "BaseRequest.h"

@interface QuestionAnswerApi : BaseRequest
- (instancetype)initWithMid:(NSString *)mid qId:(NSString *)qId sId:(NSUInteger)sId;
@end
