//
//  FUImageView.h
//  Created by feiwu on 16/7/20.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImageBlock)(void);

@interface MZYImageView : UIImageView

@property (nonatomic,copy)ImageBlock touchBlock;

@end
