//
//  AppDelegate+Globalization.m
//  taiwantongcheng
//
//  Created by wangjian on 2017/8/30.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "AppDelegate+Globalization.h"

@implementation AppDelegate (Globalization)

#pragma mark - 切换国际化语言测试
-(void)changeLanguage{
    
    //    新加坡:zh-Hans-CN(简体中文)    越南: vi-CN（越南语）   马来西亚:ms-CN(英语)
    // 切换语言前
    NSArray *langArr1 = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSString *language1 = langArr1.firstObject;
    NSLog(@"模拟器语言切换之前：%@",language1);
    
    // 切换语言
    NSArray *lans = @[@"zh-Hans-CN"];
    [[NSUserDefaults standardUserDefaults] setObject:lans forKey:@"AppleLanguages"];
    
    // 切换语言后
    NSArray *langArr2 = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSString *language2 = langArr2.firstObject;
    NSLog(@"模拟器语言切换之后：%@",language2);
    
}

/**
 获取语言国家。  例如：zh_ch
 */
-(void)getLanguageAndCountry{
    //1）获取设置的语言
    //NSString *nsLang  = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    //传说中获取语言设置最准确的方法：
    NSString *nsLang = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"]  objectAtIndex:0];
    //2）获取设置的国家
    NSString *nsCount  = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    NSString * globalizationStr = [NSString stringWithFormat:@"%@",nsLang];
    [[FWUserInformation sharedInstance] setGlobalizationStr:globalizationStr];
}


@end
