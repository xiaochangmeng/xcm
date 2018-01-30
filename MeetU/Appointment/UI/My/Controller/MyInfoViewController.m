//
//  MyInfoViewController.m
//  Appointment
//
//  Created by feiwu on 16/7/18.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyGetDetailInfoApi.h"
#import "MySetDetailInfoApi.h"
#import "LoginViewController.h"
@interface MyInfoViewController ()
@end

@implementation MyInfoViewController

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的资料页面"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的资料页面"];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideHUD];//隐藏指示器
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"我的档案", nil);
    self.isBack = YES;
    self.selectedDate = [NSDate dateWithTimeIntervalSince1970:915099041];//日期时用

    [self.view addSubview:self.tabView];
    [self.view addSubview:self.tipLabel];
    
    [self.view addSubview:self.infoScrollView];
    [self.infoScrollView addSubview:self.baseTableView];
    [self.infoScrollView addSubview:self.hobbyTableView];
    [self.infoScrollView addSubview:self.detailTableView];
    
    [self.view addSubview:self.saveButton];
    
    //信息请求
    [self getInfoRequest];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
#pragma mark - 完善资料个数
- (void)prefrect:(UserInfoModel*)model
{
    NSInteger baseCount = 0;
    NSInteger hobbyCount = 0;
    NSInteger detailCount = 0;
    
    //基本信息
    if (![model.name isEqualToString:@""]) {
        baseCount += 1;
    }
    if (![model.birth_year isEqualToString:@""]) {
         baseCount += 1;
    }
    if (![model.age isEqualToString:@""]) {
         baseCount += 1;
    }
    if (![model.city isEqualToString:@""]) {
         baseCount += 1;
    }
    if (![model.height isEqualToString:@""]) {
         baseCount += 1;
    }
    if (![model.weight isEqualToString:@""]) {
         baseCount += 1;
    }
    if (![model.blood_type isEqualToString:@""]) {
         baseCount += 1;
    }
    
    //爱好
    if (model.hobby.count > 0) {
        hobbyCount += 1;
    }
    if (model.features.count > 0) {
        hobbyCount += 1;
    }
    
    //详细信息
    if (![model.education isEqualToString:@""]) {
        detailCount += 1;
    }
    if (![model.occupation isEqualToString:@""]) {
        detailCount += 1;
    }
    if (![model.monthly_income isEqualToString:@""]) {
        detailCount += 1;
    }
   
    if (![model.making_friends isEqualToString:@""] && model.making_friends != nil) {
        detailCount += 1;
    }
    if (![model.love_concept isEqualToString:@""] && model.love_concept != nil) {
        detailCount += 1;
    }
    if (![model.first_meeting_hope isEqualToString:@""] && model.first_meeting_hope != nil) {
        detailCount += 1;
    }
    if (![model.love_place isEqualToString:@""] && model.love_place != nil) {
        detailCount += 1;
    }

    
    _baseLabel.text = [NSString stringWithFormat:@"%ld/7",(long)baseCount];
    _hobbyLabel.text = [NSString stringWithFormat:@"%ld/2",(long)hobbyCount];
    _detailLabel.text = [NSString stringWithFormat:@"%ld/7",(long)detailCount];

}
#pragma mark - Event Responses

- (void)handleSaveAction:(UIButton *)button
{
   [self validator];
}

#pragma mark 点击二级选项卡
- (void)tabAction:(int)index{
    switch (index) {
        case 0:
        {
          _tipLabel.text = NSLocalizedString(@"完善基本档案,让相遇从真诚相待开始", nil);
            _baseLabel.textColor = Color10(138, 113, 204, 1);
            _hobbyLabel.textColor = Color10(153, 153, 153, 1);
            _detailLabel.textColor = Color10(153, 153, 153, 1);
        }
            break;
        case 1:
        {
           _tipLabel.text = NSLocalizedString(@"选择个性爱好,快速建立个人印象标签", nil);
            _baseLabel.textColor = Color10(153, 153, 153, 1);
            _hobbyLabel.textColor = Color10(138, 113, 204, 1);
            _detailLabel.textColor = Color10(153, 153, 153, 1);
        }

            break;
        case 2:
        {
           _tipLabel.text = NSLocalizedString(@"完善详细档案,让相遇从真诚相待开始", nil);
            _baseLabel.textColor = Color10(153, 153, 153, 1);
            _hobbyLabel.textColor = Color10(153, 153, 153, 1);
            _detailLabel.textColor = Color10(138, 113, 204, 1);
        }

            break;
            
        default:
            break;
    }
    [_infoScrollView setContentOffset:CGPointMake(index * ScreenWidth, 0) animated:YES];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    int currentPage = point.x / ScreenWidth;
    [_tabView.tabView tabIndex:currentPage];
    
}

- (void)validator
{
    NSString *oldBirth = [NSString stringWithFormat:@"%@-%@-%@",_oldinfoModel.birth_year,_oldinfoModel.birth_month,_oldinfoModel.birth_day];
    NSString *newBirth = [NSString stringWithFormat:@"%@-%@-%@",_newinfoModel.birth_year,_newinfoModel.birth_month,_newinfoModel.birth_day];
    NSString *newhobby = @"";
    NSString *newcharacter = @"";
    NSString *oldhobby = @"";
    NSString *oldcharacter = @"";
    
    //新标签
    if (_newinfoModel.hobby.count > 0) {
        for (NSString *hobbyString in _newinfoModel.hobby) {
            if (![hobbyString isEqualToString:@""]) {
                newhobby = [NSString stringWithFormat:@"%@,%@",newhobby,hobbyString];
            }
        }
        newhobby = [newhobby substringFromIndex:1];
    }
    
    if (_newinfoModel.features.count > 0) {
        for (NSString *characterString in _newinfoModel.features) {
            if (![characterString isEqualToString:@""]) {
                newcharacter = [NSString stringWithFormat:@"%@,%@",newcharacter,characterString];
            }
            
            
        }
        newcharacter = [newcharacter substringFromIndex:1];
    } 
    
    //旧标签
    if (_oldinfoModel.hobby.count > 0) {
        for (NSString *hobbyString in _oldinfoModel.hobby) {
            if (![hobbyString isEqualToString:@""]) {
                oldhobby = [NSString stringWithFormat:@"%@,%@",oldhobby,hobbyString];
            }
        }
        oldhobby = [oldhobby substringFromIndex:1];
    }
    
    if (_oldinfoModel.features.count > 0) {
        for (NSString *characterString in _oldinfoModel.features) {
            if (![characterString isEqualToString:@""]) {
                oldcharacter = [NSString stringWithFormat:@"%@,%@",oldcharacter,characterString];
            }
        }
        oldcharacter = [oldcharacter substringFromIndex:1];
    }

    //判断是否做过修改
    if ([_oldinfoModel.name isEqualToString:_newinfoModel.name] && [oldBirth isEqualToString:newBirth] && [_oldinfoModel.height isEqualToString:_newinfoModel.height] && [_oldinfoModel.weight isEqualToString:_newinfoModel.weight] && [_oldinfoModel.blood_type isEqualToString:_newinfoModel.blood_type] && [_oldinfoModel.city isEqualToString:_newinfoModel.city] && [_oldinfoModel.education isEqualToString:_newinfoModel.education] && [_oldinfoModel.occupation isEqualToString:_newinfoModel.occupation] && [_oldinfoModel.monthly_income isEqualToString:_newinfoModel.monthly_income]  && [_oldinfoModel.making_friends isEqualToString:_newinfoModel.making_friends]  && [_oldinfoModel.love_concept isEqualToString:_newinfoModel.love_concept] && [_oldinfoModel.first_meeting_hope isEqualToString:_newinfoModel.first_meeting_hope] && [_oldinfoModel.love_place isEqualToString:_newinfoModel.love_place] && [newhobby isEqualToString:oldhobby] && [newcharacter isEqualToString:oldcharacter]) {
        [self showHUDFail:NSLocalizedString(@"您未做任何修改", nil)];
        [self hideHUDDelay:1];
        return;
    }
    [self setInfoRequestWithHobby:newhobby  Character:newcharacter];
}

#pragma mark - Network Data
#pragma mark - 获取用户信息
- (void)getInfoRequest {
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    MyGetDetailInfoApi *api = [[MyGetDetailInfoApi alloc] init];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf hideHUD];
        [weakSelf getInfoRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"获取用户信息请求失败:%@",request.responseString);
        [weakSelf hideHUD];
        [weakSelf showHUDFail:kNetWorkErrorTitle];
        [weakSelf hideHUDDelay:1];
    }];
}

- (void)getInfoRequestFinish:(NSDictionary *)result{
    LogOrange(@"获取用户信息请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        
        NSMutableDictionary *infoDic  = [result objectForKey:@"data"];
        //是否有数据
        if ((NSNull *)infoDic != [NSNull null] && infoDic.count > 0)  {
            _newinfoModel = [[UserInfoModel alloc] initWithDataDic:infoDic];
            
            if (!_oldinfoModel) {
                _oldinfoModel = [[UserInfoModel alloc] initWithDataDic:infoDic];
            }
            _baseTableView.province_arr =  infoDic[@"province_arr"];
            _baseTableView.infoModel = _newinfoModel;
            _hobbyTableView.infoModel = _newinfoModel;
            _detailTableView.infoModel = _newinfoModel;
            [self prefrect:_newinfoModel];
            
            [_baseTableView reloadData];
            [_hobbyTableView reloadData];
            [_detailTableView reloadData];
        }
        
    }else if([code intValue] == kNetWorkNoLoginCode){
        //没有登录
        LoginViewController *login = [[LoginViewController alloc] init];
        login.isNoLogin = YES;
        [self presentViewController:login animated:NO completion:^{
            
        }];
    } else {
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
    }
}

#pragma mark - 设置用户信息
- (void)setInfoRequestWithHobby:(NSString *)hobby Character:(NSString *)character {
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    MySetDetailInfoApi *api = [[MySetDetailInfoApi alloc] initWithYear:_newinfoModel.birth_year Month:_newinfoModel.birth_month Day:_newinfoModel.birth_day Province:_newinfoModel.city Height:_newinfoModel.height Weight:_newinfoModel.weight Blood:_newinfoModel.blood_type NickName:_newinfoModel.name  Education:_newinfoModel.education Job:_newinfoModel.occupation Income:_newinfoModel.monthly_income   FdPurpose:_newinfoModel.making_friends LoveSense:_newinfoModel.love_concept FtExpection:_newinfoModel.first_meeting_hope DataPlace:_newinfoModel.love_place hobby:hobby Character:character];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf hideHUD];
        [weakSelf setInfoRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"设置用户信息请求失败:%@",request.responseString);
        [weakSelf hideHUD];
        [weakSelf showHUDFail:kNetWorkErrorTitle];
        [weakSelf hideHUDDelay:1];
    }];
}

- (void)setInfoRequestFinish:(NSDictionary *)result{
    LogOrange(@"设置用户信息请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        [self showHUDComplete:NSLocalizedString(@"设置成功", nil)];
        [self hideHUDDelay:1];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyInfoViewControllerModifyNickname" object:_newinfoModel.name];
        
    }else if([code intValue] == kNetWorkNoLoginCode){
        //没有登录
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
        [self performSelector:@selector(login) withObject:nil afterDelay:1];
        
    } else {
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
    }
}

- (void)login{
    WS(weakSelf);
    LoginViewController *login = [[LoginViewController alloc] init];
    login.isNoLogin = YES;
    login.loginBlock = ^(){
        [weakSelf getInfoRequest];
    };
    [self presentViewController:login animated:NO completion:^{
        
    }];
}
#pragma mark - Getters And Setters
- (MyBaseInfoTableView *)baseTableView {
    if (!_baseTableView) {
        _baseTableView = [[MyBaseInfoTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 125 - 49)];
    }
    return _baseTableView;
}
- (MyHobbyInfoTableView *)hobbyTableView {
	if (!_hobbyTableView) {
		_hobbyTableView = [[MyHobbyInfoTableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - 64 - 125 - 49)];
	}
	return _hobbyTableView;
}

- (MyDetailInfoTableView *)detailTableView {
	if (!_detailTableView) {
		_detailTableView = [[MyDetailInfoTableView alloc] initWithFrame:CGRectMake(ScreenWidth * 2, 0, ScreenWidth, ScreenHeight - 64 - 125 - 49)];
	}
	return _detailTableView;
}

- (UIScrollView *)infoScrollView {
	if (!_infoScrollView) {
		_infoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 125, ScreenWidth, ScreenHeight - 64 - 125 - 49)];
        _infoScrollView.delegate = self;
        _infoScrollView.pagingEnabled = YES;
        _infoScrollView.showsHorizontalScrollIndicator = NO;
        _infoScrollView.showsVerticalScrollIndicator = NO;
        _infoScrollView.bounces = NO;
        [_infoScrollView setContentSize:CGSizeMake(ScreenWidth * 3, ScreenHeight - 64 - 125 - 49)];
    }
	return _infoScrollView;
}
- (MyInfoTabView *)tabView {
	if (!_tabView) {
        WS(weakSelf);
        _tabView = [[MyInfoTabView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
        _tabView.tabView.tabBlock = ^(int index){
            [weakSelf tabAction:index];
        };
        [_tabView addSubview:self.baseLabel];
        [_tabView addSubview:self.hobbyLabel];
        [_tabView addSubview:self.detailLabel];
        [_baseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ScreenWidth / 3.0 / 2.0 - 13);
            make.top.mas_equalTo(52);
        }];
        
        [_hobbyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(weakSelf.tabView);
            make.top.mas_equalTo(52);
        }];
        
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-ScreenWidth / 3.0 / 2.0 + 15);
            make.top.mas_equalTo(52);
        }];

	}
	return _tabView;
}
- (UILabel *)tipLabel {
	if (!_tipLabel) {
		_tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, ScreenWidth - 40, 35)];
        _tipLabel.font = kFont14;
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        _tipLabel.textColor = Color10(102, 102, 102, 1);
        _tipLabel.text = NSLocalizedString(@"完善基本档案,让相遇从真诚相待开始", nil);
	}
	return _tipLabel;
}

- (UILabel *)baseLabel {
	if (!_baseLabel) {
		_baseLabel = [[UILabel alloc] init];
        _baseLabel.font = kFont13;
        _baseLabel.textColor = Color10(138, 113, 204, 1);
//        _baseLabel.backgroundColor = [UIColor yellowColor];
        _baseLabel.text = @"0/7";
	}
	return _baseLabel;
}

- (UILabel *)hobbyLabel {
	if (!_hobbyLabel) {
		_hobbyLabel = [[UILabel alloc] init];
        _hobbyLabel.font = kFont13;
        _hobbyLabel.textColor = Color10(153, 153, 153, 1);
//        _hobbyLabel.backgroundColor = [UIColor yellowColor];
        _hobbyLabel.text = @"0/2";
	}
	return _hobbyLabel;
}
- (UILabel *)detailLabel {
	if (!_detailLabel) {
		_detailLabel = [[UILabel alloc] init];
        _detailLabel.font = kFont13;
        _detailLabel.textColor = Color10(153, 153, 153, 1);
//        _detailLabel.backgroundColor = [UIColor yellowColor];
        _detailLabel.text = @"0/7";

	}
	return _detailLabel;
}

- (UIButton *)saveButton {
	if (!_saveButton) {
        _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, ScreenHeight - 49 - 64, ScreenWidth, 49)];
        [_saveButton setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
        [_saveButton setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateHighlighted];
        [_saveButton addTarget:self action:@selector(handleSaveAction:) forControlEvents:UIControlEventTouchUpInside];
        _saveButton.backgroundColor = Color16(0xF85F73);
	}
	return _saveButton;
}
@end
