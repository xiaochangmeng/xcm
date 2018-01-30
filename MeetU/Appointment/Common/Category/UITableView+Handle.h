//
//  UITableView+Handle.h
//  Appointment
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Handle)

/**
 *  tableview无数据时间处理   无网络  等
 *
 *  @param message   要显示的内容
 *  @param imageName 要显示的图片
 *  @param imageType 图片类型  png or jpg
 *  @param rowCount  当前的cell的总数  
 */
- (void) tableViewDisplayWitMsg:(NSString *) message imageName:(NSString*)imageName imageType:(NSString*)imageType ifNecessaryForRowCount:(NSUInteger) rowCount;

/**
 *  单纯改变一句话中的某些字的颜色
 *
 *  @param color    需要改变成的颜色
 *  @param totalStr 总的字符串
 *  @param subArray 需要改变颜色的文字数组
 *
 *  @return 生成的富文本
 */
- (NSMutableAttributedString *)changeCorlorWithColor:(UIColor *)color TotalString:(NSString *)totalStr SubStringArray:(NSArray *)subArray;
@end
