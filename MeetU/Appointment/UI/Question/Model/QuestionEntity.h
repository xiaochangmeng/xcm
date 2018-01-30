//
//  QuestionEntity.h
//  Appointment
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//  问题

#import <Foundation/Foundation.h>

@interface QuestionEntity : NSObject
/**问题Id */
@property (strong, nonatomic) NSString* qId;
/**问题内容 */
@property (strong, nonatomic) NSString*questionContent;
@end
