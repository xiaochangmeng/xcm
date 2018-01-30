//
//  WXBaseModel.h
//  数据模型基类，实现自动映射
//  Appointment
//  Created by feiwu on 16/7/12.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.


#import <Foundation/Foundation.h>

@interface WXBaseModel : NSObject <NSCoding>{

}

-(id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;
- (void)setAttributes:(NSDictionary*)dataDic;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData*)getArchivedData;

- (NSString *)cleanString:(NSString *)str;    //清除\n和\r的字符串

- (void)replaceNilAttribute:(NSArray *)exceptionArray;

//- (id)autocopyAttrbuteValue:(id)targetObj;

@end
