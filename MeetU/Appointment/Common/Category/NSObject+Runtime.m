//
//  NSObject+DateBaseModel.m
//  Appointment
//  Created by feiwu on 16/7/12.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.

#import <objc/runtime.h>

@implementation NSObject (Runtime)

- (NSDictionary *)propertiesDic {
    
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
    
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
                  id propertyValue = [self valueForKey:(NSString *)propertyName];
            
            if (propertyValue){
                [props setObject:propertyValue forKey:propertyName];
            }else{
                [props setObject:@"" forKey:propertyName];
            }

        
    }
    
    free(properties);
    return props;
    // return [self dictionaryWithValuesForKeys:[self propertyNames]];；-(NSMutableArray*)proper；unsignedintoutCount,i;；objc_property_t*properti；NSMutableArray*propertyN；for(i=0;i<outCount;i+；objc_property_tproperty=；NSString*properpropertyNames]];
    
}

@end