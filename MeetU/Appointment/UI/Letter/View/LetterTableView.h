//
//  LetterTableView.h
//  Appointment
//
//  Created by feiwu on 16/7/13.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LetterViewController;
@interface LetterTableView : UITableView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *letterDataArray;
@property(nonatomic,copy)NSString *visitor_num;
@end
