//
//  QuestionSelectEntity.h
//  Appointment
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//  用户答案选择项

#import <Foundation/Foundation.h>

@interface QuestionSelectEntity : NSObject
/**答案Id */
@property (assign, nonatomic) NSUInteger sId;
/**答案内容 */
@property (strong, nonatomic) NSString* anserContent;
@end
