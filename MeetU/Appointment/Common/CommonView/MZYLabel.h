//
//  FULabel.h
//  Created by feiwu on 16/7/20.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.//

#import <UIKit/UIKit.h>

typedef void(^LabelBlock)(void);

@interface MZYLabel : UILabel

@property (nonatomic,copy)LabelBlock touchBlock;

- (id)initWithCircleWidth:(float)width; //圆边

@end
