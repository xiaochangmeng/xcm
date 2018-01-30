//
//  FUActionSheet.h
//  Created by feiwu on 16/7/20.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonBlock)(int);

@interface MZYActionSheet : UIView

@property (strong, nonatomic)  UIButton *cancelButton;
@property (strong, nonatomic) UIButton *otherTitleButton;
@property (strong, nonatomic) UIColor *titleColor;

@property (nonatomic,copy)ButtonBlock buttonBlock;

- (void)setTitle:(NSString *)title otherButtonTitle:(NSArray *)other;
- (void)setTitle:(NSString *)title titleColor:(UIColor *)titleColor otherButtonTitle:(NSArray *)other otherTitleColor:(NSArray *)color;
@end
