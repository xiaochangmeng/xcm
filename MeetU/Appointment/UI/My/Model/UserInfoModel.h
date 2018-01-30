//
//  UserInfoModel.h
//  Appointment
//
//  Created by feiwu on 16/7/19.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXBaseModel.h"
@interface UserInfoModel : WXBaseModel

//基本信息
@property(nonatomic,copy)NSString *age;//年龄
@property(nonatomic,copy)NSString *birth_day;//日
@property(nonatomic,copy)NSString *birth_month;//月
@property(nonatomic,copy)NSString *birth_year;//年
@property(nonatomic,copy)NSString *blood_type;//血型 1:A 2:B 3:AB 4:O'
@property(nonatomic,copy)NSString *height;//身高
@property(nonatomic,copy)NSString *name;//昵称
@property(nonatomic,copy)NSString *city;//省份
@property(nonatomic,copy)NSString *weight;//体重
@property(nonatomic,copy)NSString *ios_vip;//是否是VIP
@property(nonatomic,copy)NSString *ios_tell;//是否是包月会员
@property(nonatomic,copy)NSString *avatar;//头像
@property(nonatomic,copy)NSString *user_id;//membr_id
@property(nonatomic,copy)NSString *voice_length;//语音介绍时长
@property(nonatomic,copy)NSString *voice_size;//语音大小
@property(nonatomic,copy)NSString *voice_url;//语音url
@property(nonatomic,copy)NSString *me_attention_num;//我的关注
@property(nonatomic,copy)NSString *lately_visitor_num;//最近访客

//详细信息

@property(nonatomic,copy)NSString *education;//学历 1:初中及以下 2:高中及中专 3:大专 4:本科 5:硕士及以上
@property(nonatomic,copy)NSString *monthly_income;//收入
@property(nonatomic,copy)NSString *occupation;//职业

@property(nonatomic,copy)NSString *love_place;//爱爱地点
@property(nonatomic,copy)NSString *first_meeting_hope;//首次见面希望
@property(nonatomic,copy)NSString *love_concept;//恋爱观念
@property(nonatomic,copy)NSString *making_friends;//交友目的



//兴趣爱好
@property(nonatomic,strong)NSMutableArray *albums_original;//未经处理相册
@property(nonatomic,strong)NSMutableArray *albums;//已处理相册
@property(nonatomic,strong)NSMutableArray *albums_urlencode;//删除相册参数
@property(nonatomic,strong)NSMutableArray *hobby;//爱好
@property(nonatomic,strong)NSMutableArray *features;//兴趣

@end
