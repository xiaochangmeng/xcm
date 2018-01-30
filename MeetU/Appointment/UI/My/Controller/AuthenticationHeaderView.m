//
//  AuthenticationHeaderView.m
//  Appointment
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "AuthenticationHeaderView.h"
@interface AuthenticationHeaderView()

/**提高你的诚信等级 */
@property (strong, nonatomic) UIImageView* authenticationInstructionsImageView;

/**诚信等级 */
@property (strong, nonatomic) UILabel* starLevelLabel;
/**星星数量 */
@property (strong, nonatomic) UILabel* starCountLabel;

@end
@implementation AuthenticationHeaderView

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setBackgroundColor:Color10(34, 24, 46, 1)];
    
    [self setupView];
    
}

- (void)setupView{
    [self addSubview:self.authenticationInstructionsImageView];
    
    [self addSubview:self.starLevelLabel];
    
    [self addSubview:self.starCountLabel];
    
    [self setupConstraints];
}

- (void)setupConstraints{
    WS(weakSelf);
    [_authenticationInstructionsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf).offset(kHeightIP6(29));
        make.left.mas_equalTo(weakSelf).offset(kPercentIP6(34));
        make.width.mas_equalTo(kPercentIP6(150));
        make.height.mas_equalTo(kHeightIP6(50));
    }];
    
    [_starLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.authenticationInstructionsImageView.mas_bottom).offset(kHeightIP6(9.5));
        make.left.mas_equalTo(weakSelf).offset(kPercentIP6(37));
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(kHeightIP6(20));
    }];
    
    [_starCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.starLevelLabel.mas_centerY).offset(0);
        make.right.mas_equalTo(weakSelf).offset(-kPercentIP6(34.5));
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(kHeightIP6(20));
        [weakSelf setTextAttribute:weakSelf.starCountLabel string:weakSelf.starCountLabel.text count:2];
    }];

}



/**以下是懒加载 */
- (UIImageView *)authenticationInstructionsImageView{
    if (_authenticationInstructionsImageView == nil) {
        _authenticationInstructionsImageView = [UIImageView new];
        _authenticationInstructionsImageView.image = LOADIMAGE(@"authenticationInstructions@2x", @"png");
    }
    return _authenticationInstructionsImageView;
}

- (UILabel *)starLevelLabel{
    if (_starLevelLabel == nil) {
        _starLevelLabel = [UILabel new];
        [_starLevelLabel setText:@"当前等级 2星"];
        [_starLevelLabel setTextColor:[UIColor whiteColor]];
        _starLevelLabel.font = [UIFont systemFontOfSize:kPercentIP6(14)];
    }
    return _starLevelLabel;
}

- (UILabel *)starCountLabel{
    if (_starCountLabel == nil) {
        _starCountLabel = [UILabel new];
        _starCountLabel.text = @"★★★★★";
        _starCountLabel.textColor = Color10(61, 56, 68, 1);
        _starCountLabel.font = [UIFont systemFontOfSize:kPercentIP6(20)];
    }
    return _starCountLabel;
}

- (void)setTextAttribute:(UILabel*)label string:(NSString*)string count:(NSUInteger)count{
    //设置字符串颜色
    if (string == nil) {
        return;
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    
    [str addAttribute:NSForegroundColorAttributeName value:Color10(242, 242, 242, 1) range:NSMakeRange(0, count)];
    label.attributedText = str;
}


@end
