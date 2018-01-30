//
//  MyPhotoDetailViewController.m
//  Appointment
//
//  Created by feiwu on 16/7/30.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MyPhotoDetailViewController.h"
#import "MyUploadImageApi.h"
#import "MyDeletePhotoApi.h"
#import "LoginViewController.h"
#import "LXFileManager.h"
@interface MyPhotoDetailViewController ()

@end

@implementation MyPhotoDetailViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的相册页面"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的相册页面"];
}

#pragma mark - Life Cycle
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideHUD];//隐藏指示器
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isBack = YES;
    self.title = [NSString stringWithFormat:@"%ld/%lu",(long)_index + 1,(unsigned long)_photoOriginalArray.count];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView {
    WS(weakSelf);
    
    [self.view addSubview:self.photoScroll];
    
    //底部视图
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.lineView];
    [_bottomView addSubview:self.setheadButton];
    [_bottomView addSubview:self.deleteButton];
    
    
    [_photoScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(0);
        make.top.mas_equalTo(weakSelf.view).offset(0);
        make.right.mas_equalTo(weakSelf.view).offset(0);
        make.bottom.mas_equalTo(weakSelf.view).offset(0);
    }];

    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 49));
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScreenWidth / 2.0);
        make.bottom.mas_equalTo(-8.5);
        make.size.mas_equalTo(CGSizeMake(1, 29.5));
    }];

    
    [_setheadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-7);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth / 2.0 - 10, 36));
    }];
    
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-7);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth / 2.0 - 10, 36));
    }];

    if (!_imageViewArray) {
        _imageViewArray = [NSMutableArray array];
    }
    
    for (int i = 0; i < _photoOriginalArray.count; i++) {
        UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth * i, 0, ScreenWidth, ScreenHeight - 64)];
        photo.tag = 9000 + i;
        photo.userInteractionEnabled = YES;
        photo.clipsToBounds = YES;
        photo.contentMode = UIViewContentModeScaleAspectFill;

        [_photoScroll addSubview:photo];
        [photo sd_setImageWithURL:[NSURL URLWithString:[_photoArray objectAtIndex:i]] placeholderImage:LOADIMAGE(NSLocalizedString(@"My_album_bg", nil), @"png") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        [_imageViewArray addObject:photo];

    }
    
}
#pragma mark - Event Responses
//删除
- (void)handleDeleteAction:(UIButton *)sender
{
    if (_index < _photoDeleteArray.count ) {
        [self setDeleteImageRequest:[_photoDeleteArray objectAtIndex:_index]];
    }
}

//设为头像
- (void)handleSetHeadAction:(UIButton *)sender
{
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    NSString *url = [weakSelf.photoArray objectAtIndex:weakSelf.index];
    
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:url];
    if (cachedImage) {
        //缓存中存在
        [self setUploadImageRequest:cachedImage Type:@"img"];
    } else {
        //缓存中不存在
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];
            UIImage *image = [[UIImage alloc]initWithData:data];
            if (data != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf setUploadImageRequest:image Type:@"img"];
                });
            }
            [self hideHUD];
        });
    }
}

#pragma mark - UIScrollViewDelegate
#pragma mark 划动停止时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self selectIndex:scrollView.contentOffset.x / ScreenWidth];
}

#pragma mark 拖动停止触发
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate && scrollView == _photoScroll){
        [self selectIndex:scrollView.contentOffset.x / ScreenWidth];
    }
}

-(void)selectIndex:(int)index{
    LogOrange(@"当前的页数:%d",index);
    _index = index;
    self.title = [NSString stringWithFormat:@"%d/%lu",index + 1,(unsigned long)_photoArray.count];
}
#pragma mark - Network Data
#pragma mark - 上传图片
- (void)setUploadImageRequest:(UIImage *)image Type:(NSString *)type{
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    MyUploadImageApi* api = [[MyUploadImageApi alloc] initWithImage:image Type:type];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf hideHUD];
        [weakSelf setUploadImageRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"上传图片请求失败:%@",request.responseString);
        [weakSelf hideHUD];
        [weakSelf showHUDFail:kNetWorkErrorTitle];
        [weakSelf hideHUDDelay:1];
    }];
}

- (void)setUploadImageRequestFinish:(NSDictionary *)result{
    LogOrange(@"上传图片请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        [self hideHUD];
        [self showHUDComplete:NSLocalizedString(@"头像设置成功", nil)];
        [self hideHUDDelay:1];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyHandleHeadChange" object:[result objectForKey:@"data"]];
        NSString *key = [NSString stringWithFormat:@"%@userImage",[FWUserInformation sharedInstance].mid];
        NSString *value = [result objectForKey:@"data"];
        [LXFileManager saveUserData:value forKey:key];

    }else if([code intValue] == kNetWorkNoLoginCode){
        //没有登录
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
        [self performSelector:@selector(login) withObject:nil afterDelay:1];
        
    } else {
        [self hideHUD];
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
    }
}

- (void)login{
    LoginViewController *login = [[LoginViewController alloc] init];
    login.isNoLogin = YES;
    [self presentViewController:login animated:NO completion:^{
        
    }];
}

#pragma mark - 删除图片
- (void)setDeleteImageRequest:(NSString *)url{
    WS(weakSelf);
    [self hideHUD];
    [self showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    MyDeletePhotoApi* api = [[MyDeletePhotoApi alloc] initWithUrl:url];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf hideHUD];
        [weakSelf setDeleteImageRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"删除图片请求失败:%@",request.responseString);
        [weakSelf hideHUD];
        [weakSelf showHUDFail:kNetWorkErrorTitle];
        [weakSelf hideHUDDelay:1];
    }];
}

- (void)setDeleteImageRequestFinish:(NSDictionary *)result{
    LogOrange(@"删除图片请求成功:%@",result);
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        [self hideHUD];
        [self showHUDComplete:NSLocalizedString(@"图片删除成功", nil)];
        [self hideHUDDelay:1];
        
        //删除相应的数组中的元素
        LogOrange(@"当前的下标:%ld",(long)_index);
        NSMutableArray *photoArray = [NSMutableArray arrayWithArray:_photoArray];
        NSMutableArray *deleteArray = [NSMutableArray arrayWithArray:_photoDeleteArray];
        NSMutableArray *originalArray = [NSMutableArray arrayWithArray:_photoOriginalArray];
        
        [photoArray removeObjectAtIndex:_index];
        [deleteArray removeObjectAtIndex:_index];
        [originalArray removeObjectAtIndex:_index];
        
        _photoArray = photoArray;
        _photoOriginalArray = originalArray;
        _photoDeleteArray = deleteArray;
        
        //更新显示的内容
        
        if (_photoOriginalArray.count > 0) {
            //还有图片,处理剩下的显示
            
            if (_index == _photoOriginalArray.count) {
                _index = _photoOriginalArray.count - 1;
            }
            //处理页数显示
            self.title = [NSString stringWithFormat:@"%ld/%lu",(long)_index + 1,(unsigned long)_photoOriginalArray.count];

            [_photoScroll setContentSize:CGSizeMake(ScreenWidth *_photoOriginalArray.count, ScreenHeight - 64)];
            for (int i = 0; i < _photoOriginalArray.count; i++) {
                UIImageView *photo = (UIImageView *)_imageViewArray[i];
                [photo sd_setImageWithURL:[NSURL URLWithString:[_photoArray objectAtIndex:i]] placeholderImage:LOADIMAGE(NSLocalizedString(@"fate_detail_headPlaceholder@2x", nil), @"png") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                }];
                
            }
            
        } else {
        //直接返回
            [self performSelector:@selector(popView) withObject:nil afterDelay:1];
            
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyHandleAlbumChange" object:@{@"albums":_photoArray,@"albums_original":_photoOriginalArray,@"albums_urlencode":_photoDeleteArray}];//更新相册
        
    }else if([code intValue] == kNetWorkNoLoginCode){
        //没有登录
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
        [self performSelector:@selector(login) withObject:nil afterDelay:1];
        
    } else {
        [self hideHUD];
        [self showHUDFail:desc];
        [self hideHUDDelay:1];
    }
}

- (void)popView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getters And Setters
- (UIScrollView *)photoScroll {
    if (!_photoScroll) {
        _photoScroll = [[UIScrollView alloc] init];
        _photoScroll.delegate = self;
        _photoScroll.pagingEnabled = YES;
        _photoScroll.showsHorizontalScrollIndicator = NO;
        _photoScroll.showsVerticalScrollIndicator = NO;
        _photoScroll.bounces = NO;
        [_photoScroll setContentSize:CGSizeMake(ScreenWidth *_photoOriginalArray.count, ScreenHeight - 64)];
        [_photoScroll setContentOffset:CGPointMake(ScreenWidth *_index, 0)];
    }
    return _photoScroll;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor =Color16(0xF85F73);
    }
    return _bottomView;
}
- (UIView *)lineView {
	if (!_lineView) {
		_lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor whiteColor];
	}
	return _lineView;
}
- (UIButton *)setheadButton {
    if (!_setheadButton) {
        _setheadButton = [[UIButton alloc] init];
        [_setheadButton addTarget:self action:@selector(handleSetHeadAction:) forControlEvents:UIControlEventTouchUpInside];
        _setheadButton.titleLabel.font = kFont14;
        [_setheadButton setTitle:NSLocalizedString(@"设为头像", nil) forState:UIControlStateNormal];
        [_setheadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_setheadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

    }
    return _setheadButton;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] init];
        _deleteButton.titleLabel.font = kFont14;
        [_deleteButton setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

        [_deleteButton addTarget:self action:@selector(handleDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

@end
