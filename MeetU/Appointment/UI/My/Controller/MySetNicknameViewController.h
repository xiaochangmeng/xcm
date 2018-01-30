//
//  MySetInfoViewController.h
//  Appointment
//
//  Created by feiwu on 16/7/18.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "UserInfoModel.h"

typedef void(^ModifyNameBlock) (NSString *name);
@interface MySetNicknameViewController : CustomViewController<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *userCountText;
@property(nonatomic,strong)UIView *userCountLineView;
@property(nonatomic,strong)UserInfoModel *InfoModel;
@property(nonatomic,copy)ModifyNameBlock modifyNameBlock;


@end
