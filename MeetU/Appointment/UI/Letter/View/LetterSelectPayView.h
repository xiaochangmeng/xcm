//
//  LetterSelectPayView.h
//  Appointment
//
//  Created by feiwu on 16/10/9.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^LetterSelectPayBlock)(NSInteger typeIndex);
@interface LetterSelectPayView : UIView
/**半透明背景 */
@property (strong, nonatomic) UIView* alphaView;
@property (strong, nonatomic) UIImageView* backgroundImageView;
@property (strong, nonatomic) UIButton* payButton;//支付button
@property (strong, nonatomic) UIButton* writerYearButton;//包年button
@property (strong, nonatomic) UIButton* writerThreeMonButton;//包三个月button
@property (strong, nonatomic) UIButton* writerOneMonButton;//包一个月button
@property (assign, nonatomic) NSInteger productIndex;//选中套餐
@property (copy, nonatomic) LetterSelectPayBlock LetterSelectPayBlock;

@end
