//
//  AppDelegate+Globalization.h
//  taiwantongcheng
//
//  Created by wangjian on 2017/8/30.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Globalization)

/**
 切换国际化语言测试
 */
-(void)changeLanguage;


/**
 获取语言国家。  例如：zh_ch
 */
-(void)getLanguageAndCountry;

@end
