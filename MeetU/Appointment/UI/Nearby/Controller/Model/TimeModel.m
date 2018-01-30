//
//  TimeModel.m
//  TimeLine
//
//  Created by oujinlong on 16/6/12.
//  Copyright © 2016年 oujinlong. All rights reserved.
//

#import "TimeModel.h"
extern CGFloat max_content_height;
@implementation TimeModel

-(BOOL)shouldShowAllButton{
    NSString* content = self.content;
    CGRect rect = [content boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    CGFloat textHeight = rect.size.height;
    BOOL isShow = (max_content_height > textHeight);
    return  isShow;
}
@end
@implementation ContentImageModel



@end
