//
//  MyHobbyInfoTwoCell.m
//  Appointment
//
//  Created by feiwu on 16/8/23.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MyHobbyInfoTwoCell.h"
#import "MyInfoViewController.h"
@implementation MyHobbyInfoTwoCell
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
    NSMutableArray *characterArray = [NSMutableArray arrayWithArray:info.newinfoModel.hobby];
    if (button.selected) {
        //选中
        imageName = NSLocalizedString(@"my_info_hobbySelected", nil);
        color = Color10(138, 113, 204, 1);
        [characterArray addObject:button.titleLabel.text];
        info.newinfoModel.hobby = characterArray;
        
    } else {
        //未选中
        imageName = NSLocalizedString(@"my_info_hobbyNoSelect", nil);
        color = Color10(229, 229, 229, 1);
        [characterArray removeObject:button.titleLabel.text];
        info.newinfoModel.hobby = characterArray;

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
    NSArray *titleArray = @[NSLocalizedString(@"上网", nil),
                            NSLocalizedString(@"研究汽车", nil),
                            NSLocalizedString(@"养小动物", nil),
                            NSLocalizedString(@"摄影", nil),
                            NSLocalizedString(@"看电影", nil),
                            NSLocalizedString(@"听音乐", nil),
                            NSLocalizedString(@"写作", nil),
                            NSLocalizedString(@"购物", nil),
                            NSLocalizedString(@"做手工艺", nil),
                            NSLocalizedString(@"做园艺", nil),
                            NSLocalizedString(@" 跳舞", nil),
                            NSLocalizedString(@"看展览", nil),
                            NSLocalizedString(@"烹饪", nil),
                            NSLocalizedString(@"读书", nil),
                            NSLocalizedString(@"绘画", nil),
                            NSLocalizedString(@"研究计算机", nil),
                            NSLocalizedString(@"做运动", nil),
                            NSLocalizedString(@"旅游", nil),
                            NSLocalizedString(@"玩电子游戏", nil),NSLocalizedString(@"其他", nil)];
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }

    [self addSubview:self.typeLabel];
      [self addSubview:self.lineView];
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(22.5);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(108, 21));
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
        button.titleLabel.font = [UIFont systemFontOfSize:kPercentIP6(14)];
        
        [button setBackgroundImage:[UIImage imageNamed:NSLocalizedString(@"my_info_hobbyNoSelect", nil) ImageType:@"png" withTop:5 andLeft:15] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:NSLocalizedString(@"my_info_hobbyNoSelect", nil) ImageType:@"png" withTop:5 andLeft:15] forState:UIControlStateHighlighted];
        [button setTitleColor:Color10(229, 229, 229, 1) forState:UIControlStateNormal];
        [button setTitleColor:Color10(229, 229, 229, 1) forState:UIControlStateHighlighted];
        button.tag = 8000 + i;
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
        _typeLabel.text = NSLocalizedString(@"兴趣爱好", nil);
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
            if ([_infoModel.hobby containsObject:button.titleLabel.text]) {
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
            [button setBackgroundImage:[UIImage imageNamed:imageName  ImageType:@"png" withTop:5 andLeft:15] forState:UIControlStateHighlighted];
            [button setTitleColor:color forState:UIControlStateNormal];
            [button setTitleColor:color forState:UIControlStateHighlighted];
        }
    }
}

@end
