//
//  AppDelegate.m
//  Appointment
//
//  Created by feiwu on 16/7/8.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "AppDelegate.h"

#import "RootTabController.h"
#import "FateViewController.h"
#import "LetterViewController.h"
#import "LetterDetailViewController.h"
#import "NearbyViewController.h"
#import "MyViewController.h"
#import "DaliyRecommendViewController.h"
#import "UploadHeaderController.h"
#import "AppDelegate+YTKNetwork.h"
#import "AppDelegate+Push.h"
#import "AppDelegate+ShareSDK.h"
#import "AppDelegate+UMeng.h"

#import "NSDate+MZYExtension.h"
#import "CustomNavigationController.h"
#import "FirstViewController.h"
#import "JPUSHService.h"
#import "LXFileManager.h"
#import "GetChannelApi.h"
#import "StatisticalApi.h"
//#import "CheckStatusApi.h"
#import "InterAPPApi.h"
#import "SimulateIDFA.h"
#import "MyVerifyPayResultApi.h"
#import "AppDelegate+Globalization.h"
#import "LetterVideoView.h"
#import "MyFeedBackViewController.h"
#import "WJCirclViewController.h"

#import "NewFateViewController.h"
#import "WSMovieController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //增加定位
    [self setLocation];
    //切换国际化语言
    [self changeLanguage];
    //获取手机的语言+地区
    [self getLanguageAndCountry];
       // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //设置状态栏为亮色（ 针对IOS7）
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [self initViewControllers];//初始化
    
    //跳转控制
    NSString *phpsessid = [LXFileManager readUserDataForKey:kUserPHPSESSID];
    NSString *validKey = [NSString stringWithFormat:@"%@%@",[FWUserInformation sharedInstance].mid,kUserPHPSESSID];
    NSString *valid = [LXFileManager readUserDataForKey:validKey];
    double currentTime = time(NULL);
    
    if (phpsessid == nil ) {
        //注册
        FirstViewController *first = [[FirstViewController alloc] init];
        self.window.rootViewController = first;
    } else  if( currentTime < [valid doubleValue] + 24 * 3600 * 89){
        //判断是否每天第一次启动
        NSString *currentDate = [NSDate getDate:[NSDate date] dateFormatter:@"yyyyMMdd"];
        NSString *key = [NSString stringWithFormat:@"%@%@",currentDate,[FWUserInformation sharedInstance].mid];
        NSString *daliy = [LXFileManager readUserDataForKey:key];
        //已登录
        if ([daliy isEqualToString:@"1"]) {
            //已启动
//            self.window.rootViewController = [self.viewControllers firstObject];
            
//             [self loadqidongdate];
//                    RootTabController *controller = [[RootTabController alloc] init];
//                    self.window.rootViewController = controller;
            
           NSString * pageUrl = @"http://img.11yuehui.com/gj_yuehui/index_video1.mp4";
            WSMovieController *wsCtrl = [[WSMovieController alloc]init];
            wsCtrl.movieURL = [NSURL URLWithString:pageUrl];//选择本地的视屏
            self.window.rootViewController = wsCtrl;

        } else {
            
            
//            //   没有启动过
            NSString *userImage = [LXFileManager readUserDataForKey:[NSString stringWithFormat:@"%@userImage",[FWUserInformation sharedInstance].mid]];
            if ( userImage .length < 5) {
                //没有头像
                UploadHeaderController *upload = [[UploadHeaderController alloc] initWithType:@"login"];
                self.window.rootViewController = upload;
            } else {
                //有头像
                DaliyRecommendViewController *recommend = [[DaliyRecommendViewController alloc] init];
                self.window.rootViewController = recommend;
            }
        }//   没有启动过
        
    } else if(currentTime > [valid doubleValue] + 24 * 3600 * 89) {
        //登录
        FirstViewController *first = [[FirstViewController alloc] init];
        self.window.rootViewController = first;    }
    
    [self.window makeKeyAndVisible];
    
    //设置网络访问过滤
    [self setupRequestFilters];
    
    //sharesdk
    [self setShareSDK];
    
    //动态渠道
    NSString *ditch = [FWUserInformation sharedInstance].ditch;
    if ([ditch isEqualToString:@""] || ditch == nil) {
        [self setChannelRequest];
    }
    
    //审核状态判断
//    [self getCheckStatusRequest];
    

#if TARGET_IPHONE_SIMULATOR
    
#else
    //设置推送
    [self setUpPushWithOptions:launchOptions];
    
    //友盟配置
    [self umengTrack];
    
#endif
    
    //是否第一次打开应用
    NSString *idfa = [FWUserInformation sharedInstance].idfa;//设备标识
    if ( idfa == nil || [idfa isEqualToString:@""]) {
        idfa = [SimulateIDFA createSimulateIDFA];
        [FWUserInformation sharedInstance].idfa = idfa;
        [[FWUserInformation sharedInstance] saveUserInformation];
    }
    
    NSString *firstOpen = [LXFileManager readUserDataForKey:idfa];
    if (![firstOpen isEqualToString:@"first"]) {
        [self setStatisticalFirstOpenRequest];
    }
    //购买是否漏单
    NSString *mid = [FWUserInformation sharedInstance].mid;
    NSString *key = [NSString stringWithFormat:@"%@inAppBuy",mid];//key
    NSDictionary *dic = [LXFileManager readUserDataForKey:key];
    if (dic) {
        NSString * receipt = [dic objectForKey:@"receipt"];
        NSString * tid = [dic objectForKey:@"transactionId"];
        NSString * pid = [dic objectForKey:@"product_id"];
        NSString * from = [dic objectForKey:@"from"];
        NSString * time = [dic objectForKey:@"time"];
        [self verifyPayResultRequest:receipt TransactionId:tid ProductId:pid From:from Time:time];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkDidLogin:)
                                                 name:kJPFNetworkDidLoginNotification
                                               object:nil];
   
    return YES;
}




-(void)loadqidongdate{
//    HSKStorage *storage = [[HSKStorage alloc]initWithPath:AccountPath];
//    NSMutableArray * fatearray = (NSMutableArray *)[storage hsk_objectForKey:@"fatearray"];
//
//    }
    
    //版本
//    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    if (appVersion == nil) {
//        appVersion = @"1.0";
//    }
    
    NSString *appVersion = @"1.0";
    // 包名
    NSString *bundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    
    //渠道
    NSString *ditch = [FWUserInformation sharedInstance].ditch;//渠道
    //if ([ditch isEqualToString:@""] || ditch == nil) {
    ditch = [NSString stringWithFormat:@"%@_AppStore",bundleID];
    //}
    
    //idfa
    NSString *idfa = [FWUserInformation sharedInstance].idfa;//设备标识
    if ( idfa == nil || [idfa isEqualToString:@""]) {
        idfa = [SimulateIDFA createSimulateIDFA];
        [FWUserInformation sharedInstance].idfa = idfa;
        [[FWUserInformation sharedInstance] saveUserInformation];
    }
    
//    NSString *country = [FWUserInformation sharedInstance].country;//设备标识
//    NSString *province = [FWUserInformation sharedInstance].province;//设备标识
//    NSString *city = [FWUserInformation sharedInstance].city;//设备标识
    
    NSString *mid = [FWUserInformation sharedInstance].mid;
    NSDictionary *userinfo = [LXFileManager readUserDataForKey:[NSString stringWithFormat:@"%@password",mid]];
  NSString* username = [userinfo objectForKey:@"user_id"];
    if (username == nil) {
        username = @"";
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",nil];
    NSString * url = [NSString stringWithFormat:@"%@/iOS/Index/interApp",BaseUrl];
    
    //3.请求
    NSDictionary * dic = @{@"packName":username,@"appName":@"MeetU",@"ditchName":ditch,@"versionName":appVersion};
    [manager POST:url parameters:dic success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString*code = responseObject[@"code"];
        
        if ([code isEqualToString:@"200"]) {
            if (![responseObject[@"data"] isKindOfClass:[NSNull class]]) {
                NSString *pageUrl = responseObject[@"data"][@"pageUrl"];
                if (pageUrl == nil) {
                   
                }
                 pageUrl = @"http://img.11yuehui.com/gj_yuehui/index_video1.mp4";
                WSMovieController *wsCtrl = [[WSMovieController alloc]init];
                wsCtrl.movieURL = [NSURL URLWithString:pageUrl];//选择本地的视屏
                self.window.rootViewController = wsCtrl;
                
            }
        }

//
        
    }failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
      
        
    }];
    
    
}


- (void)networkDidLogin:(NSNotification *)notification {
    FWUserInformation* info = [FWUserInformation sharedInstance];
    if (info.age.length > 0 && info.sex.length > 0  && info.mid.length > 0) {
        [JPUSHService setTags:[NSSet setWithObjects:info.age,info.sex, nil] alias:info.mid fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            NSLog(@"ialias:%@",iAlias);
        }];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:kJPFNetworkDidLoginNotification
                                                      object:nil];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [JPUSHService resetBadge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //把桌面推送角标置零
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LetterViewControllerRefreshHighlight" object:nil];//私信列表红心刷新
    [JPUSHService resetBadge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [self setInterAppRequest];//每次進入APP
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [JPUSHService resetBadge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    //内存警告时清除缓存
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    LogRed(@"ios10私信信息:%@",userInfo);
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知");
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        LogRed(@"ios10私信信息:%@",userInfo);
        
        [JPUSHService handleRemoteNotification:userInfo];
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知");
    }
    
    completionHandler();  // 系统要求执行这个方法
}

#endif





#pragma mark 初始化
- (void)initViewControllers
{
    //缘分
    FateViewController *newfateVC = [[FateViewController alloc] init];
    
    
//    NewFateViewController*newfateVC = [[NewFateViewController alloc] init];
    //私信
    LetterViewController *letterVC = [[LetterViewController alloc] init];
    
//    //附近
//    NearbyViewController *nearbyVC = [[NearbyViewController alloc] init];
//
    //附近
    WJCirclViewController *circleVC = [[WJCirclViewController alloc] init];
    
    //我的
    MyViewController *myVC = [[MyViewController alloc] init];
    
    NSArray *vcs = @[newfateVC,letterVC,circleVC,myVC];
    NSMutableArray *nvs = [NSMutableArray arrayWithCapacity:4];
    for (UIViewController *vc in vcs) {
//        CustomNavigationController *baseNV = [[CustomNavigationController alloc] initWithRootViewController:vc];
           UINavigationController *baseNV = [[UINavigationController alloc] initWithRootViewController:vc];
        [nvs addObject:baseNV];
    }
    
    self.viewControllers  = nvs;
}

#pragma mark - 动态渠道
- (void)setChannelRequest{
    WS(weakSelf);
    GetChannelApi *api = [[GetChannelApi alloc] init];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf setChannelRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"动态渠道请求失败:%@",request.responseString);
        FWUserInformation* information = [FWUserInformation sharedInstance];
        information.ditch = @"AppStore";
        [information saveUserInformation];
    }];
}

- (void)setChannelRequestFinish:(NSDictionary *)result{
    LogOrange(@"获取动态渠道请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    FWUserInformation* information = [FWUserInformation sharedInstance];
    if ([code intValue] == kNetWorkSuccCode){
        NSString *ditch = [result objectForKey:@"data"];
        if ([ditch isEqualToString:@""]) {
            information.ditch = @"AppStore";
        } else {
            information.ditch = ditch;
        }
    } else {
        information.ditch = @"AppStore";
    }
    [information saveUserInformation];
    
}

#pragma mark - 统计第一次启动
- (void)setStatisticalFirstOpenRequest{
    WS(weakSelf);
    StatisticalApi *api = [[StatisticalApi alloc] init];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf setStatisticalFirstOpenFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"设置统计第一次启动失败:%@",request.responseString);
    }];
}

- (void)setStatisticalFirstOpenFinish:(NSDictionary *)result{
    LogOrange(@"设置统计第一次启动成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    if ([code intValue] == kNetWorkSuccCode){
        NSString *idfa = [FWUserInformation sharedInstance].idfa;//设备标识
        if ( idfa == nil || [idfa isEqualToString:@""]) {
            idfa = [SimulateIDFA createSimulateIDFA];
            [FWUserInformation sharedInstance].idfa = idfa;
            [[FWUserInformation sharedInstance] saveUserInformation];
        }
        
        [LXFileManager saveUserData:@"first" forKey:idfa];
        
    } else {
        
    }
}

#pragma mark - 获取审核状态
//- (void)getCheckStatusRequest{
//    WS(weakSelf);
//    CheckStatusApi *api = [[CheckStatusApi alloc] init];
//    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
//        [weakSelf getCheckStatusRequestFinish:request.responseJSONObject];
//    } failure:^(YTKBaseRequest *request) {
//        LogYellow(@"获取审核状态请求失败:%@",request.responseString);
//        [LXFileManager saveUserData:@"0" forKey:kAppIsCheckStatus];
//    }];
//}

//- (void)getCheckStatusRequestFinish:(NSDictionary *)result{
//    LogOrange(@"获取审核状态请求成功:%@",result);
//    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
//    if ([code intValue] == kNetWorkSuccCode){
//        NSDictionary *dic = [result objectForKey:@"data"];
//        NSString *status =[dic objectForKey:@"status"];
//        if ([status intValue] == 1) {
//            //审核状态
//            [LXFileManager saveUserData:@"0" forKey:kAppIsCheckStatus];
//        } else {
//            //非审核状态
//            [LXFileManager saveUserData:@"1" forKey:kAppIsCheckStatus];
//        }
//    } else {
//        [LXFileManager saveUserData:@"0" forKey:kAppIsCheckStatus];
//    }
//}

#pragma mark - 每次進入APP
- (void)setInterAppRequest{
    WS(weakSelf);
    InterAPPApi *api = [[InterAPPApi alloc] init];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf setInterAppRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"每次進入失败:%@",request.responseString);
    }];
}

- (void)setInterAppRequestFinish:(NSDictionary *)result{
    LogOrange(@"每次進入成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    if ([code intValue] == kNetWorkSuccCode){
    } else {
        
    }
}
#pragma mark - 验证支付结果
- (void)verifyPayResultRequest:(NSString *)receipt TransactionId:(NSString *)tid ProductId:(NSString *)pid From:(NSString *)from Time:(NSString *)time{
    WS(weakSelf);
    NSLog(@"订单号:%@",tid);
    MyVerifyPayResultApi *api = [[MyVerifyPayResultApi alloc] initWithReceipt:receipt Transactionid:tid Productid:pid From:from Time:time];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf verifyPayResultRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"验证订单信息请求失败:%@",request.responseString);
    }];
}

- (void)verifyPayResultRequestFinish:(NSDictionary *)result{
    LogOrange(@"验证订单信息请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    if ([code intValue] == kNetWorkSuccCode){
        //移除订单信息
        NSString *mid = [FWUserInformation sharedInstance].mid;//用户id
        NSString *key = [NSString stringWithFormat:@"%@inAppBuy",mid];//key
        [LXFileManager removeUserDataForkey:key];
    }else {
    }
}


#pragma mark -------------------------------定位授权--------------------------------
-(void)setLocation{
    
    self.locationMgr = [[CLLocationManager alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
        //[self.locationMgr requestAlwaysAuthorization];
        [self.locationMgr requestWhenInUseAuthorization];
    }
    self.locationMgr.delegate = self;
    
    self.locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
    
    self.locationMgr.distanceFilter = 1000.0f;
    
    [self.locationMgr startUpdatingLocation];
    
}

/**
 *  定位代理方法
 *
 *  @param application locationManager
 */

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSUserDefaults * ud =[NSUserDefaults standardUserDefaults] ;
    CLLocation * cl = [locations objectAtIndex:0];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:cl completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             
             //将获得的所有信息显示到label上
             //self.location.text = placemark.name;
             //获取城市
             NSString *city = placemark.locality;
             NSString * province=placemark.administrativeArea;
             NSString * country = placemark.country ;
             FWUserInformation* info = [FWUserInformation sharedInstance];
             info.country = country;
             info.province = province;
             info.city = city;
             
             
             [info saveUserInformation];

             
             
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             [ud setObject:city forKey:@"UserLocationCity"];
             NSLog(@"city = %@", city);
             
         }
         else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }
         else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
     }];
    
    //缓存经纬度
    
    [ud setObject:[NSString stringWithFormat:@"%f",cl.coordinate.latitude] forKey:@"UserLocationLat"];
    [ud setObject:[NSString stringWithFormat:@"%f",cl.coordinate.longitude] forKey:@"UserLocationLng"];
    [ud setObject:@"0" forKey:@"isLocation"];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:WJ_Location object:nil];
    //    [ud synchronize];
    
}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //    NSString *errorString;
    [manager stopUpdatingLocation];
    //    DLog(@"Error: %@",[error localizedDescription]);
    NSUserDefaults * ud =[NSUserDefaults standardUserDefaults] ;
    [ud setObject:@"1" forKey:@"isLocation"];
    [ud synchronize];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        
        
        
    }else{
        
        switch([error code]) {
            case kCLErrorDenied:
                break;
            case kCLErrorLocationUnknown:
                
                break;
            default:
                // errorString = @"An unknown error has occurred";
                [[[UIAlertView alloc] initWithTitle:@"提示：" message:@"定位发生错误!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
                break;
        }
    }
}


@end
