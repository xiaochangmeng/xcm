//
//  NSDate+MZYExtension.m
//  Appointment
//
//  Created by feiwu on 16/8/13.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "NSDate+MZYExtension.h"

@implementation NSDate (MZYExtension)

#pragma mark - 和当前date的时间差
+ (NSDateComponents *)getDateDifferent:(NSDate *)date
{
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd";
    
    // 截止时间字符串格式
    NSString *expireDateStr = [dateFomatter stringFromDate:date];
    
    // 当前时间字符串格式
    NSString *nowDateStr = [dateFomatter stringFromDate:nowDate];
    
    // 截止时间date格式
    NSDate *expireDate = [dateFomatter dateFromString:expireDateStr];
    
    // 当前时间date格式
    nowDate = [dateFomatter dateFromString:nowDateStr];
    
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:nowDate toDate:expireDate options:0];
    
    return dateCom;

}

#pragma mark - 时间戳指定格式输出
+ (NSString *)dateString:(NSString *)timeString dateFormatter:(NSString *)formatter {
    NSString *str = timeString;//时间戳
    
    NSTimeInterval time = [str doubleValue];//因为时差问题要加8小时
    
    NSDate*detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:formatter];
    
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
    
}

#pragma mark -date指定格式输出
+ (NSString *)getDate:(NSDate *)date dateFormatter:(NSString *)formatter
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init] ;
    [inputFormatter setDateFormat:formatter];
    NSString *dateString = [inputFormatter stringFromDate:date];
    return dateString;

}

#pragma mark - 获取当前字符串时间戳
- (NSString *)timeStamp {
    return [@([self timeIntervalSince1970]).stringValue copy];
}

@end
