//
//  CONSTS.h
//  Appointment
//
//  Created by feiwu on 16/7/16.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//


#ifndef MyWeiBo20131118_CONSTS_h
#define MyWeiBo20131118_CONSTS_h

#pragma mark - 发布版本不打印Log信息

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif


#pragma mark - 输出颜色自定义，配合插件

#define XCODE_COLORS_ESCAPE_MAC @"\033["
#define XCODE_COLORS_ESCAPE_IOS @"\xC2\xA0["


#if 0
#define XCODE_COLORS_ESCAPE XCODE_COLORS_ESCAPE_IOS
#else
#define XCODE_COLORS_ESCAPE XCODE_COLORS_ESCAPE_MAC
#endif

#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color

#define LogBlue(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"bg0,191,255;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)

#define LogRed(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"bg255,0,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)

#define LogGreen(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"bg0,255,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)

#define LogOrange(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"bg255,97,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)

#define LogYellow(frmt, ...) NSLog(( XCODE_COLORS_ESCAPE@"bg255,255,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)


#pragma mark - 系统参数

#pragma mark 判断设备
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define iOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4S (IS_IPHONE && SCREEN_MAX_LENGTH == 480.0)
#define IS_IPHONE_5S (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#pragma mark 获得屏幕高
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#pragma mark 获得屏幕宽
#define ScreenWidth [UIScreen mainScreen].bounds.size.width


#pragma mark 字号30
#define kFont30 [UIFont systemFontOfSize:30]

#pragma mark 字号21
#define kFont21 [UIFont systemFontOfSize:21]

#pragma mark 字号20
#define kFont20 [UIFont systemFontOfSize:20]

#pragma mark 字号19
#define kFont19 [UIFont systemFontOfSize:19]

#pragma mark 字号18
#define kFont18 [UIFont systemFontOfSize:18]

#pragma mark 字号17
#define kFont17 [UIFont systemFontOfSize:17]

#pragma mark 字号16
#define kFont16 [UIFont systemFontOfSize:16]

#pragma mark 字号15
#define kFont15 [UIFont systemFontOfSize:15]

#pragma mark 字号14
#define kFont14 [UIFont systemFontOfSize:14]

#pragma mark 字号13
#define kFont13 [UIFont systemFontOfSize:13]


#pragma mark 字号12
#define kFont12 [UIFont systemFontOfSize:12]

#pragma mark 字号11
#define kFont11 [UIFont systemFontOfSize:11]

#pragma mark 字号10
#define kFont10 [UIFont systemFontOfSize:10]

#pragma mark 字号8
#define kFont8 [UIFont systemFontOfSize:8]

#pragma mark 字号18
#define kBold18 [UIFont boldSystemFontOfSize:18]

#pragma mark 字号14
#define kBold14 [UIFont boldSystemFontOfSize:14]

#pragma mark 字号10
#define kBold10 [UIFont boldSystemFontOfSize:10]

#pragma mark 字号8
#define kBold8 [UIFont boldSystemFontOfSize:8]

#pragma mark 国际化语言
#define kLocalizedString(str) NSLocalizedString(str, str)

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#pragma mark 设置颜色
#define Color10(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define Color16(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

#define NavColor Color16(0xF85F73)
#pragma mark - 加载本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

#pragma mark 版本號
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#pragma mark 數組是否為空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

#pragma mark 字典是否為空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

#pragma mark 字符串是否為空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO)

#pragma mark 传入iPhone6效果图的宽或高，得到当前设备的等比例值
#define kPercentIP6(parameter) parameter * ScreenWidth/375.0
#define kHeightIP6(parameter) parameter * ScreenHeight/667.0

#pragma mark facebook
#define FacebookId @"1474739059215209"
#define FacebookSecret @"a2015c8eb328bf185cde36c0847ad99e"

#pragma mark 请求URL
//#define BaseUrl @"http://gj.api.11yuehui.com"//正式
#define BaseUrl @"http://gj-dev.api.11yuehui.com"//测试


#pragma 商品价格
#define write_1 @"34.3"
#define write_3 @"67.24"
#define write_12 @"135.84"

#define vip_1 @"41.16"
#define vip_3 @"41.16"
#define vip_12 @"80.96"


#pragma mark -弱引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#pragma mark 通用字符串

#define kNetWorkSuccCode 200  //正确返回Code

#define kNetWorkNoSetSexCode 402 //没有设置性别

#define kNetWorkNoLoginCode 411 //没有登录

#define kNetWorkNoDataCode 412 //没有数据

#define kNetWorkErrorTitle NSLocalizedString(@"請求失敗，稍後重試！", @"請求失敗，稍後重試！")



#define kUserPHPSESSID @"PHPSESSID" //用户令牌

#define kUserLetterCount @"userLetterCount" //用户未读私信

#define kAppIsCheckStatus @"appIsCheckStatus" //app审核状态

#endif

