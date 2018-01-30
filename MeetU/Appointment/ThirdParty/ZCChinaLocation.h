//
//  ZCChinaLocation.h
//  ZCChinaLocation
//
//  Created by cuibo on 5/12/15.
//  Copyright (c) 2015 cuibo. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@interface ZCChinaLocation : NSObject

//单例
+ (instancetype)shared;

//判断location是否在中国
- (BOOL)isInsideChina:(CLLocationCoordinate2D)location;

@end
