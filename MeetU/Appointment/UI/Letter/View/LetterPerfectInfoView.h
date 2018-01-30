//
//  LetterPerfectInfoView.h
//  Appointment
//
//  Created by feiwu on 16/7/14.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^PerfectBlock) ();
@interface LetterPerfectInfoView : UIView
@property(nonatomic,strong)UIImageView *perfectImageView;
@property(nonatomic,strong)UILabel *perfectLabel;
@property(nonatomic,strong)UIImageView *arrowImageView;
@property(nonatomic,strong)UIView *lineView;
@property (nonatomic, copy) PerfectBlock perfectBlock;
@end
