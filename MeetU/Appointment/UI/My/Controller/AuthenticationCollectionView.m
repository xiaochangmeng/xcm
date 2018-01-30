//
//  AuthenticationCollectionView.m
//  Appointment
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "AuthenticationCollectionView.h"
#import "AuthenticationHeaderView.h"
#import "AuthenticationCell.h"
#import "AuthenticationEntity.h"
#import "AuthenticationIdentityController.h"    //身份认证
#import "AuthenticationPhoneController.h"      //手机认证
#import "MyInfoViewController.h"                   //资料完善
#import "MZYActionSheet.h"
#import "FWImageUtils.h"
#define kHeaderIdentifier @"authenticationHeaderView"
#define kCellIdentifier @"authenticationCell"

@interface AuthenticationCollectionView()<UIActionSheetDelegate,FWImageUtilsDelegate>
@property (strong, nonatomic) NSMutableArray* dataArray;

@end


@implementation AuthenticationCollectionView
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self initCollectionView];
    }
    return self;
}
#pragma mark- 初始化collectionView
- (void)initCollectionView{
    [self setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    self.delegate = self;
    self.dataSource = self;
    //注册header
    [self registerClass:[AuthenticationHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier];
    
    //注册cell
    [self registerClass:[AuthenticationCell class] forCellWithReuseIdentifier:kCellIdentifier];
    
    
    //绘制分割线
    [self drawDivider];
}

#pragma mark - 照片选择回调
- (void)chooseImageEnd:(NSString *)imagePath{
#warning 上传照片
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [FWImageUtils sharedInstance].delegate = self;
        [[FWImageUtils sharedInstance] chooseImageForLibiary:[self viewController]];
    }else if(buttonIndex == 1){
        [FWImageUtils sharedInstance].delegate = self;
        [[FWImageUtils sharedInstance] chooseImageForCamera:[self viewController]];
    }
}

#pragma mark - drawDivider分割线绘制
- (void)drawDivider{
    UILabel* horizontalLine = [[UILabel alloc]initWithFrame:CGRectMake(0, kHeightIP6(200) + kHeightIP6(158) - 0.5, ScreenWidth, 1)];
    [horizontalLine setBackgroundColor:Color10(246, 246, 246, 1)];
    [self addSubview:horizontalLine];
    
    UILabel* verticalLine = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth / 2 - 0.5, kHeightIP6(158), 1, kHeightIP6(400))];
    [verticalLine setBackgroundColor:Color10(246, 246, 246, 1)];
    [self addSubview:verticalLine];
}

#pragma mark -  numberOfSectionsInCollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

#pragma mark -  numberOfItemsInSection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (void)authenticationAction:(NSUInteger)tag{
    if (tag == 0) {//身份认证
        AuthenticationIdentityController* authenticationIdentityController = [[AuthenticationIdentityController alloc]init];
        [[self viewController].navigationController pushViewController:authenticationIdentityController animated:YES];
    }else if (tag == 1){//手机认证
        AuthenticationPhoneController* authenticationPhoneController = [[AuthenticationPhoneController alloc]init];
        [[self viewController].navigationController pushViewController:authenticationPhoneController animated:YES];
    }else if (tag == 2){//上传照片
        UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"手机相册",@"拍照", nil];
        actionSheet.delegate = self;
        [actionSheet showInView:self];
    }else if (tag == 3){//资料
        MyInfoViewController* myInfoViewController = [[MyInfoViewController alloc]init];
        [[self viewController].navigationController pushViewController:myInfoViewController animated:YES];
    }

}

#pragma mark -  cellForItemAtIndexPath
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AuthenticationCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.tag = indexPath.row;
    cell.authenticationEntity = self.dataArray[indexPath.row];
    cell.buttonClick = ^(NSUInteger tag){
        [self authenticationAction:tag];
    };
    return cell;
}

#pragma mark - cell的大小 sizeForItemAtIndexPath
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGRect rect = [UIScreen mainScreen].bounds;
    return CGSizeMake(rect.size.width / 2, kHeightIP6(200));
}

#pragma mark - 设置两个cell之间的水平距离 如果数值是2那么两个cell直接的距离就是4
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.0;
}

#pragma mark - 设置两个cell之间的垂直距离如果数值是2那么两个cell直接的距离就是2与水平距离有些差别
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView* resuableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        AuthenticationHeaderView* headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier forIndexPath:indexPath];
        resuableView = headerView;
    }
    return resuableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(ScreenWidth, kHeightIP6(158));
}

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray new];
        AuthenticationEntity* entity_1 = [[AuthenticationEntity alloc]initWithImageViewName:@"authentication_identity@2x" typeTitle:@"身份认证" starCount:@"可获 ★★" buttonTitle:@"已认证"];
        [_dataArray addObject:entity_1];
        
        AuthenticationEntity* entity_2 = [[AuthenticationEntity alloc]initWithImageViewName:@"authentication_phone@2x" typeTitle:@"手机认证" starCount:@"可获 ★" buttonTitle:@"去认证"];
        [_dataArray addObject:entity_2];
        
        AuthenticationEntity* entity_3 = [[AuthenticationEntity alloc]initWithImageViewName:@"authentication_photo@2x" typeTitle:@"上传3张个人照片" starCount:@"可获 ★" buttonTitle:@"去上传"];
        [_dataArray addObject:entity_3];
        
        NSString* percent = @"去完善";
        if ([[FWUserInformation sharedInstance].percent intValue] > 0) {
            percent = [NSString stringWithFormat:@"到达%@%%,去完善",[FWUserInformation sharedInstance].percent];
        }
        AuthenticationEntity* entity_4 = [[AuthenticationEntity alloc]initWithImageViewName:@"authentication_data@2x" typeTitle:@"资料到达90%" starCount:@"可获 ★" buttonTitle:percent];
        [_dataArray addObject:entity_4];
    }
    return _dataArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
