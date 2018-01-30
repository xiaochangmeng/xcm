//
//  FateUserModel.h
//  Appointment
//
//  Created by feiwu on 16/7/21.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXBaseModel.h"
@interface FateUserModel : WXBaseModel
@property(nonatomic,copy)NSString *age;//年龄
@property(nonatomic,copy)NSString *blood_type;//血型
@property(nonatomic,copy)NSString *constellation;//星座
@property(nonatomic,copy)NSString *flag_attention;//关注数
@property(nonatomic,copy)NSString *flag_black;//拉黑数
@property(nonatomic,copy)NSString *flag_vip;//是否是vip
@property(nonatomic,copy)NSString *flag_write_monthly;//是否写信包月
@property(nonatomic,copy)NSString *helloed;//当天是否打招呼(0没有打招呼 2已打招呼)

@property(nonatomic,copy)NSString *avatar;//头像(高清)
@property(nonatomic,copy)NSString *img_deal;//头像(压缩版)
@property(nonatomic,copy)NSString *occupation;//工作
@property(nonatomic,copy)NSString *user_id;//用户id
@property(nonatomic,copy)NSString *next_user_id;//下一个用户id
@property(nonatomic,copy)NSString *name;//昵称

@property(nonatomic,copy)NSString *province;//省份
@property(nonatomic,copy)NSString *sex;//性别
@property(nonatomic,copy)NSString *weight;//体重
@property(nonatomic,copy)NSString *height;//身高
@property(nonatomic,copy)NSString *voice_length;//语音介绍时长
@property(nonatomic,copy)NSString *voice_size;//语音大小
@property(nonatomic,copy)NSString *voice_url;//语音url
@property(nonatomic,copy)NSString *online_content;//在线状态
@property(nonatomic,copy)NSString *love_place;//爱爱地点
@property(nonatomic,copy)NSString *first_meeting_hope;//首次见面希望
@property(nonatomic,copy)NSString *love_concept;//恋爱观念
@property(nonatomic,copy)NSString *making_friends;//交友目的
@property(nonatomic,copy)NSString *monthly_income;//收入
@property(nonatomic,copy)NSString *partner_age;//征友年龄
@property(nonatomic,copy)NSString *partner_height;//征友身高
@property(nonatomic,copy)NSString *partner_province;//征友地区
@property(nonatomic,copy)NSString *education;//学历
@property(nonatomic,copy)NSString *hobby;//爱好
@property(nonatomic,copy)NSString *features;//性格
@property(nonatomic,copy)NSString *region_name;
@property(nonatomic,copy)NSString *attention_me_num;//关注我的人数


@property(nonatomic,strong)NSMutableArray *original_photos;
@property(nonatomic,strong)NSMutableArray *photos;//相册(高清)
@property(nonatomic,strong)NSMutableArray *photos_deal;//相册(压缩)
@end
