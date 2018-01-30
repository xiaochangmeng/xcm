//
//  newfateCell.m
//  taiwantongcheng
//
//  Created by wanchangwen on 2017/11/28.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "newfateCell.h"

@implementation newfateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.detailabel.textColor = [UIColor whiteColor];
}


-(void)setModel:(NewfateModel *)model{
    _model = model;
    [self.iconView  sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    if ([model.flag_vip isEqualToString:@"0"]) {
        self.vipicon.hidden = YES;
    }else{
        self.vipicon.hidden = NO;
    }
    
    
    if ([model.hot isEqualToString:@"0"]) {
        self.letfBtn.hidden = YES;
    }else{
        self.letfBtn.hidden = NO;
    }
    
    if ([model.sex isEqualToString:@"0"]) {
        [self.sexicon setImage:[UIImage imageNamed:@"sex_girl"]];
    }else{
        [self.sexicon setImage:[UIImage imageNamed:@"sex_boy"]];
    }
    
    self.detailabel.text = [NSString stringWithFormat:@"%@|%@",model.name,model.age];
    
}
@end
