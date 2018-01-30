//
//  QuestionViewParser.h
//  Appointment
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionViewEntity.h"
@interface QuestionViewParser : NSObject
+ (QuestionViewEntity*)parse:(NSDictionary*)dictionary;
@end
