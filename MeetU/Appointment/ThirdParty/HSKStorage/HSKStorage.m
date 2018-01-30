//
//  HSKStorage.m
//
//  Created by zhouqiao on 2016/12/30.
//  Copyright © 2016年 ZQ. All rights reserved.
//

#import "HSKStorage.h"
#import <sqlite3.h>

@interface HSKStorage (){
    sqlite3 *_db;
    dispatch_semaphore_t _semaphore;
}
@end

@implementation HSKStorage

- (instancetype)initWithPath:(NSString *)path{
    if(!path) return nil;
    self = [super init];
    if(self){
        _path = path.copy;
        _semaphore = dispatch_semaphore_create(1);
        if(sqlite3_open(_path.UTF8String, &_db) == SQLITE_OK){
            static const char *sql = "create table if not exists hskStorage (key text primary key, value blob);";
            char *error = NULL;
            if(sqlite3_exec(_db, sql, NULL, NULL, &error) != SQLITE_OK){
                NSLog(@"失败");
            }
        }else{
            NSLog(@"失败");
        }
        sqlite3_close(_db);
    }
    return self;
}

- (BOOL)hsk_setObject:(id<NSCoding>)object forKey:(NSString *)key{
    if(!object) NO;
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    BOOL result = [self _setObject:object forKey:key];
    dispatch_semaphore_signal(_semaphore);
    return result;
}

- (BOOL)hsk_removeObjectForKey:(NSString *)key{
    if(!key) return NO;
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    BOOL result = [self _removeObjectForKey:key];
    dispatch_semaphore_signal(_semaphore);
    return result;
}

- (BOOL)hsk_removeObjectsForKeys:(NSArray<NSString *> *)keys{
    if(!keys) return NO;
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    BOOL result = [self _removeObjectsForKeys:keys];
    dispatch_semaphore_signal(_semaphore);
    return result;
}

- (BOOL)hsk_removeAllObjects{
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    BOOL result = [self _removeAllObjects];
    dispatch_semaphore_signal(_semaphore);
    return result;
}

- (BOOL)hsk_containsObjectForKey:(NSString *)key{
    if(!key) return NO;
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    BOOL result = [self _containsObjectForKey:key];
    dispatch_semaphore_signal(_semaphore);
    return result;
}

- (id<NSCoding>)hsk_objectForKey:(NSString *)key{
    if(!key) return nil;
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    id result = [self _objectForKey:key];
    dispatch_semaphore_signal(_semaphore);
    return result;
}

- (NSArray<id<NSCoding>> *)hsk_objectsForKeys:(NSArray<NSString *> *)keys{
    if(!keys) return nil;
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    NSArray *result = [self _objectsForKeys:keys];
    dispatch_semaphore_signal(_semaphore);
    return result;
}

- (NSArray<NSString *> *)allKeys{
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    NSArray *result = [self _allKeys];
    dispatch_semaphore_signal(_semaphore);
    return result;
}

- (NSArray<id<NSCoding>> *)allValues{
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    NSArray *result = [self _allValues];
    dispatch_semaphore_signal(_semaphore);
    return result;
}

- (NSUInteger)count{
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    NSUInteger result = [self _count];
    dispatch_semaphore_signal(_semaphore);
    return result;
}

- (BOOL)_openDB{
    if(sqlite3_open(_path.UTF8String, &_db) == SQLITE_OK){
        return YES;
    }
    NSLog(@"错误");
    return NO;
}

- (BOOL)_setObject:(id<NSCoding>)object forKey:(NSString *)key{
    BOOL result = NO;
    if([self _openDB]){
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
        static const char *sql = "insert or replace into hskStorage (key, value) values (?, ?);";
        sqlite3_stmt *stmt = NULL;
        if (sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL) == SQLITE_OK)  {
            sqlite3_bind_text(stmt, 1, key.UTF8String, -1, NULL);
            sqlite3_bind_blob(stmt, 2, data.bytes, (int)data.length, NULL);
            if(sqlite3_step(stmt) == SQLITE_DONE)  {
                result = YES;
            }
        }
        sqlite3_finalize(stmt);
        sqlite3_close(_db);
    }
    return result;
}

- (BOOL)_removeObjectForKey:(NSString *)key{
    BOOL result = NO;
    if([self _openDB]){
        static const char *sql = "delete from hskStorage where key = ?;";
        sqlite3_stmt *stmt = NULL;
        if (sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL) == SQLITE_OK) {
            sqlite3_bind_text(stmt, 1, key.UTF8String, -1, NULL);
            if(sqlite3_step(stmt) == SQLITE_DONE)  {
                result = YES;
            }
        }
        sqlite3_finalize(stmt);
        sqlite3_close(_db);
    }
    return result;
}

- (BOOL)_removeObjectsForKeys:(NSArray<NSString *> *)keys{
    BOOL result = NO;
    if([self _openDB]){
        NSString *key = [keys componentsJoinedByString:@","];
        NSString *sql = [NSString stringWithFormat:@"delete from hskStorage where key in (%@);", key];
        sqlite3_stmt *stmt = NULL;
        if (sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
            NSInteger count = keys.count;
            for (int i = 0; i < count; i++) {
                NSString *key = keys[i];
                sqlite3_bind_text(stmt, 1 + i, key.UTF8String, -1, NULL);
            }
            if(sqlite3_step(stmt) == SQLITE_DONE)  {
                result = YES;
            }
        }
        sqlite3_finalize(stmt);
        sqlite3_close(_db);
    }
    return result;
}

- (BOOL)_removeAllObjects{
    BOOL result = NO;
    if([self _openDB]){
        static const char *sql = "drop table if exists hskStorage;";
        char *error = NULL;
        if(sqlite3_exec(_db, sql, NULL, NULL, &error)){
            result = YES;
        }
        sqlite3_close(_db);
    }
    return result;
}

- (BOOL)_containsObjectForKey:(NSString *)key{
    BOOL result = NO;
    if([self _openDB]){
        static const char *sql = "select count(key) from hskStorage where key = ?;";
        sqlite3_stmt *stmt = NULL;
        if (sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL) == SQLITE_OK) {
            sqlite3_bind_text(stmt, 1, key.UTF8String, -1, NULL);
            if(sqlite3_step(stmt) == SQLITE_ROW)  {
                result = sqlite3_column_int(stmt, 0);
            }
        }
        sqlite3_finalize(stmt);
        sqlite3_close(_db);
    }
    return result;
}

- (id<NSCoding>)_objectForKey:(NSString *)key{
    id value = nil;
    if([self _openDB]){
        static const char *sql = "select value from hskStorage where key = ?;";
        sqlite3_stmt *stmt = NULL;
        if (sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL) == SQLITE_OK) {
            sqlite3_bind_text(stmt, 1, key.UTF8String, -1, NULL);
            if(sqlite3_step(stmt) == SQLITE_ROW)  {
                const void *bytes = sqlite3_column_blob(stmt, 0);
                int length = sqlite3_column_bytes(stmt, 0);
                NSData *data = [NSData dataWithBytes:bytes length:length];
                value = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            }
        }
        sqlite3_finalize(stmt);
        sqlite3_close(_db);
    }
    return value;
}

- (NSArray<id<NSCoding>> *)_objectsForKeys:(NSArray<NSString *> *)keys{
    id value = nil;
    if([self _openDB]){
        NSString *key = [keys componentsJoinedByString:@","];
        NSString *sql = [NSString stringWithFormat:@"select value from hskStorage where key in (%@);", key];
        sqlite3_stmt *stmt = NULL;
        if (sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
            NSInteger count = keys.count;
            for (int i = 0; i < count; i++) {
                NSString *key = keys[i];
                sqlite3_bind_text(stmt, 1 + i, key.UTF8String, -1, NULL);
            }
            NSMutableArray *values = [NSMutableArray array];
            while (YES) {
                if(sqlite3_step(stmt) == SQLITE_ROW)  {
                    const void *bytes = sqlite3_column_blob(stmt, 0);
                    int length = sqlite3_column_bytes(stmt, 0);
                    NSData *data = [NSData dataWithBytes:bytes length:length];
                    id item = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    [values addObject:item];
                }else{
                    break;
                }
            }
            value = values.copy;
        }
        sqlite3_finalize(stmt);
        sqlite3_close(_db);
    }
    return value;
}

- (NSArray<NSString *> *)_allKeys{
    id value = nil;
    if([self _openDB]){
        static const char *sql = "select key from hskStorage;";
        sqlite3_stmt *stmt = NULL;
        if (sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL) == SQLITE_OK) {
            NSMutableArray *keys = [NSMutableArray array];
            while (YES) {
                if(sqlite3_step(stmt) == SQLITE_ROW)  {
                    const char *key = (char *)sqlite3_column_text(stmt, 0);
                    [keys addObject:[NSString stringWithUTF8String:key]];
                }else{
                    break;
                }
            }
            value = keys.copy;
        }
        sqlite3_finalize(stmt);
        sqlite3_close(_db);
    }
    return value;
}

- (NSArray<id<NSCoding>> *)_allValues{
    id value = nil;
    if([self _openDB]){
        static const char *sql = "select value from hskStorage;";
        sqlite3_stmt *stmt = NULL;
        if (sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL) == SQLITE_OK) {
            NSMutableArray *values = [NSMutableArray array];
            while (YES) {
                if(sqlite3_step(stmt) == SQLITE_ROW)  {
                    const void *bytes = sqlite3_column_blob(stmt, 0);
                    int length = sqlite3_column_bytes(stmt, 0);
                    NSData *data = [NSData dataWithBytes:bytes length:length];
                    id item = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    [values addObject:item];
                }else{
                    break;
                }
            }
            value = values.copy;
        }
        sqlite3_finalize(stmt);
        sqlite3_close(_db);
    }
    return value;
}

- (NSUInteger)_count{
    int result = 0;
    if([self _openDB]){
        static const char *sql = "select count(*) from hskStorage;";
        sqlite3_stmt *stmt = NULL;
        if (sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL) == SQLITE_OK) {
            if(sqlite3_step(stmt) == SQLITE_ROW)  {
                result = sqlite3_column_int(stmt, 0);
            }
        }
        sqlite3_finalize(stmt);
        sqlite3_close(_db);
    }
    return result;
}
@end
