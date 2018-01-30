//
//  AuthenticationCell.h
//  Appointment
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthenticationEntity.h"
typedef void (^AuthenticationCellButtonClick)(NSUInteger tag);
@interface AuthenticationCell : UICollectionViewCell
@property (strong, nonatomic) AuthenticationEntity* authenticationEntity;
@property (strong, nonatomic) AuthenticationCellButtonClick buttonClick;
@end
