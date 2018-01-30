//
//  WhoSeeMeCollectionView.h
//  Appointment
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WhoSeeMeController;
@interface WhoSeeMeCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) NSMutableArray* dataArray;
@end
