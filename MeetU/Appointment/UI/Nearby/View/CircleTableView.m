//
//  CircleTableView.m
//  Appointment
//
//  Created by feiwu on 2017/2/5.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "CircleTableView.h"
#import "CircleTableViewCell.h"
#import "NearbyViewController.h"
#import "CircleListApi.h"
#import "LoginViewController.h"
#import "CircleModel.h"
#import "NSString+MZYExtension.h"
#import "NSObject+XWAdd.h"

@implementation CircleTableView

#pragma mark - 生命周期方法

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initView];
        // 图片打赏
        [self xw_addNotificationForName:@"CircleListReload" block:^(NSNotification *notification) {
            NSDictionary *dic = [notification object];
            if (dic) {
                NSIndexPath *indexPath = [dic objectForKey:@"indexPath"]; //点击行数
                NSInteger index = [[dic objectForKey:@"index"] integerValue]; //点击图片
                NSLog(@"第几张图片:%@",[dic objectForKey:@"index"]);
                NSDictionary *oldPicDic = [dic objectForKey:@"picDic"]; //点击的图片数据
                
                NSMutableDictionary *newPicDic  = [NSMutableDictionary dictionaryWithDictionary:oldPicDic];
                [newPicDic setValue:@"1" forKey:@"status"];
                
                CircleModel *oldModel = [_circleDataArray objectAtIndex:indexPath.row];
                NSMutableArray *newPics_url = [NSMutableArray arrayWithArray:oldModel.pics_url];
                [newPics_url replaceObjectAtIndex:index withObject:newPicDic];
                
                // 新model
                CircleModel *newModel = [[CircleModel alloc] init];
//                newModel.author = oldModel.author;
                newModel.content = oldModel.content;
                newModel.from = oldModel.from;
                newModel.comment_id = oldModel.comment_id;
                newModel.hits_count = oldModel.hits_count;
                newModel.like_count = oldModel.like_count;
                newModel.past_time = oldModel.past_time;
                newModel.comment_list = oldModel.comment_list;
                newModel.isLike = oldModel.isLike;
                newModel.comment_count = oldModel.comment_count;
                newModel.publish_id = oldModel.publish_id;
                newModel.pics_url = newPics_url;
                newModel.dashang_num = oldModel.dashang_num;
                newModel.dashang_list = oldModel.dashang_list;
                newModel.nickname=oldModel.nickname;
                newModel.avatar=oldModel.avatar;
             
                [_circleDataArray replaceObjectAtIndex:indexPath.row withObject:newModel];
                [self  reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化子控件
- (void) initView
{
    self.separatorStyle = UITableViewCellSelectionStyleNone;//隐藏cell分割线
    self.backgroundColor = [UIColor clearColor];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
    self.dataSource =self;
    self.page = 0;
    self.isRefresh = NO;
    [self addHeader];
    [self addFooter];
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _circleDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify_SelectCell = @"CircleTableViewCell";
    CircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify_SelectCell];
    if (cell == nil) {
        cell = [[CircleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify_SelectCell];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_circleDataArray.count > 0) {
        CircleTableViewCell *circleCell = (CircleTableViewCell *)cell;
        circleCell.model = _circleDataArray[indexPath.row];
        circleCell.indexpath = indexPath;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleModel *model = _circleDataArray[indexPath.row];
    
    CGFloat contentHeight = [model.content textHeightWithContentWidth:ScreenWidth - 30 font:[UIFont systemFontOfSize:kPercentIP6(16)]];//文本
    if (contentHeight > 90) {
        contentHeight = 90;
    }
    // 打赏
    CGFloat awardHeight = 0;
    NSInteger dashangnum;
    NSString *content;
//    if (model.dashang_list.count > 6) {
//        dashangnum = 6;
//    } else {
//        dashangnum = model.dashang_list.count;
//    }
//    
//    if ([model.dashang_num integerValue] > 0) {
//        NSString *temp = @"";
//        for (int i = 0; i < dashangnum; i++) {
//            NSDictionary *dic = [model.dashang_list objectAtIndex:i];
//            NSString *name = [NSString stringWithFormat:@"%@、",[dic objectForKey:@"nickname"]];
//            temp =  [temp stringByAppendingString:name];
//        }
//        if (model.dashang_list.count > 6) {
//            content = [NSString stringWithFormat:@"%@等%lu人打赏了Ta",temp,(unsigned long)model.dashang_list.count];
//        } else {
//            content = [NSString stringWithFormat:@"%@等打赏了Ta",temp];
//        }
//        awardHeight = [content textHeightWithContentWidth:ScreenWidth - 80 font:[UIFont systemFontOfSize:kPercentIP6(14)]] + 10;//打赏
//        if (model.comment_list.count <= 0) {
//            awardHeight += 10;
//        }
//        
//    }
    
    
    // 评论
    int count  = 0;
    if (model.comment_list.count <= 3) {
        count = 0;
    } else {
        count = (int)model.comment_list.count - 3;
    }
    CGFloat commentHeight = 0;
    if (model.comment_list.count > 0) {
        for (int i = count; i < model.comment_list.count; i++) {
            NSDictionary *dic = [model.comment_list objectAtIndex:i];//评论信息
            NSString *str = [NSString stringWithFormat:@"%@:%@",[dic objectForKey:@"nickname"], [dic objectForKey:@"content"]];
            CGFloat height = [str textHeightWithContentWidth:ScreenWidth - 30 font:[UIFont systemFontOfSize:kPercentIP6(14)]] + 10;
            commentHeight += height;
        }
        commentHeight += 30;
        if ([model.comment_count integerValue] > 3) {
            commentHeight += 20;
        }
    }
    
    if (model.pics_url.count > 0) {
        // 有图片
        int row  = 0;
        if (model.pics_url.count <= 3) {
            row = 1;
        } else if(model.pics_url.count <= 6) {
            row = 2;
        } else if(model.pics_url.count <= 9) {
            row = 3;
        } else if(model.pics_url.count <= 12) {
            row = 4;
        } else if(model.pics_url.count <= 15) {
            row = 5;
        } else if(model.pics_url.count <= 18) {
            row = 6;
        }
        return  12 + 36 + 10 + contentHeight + 2 + 10 +  ((ScreenWidth - 50) / 3.0 ) * row + (row - 1)  * 10  +  46 + 10 + commentHeight + awardHeight;
    } else {
        // 没有图片
        return  12 + 36 + 10 + contentHeight + 2 + 46 + 10 + commentHeight + awardHeight;
    }
    
    return 500;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MobClick event:@"circleEnterUserDetail"];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - 加载圈子列表信息
- (void)getCircleListRequest:(NSString *)page {
    WS(weakSelf);
    __weak NearbyViewController *near = (NearbyViewController *)self.viewController;
    [near hideHUD];
    [near showHUD:nil isDim:NO mode:MBProgressHUDModeIndeterminate];
    CircleListApi *api = [[CircleListApi alloc] initWithPage:page];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [weakSelf.mj_header endRefreshing];
        [weakSelf.mj_footer endRefreshing];
        [near hideHUD];
        [weakSelf getCircleListRequestFinish:request.responseJSONObject];
    } failure:^(YTKBaseRequest *request) {
        LogYellow(@"圈子列表请求失败:%@",request.responseString);
        [weakSelf.mj_header endRefreshing];
        [weakSelf.mj_footer endRefreshing];
        [near hideHUD];
        [near showNetRefresh:^{
            [near hideNetRefresh];
            [weakSelf getCircleListRequest:page];
        }];
        
    }];
}

- (void)getCircleListRequestFinish:(NSDictionary *)result{
    LogOrange(@"圈子列表请求成功:%@",result);
    __weak NearbyViewController *near = (NearbyViewController *)self.viewController;
    NSNumber *code =(NSNumber *)[result objectForKey:@"code"];
    NSString *desc = [result objectForKey:@"msg"];
    if ([code intValue] == kNetWorkSuccCode){
        
        if (_isRefresh) {
            _isRefresh = NO;
            _page = 0;
            [_circleDataArray removeAllObjects];
            [self reloadData];
        }
        NSMutableArray *nearbyArray = [NSMutableArray arrayWithArray:[result objectForKey:@"data"]];
        // 是否有数据
        if ((NSNull *)nearbyArray != [NSNull null] && nearbyArray.count > 0)  {
            
            if (!_circleDataArray) {
                _circleDataArray = [NSMutableArray array];
            }
            
            for (int i = 0; i < nearbyArray.count; i++) {
                NSDictionary *dic = [nearbyArray objectAtIndex:i];
                CircleModel *model = [[CircleModel alloc] initWithDataDic:dic];
                [_circleDataArray addObject:model];
            }
            
            [self reloadData];
            _page++;
            
        } else {
            NSLog(@"没有新数据");
        }
        
    
        
    }else if([code intValue] == kNetWorkNoLoginCode){
        //没有登录
        [near showHUDFail:desc];
        [near hideHUDDelay:1];
        [self performSelector:@selector(login) withObject:nil afterDelay:1];
        
    }else if([code intValue] == kNetWorkNoDataCode){
        //没有数据
        [near showHUDFail:@"没有更多数据请稍后重试"];
        [near hideHUDDelay:1];
    } else {
        [near showHUDFail:desc];
        [near hideHUDDelay:1];
    }
}

- (void)login{
    WS(weakSelf);
    __weak NearbyViewController *near = (NearbyViewController *)self.viewController;
    LoginViewController *login = [[LoginViewController alloc] init];
    login.isNoLogin = YES;
    login.loginBlock = ^(){
        [weakSelf getCircleListRequest:@"0"];
    };
    [near presentViewController:login animated:NO completion:^{
        
    }];
}

#pragma mark - 下拉刷新数据
- (void)addHeader
{
    WS(weakSelf);
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isRefresh = YES;
        [weakSelf getCircleListRequest:@"0"];
    }];
}

#pragma mark - 上拉加载数据
- (void)addFooter
{
    WS(weakSelf);
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getCircleListRequest:[NSString stringWithFormat:@"%d", weakSelf.page]];
    }];
}


@end
