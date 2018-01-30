//
//  AppDelegate+Push.m
//  Appointment
//
//  Created by feiwu on 16/7/12.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "AppDelegate+Push.h"
#import "JPUSHService.h"
#import "GetLetterCountApi.h"
#import "LetterDetailViewController.h"
#import "FateModel.h"
#import "LXFileManager.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#import "LetterVideoView.h"
#import "MyFeedBackViewController.h"
#import "CustomNavigationController.h"
#endif
@implementation AppDelegate (Push)

- (void)setUpPushWithOptions:(NSDictionary *)launchOptions{
    // 3.0.0及以后版本注册可以这样写，也可以继续用旧的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //Required
    NSString *ditch = [FWUserInformation sharedInstance].ditch;//渠道
    if ([ditch isEqualToString:@""] || ditch == nil) {
        ditch = @"AppStore";
    }
    
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。e1ee30d819da5e773504f967
    [JPUSHService setupWithOption:launchOptions appKey:@"e1ee30d819da5e773504f967"
                          channel:ditch
                 apsForProduction:YES
            advertisingIdentifier:nil];
    
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 极光 Required
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //极光 Required
    [JPUSHService handleRemoteNotification:userInfo];
    
    //点击通知栏
    NSString *mid = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"send_id"]];
    NSString *type = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"type"]];
    if ([type isEqualToString:@"vedio"]) {//视频推送
        [self vedioPushAlterMethod:userInfo];
        return;
    }
    if ( [UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        NSString *nickname = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"name"]];
        if ([type isEqualToString:@"chat"] && ![mid isEqualToString:@""] && mid != nil) {
            if (self.isLetter) {
                //当前在聊天页
                [[NSNotificationCenter defaultCenter] postNotificationName:@"backgroundNewLetter" object:@{mid : nickname}];
            } else {
                //不在聊天页
                self.window.rootViewController = self.viewControllers[1];
                UINavigationController *navigation = self.viewControllers[1];
                FateModel *model = [[FateModel alloc] init];
                model.send_id = mid;
                model.name = nickname;
                
                CustomViewController *letter = [navigation.viewControllers firstObject];
                LetterDetailViewController *detail = [[LetterDetailViewController alloc] init];
                detail.model = model;
                [letter.navigationController pushViewController:detail animated:YES];
            }
        }
    }
    
    //刷新私信列表
    if ( ![mid isEqualToString:@""] && mid != nil) {
        [self getLetterCountRequest];//私信数目
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LetterViewControllerRefreshLetterList" object:mid];//刷新私信列表
    }
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void
                        (^)(UIBackgroundFetchResult))completionHandler {
    LogRed(@"ios10以下fetchCompletionHandler私信数目:%@",userInfo);
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    
    //点击通知栏处理
    NSString *mid = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"send_id"]];
    NSString *type = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"type"]];
    if ([type isEqualToString:@"virtual_video"]) {//视频推送
        [self vedioPushAlterMethod:userInfo];
        return;
    }
    if ( [UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        NSString *nickname = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"name"]];
        if ([type isEqualToString:@"chat"] && ![mid isEqualToString:@""] && mid != nil) {
            if (self.isLetter) {
                //当前在聊天页
                [[NSNotificationCenter defaultCenter] postNotificationName:@"backgroundNewLetter" object:@{mid : nickname}];
            } else {
                //不在聊天页
                self.window.rootViewController = self.viewControllers[1];
                UINavigationController *navigation = self.viewControllers[1];
                FateModel *model = [[FateModel alloc] init];
                model.send_id = mid;
                model.name = nickname;
                
                CustomViewController *letter = [navigation.viewControllers firstObject];
                LetterDetailViewController *detail = [[LetterDetailViewController alloc] init];
                detail.model = model;
                [letter.navigationController pushViewController:detail animated:YES];
            }
            
        }
    }
    
    //刷新私信列表
    if ( ![mid isEqualToString:@""] && mid != nil) {
        [self getLetterCountRequest];//私信数目
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LetterViewControllerRefreshLetterList" object:mid];//刷新私信列表
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    
}

#pragma mark - 未读私信数量
- (void)getLetterCountRequest{
    WS(weakSelf);
    GetLetterCountApi *api = [[GetLetterCountApi alloc] init];
    [api startWithCompletionBlockWithSuccess:^( YTKBaseRequest *request) {
        [weakSelf getLetterCountRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        if ([[request.responseJSONObject objectForKey:@"code"] integerValue] == 200) {
            [weakSelf getLetterCountRequestFinish:request.responseJSONObject];
        }
    }];
}

- (void)getLetterCountRequestFinish:(NSDictionary *)result{
    LogOrange(@"未读私信请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    if ([code intValue] == kNetWorkSuccCode){
        NSDictionary *dic = [result objectForKey:@"data"];
        NSInteger visitor = [[dic objectForKey:@"lately_total"] integerValue];
        NSInteger letter = [[dic objectForKey:@"letter_total"] integerValue];
        NSString *newCount = [NSString  stringWithFormat:@"%ld",visitor + letter];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LetterCountChange" object:newCount];
        NSString *userid = [NSString stringWithFormat:@"%@%@",[FWUserInformation sharedInstance].mid,kUserLetterCount];
        [LXFileManager saveUserData:newCount forKey:userid];
        
    } else if ([code intValue] == kNetWorkNoSetSexCode) {
        
    } else {
    }
}


#pragma mark - 收到视频推送执行的方法
-(void)vedioPushAlterMethod:(NSDictionary *)userInfo{
    NSString *mid = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"send_id"]];
    NSString *name = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"name"]];
    NSString *img = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"avatar"]];
    LetterVideoView* letterVideoView = [[LetterVideoView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) Type:@"1" Mid:mid Nickname:name Img:img];
    WS(weakSelf);
    [letterVideoView setLetterVideoBlock:^(NSString *type) {
        if ([type intValue]==1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.vedioPushAlter show];
            }) ;
         }
    }];
    [[[UIApplication sharedApplication].windows lastObject] addSubview:letterVideoView];
    
}

-(UIAlertView *)vedioPushAlter{
    
      UIAlertView *  vedioPushAlter = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"开通VIP", nil) message:NSLocalizedString(@"您暂未开通vip，暂无权限视频通话，升级VIP就可以去撩她了！", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"升级VIP会员", nil), nil];
    
    return vedioPushAlter;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0){
    if(buttonIndex==1){//跳转到vip充值页面
        MyFeedBackViewController *feed = [[MyFeedBackViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/iOS/Buy/vip_v1",BaseUrl]];
        feed.titleStr = NSLocalizedString(@"VIP会员", nil);
        feed.pushType = @"center-vip";
        [(CustomNavigationController *)self.window.rootViewController pushViewController:feed animated:YES];
    }
    
}

@end
