//
//  FateDetailRechargeMaskView.h
//  Appointment
//
//  Created by apple on 16/9/26.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^FateDetailRechargeMaskViewHelloButton)();
@interface FateDetailRechargeMaskView : UIView
/**半透明背景 */
@property (strong, nonatomic) UIView* alphaView;
@property (strong, nonatomic) UIImageView* rechargeImageView;
@property (strong, nonatomic) UIButton* rechargeButton;
@property (strong, nonatomic) UIButton* helloButton;
@property (copy, nonatomic) FateDetailRechargeMaskViewHelloButton fateDetailRechargeMaskViewHelloButton;
@end
