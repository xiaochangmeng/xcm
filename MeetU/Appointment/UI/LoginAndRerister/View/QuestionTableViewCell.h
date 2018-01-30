//
//  QuestionTableViewCell.h
//  Appointment
//
//  Created by feiwu on 16/7/15.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface QuestionTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *userImageView;//头像
@property(nonatomic,strong)UILabel *tipLabel;//提示
@property(nonatomic,strong)UILabel *pageLabel;//页码
@property(nonatomic,strong)UIButton *questionButton;//问题
@property(nonatomic,strong)UIButton *cancelButton;//跳过
@property(nonatomic,strong)UILabel *questionLabel;//问题label
@property(nonatomic,strong)UIView *topLineView;
@property(nonatomic,strong)UIView *bottomLineView;

@property(nonatomic,strong)NSDictionary *questionDic;//数据
@property(nonatomic,strong)NSMutableArray *reuseArray;//结果
@property(nonatomic,strong)NSMutableDictionary *infoDic;//設置信息
@end
