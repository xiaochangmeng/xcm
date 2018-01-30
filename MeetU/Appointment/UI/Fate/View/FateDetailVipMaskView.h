//
//  FateDetailVipMaskView.h
//  Appointment
//
//  Created by feiwu on 2016/11/1.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface FateDetailVipMaskView : UIView
/**半透明背景 */
@property (strong, nonatomic) UIView* alphaView;
@property (strong, nonatomic) UIImageView* rechargeImageView;//背景图
@property (strong, nonatomic) UIButton* rechargeButton;//支付

@property (strong, nonatomic) UILabel* titleLabel;//标题
@property (strong, nonatomic) NSString* title;
- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title;//初始化方法
@end
