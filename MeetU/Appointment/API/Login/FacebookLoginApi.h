//
//  FacebookLoginApi.h
//  taiwantongcheng
//
//  Created by feiwu on 2016/11/25.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "BaseRequest.h"

@interface FacebookLoginApi : BaseRequest
- (id)initWithUser_id:(NSString *)user_id Nickname:(NSString *)nickname Sex:(NSString *)sex Photo:(NSString *)photo Age:(NSString *)age Third_id:(NSString *)third_id Locale:(NSString *)locale Tag:(NSString *)tag;

@end
