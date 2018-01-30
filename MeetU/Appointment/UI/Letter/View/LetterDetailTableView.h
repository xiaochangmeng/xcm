//
//  LetterDetailTableView.h
//  Appointment
//
//  Created by feiwu on 16/7/20.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LetterDetailTableView : UITableView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *recordDataArray;
@end
