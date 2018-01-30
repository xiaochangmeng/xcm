//
//  CirclePhotoPayMaskView.h
//  Appointment
//
//  Created by feiwu on 2017/2/13.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleModel.h"
typedef void(^VIPSeePhotoBlock) (NSDictionary *dic);
@interface CirclePhotoPayMaskView : UIView
@property (strong, nonatomic) UIView* alphaView;//底部黑色背景
@property (strong, nonatomic) UIImageView* rechargeImageView;//背景图
@property(nonatomic,strong)UIImageView *userImageView;//头像
@property (strong, nonatomic) UILabel* priceLabel;//价格
@property (nonatomic, strong) UIButton *cancleButton;//取消按钮
@property (nonatomic, strong) UIButton *weixinButton;//微信
@property (nonatomic, strong) UIButton *alipayButton;//支付宝
@property (nonatomic, strong) UIButton *payButton;//立即支付
@property (nonatomic, strong) UIButton *vipButton;//钻石VIP查看
@property (copy, nonatomic) VIPSeePhotoBlock vipBlock;//钻石VIP

- (instancetype)initWithFrame:(CGRect)frame  CircleModel:(CircleModel *)model  IndexPath:(NSIndexPath *)indexPath Index:(NSString *)index;//初始化方法

@end
