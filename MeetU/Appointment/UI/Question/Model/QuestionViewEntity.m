//
//  QuestionViewEntity.m
//  Appointment
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "QuestionViewEntity.h"

@implementation QuestionViewEntity

/**
 *  懒加载
 *
 *  @return 初始化之后的问题实体类
 */
#pragma mark - questionEntity
- (QuestionEntity *)questionEntity{
    if (nil == _questionEntity) {
        _questionEntity = [QuestionEntity new];
    }
    return _questionEntity;
}

/**
 *  懒加载
 *
 *  @return 初始化之后的  答案数组
 */
#pragma mark - questionSelectionEntitys
- (NSMutableArray<QuestionSelectEntity *> *)questionSelectionEntitys{
    if (nil == _questionSelectionEntitys) {
        _questionSelectionEntitys = [NSMutableArray new];
    }
    return _questionSelectionEntitys;
}
@end
