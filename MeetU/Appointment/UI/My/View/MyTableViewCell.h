//
//  MyTableViewCell.h
//  Appointment
//
//  Created by feiwu on 16/7/18.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *typeImageView;
@property(nonatomic,strong)UILabel *typeLabel;
@property(nonatomic,strong)UILabel *detailLabel;
@property(nonatomic,strong)UIImageView *arrowImageView;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)NSIndexPath *indexPath;
@end
