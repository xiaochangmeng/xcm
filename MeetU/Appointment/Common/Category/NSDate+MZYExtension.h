//
//  NSDate+MZYExtension.h
//  Appointment
//
//  Created by feiwu on 16/8/13.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MZYExtension)
/** 字符串时间戳。 */
@property (nonatomic, copy, readonly) NSString *timeStamp;


/**
 *  @brief 返回和当前NSDate之间的时间差
 *  @param date 截止NSDate
 *  @return 时间差
 */
+ (NSDateComponents *)getDateDifferent:(NSDate *)date;

/**
 *  @brief 时间戳按指定格式输出
 *  @param timeString 时间戳
    @param formatter 输出格式
 *  @return 输出字符串
 */

+ (NSString *)dateString:(NSString *)timeString dateFormatter:(NSString *)formatter;

/**
 *  @brief NSDate按指定格式输出
 *  @param date 原始date
    @param formatter 输出格式
 *  @return 输出字符串
 */

+ (NSString *)getDate:(NSDate *)date dateFormatter:(NSString *)formatter;


@end
