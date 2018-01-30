//
//  LetterRecordModel.h
//  Appointment
//
//  Created by feiwu on 16/7/20.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXBaseModel.h"
@interface LetterRecordModel : WXBaseModel
@property(nonatomic,copy)NSString *content;//内容
@property(nonatomic,copy)NSString *avatar;//头像
@property(nonatomic,copy)NSString *showtime;//发送时间
@property(nonatomic,copy)NSString *tag;//1我的文本，2她的文本；3我的音频，4她的音频；5回答列表 7图片
@property(nonatomic,copy)NSString *time;

@end
