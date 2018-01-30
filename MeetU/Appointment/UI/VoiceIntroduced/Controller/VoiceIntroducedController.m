//
//  VoiceIntroducedController.m
//  Appointment
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "VoiceIntroducedController.h"

#import "VoiceIntroducedApi.h"
#import "RecordView.h"
@interface VoiceIntroducedController ()<RecordViewDelegate>
/**说几句极少自己的话 */
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
/**录音提示label */
@property (weak, nonatomic) IBOutlet UILabel *recordAlertLabel;

/**红色背景 */
@property (weak, nonatomic) IBOutlet RecordView *recordBackView;


/**重新录制按钮 */
@property (weak, nonatomic) IBOutlet UIButton *anewButton;


@end

@implementation VoiceIntroducedController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.recordBackView.audioPlayer isPlaying]) {
        [self.recordBackView.audioPlayer stop];
        self.recordBackView.audioPlayer = nil;
    }
    [MobClick endLogPageView:@"录制音频页面"];
}

- (void)recordViewCalculateRecordDuration:(NSUInteger)duration{
    _duration = duration;
    NSUInteger min =  duration / 60;
    NSUInteger sec = duration % 60;
    self.recordAlertLabel.text = [NSString stringWithFormat:@"%02lu:%02lu",min,sec];
}
#pragma mark 录音上传
/**
 *  录音结束
 *
 *  @param voiceData 要上传的声音data
 *  @param duration  录音时长
 */
- (void)recordViewStopRecord:(NSData *)voiceData duration:(NSUInteger)duration{
    //上传
    WS(weakSelf);
    [self.recordBackView resetView:RECORDVIEWSTATUS_UPLOADING];
    VoiceIntroducedApi* voiceIntroducedApi = [[VoiceIntroducedApi alloc]initWithVoiceData:voiceData duration:duration];
    [voiceIntroducedApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary* resultDictionary = request.responseJSONObject;
        NSLog(@"录音上传成功：%@",resultDictionary);
        if ([[resultDictionary objectForKey:@"code"] isEqualToString:@"200"]) {//上传成功
            [weakSelf.recordBackView resetView:RECORDVIEWSTATUS_PLAY];
            weakSelf.anewButton.hidden = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MyInfoViewControllerRecordChange" object:[NSString stringWithFormat:@"%lu''",(unsigned long)weakSelf.duration]];
            }else{
            [weakSelf.recordBackView resetView:RECORDVIEWSTATUS_NORAML];
            weakSelf.anewButton.hidden = YES;
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf.recordBackView resetView:RECORDVIEWSTATUS_NORAML];
        weakSelf.anewButton.hidden = YES;
    }];

}

- (void)recordViewStatusSwitch:(RecordViewStatus)status{
    if (status == RECORDVIEWSTATUS_NORAML) {
        [self setAlertText];
    }
}

/**
 *  重新录制按钮
 *
 *  @param sender 重新录制按钮
 */
- (IBAction)clickAnewButtonHandle:(UIButton *)sender {
    self.anewButton.hidden = YES;   //隐藏重新录制按钮
    [self setAlertText];                //重新设置录音提示Label
    [self.recordBackView resetView:RECORDVIEWSTATUS_NORAML];
    [self.recordBackView.audioPlayer stop];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"录制音频页面"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

/**
 *  初始化界面
 */
#pragma mark - setupView
- (void)setupView{
    
    //navigation标题
    self.title = NSLocalizedString(@"录制语音介绍", nil);
    self.isBack = YES;
    
    //设置字体
    NSString* content =  NSLocalizedString(@"说几句介绍自己的话 \n 用声音打动她的心", nil);
    [self setLineSpaceAndFontSpace:content label:self.descriptionLabel lineSpace:14 wordSpace:1.5];
    
    [self setAlertText];
    
    
    
    [self.recordBackView resetView:self.status];
    self.recordBackView.frame = CGRectMake(0, 0, 125, 125);
    self.recordBackView.layer.cornerRadius = 62.5f;
    self.recordBackView.layer.masksToBounds = YES;
    self.recordBackView.delegate = self;
    self.anewButton.hidden = self.status == RECORDVIEWSTATUS_PLAY ? NO : YES;
    
}

- (void)setAlertText{
    //录音提示
    NSString* alertContent = NSLocalizedString(@"长按按钮录音\n(至少三秒以上)", nil);
    [self setTextAttribute:self.recordAlertLabel string:alertContent];
}


/**
 *  设置字符串颜色
 *
 *  @param label  显示在哪个Label上面
 *  @param string 要显示的字符串
 */
- (void)setTextAttribute:(UILabel*)label string:(NSString*)string{
    //设置字符串颜色
    if (string == nil) {
        return;
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    //拆分的字符包含在前半部分
    NSArray* tempArr = [string componentsSeparatedByString:@"("];
    
    NSRange range_pre = NSMakeRange(0, [[tempArr firstObject]length] + 1);
    NSRange range_next = NSMakeRange([[tempArr firstObject]length] + 1,[[tempArr lastObject]length]);
    //
    [str addAttribute:NSForegroundColorAttributeName value:Color10(153, 153, 153, 1) range:range_pre];
    [str addAttribute:NSForegroundColorAttributeName value:Color10(205, 79, 50, 1) range:range_next];
    label.attributedText = str;
}


/**
 *  设置字体的行间距和字间距
 *
 *  @param content   要显示的内容
 *  @param label     显示哪个Label上面
 *  @param lineSpace 行间距
 *  @param wordSpace 字间距
 */
- (void)setLineSpaceAndFontSpace:(NSString*)content label:(UILabel*)label lineSpace:(CGFloat)lineSpace wordSpace:(CGFloat)wordSpace{
    
    NSNumber* wordSpaceNum = [NSNumber numberWithFloat:wordSpace];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    //设置行间距
    paraStyle.lineSpacing = lineSpace;
    
    //设置字间距 NSKernAttributeName
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:wordSpaceNum};
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:content attributes:dic];
    
    label.attributedText = attributeStr;
    
}


/**
 *  button的title添加下划线
 *
 *  @param button  要添加下划线的Button
 *  @param content title
 */
- (void)setWordAddLine:(UIButton*)button content:(NSString*)content{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:content];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:Color10(153, 153, 153, 1) range:strRange];
    [button setAttributedTitle:str forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  HUD
 *
 *  @param content 要提示的内容
 */
#pragma mark - showAlertView
- (void)showAlertView:(NSString*)content{
    UIView* view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD* HUD =  [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.animationType = MBProgressHUDAnimationZoom;
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = content;
    [HUD show:YES];
    [HUD hide:YES afterDelay:2];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
/*
 在iOS开发过程中，如果要使用到一些跟特定系统版本特性有关的功能，或者要适配低版本系统的用户，还有一些方法是新版本系统才有的，有一些方法在新版本中已经弃用了，这都需要对不同系统版本的设备进行分别的处理，而这有个前提就是判断系统的版本号。
 
 判断系统版本号有多种方法，这里都列出来供大家和自己在开发中需要时进行选择使用。
 CFBundleVersion，标识（发布或未发布）的内部版本号。这是一个单调增加的字符串，包括一个或多个时期分隔的整数。
 
 CFBundleShortVersionString  标识应用程序的发布版本号。该版本的版本号是三个时期分隔的整数组成的字符串。第一个整数代表重大修改的版本，如实现新的功能或重大变化的修订。第二个整数表示的修订，实现较突出的特点。第三个整数代表维护版本。该键的值不同于“CFBundleVersion”标识。
 
 版本号的管理是一个谨慎的事情，希望各位开发者了解其中的意义。
 
 比较小白，更新应用的时候遇到版本号CFBundleShortVersionString命名的错误，导致无法更新，后来看了文档研究下发现是这样，希望给不了解的人以启示；
 */
-(void)versiontTEST{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    //手机序列号
    //    NSString* identifierNumber = [[UIDevice currentDevice] uniqueIdentifier];
    NSLog(@"手机序列号: %@",@"identifierNumberidentifierNumberidentifierNumberidentifierNumberidentifierNumber");
    //手机别名： 用户定义的名称
    NSString* userPhoneName = [[UIDevice currentDevice] name];
    NSLog(@"手机别名: %@", userPhoneName);
    //设备名称
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    NSLog(@"设备名称: %@",deviceName );
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本: %@", phoneVersion);
    //手机型号
    NSString* phoneModel = [[UIDevice currentDevice] model];
    NSLog(@"手机型号: %@",phoneModel );
    //地方型号 （国际化区域名称）
    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    NSLog(@"国际化区域名称: %@",localPhoneModel );
    
    NSDictionary *infoDictionary1 = [[NSBundle mainBundle] infoDictionary];
    // 当前应用名称
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"当前应用名称：%@",appCurName);
    // 当前应用软件版本 比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    // 当前应用版本号码  int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"当前应用版本号码：%@",appCurVersionNum); }
@end
