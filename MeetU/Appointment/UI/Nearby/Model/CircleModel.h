//
//  CircleModel.h
//  Appointment
//
//  Created by feiwu on 2017/2/7.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXBaseModel.h"

@interface CircleModel : WXBaseModel

//@property(nonatomic,strong)NSDictionary *author;//作者信息age 23; avatar https://******.jpg; is_vip 0; mid 110027244; nickname 夏天; publish_id 110027244; sex 0
@property(nonatomic,copy)NSString *content;//内容
@property(nonatomic,copy)NSString *from;//发布人
@property(nonatomic,copy)NSString *comment_id;//文章id
@property(nonatomic,copy)NSString *publish_id;//发表者id
@property(nonatomic,copy)NSString *hits_count;//浏览数量
@property(nonatomic,copy)NSString *like_count;//点赞数量
@property(nonatomic,copy)NSString *isLike;//0没有点赞 1已经点赞
@property(nonatomic,copy)NSString *past_time;//发布时间
@property(nonatomic,copy)NSString *comment_count;//评论总数
@property(nonatomic,copy)NSString *dashang_num;//打赏人数
@property(nonatomic,copy)NSString *avatar;//评论者头像
@property(nonatomic,copy)NSString *nickname;//评论者头像
@property(nonatomic,strong)NSMutableArray *pics_url;//图片数组"id": 图片id,"url":蒙版图 ori_url：原图 ,"price": 价格,"status": 1已付费 0未付费
@property(nonatomic,strong)NSMutableArray *comment_list;//count,评论个数 list[{id,评论id moment_id，评论文章id  mid,评论人id to_mid，文章发布人id  nickname,评论人昵称  avatar,评论人头像  sex，评论人性别   create_time，评论时间 content评论内容   status，评论状态1已审核，0未审核  is_visible，所有人可见，0为仅评论人自己可见}]
@property(nonatomic,strong)NSMutableArray *dashang_list;






@end
