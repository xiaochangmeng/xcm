//
//  MyTabBarView.h
//  Created by feiwu on 16/7/20.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.//

#import <UIKit/UIKit.h>
#import "MZYLabel.h"
@interface TabBarView : UIView

- (id)initWithIndex:(int)index;


@property(nonatomic,assign)int index;
@property(nonatomic, strong)MZYLabel *countLabel;

@property(nonatomic, strong) UIButton *fateButton;//缘分button


@property(nonatomic, strong) UIButton *letterButton;//訊息button


@property(nonatomic, strong) UIButton *nearbyButton;//附近button

@property(nonatomic, strong) UIButton *myButton;//我的button


@end
