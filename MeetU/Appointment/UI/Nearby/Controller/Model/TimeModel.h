//
//  TimeModel.h
//  TimeLine
//
//  Created by oujinlong on 16/6/12.
//  Copyright © 2016年 oujinlong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContentImageModel;
@interface TimeModel : NSObject
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSMutableArray <ContentImageModel*>* imageArray;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, assign) NSInteger like_count;
@property(nonatomic,copy)NSString * country_id;
@property(nonatomic,copy)NSArray * dashang_list;
@property(nonatomic,copy)NSString * hits_count;
@property(nonatomic,copy)NSString * id;
@property(nonatomic,copy)NSString * mid;
@property(nonatomic,copy)NSString * send_time;


@property (nonatomic, assign) BOOL isShowAll;
@property (nonatomic, assign) BOOL shouldShowAllButton;
@property (nonatomic, assign) BOOL isLiked;



@end
@interface ContentImageModel : NSObject
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@end
