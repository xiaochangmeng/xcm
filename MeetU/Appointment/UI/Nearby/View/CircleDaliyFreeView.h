//
//  CircleDaliyFreeView.h
//  Appointment
//
//  Created by feiwu on 2017/3/2.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DaliySeePhotoFreeOnceBlock) (NSString *index);
@interface CircleDaliyFreeView : UIView
@property (strong, nonatomic) UIView* alphaView;/**半透明背景 */
@property (strong, nonatomic) UIImageView* loginImageView;//背景图
@property (strong, nonatomic) UIButton* getKeyButton;//使用钥匙
@property (strong, nonatomic) UIButton* cancleButton;//取消
@property (copy, nonatomic) DaliySeePhotoFreeOnceBlock seePhotoBlock;//使用钥匙

- (instancetype)initWithFrame:(CGRect)frame Index:(NSString *)index; //初始化方法

@end
