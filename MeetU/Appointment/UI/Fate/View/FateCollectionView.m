//
//  FateCollectionView.m
//  Appointment
//
//  Created by feiwu on 16/7/8.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "FateCollectionView.h"
#import "FateCollectionViewCell.h"
#import "FateModel.h"
#import "FateDetailViewController.h"
#import "FateViewController.h"
#import "FateCollectionHeadView.h"
#import "FateListApi.h"
#import "NSDate+MZYExtension.h"
#import "LoginViewController.h"
#import "LXFileManager.h"

@implementation FateCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
         self.backgroundColor = [UIColor clearColor];
        [self addHeader];
        [self addFooter];
        self.page = 1;
        self.isRefresh = NO;
    }
    return self;
}
#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _fateDataArray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (_fateDataArray.count > 0) {
        FateModel *fateModel = _fateDataArray[indexPath.row];

               
        [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:fateModel.img] placeholderImage:LOADIMAGE(NSLocalizedString(@"fate_headPlaceholder", nil), @"png") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //计算出图片 的 宽度 大于 高度  还是高度 大于 宽度
            CGFloat imageSize = image.size.width > image.size.height ? image.size.height : image.size.width;
            //按等宽等高裁剪
             CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage,CGRectMake(image.size.width * 0.5 - imageSize * 0.5, 0, imageSize, imageSize));
            
            cell.userImageView.image = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
        }];
        cell.nameLabel.text = fateModel.name;
        cell.model = fateModel;

    }
    
     return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    
    FateCollectionHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headIdentify forIndexPath:indexPath];
    
    return headerView;
}

#pragma mark - UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(ScreenWidth, 0.0f);
    } else {
        return CGSizeMake(0, 0);
    }
}


#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [MobClick event:@"fateEnterUserDetail"];
    FateViewController *fate = (FateViewController *)self.viewController;
    FateModel *model = _fateDataArray[indexPath.row];
    FateDetailViewController *detail = [[FateDetailViewController alloc] init];
    detail.fateModel = model;
    [fate.navigationController pushViewController:detail animated:YES];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark - UICollectionViewDelegateFlowLayout


#pragma mark - 获取缘分列表
- (void)getFateListRequest:(NSString *)type {
    WS(weakSelf);
    FateViewController *fate = (FateViewController *)self.viewController;
    [fate hideHUD];
    [fate showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    FateListApi *api = [[FateListApi alloc] initWithPage:type];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf.mj_header endRefreshing];
        [weakSelf.mj_footer endRefreshing];
        [fate hideHUD];
        [weakSelf getFateListRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"缘分列表请求失败:%@",request.responseString);
        [weakSelf.mj_header endRefreshing];
        [weakSelf.mj_footer endRefreshing];
        [fate hideHUD];
        [fate showNetRefresh:^{
            [fate hideNetRefresh];
            [weakSelf getFateListRequest:type];
        }];
    }];
}

- (void)getFateListRequestFinish:(NSDictionary *)result{
    LogOrange(@"缘分列表请求成功:%@",result);
    FateViewController *fate = (FateViewController *)self.viewController;
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        
        if (_isRefresh) {
            _isRefresh = NO;
            _page = 1;
            [_fateDataArray removeAllObjects];
            [self reloadData];
        }
        NSMutableArray *fateArray = [NSMutableArray arrayWithArray:[result objectForKey:@"data"]];
        //是否有数据
        if ((NSNull *)fateArray != [NSNull null] && fateArray.count > 0)  {
            if (!_fateDataArray) {
                _fateDataArray = [NSMutableArray array];
            }
            
            for (int i = 0; i < fateArray.count; i++) {
                NSDictionary *dic = [fateArray objectAtIndex:i];
                FateModel *model = [[FateModel alloc] initWithDataDic:dic];
                [_fateDataArray addObject:model];
            }
            
            [self reloadData];
            _page++;
            
            // MARK: - 修改
            //活动
            NSString *status = [LXFileManager readUserDataForKey:kAppIsCheckStatus];
            if ([status intValue] != 0) {
                NSString *currentDate = [NSDate getDate:[NSDate date] dateFormatter:@"yyyyMMdd"];
                NSString *key = [NSString stringWithFormat:@"%@%@DaliyLoginKey",currentDate,[FWUserInformation sharedInstance].mid];
                NSString *daliy = [LXFileManager readUserDataForKey:key];
                if (![daliy isEqualToString:@"1"]) {
                    
//                    FateDaliyLoginView *loginview = [[FateDaliyLoginView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//                    [fate.navigationController.view addSubview:loginview];
                }
                
            }
            
        }
    }else if([code intValue] == kNetWorkNoLoginCode){
        //没有登录
        [fate showHUDFail:desc];
        [fate hideHUDDelay:1];
        [self performSelector:@selector(login) withObject:nil afterDelay:1];
        
    } else {
        [fate showHUDFail:desc];
        [fate hideHUDDelay:1];
    }
}

- (void)login{
    WS(weakSelf);
    FateViewController *fate = (FateViewController *)self.viewController;
    LoginViewController *login = [[LoginViewController alloc] init];
    login.isNoLogin = YES;
    login.loginBlock = ^(){
        weakSelf.isRefresh = YES;
        [weakSelf getFateListRequest:@"1"];
    };
    [fate presentViewController:login animated:NO completion:^{
        
    }];
}
#pragma mark 下拉刷新数据
- (void)addHeader
{
    WS(weakSelf);
    MJRefreshStateHeader* header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isRefresh = YES;
        [weakSelf getFateListRequest:@"1"];
    }];
    [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开可以刷新" forState:MJRefreshStatePulling];
    if ([[FWUserInformation sharedInstance].sex isEqualToString:@"1"]) {
        [header setTitle:@"正在锁定妹子" forState:MJRefreshStateRefreshing];
    }else{
        [header setTitle:@"正在锁定帅哥" forState:MJRefreshStateRefreshing];
    }
    self.mj_header = header;
}

#pragma mark 上拉加载数据
- (void)addFooter
{
    WS(weakSelf);
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getFateListRequest:[NSString stringWithFormat:@"%d",weakSelf.page]];
    }];
}
#pragma mark - Getters And Setters
@end
