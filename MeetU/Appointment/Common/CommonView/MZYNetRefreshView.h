//
//  FUCenterNetRefreshView.h
//  SportIM
//
//  Created by Mac-apple on 15/11/10.
//  Copyright © 2015年 广州晌网文化传播有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^RefreshBlock)(void);//刷新
@interface MZYNetRefreshView : UIView

@property (nonatomic,copy) RefreshBlock refreshBlock;
@property(nonatomic, strong)UIButton *refreshButton;
@property(nonatomic, strong)UILabel *refreshLabel;

@end
