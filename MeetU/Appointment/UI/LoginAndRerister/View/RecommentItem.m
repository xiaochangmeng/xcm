//
//  RecommentItem.m
//  Appointment
//
//  Created by feiwu on 16/7/25.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "RecommentItem.h"

@implementation RecommentItem

- (instancetype)initWithIdentifier:(NSString *)identifier {
    self = [super initWithIdentifier:identifier];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [Color10(237, 237, 237, 1) CGColor];
        [self initView];
    }
    return self;
}

#pragma mark 初始化
- (void)initView
{
    [self addSubview:self.imageView];
    [self addSubview:self.infoView];
    [_infoView addSubview:self.nickLabel];
    [_infoView addSubview:self.ageLabel];
}


#pragma mark - Getters And Setters
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}
- (UIView *)infoView {
	if (!_infoView) {
		_infoView = [[UIView alloc] init];
        _infoView.backgroundColor = [UIColor whiteColor];
	}
	return _infoView;
}

- (UILabel *)nickLabel {
	if (!_nickLabel) {
		_nickLabel = [[UILabel alloc] init];
//        _nickLabel.backgroundColor = [UIColor orangeColor];
        _nickLabel.font = [UIFont systemFontOfSize:kPercentIP6(16)];
        _nickLabel.textAlignment = NSTextAlignmentCenter;
        _nickLabel.textColor = Color10(102, 102, 102, 1);
	}
	return _nickLabel;
}

- (UILabel *)ageLabel {
	if (!_ageLabel) {
		_ageLabel = [[UILabel alloc] init];
        _ageLabel.font = [UIFont systemFontOfSize:kPercentIP6(13)];
        _ageLabel.textAlignment = NSTextAlignmentCenter;
        _ageLabel.textColor = Color10(153, 153, 153, 1);
//        _ageLabel.backgroundColor = [UIColor orangeColor];
	}
	return _ageLabel;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.imageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - kHeightIP6(72));
    self.infoView.frame = CGRectMake(0, self.bounds.size.height - kHeightIP6(72), self.bounds.size.width, kHeightIP6(72));
    self.nickLabel.frame = CGRectMake(0, kHeightIP6(11), self.bounds.size.width, 20);
    self.ageLabel.frame = CGRectMake(0, kHeightIP6(38), self.bounds.size.width, 20);
    
}


@end
