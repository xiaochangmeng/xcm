//
//  CircleCommnetModel.h
//  Appointment
//
//  Created by feiwu on 2017/2/10.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXBaseModel.h"
@interface CircleCommnetModel : WXBaseModel
@property(nonatomic,copy)NSString *content;//内容
@property(nonatomic,copy)NSString *avatar;//头像
@property(nonatomic,copy)NSString *moment_id;//文章id
@property(nonatomic,copy)NSString *create_time;//发布时间
@property(nonatomic,copy)NSString *to_mid;//发布人id
@property(nonatomic,copy)NSString *mid;//评论人id
@property(nonatomic,copy)NSString *sex;//性别
@property(nonatomic,copy)NSString *nickname;//昵称
@property(nonatomic,copy)NSString *vip_grade;//VIP等级 10写信，20普通vip，30写信+普通vip，80钻石vip
@end
