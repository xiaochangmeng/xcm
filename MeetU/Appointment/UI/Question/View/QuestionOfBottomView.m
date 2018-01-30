//
//  QuestionView.m
//  Appointment
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "QuestionOfBottomView.h"
#import "QuestionViewEntity.h"
#import "QuestionViewParser.h"
#import "QuestionViewApi.h"
#import "QuestionAnswerApi.h"
#import "FateHelloApi.h"
@interface QuestionOfBottomView()
/**头像 */
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImageView;

/**颜色背景试图 */
@property (weak, nonatomic) IBOutlet UIView *backView;

/**信息内容 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

/**不会按钮 */
@property (weak, nonatomic) IBOutlet UIButton *noButton;
/**可以考虑按钮 */
@property (weak, nonatomic) IBOutlet UIButton *considerButton;
/**确定按钮 */
@property (weak, nonatomic) IBOutlet UIButton *sureButton;


@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@property (strong, nonatomic) QuestionViewEntity* questionViewEntity;

@end
@implementation QuestionOfBottomView
/**
 *  单例模式创建对象
 *
 *  @return 单例对象
 */
+ (QuestionOfBottomView *)sharedManager{
    
    FWUserInformation* information = [FWUserInformation sharedInstance];
    if ([information.sex isEqualToString:@"0"]) {
        return nil;
    }
    static QuestionOfBottomView *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[NSBundle mainBundle] loadNibNamed:@"QuestionOfBottomView" owner:self options:nil][0];
        //第一次弹出视图的时间
        [sharedAccountManagerInstance calculateCountdown:arc4random() % 20];
    });
    return sharedAccountManagerInstance;
}


/**
 *  计算整个view的高度
 *
 *  @param content 文字内容
 *
 *  @return 计算之后的高度
 */
- (CGFloat)viewHeightForContentLabel:(NSString *)content{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:kPercentIP6(14)]};
    CGFloat contentWidth = ScreenWidth - 94 - 26 - 15;
    CGSize  size =  [content boundingRectWithSize:CGSizeMake(contentWidth, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    
    
    return 78 + size.height;
    
}

/**
 *  初始化视图样式
 */
- (void)awakeFromNib{
    [super awakeFromNib];
    //视图默认位置
    self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 78);
    
    //颜色背景试图圆角
    [self setViewCornerRadius:self.backView Angle:10 borderColor:nil borderWidth:0];
    
    //头像
    [self setViewCornerRadius:self.userHeaderImageView Angle: 28 borderColor:nil borderWidth:0];
    
    //三个按钮 圆角 边框
    UIColor* borderColor = Color16(0xF85F73);
    [self setViewCornerRadius:self.sureButton Angle:10 borderColor:borderColor borderWidth:1];
    [self setViewCornerRadius:self.considerButton Angle:10 borderColor:borderColor borderWidth:1];
    [self setViewCornerRadius:self.noButton Angle:10 borderColor:borderColor borderWidth:1];
    
    self.sureButton.titleLabel.font = [UIFont systemFontOfSize:kPercentIP6(13)];
    self.considerButton.titleLabel.font = [UIFont systemFontOfSize:kPercentIP6(13)];
    self.noButton.titleLabel.font = [UIFont systemFontOfSize:kPercentIP6(13)];
}


/**
 *  打招呼
 *
 *  @param mid 对方的mid
 */
#pragma mark - setHelloRequest
- (void)setHelloRequest:(NSString*)mid{
    FateHelloApi *api = [[FateHelloApi alloc] initWithMid:mid];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSLog(@"%@",request.responseJSONObject);
    } failure:^(YTKBaseRequest *request) {
        
    }];
    
}

/**
 *  按钮点击事件
 *
 *  @param sender 点击的按钮
 */
#pragma mark - clickButtonHandle
- (IBAction)clickButtonHandle:(UIButton *)sender {
    
    NSArray* alertContent = @[NSLocalizedString(@"你可以的", nil),
                              NSLocalizedString(@"可以考虑  真棒,有机会了", nil),
                              NSLocalizedString(@"我只能帮你到这里了 加油!", nil)];
    NSUInteger index = 0;
    if (self.questionViewEntity.questionSelectionEntitys.count == 2) {
        index = arc4random() % 2;
    }else{
        index = arc4random() % 3;
    }
    [self showAlertView:alertContent[index]];
    
    
    //隐藏时候视图的frame
    CGRect rect = self.frame;
    rect.origin.y = ScreenHeight;
    
    
    //弹窗消失动画
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        
    }];
    
    
    //消息回复
    @try {
        QuestionSelectEntity* selectEntity = nil;
        if (self.questionViewEntity.questionSelectionEntitys.count == 2 && sender.tag == 2) {
            selectEntity = self.questionViewEntity.questionSelectionEntitys[sender.tag - 1];
        }else{
            selectEntity = self.questionViewEntity.questionSelectionEntitys[sender.tag];
        }
        
        QuestionAnswerApi* questionViewApi = [[QuestionAnswerApi alloc]initWithMid:self.questionViewEntity.mid qId:self.questionViewEntity.questionEntity.qId sId:selectEntity.sId];
        WS(weakSelf);
        [questionViewApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            NSLog(@"%@",request.responseJSONObject);
            //回复成功之后 打招呼
            [weakSelf setHelloRequest:weakSelf.questionViewEntity.mid];
        } failure:^(__kindof YTKBaseRequest *request) {
            
        }];
        
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    //重新开始请求底部弹窗消息
    [self calculateCountdown:180];
    
}

/**
 *  按钮选择结果 提示视图
 *
 *  @param content 要提示的内容
 */
#pragma mark - showAlertView
- (void)showAlertView:(NSString*)content{
    UIView* view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD* HUD =  [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.customView = [[UIImageView alloc] initWithImage: LOADIMAGE(@"MBProgressHUD.bundle/success@2x", @"png")];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = content;
    [HUD show:YES];
    [HUD hide:YES afterDelay:2];
}

/**
 *  更新视图
 *
 *  @param entity 视图数据源
 */
#pragma mark - updateView
- (void)updateView:(QuestionViewEntity*)entity{
    //设置内容 计算视图高度
    self.contentLabel.text = entity.questionEntity.questionContent;
    CGFloat contentHeight =  [self viewHeightForContentLabel:entity.questionEntity.questionContent];
    CGRect frame = CGRectMake(0, ScreenHeight - contentHeight - 49 - 7.5, ScreenWidth,contentHeight);
    
    
    //设置头像
    WS(weakSelf);
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:entity.imgPath] placeholderImage:LOADIMAGE(@"my_defaultHeadImage@2x", @"png") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //计算出图片 的 宽度 大于 高度  还是高度 大于 宽度
        CGFloat imageSize = image.size.width > image.size.height ? image.size.height : image.size.width;
        //按等宽等高裁剪
        CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage,CGRectMake(image.size.width * 0.5 - imageSize * 0.5, 0, imageSize, imageSize));
        
        weakSelf.userHeaderImageView.image = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
    }];

    //设置选项
    if (entity.questionSelectionEntitys.count == 2) {//两个选项
        self.considerButton.hidden = YES;
        for (int i = 0; i < entity.questionSelectionEntitys.count; i++) {
            QuestionSelectEntity* selectEntity = entity.questionSelectionEntitys[i];
            if (i == 0) {
                [self.noButton setTitle:selectEntity.anserContent forState:UIControlStateNormal];
            }else{
                [self.sureButton setTitle:selectEntity.anserContent forState:UIControlStateNormal];
            }
        }
    } else {
        self.considerButton.hidden = NO;
        NSUInteger count = entity.questionSelectionEntitys.count > 3 ? 3 : entity.questionSelectionEntitys.count;
        for (int i = 0; i < count; i++) {
            QuestionSelectEntity* selectEntity = entity.questionSelectionEntitys[i];
            UIButton* button = self.buttons[i];
            [button setTitle:selectEntity.anserContent forState:UIControlStateNormal];
            NSLog(@"文本是多少:%@",selectEntity.anserContent);
        }
    }
    
    
    //显示视图
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    [self layoutIfNeeded];
}


/**
 *  请求最新数据
 */
#pragma mark - requestData
- (void)requestData{
    WS(weakSelf);
    QuestionViewApi* questionViewApi = [[QuestionViewApi alloc]init];
    [questionViewApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSDictionary* dictionary = request.responseJSONObject;
        NSLog(@"底部弹窗:%@",dictionary);
        weakSelf.questionViewEntity = [QuestionViewParser parse:[dictionary objectForKey:@"data"]];
        
        //请求过来的数据有问题
        if (weakSelf.questionViewEntity.questionSelectionEntitys.count == 0 || [weakSelf.questionViewEntity.questionEntity.qId isEqualToString:@""] || [weakSelf.questionViewEntity.questionEntity.questionContent isEqualToString:@""]) {
            [self calculateCountdown:180];
        }else{
            [self updateView:weakSelf.questionViewEntity];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
    }];
    
}

/**
 *  每time秒请求一次数据
 *
 *  @param time 时间间隔
 */
- (void)calculateCountdown:(NSInteger)time{
    __weak typeof(self) weakSelf = self;
    __block int timeout = (int)time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf requestData];
                
            });
        }else{
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

/**
 *  设置视图圆角 并设置边框颜色
 *
 *  @param view        要设置成圆角的试图
 *  @param angle       角度
 *  @param borderColor 边框颜色  如果不需要 传入Nil
 *  @param borderWidth 边框宽度  如果borderColor传入nil则 borderWidth无效
 */
#pragma mark - 设置视图圆角  如果不需要边框 传入nil
- (void)setViewCornerRadius:(UIView*)view Angle:(int)angle borderColor:(UIColor*)borderColor borderWidth:(CGFloat)borderWidth{
    view.layer.cornerRadius = angle;
    view.layer.masksToBounds = YES;
    if (nil != borderColor) {
        view.layer.borderColor = borderColor.CGColor;
        view.layer.borderWidth = borderWidth;
    }
}

/**
 *  懒加载
 *
 *  @return 初始化之后的视图实体类数据源
 */
- (QuestionViewEntity *)questionViewEntity{
    if (nil == _questionViewEntity) {
        _questionViewEntity = [QuestionViewEntity new];
    }
    return _questionViewEntity;
}
@end
