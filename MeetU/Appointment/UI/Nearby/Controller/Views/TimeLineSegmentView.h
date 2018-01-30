//
//  TimeLineSegmentView.h
//  TimeLine
//
//  Created by oujinlong on 16/6/13.
//  Copyright © 2016年 oujinlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimeLineSegmentViewDelegate <NSObject>

-(void)TimeLineSegmentViewDidClickButtonWithIndex:(NSInteger)index;

@end
@interface TimeLineSegmentView : UIView
@property (nonatomic, weak) id <TimeLineSegmentViewDelegate> delegate;


-(void)setCurrentPageIndex:(NSInteger)index;
@end
