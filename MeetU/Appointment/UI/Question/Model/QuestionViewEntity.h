//
//  QuestionViewEntity.h
//  Appointment
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//  问题视图需要的数据

#import <Foundation/Foundation.h>
#import "QuestionEntity.h"
#import "QuestionSelectEntity.h"
@interface QuestionViewEntity : NSObject
/**mid */
@property (strong, nonatomic) NSString* mid;
/**昵称 */
@property (strong, nonatomic) NSString* nickName;
/**头像路径 */
@property (strong, nonatomic) NSString* imgPath;
/**问题 */
@property (strong, nonatomic) QuestionEntity* questionEntity;
/**答案 */
@property (strong, nonatomic) NSMutableArray<QuestionSelectEntity *>* questionSelectionEntitys;
@end
