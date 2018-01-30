//
//  TestViewController.m
//  Appointment
//
//  Created by feiwu on 16/7/11.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "SelectConditionViewController.h"
#import "ConditionButton.h"
#import "ActionSheetPicker.h"
#import "AbstractActionSheetPicker+Interface.h"
#import "SetSelectConditionApi.h"
#import "GetSelectConditionApi.h"
#import "LoginViewController.h"
@interface SelectConditionViewController ()

@end

@implementation SelectConditionViewController

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"搜索条件页面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"搜索条件页面"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideHUD];//隐藏指示器
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"征友条件", nil);
    self.isCancel = YES;
    [self initView];
    [self makeConstraints];
    [self getSelectConditionRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Private Methods
//私有方法
#pragma mark 初始化
- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.conditionView];
    [_conditionView addSubview:self.locationButton];
    [_conditionView addSubview:self.ageButton];
    [_conditionView addSubview:self.heightButton];
    [self.view addSubview:self.saveButton];
}

#pragma mark 布局
- (void)makeConstraints
{
    WS(weakSelf);
    [_conditionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(5);
        make.top.mas_equalTo(weakSelf.view).offset(0);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 10, 150));
    }];
    
    [_locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.conditionView);
        make.top.mas_equalTo(weakSelf.conditionView.mas_top);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 10, 50));
    }];
    
    
    [_ageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.conditionView);
        make.top.mas_equalTo(weakSelf.locationButton.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 10, 50));
    }];
    
    [_heightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.conditionView);
        make.top.mas_equalTo(weakSelf.ageButton.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 10, 50));
    }];
    
    [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(20);
        make.top.mas_equalTo(weakSelf.conditionView.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 40, 44));
    }];
    
    
}

#pragma mark - Event Responses
- (void)handleSaveAction:(UIButton *)button
{
    [self setSelectConditionRequest];
}

#pragma mark - Network Data
#pragma mark - 获得搜索条件
- (void)getSelectConditionRequest {
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    GetSelectConditionApi*api = [[GetSelectConditionApi alloc] init];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf hideHUD];
        [weakSelf getSelectConditionRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"获取筛选条件请求失败:%@",request.responseString);
        [weakSelf hideHUD];
        [weakSelf showHUDFail:kNetWorkErrorTitle];
        [weakSelf hideHUDDelay:1];
    }];
}

- (void)getSelectConditionRequestFinish:(NSDictionary *)result{
    LogOrange(@"获取筛选条件请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        
        NSMutableDictionary *infoDic  = [result objectForKey:@"data"];
        _selectDic = infoDic;
        
        //是否有数据
        if ((NSNull *)infoDic != [NSNull null] && infoDic.count > 0)  {
          _selectModel = [[SelectModel alloc] initWithDataDic:infoDic];
            
            //所在地
            _locationButton.contentLabel.text = _selectModel.area;
            
            //年龄
            if ([_selectModel.minage isEqualToString:@""] && [_selectModel.maxage isEqualToString:@"200"]) {
                _ageButton.contentLabel.text = NSLocalizedString(@"不限", nil);
            } else if ([_selectModel.minage isEqualToString:@"45"] && [_selectModel.maxage isEqualToString:@"200"]) {
             _ageButton.contentLabel.text = NSLocalizedString(@"45及以上", nil);
            } else {
             _ageButton.contentLabel.text = [NSString stringWithFormat:@"%@-%@",_selectModel.minage,_selectModel.maxage];
            }
            
            //身高
            if ([_selectModel.minheight isEqualToString:@""] && [_selectModel.maxheight isEqualToString:@"200"]) {
                _heightButton.contentLabel.text = NSLocalizedString(@"不限", nil);
            } else if ([_selectModel.minage isEqualToString:@"180"] && [_selectModel.maxage isEqualToString:@"200"]) {
                _heightButton.contentLabel.text = NSLocalizedString(@"180及以上", nil);
            } else {
                _heightButton.contentLabel.text = [NSString stringWithFormat:@"%@-%@",_selectModel.minheight,_selectModel.maxheight];
            }
            
        }
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
        [weakSelf getSelectConditionRequest];
    };
    [self presentViewController:login animated:NO completion:^{
        
    }];
}

#pragma mark - 修改搜索条件
- (void)setSelectConditionRequest {
    
    if (_age) {
        if ([_age isEqualToString:NSLocalizedString(@"不限", nil)]) {
            _selectModel.minage = @"";
            _selectModel.maxage = @"200";
        } else if([_age isEqualToString:NSLocalizedString(@"45及以上", nil)]) {
            _selectModel.minage = @"45";
            _selectModel.maxage = @"200";
        } else {
            NSArray *temp = [_age componentsSeparatedByString:@"-"];
            _selectModel.minage = [temp firstObject];
            _selectModel.maxage = [temp lastObject];
        }
    }
    
    if (_height) {
        if ([_height isEqualToString:NSLocalizedString(@"不限", nil)]) {
            _selectModel.minheight = @"";
            _selectModel.maxheight = @"200";
        } else if([_height isEqualToString:NSLocalizedString(@"180及以上", nil)]) {
            _selectModel.minheight = @"180";
            _selectModel.maxheight = @"200";
        } else {
            NSArray *temp = [_height componentsSeparatedByString:@"-"];
            _selectModel.minheight = [temp firstObject];
            _selectModel.maxheight = [temp lastObject];
        }
    }
    
    if (_area) {
        _selectModel.area = _area;
    }
    
    //判断是否修改
    NSString *area = [_selectDic objectForKey:@"area"];
    NSString *minage = [_selectDic objectForKey:@"minage"];
    NSString *maxage = [_selectDic objectForKey:@"maxage"];
    NSString *minheight = [_selectDic objectForKey:@"minheight"];
    NSString *maxheight = [_selectDic objectForKey:@"maxheight"];
    
    if ([area isEqualToString:_selectModel.area] && [minage isEqualToString:_selectModel.minage] && [maxage isEqualToString:_selectModel.maxage] && [minheight isEqualToString:_selectModel.minheight] && [maxheight isEqualToString:_selectModel.maxheight]) {
        [self showHUDFail:NSLocalizedString(@"您未做任何修改", nil)];
        [self hideHUDDelay:1];
        return;
    }

    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    SetSelectConditionApi *api = [[SetSelectConditionApi alloc] initWithArea:_selectModel.area Minage:_selectModel.minage Maxage:_selectModel.maxage Minht:_selectModel.minheight Maxht:_selectModel.maxheight];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf hideHUD];
        [weakSelf setSelectConditionRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"设置筛选条件请求失败:%@",request.responseString);
        [weakSelf hideHUD];
        [weakSelf showHUDFail:kNetWorkErrorTitle];
        [weakSelf hideHUDDelay:1];
    }];
}

- (void)setSelectConditionRequestFinish:(NSDictionary *)result{
    LogOrange(@"设置筛选条件请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
         [self showHUDComplete:NSLocalizedString(@"设置成功", nil)];
         [self hideHUDDelay:1];
         [self performSelector:@selector(popView) withObject:nil afterDelay:1];
        
        //刷新搜索列表
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshSelectList" object:nil];
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
- (void)popView
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Getters And Setters
- (UIView *)conditionView {
    if (!_conditionView) {
        _conditionView = [[UIView alloc] init];
        _conditionView.backgroundColor = [UIColor whiteColor];
    }
    return _conditionView;
}
- (ConditionButton *)locationButton {
    if (!_locationButton) {
        WS(weakSelf);
        _locationButton = [[ConditionButton alloc] initWithTitle:NSLocalizedString(@"期望所在的位置", nil)];
        _locationButton.conditionBlock = ^{
            LogRed(@"Ta所在的位置");
              NSArray *dataArr = @[@"臺北",@"桃園",@"台中",@"台南",@"高雄",@"基隆",@"新竹",@"嘉義",@"苗栗",@"彰化",@"南投",@"雲林",@"屏東",@"宜蘭",@"花蓮",@"台東",@"金門",@"連江",@"澎湖",@"新北"];
            ActionSheetStringPicker *actionPicker = [[ActionSheetStringPicker alloc]initWithTitle:NSLocalizedString(@"选择地区", nil) rows:dataArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                //*********一组点击确认按钮做处理************
                weakSelf.area = (NSString *)selectedValue;
                weakSelf.locationButton.contentLabel.text = (NSString *)selectedValue;
                NSLog(@"选择的省份%@",weakSelf.area);
                
                
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:weakSelf.view];
            [actionPicker customizeInterface];
            [actionPicker showActionSheetPicker];
        };
    }
    return _locationButton;
}

- (ConditionButton *)ageButton {
    if (!_ageButton) {
        WS(weakSelf);
        _ageButton = [[ConditionButton alloc] initWithTitle:NSLocalizedString(@"期望的年龄", nil)];
        _ageButton.conditionBlock = ^{
            LogRed(@"Ta的年龄");
            NSArray *dataArr = @[@"18-20",@"21-25",@"26-30",@"31-35",@"36-40",@"41-45",@"45以上",NSLocalizedString(@"不限", nil)];
            ActionSheetStringPicker *actionPicker = [[ActionSheetStringPicker alloc]initWithTitle:NSLocalizedString(@"选择年龄(岁)", nil) rows:dataArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                //*********一组点击确认按钮做处理************
                weakSelf.age = (NSString *)selectedValue;
                weakSelf.ageButton.contentLabel.text = (NSString *)selectedValue;
                NSLog(@"选择的年龄%@",weakSelf.age);
                
                
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:weakSelf.view];
            [actionPicker customizeInterface];
            [actionPicker showActionSheetPicker];
            
        };
    }
    return _ageButton;
}

- (ConditionButton *)heightButton {
    if (!_heightButton) {
        WS(weakSelf);
        _heightButton = [[ConditionButton alloc] initWithTitle:NSLocalizedString(@"期望的身高", nil)];
        _heightButton.conditionBlock = ^{
            LogRed(@"Ta的身高");
            NSArray *dataArr = @[@"160-165",@"166-170",@"171-175",@"176-180",@"180以上",NSLocalizedString(@"不限", nil)];
            ActionSheetStringPicker *actionPicker = [[ActionSheetStringPicker alloc]initWithTitle:NSLocalizedString(@"选择身高(cm)", nil) rows:dataArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                //*********一组点击确认按钮做处理************
                weakSelf.height = (NSString *)selectedValue;
                weakSelf.heightButton.contentLabel.text = (NSString *)selectedValue;
                NSLog(@"选择的身高%@",weakSelf.height);
                
                
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:weakSelf.view];
            [actionPicker customizeInterface];
            [actionPicker showActionSheetPicker];
            
        };
    }
    return _heightButton;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] init];
        _saveButton.titleLabel.font = kFont18;
        [_saveButton addTarget:self action:@selector(handleSaveAction:) forControlEvents:UIControlEventTouchUpInside];
        [_saveButton setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        _saveButton.backgroundColor = Color16(0xF85F73);
        _saveButton.layer.cornerRadius = 6;


    }
    return _saveButton;
}
@end
