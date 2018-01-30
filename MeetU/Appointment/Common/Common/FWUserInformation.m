//
//  SBUserInformation.m
//  HUD
//
//  Created by apple on 16/7/29.
//  Copyright © 2016年 yuhy. All rights reserved.
//

#import "FWUserInformation.h"
#import "LXFileManager.h"
#define USERINFORMATION_KEY @"fwuserinformation"
@implementation FWUserInformation
+ (instancetype)sharedInstance{
    static FWUserInformation *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    
    //获取到序列化的数据
    NSData* data =  [LXFileManager readUserDataForKey:USERINFORMATION_KEY];;
    
    if (nil != data) {//
        //反序列化
        FWUserInformation* information = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        /**userId */
        sharedInstance.mid = information.mid;
        /**用户性别 */
        sharedInstance.sex = information.sex;
        /**用户年龄 */
        sharedInstance.age = information.age;
        
        /**渠道 */
        sharedInstance.ditch = information.ditch;
        /**我的关注数量 */
        sharedInstance.addentionCount = information.addentionCount;
        /**资料百分百 */
        sharedInstance.percent = information.percent;
        /**广告标识符 */
        sharedInstance.idfa = information.idfa;
        /**token */
        sharedInstance.token = information.token;
        /**国家 */
        sharedInstance.country = information.country;
        /**省 */
        sharedInstance.province = information.province;
        /**市 */
        sharedInstance.city = information.city;
        
        sharedInstance.vip_tell = information.vip_tell;
    }
    return sharedInstance;
}

-(void)setCountry:(NSString *)country{
    _country=country;
    [LXFileManager saveUserData:country forKey:@"country"];
}


#pragma mark - 存储数据
- (void)saveUserInformation{
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [LXFileManager saveUserData:data forKey:USERINFORMATION_KEY];
}

#pragma mark - 删除数据
- (void)deleteUserInformation{
    [LXFileManager removeUserDataForkey:USERINFORMATION_KEY];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        /**userId */
        self.mid = [aDecoder decodeObjectForKey:@"mid"];
        /**用户性别 */
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        /**用户年龄 */
        self.age = [aDecoder decodeObjectForKey:@"age"];
        /**渠道 */
        self.ditch = [aDecoder decodeObjectForKey:@"ditch"];
        /**我的关注数量 */
        self.addentionCount = [aDecoder decodeObjectForKey:@"addentionCount"];
        /**资料百分比 */
        self.percent = [aDecoder decodeObjectForKey:@"percent"];
        /**广告标识符 */
        self.idfa = [aDecoder decodeObjectForKey:@"idfa"];
        /**token */
        self.token = [aDecoder decodeObjectForKey:@"token"];
        /**country */
        self.country = [aDecoder decodeObjectForKey:@"country"];
        /**city */
        self.province = [aDecoder decodeObjectForKey:@"province"];
        /**city */
        self.city = [aDecoder decodeObjectForKey:@"city"];
        /**vip_tell */
        self.vip_tell = [aDecoder decodeObjectForKey:@"vip_tell"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    /**userId */
    [aCoder encodeObject:self.mid forKey:@"mid"];
    /**用户性别 */
    [aCoder encodeObject:self.sex forKey:@"sex"];
    /**用户年龄 */
    [aCoder encodeObject:self.age forKey:@"age"];
    /**渠道 */
    [aCoder encodeObject:self.ditch forKey:@"ditch"];
    /**我的关注数量 */
    [aCoder encodeObject:self.addentionCount forKey:@"addentionCount"];
    /**资料百分比 */
    [aCoder encodeObject:self.percent forKey:@"percent"];
    /**广告标识符 */
    [aCoder encodeObject:self.idfa forKey:@"idfa"];
    /**token */
    [aCoder encodeObject:self.token forKey:@"token"];
    /**country */
    [aCoder encodeObject:self.country forKey:@"country"];
    /**province */
    [aCoder encodeObject:self.province forKey:@"province"];
    /**city */
    [aCoder encodeObject:self.city forKey:@"city"];
    /**city */
    [aCoder encodeObject:self.vip_tell forKey:@"vip_tell"];
}

@end
