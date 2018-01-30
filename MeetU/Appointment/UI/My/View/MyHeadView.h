//
//  MyHeadView.h
//  Appointment
//
//  Created by feiwu on 16/7/18.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZYImageView.h"
#import "MZYActionSheet.h"
#import "UserInfoModel.h"
@class MyViewController;
@interface MyHeadView : UIView<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property(nonatomic,strong)UIImageView *backgroundImageView;
@property(nonatomic,strong)MZYImageView *userImageView;
@property(nonatomic,strong)UILabel *userNickLabel;
@property(nonatomic,strong)UIButton *userinfoButton;
@property(nonatomic,strong)UIImageView *vipImageView;
@property(nonatomic,strong)UIImageView *writeImageView;
@property(nonatomic,strong)UIButton *uploadButton;
/**语音介绍按钮 */
@property (strong, nonatomic) UIButton* voiceIntroduced;
@property(nonatomic,strong)UIScrollView *uploadScroll;
@property(nonatomic,strong)UIView *lastView;

@property(nonatomic,copy)NSString *uploadType;//上传类型
@property(nonatomic,copy)NSMutableArray *photoArray;//图片数组
@property(nonatomic,copy)NSMutableArray *imageViewArray;//图片视图数组
@property(nonatomic,strong)UserInfoModel *infoModel;

@property(nonatomic,strong)MZYImageView *backgroundView;//菜单背景
@property(nonatomic,strong)MZYActionSheet *actionSheet;//“菜单视图
@end
