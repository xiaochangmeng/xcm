//
//  AuthenticationEntity.m
//  Appointment
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "AuthenticationEntity.h"

@implementation AuthenticationEntity
- (instancetype)initWithImageViewName:(NSString *)imageName typeTitle:(NSString *)typeTitle starCount:(NSString*)starCount buttonTitle:(NSString *)buttonTitle{
    if (self = [super init]) {
        _authenticationImageViewName = imageName;
        _authenticationTypeTitle = typeTitle;
        _authenticationStarCount = [self setTextAttributed:starCount];
        _authenticationButtonTitle = buttonTitle;
    }
    return self;
}

- (NSAttributedString*)setTextAttributed:(NSString*)string{
    //设置字符串颜色
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:Color10(153, 153, 153, 1) range:NSMakeRange(0, string.length)];
    return attributedString;
}


@end
