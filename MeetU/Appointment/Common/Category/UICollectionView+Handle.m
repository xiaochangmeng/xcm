//
//  UICollectionView+Handle.m
//  Appointment
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "UICollectionView+Handle.h"

@implementation UICollectionView (Handle)
- (void)collectionViewDisplayWitMsg:(NSString *)message imageName:(NSString *)imageName imageType:(NSString *)imageType ifNecessaryForRowCount:(NSUInteger)rowCount{
    if (rowCount == 0) {
        // Display a message when the table is empty
        UIView* view = [[UIView alloc]init];
        UILabel *messageLabel = [UILabel new];
        messageLabel.text = message;
        
        messageLabel.font = [UIFont systemFontOfSize:14];
        messageLabel.textColor = Color10(153, 153, 153, 1);
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        
        UIImageView* imageView = [[UIImageView alloc]initWithImage:LOADIMAGE(imageName, imageType)];
        
        CGFloat imageViewWidth = 230 * SCREEN_WIDTH / 375;
        CGFloat imageViewHeight = 210 * SCREEN_HEIGHT / 667;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        CGFloat imageViewToTopDistance = 72.5 * SCREEN_HEIGHT / 667;
        
        imageView.frame = CGRectMake(SCREEN_WIDTH / 2 - imageViewWidth / 2, imageViewToTopDistance, imageViewWidth, imageViewHeight);
        
        messageLabel.frame = CGRectMake(0, imageView.frame.origin.y + imageView.frame.size.height + 10, SCREEN_WIDTH, 30);
        
        
        
        [view addSubview:messageLabel];
        [view addSubview:imageView];
        
        
        self.backgroundView = view;
//        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.backgroundView = nil;
//        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
}

@end
