//
//  FUTabView.h
//  UTalkSport
//
//  Created by feiwu on 16/7/20.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^TabBlock)(int index);//轻拍之后回调

@interface MZYTabView : UIView<UIScrollViewDelegate>

//ScrollView
@property (nonatomic,strong)UIScrollView *scrollView;

//标题数组
@property (nonatomic,strong)NSArray *titleArray;

//标签数组
@property (nonatomic,strong)NSMutableArray *labelArray;

//
@property (nonatomic,strong)NSMutableArray *lineViewArray;

//轻拍回调
@property (nonatomic,strong)TabBlock tabBlock;

//代码轻拍某一项
- (void)tabIndex:(int)index;


@end
