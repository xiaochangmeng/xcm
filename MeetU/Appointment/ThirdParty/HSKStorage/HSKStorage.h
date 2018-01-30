//
//  HSKStorage.h
//
//  Created by zhouqiao on 2016/12/30.
//  Copyright © 2016年 ZQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSKStorage : NSObject

- (instancetype)initWithPath:(NSString *)path;

@property (nonatomic, strong, readonly) NSString *path;
@property (nonatomic, strong, readonly) NSArray<NSString *> *allKeys;
@property (nonatomic, strong, readonly) NSArray<id<NSCoding>> *allValues;
@property (nonatomic, assign, readonly) NSUInteger count;

- (BOOL)hsk_setObject:(id<NSCoding>)object forKey:(NSString *)key;

- (BOOL)hsk_removeObjectForKey:(NSString *)key;
- (BOOL)hsk_removeObjectsForKeys:(NSArray<NSString *> *)keys;
- (BOOL)hsk_removeAllObjects;

- (BOOL)hsk_containsObjectForKey:(NSString *)key;

- (id<NSCoding>)hsk_objectForKey:(NSString *)key;
- (NSArray<id<NSCoding>> *)hsk_objectsForKeys:(NSArray<NSString *> *)keys;

@end
