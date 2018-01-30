//
//  LetterDetailViewController.h
//  Appointment
//
//  Created by feiwu on 16/7/20.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "LetterDetailTableView.h"
#import "FateModel.h"
#import "LetterReplyView.h"
#import "MJRefresh.h"
#import <StoreKit/StoreKit.h>
@interface LetterDetailViewController : CustomViewController<SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property(nonatomic ,strong)FateModel *model;
@property(nonatomic ,strong)LetterDetailTableView *tableView;

@property(nonatomic,strong)NSMutableArray *recordDataArray;
@property(nonatomic,strong)NSMutableArray *answerDataArray;
@property(nonatomic,strong)NSDictionary *answerDataDic;
@property(nonatomic,strong)NSMutableArray *selectedArray;//已打招呼

@property(nonatomic,strong)UIView *questionView;
@property(nonatomic,assign)CGFloat keyboardHeight;
@property(nonatomic,copy)NSString *img;//用户头像
@property(nonatomic,assign)BOOL flag_refresh;//每天一次免费回复机会
@property(nonatomic,assign)BOOL send_bool;//是否给这个用户发送消息
@property(nonatomic,assign)BOOL flag_writer;//是否开通短信包月
@property(nonatomic,assign)BOOL isFirstReply;//当天是否第一次回复
@property(nonatomic,copy)NSString *price;//商品价格
@property(nonatomic,copy)NSString *productName;//商品名称
@property(nonatomic,copy)NSString *productId;//商品id
@property(nonatomic,copy)NSString *from;//商品来源

/** 所有的产品 */
@property (nonatomic, strong) NSArray *products;


//底部button
@property(nonatomic,strong)UILabel *tipLabel;
@property(nonatomic,strong)UIButton *replyButton;
@property(nonatomic,strong)LetterReplyView *replyView;


@end
