//
//  SelectTableViewCell.m
//  Appointment
//
//  Created by feiwu on 16/7/8.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "SelectTableViewCell.h"
#import "FateHelloApi.h"
#import "SelectViewController.h"
#import "NearbyViewController.h"
#import "MyAddentionViewController.h"
#import "MyVisitorViewController.h"
#import "NSString+MZYExtension.h"
@implementation SelectTableViewCell

#pragma mark - Life Cycle
//生命周期方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
        [self makeConstraints];
    }
    return self;
}

#pragma mark - Private Methods
//私有方法
#pragma mark 初始化
- (void)initView
{
    [self addSubview:self.userImageView];
    [self addSubview:self.userMaskView];
    [self addSubview:self.greetButton];
    [self addSubview:self.nickLabel];
    [self addSubview:self.vipImageView];
    [self addSubview:self.ageAndLocationLabel];
    [self addSubview:self.phogoImageView];
    [self addSubview:self.photoLabel];
    [self addSubview:self.heightLabel];
    [self addSubview:self.tagButton];
    [self addSubview:self.characterButton];
    [self addSubview:self.locationImageView];
    [self addSubview:self.locationLabel];
    [self addSubview:self.lineView];
}

#pragma mark 布局
- (void)makeConstraints
{
    WS(weakSelf);
    [_userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(weakSelf).offset(12);
        make.size.mas_equalTo(CGSizeMake(75, 75));
    }];
    
    [_userMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(weakSelf).offset(12);
        make.size.mas_equalTo(CGSizeMake(75, 75));
    }];
    
    
    [_greetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(kPercentIP6(95), 40));
    }];
    
    [_nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.userImageView.mas_right).offset(10);
        make.top.mas_equalTo(weakSelf).offset(14);
        make.width.mas_equalTo(0);
    }];
    
    [_vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nickLabel.mas_right).offset(3);
        make.centerY.mas_equalTo(weakSelf.nickLabel);
        make.size.mas_equalTo(CGSizeMake(27, 12));
    }];
    
    [_ageAndLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.userImageView.mas_right).offset(10);
        make.top.mas_equalTo(weakSelf.nickLabel.mas_bottom).offset((75 - kPercentIP6(16) - 2 - kPercentIP6(14) - 2 - 5.5 - 2 - kPercentIP6(14) - 2) / 2.0);
    }];
    
    [_phogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.ageAndLocationLabel.mas_right).offset(7.5);
        make.centerY.mas_equalTo(weakSelf.ageAndLocationLabel);
        make.size.mas_equalTo(CGSizeMake(15, 13));
    }];
    
    [_photoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.phogoImageView.mas_right).offset(3);
        make.top.mas_equalTo(weakSelf.ageAndLocationLabel.mas_top).offset(1);
    }];
    
    
    [_heightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.userImageView.mas_right).offset(10);
        make.bottom.mas_equalTo(weakSelf.userImageView.mas_bottom).offset(-5.5);
    }];
    
    
    [_tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.userImageView.mas_right).offset(10);
        make.top.mas_equalTo(weakSelf.userImageView.mas_bottom).offset(0);
        //        make.size.mas_equalTo(CGSizeMake(80, 16));
    }];
    
    [_characterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.tagButton.mas_right).offset(10);
        make.top.mas_equalTo(weakSelf.userImageView.mas_bottom).offset(0);
        //        make.size.mas_equalTo(CGSizeMake(80, 16));
    }];
    
    
    [_locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.locationLabel.mas_left).offset(-5);
        make.top.mas_equalTo(weakSelf.userImageView.mas_top).offset(3);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf).offset(-30);
        make.top.mas_equalTo(weakSelf.userImageView.mas_top).offset(0);
    }];
    
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 1));
    }];
}

#pragma mark - Public Methods
//公有方法
#pragma mark 选中方法
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Event Responses
- (void)handleHelloAction:(UIButton *)button
{
    if ([self.viewController isKindOfClass:[SelectViewController class]]) {
        [MobClick event:@"selectHello"];
    } else if ([self.viewController isKindOfClass:[NearbyViewController class]]){
        [MobClick event:@"nearbyHello"];
    } else  if([self.viewController isKindOfClass:[MyAddentionViewController class]]){
        [MobClick event:@"addentionHello"];
    } else if([self.viewController isKindOfClass:[MyVisitorViewController class]]){
        [MobClick event:@"visitorHello"];
    }
    
    [self setHelloRequestWithMid:_model.user_id];
    
}
#pragma mark - "控件代理方法"
//控件代理方法

#pragma mark - Notification Responses
//通知响应方法

#pragma mark - Network Data
#pragma mark - 设置打招呼
- (void)setHelloRequestWithMid:(NSString *)mid {
    NSLog(@"用戶是:%@",mid);
    id fate;
    if ([self.viewController isKindOfClass:[SelectViewController class]]) {
        fate = (SelectViewController *)self.viewController;
    } else if ([self.viewController isKindOfClass:[NearbyViewController class]]){
        fate = (NearbyViewController *)self.viewController;
    } else {
        fate = (MyAddentionViewController *)self.viewController;
    }
    
    FateHelloApi *api = [[FateHelloApi alloc] initWithMid:mid];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSLog(@"打招呼成功输出数据:%@", request.responseJSONObject);
        
    } failure:^(YTKBaseRequest *request) {
        
        
    }];
    
    [fate showHUDComplete:NSLocalizedString(@"打招呼成功", nil)];
    [fate hideHUDDelay:1.5];
    
    [_greetButton setImage:LOADIMAGE(NSLocalizedString(@"nearby_hello_highlight", nil), @"png") forState:UIControlStateNormal];
    [_greetButton setBackgroundImage:[UIImage imageNamed:@"nearby_hello_highlightbackground@2x" ImageType:@"png"  withTop:20 andLeft:40] forState:UIControlStateNormal];
    [_greetButton setBackgroundImage:[UIImage imageNamed:@"nearby_hello_highlightbackground@2x" ImageType:@"png" withTop:20 andLeft:40] forState:UIControlStateHighlighted];
    [_greetButton setTitle:NSLocalizedString(@"已打招呼", nil) forState:UIControlStateNormal];
    [_greetButton setTitle:NSLocalizedString(@"已打招呼", nil) forState:UIControlStateHighlighted];
    [_greetButton setTitleColor:Color10(219, 219, 219, 1) forState:UIControlStateNormal];
    _greetButton.enabled = NO;
    
    if ([self.viewController isKindOfClass:[SelectViewController class]]) {
        SelectViewController  *select = (SelectViewController *)self.viewController;
        [select.selectedArray addObject:_model.user_id];//添加到已选中数组中
        
        //改变helloed值
        NSMutableArray *temp = [NSMutableArray array];
        for (FateModel *model in select.selectDataArray) {
            if ([model.user_id isEqualToString:_model.user_id]) {
                model.helloed = @"2";
            }
            [temp addObject:model];
        }
        select.selectDataArray = temp;//列表数据重新赋予
        
        
    } else if ([self.viewController isKindOfClass:[NearbyViewController class]]){
        NearbyViewController *nearby = (NearbyViewController *)self.viewController;
        [nearby.selectedArray addObject:_model.user_id];//添加到已选中数组中
        
        //改变helloed值
        NSMutableArray *temp = [NSMutableArray array];
        for (FateModel *model in nearby.nearbyDataArray) {
            if ([model.user_id isEqualToString:_model.user_id]) {
                model.helloed = @"2";
            }
            [temp addObject:model];
        }
        nearby.nearbyDataArray = temp;//列表数据重新赋予
        
    } else  if([self.viewController isKindOfClass:[MyAddentionViewController class]]){
        MyAddentionViewController *addention = (MyAddentionViewController *)self.viewController;
        [addention.selectedArray addObject:_model.user_id];//添加到已选中数组中
        
        //改变helloed值
        NSMutableArray *temp = [NSMutableArray array];
        for (FateModel *model in addention.addentionDataArray) {
            if ([model.user_id isEqualToString:_model.user_id]) {
                model.helloed = @"2";
            }
            [temp addObject:model];
        }
        addention.addentionDataArray = temp;//列表数据重新赋予
        
    } else if([self.viewController isKindOfClass:[MyVisitorViewController class]]){
        MyVisitorViewController *visitor = (MyVisitorViewController *)self.viewController;
        //改变helloed值
        NSMutableArray *temp = [NSMutableArray array];
        for (FateModel *model in visitor.visitorDataArray) {
            if ([model.user_id isEqualToString:_model.user_id]) {
                model.helloed = @"2";
            }
            [temp addObject:model];
        }
        visitor.visitorDataArray = temp;//列表数据重新赋予
        
    }
    
    
}


#pragma mark - Getters And Setters
- (UIImageView *)userImageView {
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.clipsToBounds = YES;
        _userImageView.contentMode = UIViewContentModeScaleAspectFill;
        _userImageView.image = LOADIMAGE(NSLocalizedString(@"fate_headPlaceholder", nil), @"png");
    }
    return _userImageView;
}

- (UIImageView *)userMaskView {
	if (!_userMaskView) {
		_userMaskView = [[UIImageView alloc] init];
        _userMaskView.image = LOADIMAGE(@"nearby_userMask@2x", @"png");
	}
	return _userMaskView;
}

- (UIButton *)greetButton {
    if (!_greetButton) {
        _greetButton = [[UIButton alloc] init];
        [_greetButton addTarget:self action:@selector(handleHelloAction:) forControlEvents:UIControlEventTouchUpInside];
        [_greetButton setImage:LOADIMAGE(NSLocalizedString(@"nearby_hello_default", nil), @"png") forState:UIControlStateNormal];
        [_greetButton setImage:LOADIMAGE(NSLocalizedString(@"nearby_hello_highlight", nil), @"png") forState:UIControlStateHighlighted];
        [_greetButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kPercentIP6(10))];
        
        [_greetButton setTitle:NSLocalizedString(@"打招呼", nil) forState:UIControlStateNormal];
        [_greetButton setTitle:NSLocalizedString(@"打招呼", nil) forState:UIControlStateHighlighted];
        [_greetButton setTitleEdgeInsets:UIEdgeInsetsMake(0, kPercentIP6(10), 0, 0)];
        
        _greetButton.titleLabel.font = [UIFont systemFontOfSize:kPercentIP6(14)];
        [_greetButton setTitleColor:Color16(0xF85F73) forState:UIControlStateNormal];
        
        [_greetButton setBackgroundImage:[UIImage imageNamed:@"nearby_hello_defaultBackground@2x"ImageType:@"png" withTop:20 andLeft:40] forState:UIControlStateNormal];
        [_greetButton setBackgroundImage:[UIImage imageNamed:@"nearby_hello_defaultBackground@2x" ImageType:@"png"withTop:20 andLeft:40] forState:UIControlStateHighlighted];
    }
    return _greetButton;
}

- (UILabel *)nickLabel {
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc] init];
//                _nickLabel.backgroundColor = [UIColor lightGrayColor];
        _nickLabel.font = [UIFont systemFontOfSize:kPercentIP6(16)];
        _nickLabel.textColor = Color10(51, 51, 51, 1);
        [_nickLabel sizeToFit];
    }
    return _nickLabel;
}

- (UILabel *)ageAndLocationLabel {
    if (!_ageAndLocationLabel) {
        _ageAndLocationLabel = [[UILabel alloc] init];
//                _ageAndLocationLabel.backgroundColor = [UIColor lightGrayColor];
        _ageAndLocationLabel.font = [UIFont systemFontOfSize:kPercentIP6(14)];
        _ageAndLocationLabel.textColor = Color10(153, 153, 153, 1);
        [_ageAndLocationLabel sizeToFit];
        
    }
    return _ageAndLocationLabel;
}

- (UIButton *)tagButton {
    if (!_tagButton) {
        _tagButton = [[UIButton alloc] init];
        _tagButton.titleLabel.font = [UIFont systemFontOfSize:kPercentIP6(12)];
        [_tagButton setTitleColor:Color10(153, 153, 153, 1) forState:UIControlStateNormal];
        //        _tagButton.backgroundColor = [UIColor lightGrayColor];
        [_tagButton setBackgroundImage:[UIImage imageNamed:@"common_hobbyBackground@2x" ImageType:@"png" withTop:5 andLeft:10] forState:UIControlStateNormal];
    }
    return _tagButton;
}

- (UIButton *)characterButton {
    if (!_characterButton) {
        _characterButton = [[UIButton alloc] init];
        _characterButton.titleLabel.font = [UIFont systemFontOfSize:kPercentIP6(12)];
        [_characterButton setTitleColor:Color10(153, 153, 153, 1) forState:UIControlStateNormal];
        //        _tagButton.backgroundColor = [UIColor lightGrayColor];
        [_characterButton setBackgroundImage:[UIImage imageNamed:@"common_hobbyBackground@2x" ImageType:@"png" withTop:5 andLeft:10] forState:UIControlStateNormal];
    }
    return _characterButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = Color10(239, 239, 239, 1);
    }
    return _lineView;
}

- (UIImageView *)locationImageView {
    if (!_locationImageView) {
        _locationImageView = [[UIImageView alloc] init];
        _locationImageView.image = LOADIMAGE(@"nearby_location_gps@2x", @"png");
    }
    return _locationImageView;
}

- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        _locationLabel.font = [UIFont systemFontOfSize:kPercentIP6(14)];
        _locationLabel.textColor = Color10(153, 153, 153, 1);
        [_locationLabel sizeToFit];
//                _locationLabel.backgroundColor = [UIColor orangeColor];
    }
    return _locationLabel;
}
- (UILabel *)heightLabel {
	if (!_heightLabel) {
		_heightLabel = [[UILabel alloc] init];
//        _heightLabel.backgroundColor = [UIColor orangeColor];
        _heightLabel.font = [UIFont systemFontOfSize:kPercentIP6(14)];
        _heightLabel.textColor = Color10(153, 153, 153, 1);
        [_heightLabel sizeToFit];

	}
	return _heightLabel;
}
- (UIImageView *)vipImageView {
    if (!_vipImageView) {
        _vipImageView = [[UIImageView alloc] init];
        _vipImageView.image =LOADIMAGE(@"select_vip@2x", @"png");
        _vipImageView.hidden = YES;
    }
    return _vipImageView;
}

- (UIImageView *)phogoImageView {
    if (!_phogoImageView) {
        _phogoImageView = [[UIImageView alloc] init];
        _phogoImageView.image = LOADIMAGE(@"nearby_photonum@2x", @"png");
    }
    return _phogoImageView;
}
- (UILabel *)photoLabel {
    if (!_photoLabel) {
        _photoLabel = [[UILabel alloc] init];
        _photoLabel.textAlignment = NSTextAlignmentLeft;
        _photoLabel.font = [UIFont systemFontOfSize:kPercentIP6(14)];
        _photoLabel.textColor = Color10(153, 153, 153, 1);
        [_photoLabel sizeToFit];
        
    }
    return _photoLabel;
}
- (void)setModel:(FateModel *)model
{
    _model = model;
    
    if (_model.distance.length > 1) {
        _locationImageView.hidden = NO;
        _locationLabel.hidden = NO;
        _locationLabel.text = [NSString stringWithFormat:@"%@km",_model.distance];
    } else {
        _locationImageView.hidden = YES;
        _locationLabel.hidden = YES;
        
    }
 
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:LOADIMAGE(NSLocalizedString(@"fate_headPlaceholder", nil), @"png") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    _nickLabel.text = _model.name;
    
    if (![_model.city  isEqualToString:@""]) {
        _ageAndLocationLabel.text = [NSString stringWithFormat:@"%@%@ %@",_model.age,NSLocalizedString(@"岁", nil),_model.city];
    } else {
        _ageAndLocationLabel.text = [NSString stringWithFormat:@"%@%@ %@",_model.age,NSLocalizedString(@"岁", nil),_model.region_name];
    }
    CGFloat ageWidth = [_model.name textWidthWithContentHeight:20 font:[UIFont systemFontOfSize:kPercentIP6(16)]] + 2;
    if (ageWidth > ScreenWidth - 155 - kPercentIP6(95)) {
        ageWidth = ScreenWidth - 155 - kPercentIP6(95);
    }
    [_nickLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ageWidth);
    }];
    
    //是否是vip
    if ([_model.flag_vip isEqualToString:@"0"]) {
        //不是vip
        _vipImageView.hidden = YES;
    } else if ([_model.flag_vip isEqualToString:@"1"]) {
        //是VIP
        _vipImageView.hidden = NO;
    } else {
        _vipImageView.hidden = YES;
    }
    
   
    
    //身高与收入7
    if ([_model.height intValue] > 0) {
        _heightLabel.text = [NSString stringWithFormat:@"%@cm %@",_model.height,_model.income];
    } else {
        _heightLabel.text = [NSString stringWithFormat:@"%@",_model.income];
    }
    
    //图片个数
    if ([_model.photo_nums intValue] > 0) {
        _photoLabel.hidden = NO;
        _phogoImageView.hidden = NO;
        _photoLabel.text = [NSString stringWithFormat:@"%@",_model.photo_nums];
    } else {
        _photoLabel.hidden = YES;
        _phogoImageView.hidden = YES;
    }
    
    //标签
    WS(weakSelf);
    if (![_model.hobby isEqualToString:@""]) {
        _tagButton.hidden = NO;
        NSArray *tagArray = [_model.hobby componentsSeparatedByString:@","];
        CGFloat tagWidth;
        if (tagArray.count > 0) {
            [_tagButton setTitle:[tagArray firstObject] forState:UIControlStateNormal];
            tagWidth = [[tagArray firstObject] textHeightWithContentWidth:20 font:[UIFont systemFontOfSize:kPercentIP6(12)]]+ 10;
        } else {
            [_tagButton setTitle:_model.hobby forState:UIControlStateNormal];
            tagWidth = [_model.hobby textHeightWithContentWidth:20 font:[UIFont systemFontOfSize:kPercentIP6(12)]]+ 10;
            
        }
        
        [_tagButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.userImageView.mas_right).offset(10);
            make.top.mas_equalTo(weakSelf.userImageView.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(tagWidth, 20));
        }];
        
    } else {
        _tagButton.hidden = YES;
    }
    
    //性格
    if (![_model.features isEqualToString:@""]) {
        _characterButton.hidden = NO;
        NSArray *characterArray = [_model.features componentsSeparatedByString:@","];
        CGFloat characterWidth;
        if (characterArray.count > 0) {
            [_characterButton setTitle:[characterArray firstObject] forState:UIControlStateNormal];
            characterWidth = [[characterArray firstObject] textHeightWithContentWidth:20 font:kFont12]+ 10;
        } else {
            [_characterButton setTitle:_model.features forState:UIControlStateNormal];
            characterWidth = [_model.features textHeightWithContentWidth:20 font:kFont12]+ 10;
            
        }
        [_characterButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.tagButton.mas_right).offset(10);
             make.top.mas_equalTo(weakSelf.userImageView.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(characterWidth, 20));
        }];
    } else {
        _characterButton.hidden = YES;
    }
    
    //是否已经打招呼
    NSLog(@"当前打招呼的状态:%@",_model.helloed);
    if ([_model.helloed intValue] == 2) {
        
        [_greetButton setImage:LOADIMAGE(NSLocalizedString(@"nearby_hello_highlight", nil), @"png") forState:UIControlStateNormal];
        [_greetButton setBackgroundImage:[UIImage imageNamed:@"nearby_hello_highlightbackground@2x" ImageType:@"png"withTop:20 andLeft:40] forState:UIControlStateNormal];
        [_greetButton setBackgroundImage:[UIImage imageNamed:@"nearby_hello_highlightbackground@2x"ImageType:@"png" withTop:20 andLeft:40] forState:UIControlStateHighlighted];
        [_greetButton setTitle:@"已招呼" forState:UIControlStateNormal];
        [_greetButton setTitle:@"已招呼" forState:UIControlStateHighlighted];
        [_greetButton setTitleColor:Color10(219, 219, 219, 1) forState:UIControlStateNormal];
        _greetButton.enabled = NO;
        
    } else {
        [_greetButton setImage:LOADIMAGE(NSLocalizedString(@"nearby_hello_default", nil), @"png") forState:UIControlStateNormal];
        [_greetButton setBackgroundImage:[UIImage imageNamed:@"nearby_hello_defaultBackground@2x"ImageType:@"png" withTop:20 andLeft:40] forState:UIControlStateNormal];
        [_greetButton setBackgroundImage:[UIImage imageNamed:@"nearby_hello_defaultBackground@2x" ImageType:@"png"withTop:20 andLeft:40] forState:UIControlStateHighlighted];
        [_greetButton setTitle:NSLocalizedString(@"打招呼", nil) forState:UIControlStateNormal];
        [_greetButton setTitle:NSLocalizedString(@"打招呼", nil) forState:UIControlStateHighlighted];
        [_greetButton setTitleColor:Color16(0xF85F73) forState:UIControlStateNormal];
        _greetButton.enabled = YES;
    }
    
    
}


@end
