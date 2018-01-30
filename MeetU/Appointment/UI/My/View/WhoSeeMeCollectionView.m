//
//  WhoSeeMeCollectionView.m
//  Appointment
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "WhoSeeMeCollectionView.h"
#import "WhoSeeMeCollectionViewFlowlayout.h"
#import "MyFeedBackViewController.h"
#import "WhoSeeMeController.h"
@interface WhoSeeMeCollectionView()<UIAlertViewDelegate>


@end
@implementation WhoSeeMeCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != self.dataArray.count || indexPath.row != self.dataArray
        .count + 1) {
        NSString* message = NSLocalizedString(@"开通VIP会员,即可查看Ta的详细资料", nil);
        
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"温馨提醒", nil) message:message delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"暂不开通", nil),NSLocalizedString(@"立即开通", nil), nil];
        
        alertView.delegate = self;
        [alertView show];
      
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self skipToFeed];
    }
}

- (void)skipToFeed{
    WhoSeeMeController *whosee = (WhoSeeMeController *)self.viewController;
    MyFeedBackViewController *feed = [[MyFeedBackViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/iOS/Buy/vip_v1",BaseUrl]];
    feed.titleStr = NSLocalizedString(@"VIP会员", nil);
    feed.pushType = whosee.pushType;
    [[self viewController].navigationController pushViewController:feed animated:YES];
}

- (void)dredgeVip:(UIButton*)sender{
    [self skipToFeed];
}

#pragma mark -  numberOfSectionsInCollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

#pragma mark -  numberOfItemsInSection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count + 2;
}

#pragma mark -  cellForItemAtIndexPath
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (self.dataArray.count > 0) {
        if (indexPath.row == self.dataArray.count) {
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.frame.size.height - 13, cell.frame.size.width, 13)];
            label.text = NSLocalizedString(@"开通VIP会员,即可查看Ta的详细资料", nil);
            label.font = [UIFont systemFontOfSize:kPercentIP6(13)];
//            label.minimumScaleFactor = 0.5;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = Color10(153, 153, 153, 1);
            [cell addSubview:label];
        }else if (indexPath.row == self.dataArray.count + 1){
            UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake(0, cell.frame.size.height - 44, cell.frame.size.width, 44)];
            [button setTitle:@"開通VIP馬上查看" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [button setBackgroundColor:Color10(245, 45, 74, 1)];
            button.layer.cornerRadius = 5;
//            button.layer.masksToBounds = YES;
            [button addTarget:self action:@selector(dredgeVip:) forControlEvents:UIControlEventTouchDown];
            [cell addSubview:button];
        }else{
            UIImageView* imageView = [[UIImageView alloc]initWithFrame:cell.bounds];
            imageView.layer.cornerRadius = imageView.frame.size.width  / 2;
            imageView.layer.masksToBounds = YES;
            NSString* imgPath = self.dataArray[indexPath.row];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imgPath] placeholderImage:LOADIMAGE(@"my_defaultHeadImage@2x", @"png")];
            [cell addSubview:imageView];
            if (self.dataArray.count > 7) {
                if (indexPath.row == self.dataArray.count - 1) {
                    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.frame.size.height / 2 - 6.5, cell.frame.size.width, 13)];
                    label.textColor = [UIColor whiteColor];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:13];
                    label.text = NSLocalizedString(@"查看更多", nil);
                    [cell addSubview:label];
                }
            }
        }

    }
    return cell;
}

#pragma mark - cell的大小 sizeForItemAtIndexPath
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat cellWidth = (rect.size.width - 65 - 30) / 4;
    if (indexPath.row == self.dataArray.count) {
        return CGSizeMake(ScreenWidth - 65, 53);
    }else if (indexPath.row == self.dataArray.count + 1){
        return CGSizeMake(ScreenWidth - 65, 69);
    }else{
        return CGSizeMake(cellWidth,cellWidth);
    }
}

#pragma mark - 设置两个cell之间的水平距离 如果数值是2那么两个cell直接的距离就是4
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
}

#pragma mark - 设置两个cell之间的垂直距离如果数值是2那么两个cell直接的距离就是2与水平距离有些差别
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
}


- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray new];
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
