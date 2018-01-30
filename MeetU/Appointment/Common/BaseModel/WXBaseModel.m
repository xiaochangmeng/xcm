//
//  WXBaseModel.m
//  Appointment
//  Created by feiwu on 16/7/12.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.



#import "WXBaseModel.h"
#import "NSObject+Runtime.h"

@implementation WXBaseModel

-(id)initWithDataDic:(NSDictionary*)data{
	if (self = [super init]) {
		[self setAttributes:data];
	}
	return self;
}

-(NSDictionary*)attributeMapDictionary{
	return nil;
}

-(SEL)getSetterSelWithAttibuteName:(NSString*)attributeName{
	NSString *capital = [[attributeName substringToIndex:1] uppercaseString];
	NSString *setterSelStr = [NSString stringWithFormat:@"set%@%@:",capital,[attributeName substringFromIndex:1]];
	return NSSelectorFromString(setterSelStr);
}

- (NSString *)customDescription{
	return nil;
}

- (NSString *)description{
	NSMutableString *attrsDesc = [NSMutableString stringWithCapacity:100];
	NSDictionary *attrMapDic = [self attributeMapDictionary];
	NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
	id attributeName;
	
	while ((attributeName = [keyEnum nextObject])) {
		SEL getSel = NSSelectorFromString(attributeName);   
		if ([self respondsToSelector:getSel]) {
			NSMethodSignature *signature = nil;
			signature = [self methodSignatureForSelector:getSel];
			NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
			[invocation setTarget:self];
			[invocation setSelector:getSel];
			NSObject *valueObj = nil;
			[invocation invoke];
			[invocation getReturnValue:&valueObj];
//            ITTDINFO(@"attributeName %@ value %@", attributeName, valueObj);
			if (valueObj) {
				[attrsDesc appendFormat:@" [%@=%@] ",attributeName, valueObj];		
				//[valueObj release];			
			}else {
				[attrsDesc appendFormat:@" [%@=nil] ",attributeName];		
			}
			
		}
	}
	
	NSString *customDesc = [self customDescription];
	NSString *desc;
	
	if (customDesc && [customDesc length] > 0 ) {
		desc = [NSString stringWithFormat:@"%@:{%@,%@}",[self class],attrsDesc,customDesc];
	}else {		
		desc = [NSString stringWithFormat:@"%@:{%@}",[self class],attrsDesc];
	}
    
	return desc;
}

-(void)setAttributes:(NSDictionary*)dataDic{
	NSDictionary *attrMapDic = [self attributeMapDictionary];
	if (attrMapDic == nil) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[dataDic count]];
        for (NSString *key in dataDic) {
            [dic setValue:key forKey:key];
            attrMapDic = dic;
        }
	}
	NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
	id attributeName;
	while ((attributeName = [keyEnum nextObject])) {
		SEL sel = [self getSetterSelWithAttibuteName:attributeName];
		if ([self respondsToSelector:sel]) {
			NSString *dataDicKey = [attrMapDic objectForKey:attributeName];
//            NSLog(@"%@",dataDicKey);
            id attributeValue = [dataDic objectForKey:dataDicKey];

            if (attributeValue == nil) {
//                if ([attributeName isEqualToString:@"body"]) {
//                    continue;
//                }
                attributeValue = @"";
            }
            
            
            if ((NSNull *)attributeValue == [NSNull null]) {
                attributeValue = @"";
            }else{
                if ([attributeValue isKindOfClass:[NSNumber class]]) {
//                      LogBlue(@"%@",attributeValue)
                    attributeValue = [NSString stringWithFormat:@"%@",attributeValue];

                    
                    
//                    attributeValue = [[[NSNumberFormatter alloc] init] stringForObjectValue:attributeValue];
                }
                
            }
            
            
			[self performSelectorOnMainThread:sel 
                                   withObject:attributeValue 
                                waitUntilDone:[NSThread isMainThread]];		
		}
	}
}

- (id)initWithCoder:(NSCoder *)decoder{
	if( self = [super init] ){
		NSDictionary *attrMapDic = [self attributeMapDictionary];
		if (attrMapDic == nil) {
			return self;
		}
		NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
		id attributeName;
		while ((attributeName = [keyEnum nextObject])) {
			SEL sel = [self getSetterSelWithAttibuteName:attributeName];
			if ([self respondsToSelector:sel]) {
				id obj = [decoder decodeObjectForKey:attributeName];
				[self performSelectorOnMainThread:sel 
                                       withObject:obj
                                    waitUntilDone:[NSThread isMainThread]];
			}
		}
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
	NSDictionary *attrMapDic = [self attributeMapDictionary];
	if (attrMapDic == nil) {
		return;
	}
	NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
	id attributeName;
	while ((attributeName = [keyEnum nextObject])) {
		SEL getSel = NSSelectorFromString(attributeName);
		if ([self respondsToSelector:getSel]) {
			NSMethodSignature *signature = nil;
			signature = [self methodSignatureForSelector:getSel];
			NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
			[invocation setTarget:self];
			[invocation setSelector:getSel];
			NSObject *valueObj = nil;
			[invocation invoke];
			[invocation getReturnValue:&valueObj];
			
			if (valueObj) {
				[encoder encodeObject:valueObj forKey:attributeName];	
			}
		}
	}
}
- (NSData*)getArchivedData{
	return [NSKeyedArchiver archivedDataWithRootObject:self];
}

- (NSString *)cleanString:(NSString *)str {
    if (str == nil) {
        return @"";
    }
    NSMutableString *cleanString = [NSMutableString stringWithString:str];
    [cleanString replaceOccurrencesOfString:@"\n" withString:@"" 
                                    options:NSCaseInsensitiveSearch 
                                      range:NSMakeRange(0, [cleanString length])];
    [cleanString replaceOccurrencesOfString:@"\r" withString:@"" 
                                    options:NSCaseInsensitiveSearch 
                                      range:NSMakeRange(0, [cleanString length])];    
    return cleanString;
}

- (void)replaceNilAttribute:(NSArray *)exceptionArray{
    
    NSDictionary *attrDic =  [self propertiesDic];
    NSEnumerator *keyEnum = [attrDic keyEnumerator];
    id keyName;
    if (exceptionArray) {
         while (keyName = [keyEnum nextObject]) {
             for (NSString *proName in exceptionArray) {
                 if (![keyName isEqualToString:proName]) {
                     NSString *value =(NSString *)[attrDic objectForKey:keyName];
                     if ([value isEqualToString:@""]) {
                         SEL sel = [self getSetterSelWithAttibuteName:keyName];
                         [self performSelectorOnMainThread:sel
                                                withObject:value
                                             waitUntilDone:[NSThread isMainThread]];
                     }
                 }
             }
         }
    }else{
        while (keyName = [keyEnum nextObject]) {
            if ([[attrDic objectForKey:keyName] isKindOfClass:[NSString class]]) {
                NSString *value =(NSString *)[attrDic objectForKey:keyName];
                if ([value isEqualToString:@""]) {
                    SEL sel = [self getSetterSelWithAttibuteName:keyName];
                    [self performSelectorOnMainThread:sel
                                           withObject:value
                                        waitUntilDone:[NSThread isMainThread]];
                }

            }
        }

    }
   }

//- (id)autocopyAttrbuteValue:(id)targetObj{
//    NSDictionary *sourceAttrDic =  [self propertiesDic];
//    NSDictionary *targetAttrDic =  [targetObj propertiesDic];
//    
//    NSEnumerator *sourceKeyEnum = [sourceAttrDic keyEnumerator];
//    NSEnumerator *targetKeyEnum = [targetAttrDic keyEnumerator];
//    
//    id sourceKeyName;
//    id targetKeyName;
//    while (targetKeyName = [targetKeyEnum nextObject]) {
//         while (sourceKeyName = [sourceKeyEnum nextObject]) {
//             if ([targetKeyName isEqualToString:sourceKeyName] && ![targetKeyName isEqualToString:@"db_id"]) {
//                 SEL sel = [targetObj getSetterSelWithAttibuteName:targetKeyName];
//                 if ([self respondsToSelector:sel]) {
//                     id attributeValue = [sourceAttrDic objectForKey:targetKeyName];
//                     NSLog(@"%@",attributeValue);
////                     id attributeValue = [dataDic objectForKey:dataDicKey];
//                     [self performSelectorOnMainThread:sel
//                                            withObject:attributeValue 
//                                         waitUntilDone:[NSThread isMainThread]];		
//                 }
//             }
//         }
//    }
//    
//    return targetObj;
//    
//}

#ifdef _FOR_DEBUG_  
-(BOOL) respondsToSelector:(SEL)aSelector {  
//    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);  
    return [super respondsToSelector:aSelector];  
}  
#endif

@end
