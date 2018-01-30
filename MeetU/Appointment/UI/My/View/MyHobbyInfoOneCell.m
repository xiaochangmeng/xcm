//
//  MyHobbyInfoCell.m
//  Appointment
//
//  Created by feiwu on 16/8/23.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MyHobbyInfoOneCell.h"
#import "MyInfoViewController.h"
@implementation MyHobbyInfoOneCell
#pragma mark - Life Cycle
//生命周期方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}

#pragma mark - Private Methods
//私有方法
- (void)handleHobbySelectAction:(UIButton *)button
{
    MyInfoViewController *info = (MyInfoViewController *)self.viewController;
    button.selected = !button.selected;
    NSString *imageName;
    UIColor *color;
    NSMutableArray *characterArray = [NSMutableArray arrayWithArray:info.newinfoModel.features];
    if (button.selected) {
        //选中
        imageName = NSLocalizedString(@"my_info_hobbySelected", nil);
        color = Color10(138, 113, 204, 1);
        [characterArray addObject:button.titleLabel.text];
        info.newinfoModel.features = characterArray;
        
    } else {
        //未选中
        imageName = NSLocalizedString(@"my_info_hobbyNoSelect", nil);
        color = Color10(229, 229, 229, 1);
        [characterArray removeObject:button.titleLabel.text];
         info.newinfoModel.features = characterArray;
    }
    
    [button setBackgroundImage:[UIImage imageNamed:imageName ImageType:@"png" withTop:5 andLeft:15] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:imageName ImageType:@"png" withTop:5 andLeft:15] forState:UIControlStateHighlighted];

    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateHighlighted];
    
     [info prefrect:info.newinfoModel];
}

#pragma mark 初始化
- (void)initView
{
    WS(weakSelf);
    NSArray *titleArray = @[NSLocalizedString(@"宅", nil),
                            NSLocalizedString(@"感性", nil),
                            NSLocalizedString(@"体贴", nil),
                            NSLocalizedString(@"憨厚", nil),
                            NSLocalizedString(@"稳重", nil),
                            NSLocalizedString(@"好强", nil),
                            NSLocalizedString(@" 温柔", nil),
                            NSLocalizedString(@"闷骚", nil),
                            NSLocalizedString(@"自我", nil),
                            NSLocalizedString(@" 幽默", nil),
                            NSLocalizedString(@"冷静", nil),
                            NSLocalizedString(@"正直", nil),
                            NSLocalizedString(@" 讲义气", nil),
                            NSLocalizedString(@"孝顺", nil),
                            NSLocalizedString(@" 勇敢", nil),
                            NSLocalizedString(@"有责任心", nil),
                            NSLocalizedString(@" 好动", nil),
                            NSLocalizedString(@"随和", nil)];
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    
    [self addSubview:self.typeLabel];
    [self addSubview:self.lineView];
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(22.5);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(128, 21));
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 1));
    }];

    
    for (int i = 0; i < titleArray.count; i++) {
        int line = i % 4;//列
        int row = i / 4;//行
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(21 + ((ScreenWidth - 63) / 4.0 + 7) * line, 50 + 50 * row, (ScreenWidth - 63) / 4.0, 43)];
        [button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateHighlighted];
         button.titleLabel.font = [UIFont systemFontOfSize:kPercentIP6(14)];;
        
        [button setBackgroundImage:[UIImage imageNamed:NSLocalizedString(@"my_info_hobbyNoSelect", nil) ImageType:@"png" withTop:5 andLeft:15] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:NSLocalizedString(@"my_info_hobbyNoSelect", nil) ImageType:@"png" withTop:5 andLeft:15] forState:UIControlStateHighlighted];
        
        [button setTitleColor:Color10(229, 229, 229, 1) forState:UIControlStateNormal];
        [button setTitleColor:Color10(229, 229, 229, 1) forState:UIControlStateHighlighted];
        button.tag = 9000 + i;
        [button addTarget:self action:@selector(handleHobbySelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonArray addObject:button];
        [self addSubview:button];
    }
}

#pragma mark - Getters And Setters
- (UILabel *)typeLabel {
	if (!_typeLabel) {
		_typeLabel = [[UILabel alloc] init];
        _typeLabel.font = kFont15;
        _typeLabel.textColor = Color10(51, 51, 51, 1);
        _typeLabel.text = NSLocalizedString(@"个性特征", nil);
	}
	return _typeLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = Color10(239, 239, 239, 1);
    }
    return _lineView;
}


- (void)setInfoModel:(UserInfoModel *)infoModel {
    if (_infoModel != infoModel) {
        _infoModel = infoModel;
        
        NSString *imageName;
        UIColor *color;
        for (UIButton *button in _buttonArray) {
            if ([_infoModel.features containsObject:button.titleLabel.text]) {
                //选中
                imageName = NSLocalizedString(@"my_info_hobbySelected", nil);
                color = Color10(138, 113, 204, 1);
                button.selected = YES;
            } else {
                //未选中
                imageName = NSLocalizedString(@"my_info_hobbyNoSelect", nil);
                color = Color10(229, 229, 229, 1);
                button.selected = NO;
            }
            
            [button setBackgroundImage:[UIImage imageNamed:imageName ImageType:@"png" withTop:5 andLeft:15] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:imageName ImageType:@"png" withTop:5 andLeft:15] forState:UIControlStateHighlighted];
            [button setTitleColor:color forState:UIControlStateNormal];
            [button setTitleColor:color forState:UIControlStateHighlighted];
        }
    }
}
@end
