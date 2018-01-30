//
//  QuestionTableView.h
//  Appointment
//
//  Created by feiwu on 16/7/15.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface QuestionTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)NSDictionary *one;
@property(nonatomic, strong)NSDictionary *two;
@property(nonatomic, strong)NSDictionary *three;
@property(nonatomic, strong)NSDictionary *four;
@property(nonatomic, strong)NSDictionary *five;
@property(nonatomic, assign)NSInteger count;
@end
