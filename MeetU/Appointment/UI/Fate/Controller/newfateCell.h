//
//  newfateCell.h
//  taiwantongcheng
//
//  Created by wanchangwen on 2017/11/28.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewfateModel.h"
@interface newfateCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIButton *letfBtn;
@property (weak, nonatomic) IBOutlet UIImageView *sexicon;
@property (weak, nonatomic) IBOutlet UIImageView *vipicon;
@property (weak, nonatomic) IBOutlet UILabel *detailabel;
@property(nonatomic,strong)NewfateModel * model;
@end
