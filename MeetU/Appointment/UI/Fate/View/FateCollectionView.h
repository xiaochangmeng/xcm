//
//  FateCollectionView.h
//  Appointment
//
//  Created by feiwu on 16/7/8.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FateViewController;
static NSString *identify = @"cellreuse";
static NSString *headIdentify = @"Headcellreuse";
@interface FateCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSMutableArray *fateDataArray;
@property(nonatomic,assign)BOOL isRefresh;
@property(nonatomic,assign)int page;
- (void)getFateListRequest:(NSString *)type;

@end
