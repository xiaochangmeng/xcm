//
//  FateModel.h
//  Appointment
//
//  Created by feiwu on 16/7/14.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXBaseModel.h"
@interface FateModel : WXBaseModel
@property(nonatomic,copy)NSString *age;//年龄
@property(nonatomic,copy)NSString *features;//性格
@property(nonatomic,copy)NSString *region_name;//城市
@property(nonatomic,copy)NSString *height;//身高
@property(nonatomic,copy)NSString *helloed;//当天是否打招呼(0没有打招呼 2已打招呼)
@property(nonatomic,copy)NSString *hobby;//嗜好
@property(nonatomic,copy)NSString *img;//头像(高清)
@property(nonatomic,copy)NSString *img_deal;//头像(压缩版)
@property(nonatomic,copy)NSString *user_id;
@property(nonatomic,copy)NSString *name;//昵称
@property(nonatomic,copy)NSString *province;//省份
@property(nonatomic,copy)NSString *distance;//距离
@property(nonatomic,copy)NSString *datetime;//时间
@property(nonatomic,copy)NSString *status;//私信状态
@property(nonatomic,copy)NSString *photo_nums;//图片数目
@property(nonatomic,copy)NSString *tag1;
@property(nonatomic,copy)NSString *tag2;
@property(nonatomic,copy)NSString *visitor_num;//最近访客数目
@property(nonatomic,copy)NSString *highlight;//是否显示心形动画
@property(nonatomic,copy)NSString *income;//收入
@property(nonatomic,copy)NSString *content;//最新消息
@property(nonatomic,copy)NSString *sex;//性别
@property(nonatomic,copy)NSString *flag_vip;//vip
@property(nonatomic,copy)NSString *receive_id;//接受id
@property(nonatomic,copy)NSString *send_id;//发送id
@property(nonatomic,copy)NSString *time;//接收时间
@property(nonatomic,copy)NSString *city;//城市
@end
