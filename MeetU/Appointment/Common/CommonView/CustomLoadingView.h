//
//  LoadingViewForOC.h
//  LoadingAnimation
//
//  Created by huangbaoyu on 16/10/23.
//  Copyright © 2016年 chachong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomLoadingView : UIView

+ (CustomLoadingView *)showLoadingWith:(UIView *)view;
+ (CustomLoadingView *)showLoadingWithWindow;
- (void)hideLoadingView;
@end
