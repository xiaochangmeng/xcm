//
//  SBUserInformation.h
//  HUD
//
//  Created by apple on 16/7/29.
//  Copyright © 2016年 yuhy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWUserInformation : NSObject<NSCoding>

/**实例化对象 */
+ (instancetype)sharedInstance;

/**保存用户信息 */
- (void)saveUserInformation;
/**删除用户信息 */
- (void)deleteUserInformation;

/**token */
@property (copy, nonatomic) NSString* token;
/**用户mid */
@property (copy, nonatomic) NSString* mid;

/**用户性别  1男  0女*/
@property (copy, nonatomic) NSString* sex;
/**用户年龄 */
@property (copy, nonatomic) NSString* age;

/**渠道 */
@property (copy, nonatomic) NSString* ditch;

/**国家 */
@property (copy, nonatomic) NSString* country;

/**省 */
@property (copy, nonatomic) NSString* province;

/**市 */
@property (copy, nonatomic) NSString* city;

/**我的关注数量 */
@property (copy, nonatomic) NSString* addentionCount;

/**资料百分百 */
@property (strong, nonatomic) NSString* percent;
/**广告标识符 */
@property (strong, nonatomic) NSString* idfa;

/**语言+地区（用来国际化区分） */
@property (copy, nonatomic) NSString* globalizationStr;

/** VIP等级 */
@property (nonatomic, copy) NSString *vip_grade;//VIP等级 10写信，20普通vip，30写信+普通vip，80钻石vip
/** 是否开通了vip会员 */
@property(nonatomic, copy) NSString *vip_tell;

@end
