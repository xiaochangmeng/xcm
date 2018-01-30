//
//  ConditionButton.h
//  Appointment
//
//  Created by feiwu on 16/7/14.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ConditionBlock) ();
@interface ConditionButton : UIButton
@property(nonatomic,strong)UILabel *typeLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIImageView *arrowImageView;
@property(nonatomic,strong)UIView *lineView;

@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)ConditionBlock conditionBlock;
- (id)initWithTitle:(NSString *)title;
@end
