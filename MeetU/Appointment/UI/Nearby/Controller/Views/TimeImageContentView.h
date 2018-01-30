//
//  TimeImageContentView.h
//  TimeLine
//
//  Created by oujinlong on 16/6/13.
//  Copyright © 2016年 oujinlong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeModel.h"
@interface TimeImageContentView : UIView
@property (nonatomic, strong) UIImageView* lastImageView;
@property (nonatomic, strong) NSArray* imageArray;
@property (nonatomic, strong) ContentImageModel* singleImage;
@end
