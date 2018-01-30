//
//  UICollectionView+Handle.h
//  Appointment
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (Handle)
- (void)collectionViewDisplayWitMsg:(NSString *)message imageName:(NSString *)imageName imageType:(NSString *)imageType ifNecessaryForRowCount:(NSUInteger)rowCount;
@end
