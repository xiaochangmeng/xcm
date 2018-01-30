//
//  MyGetInfoApi.h
//  Appointment
//
//  Created by feiwu on 16/7/19.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "BaseRequest.h"

@interface MySetDetailInfoApi : BaseRequest
- (id)initWithYear:(NSString *)year Month:(NSString *)month Day:(NSString *)day Province:(NSString *)province Height:(NSString *)height Weight:(NSString *)weight Blood:(NSString *)blood NickName:(NSString *)nickname   Education:(NSString *)education Job:(NSString *)job Income:(NSString *)income   FdPurpose:(NSString *)fd_purpose LoveSense:(NSString *)love_sense FtExpection:(NSString *)ft_expection DataPlace:(NSString *)data_place  hobby:(NSString *)hobby Character:(NSString *)character;
@end
