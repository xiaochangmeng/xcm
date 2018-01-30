//
//  CircleButton.h
//  Appointment
//
//  Created by feiwu on 2017/2/5.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CircleButtonBlock) ();
@interface CircleButton : UIButton
@property(nonatomic,strong)UIImageView *typeImageView;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,copy)CircleButtonBlock circleBlock;

- (id)initWithTitle:(NSString *)title TypeImage:(NSString *)typeimage;

@end
