//
//  QuestionTableView.m
//  Appointment
//
//  Created by feiwu on 16/7/15.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "QuestionTableView.h"
#import "QuestionTableViewCell.h"
#import "NSObject+XWAdd.h"
@implementation QuestionTableView

#pragma mark - Life Cycle
//生命周期方法
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Methods
//私有方法
- (void) initView
{
    WS(weakSelf);
    self.separatorStyle = UITableViewCellSelectionStyleNone;//隐藏cell分割线
    self.backgroundColor = [UIColor clearColor];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
    self.dataSource = self;
   
    NSString *sex = [FWUserInformation sharedInstance].sex;
    NSInteger type = [sex integerValue];

    //注册完成后回答问题
    _one = @{@"type" : @"making_friends", @"index" : @"1", @"question" : NSLocalizedString(@"我现在19岁，能说一下你的交友目的吗?", nil), @"img" : type == 0 ? @"boy_one@2x" : @"re_questionOne@2x", @"answers" : @[NSLocalizedString(@"周末约会", nil), NSLocalizedString(@"寻找另一半", nil), NSLocalizedString(@"寻找刺激", nil), NSLocalizedString(@"假日x伙伴", nil)]};
    
    _two = @{@"type" : @"love_concept",@"index" : @"2", @"question" :NSLocalizedString(@"我是台北人，你能说说你的恋爱观念是怎样的吗？", nil), @"img" : type == 0 ? @"boy_two@2x" : @"re_questionTwo@2x", @"answers":@[NSLocalizedString(@"保守", nil), NSLocalizedString(@"开放", nil), NSLocalizedString(@"寻找刺激", nil)]};
    
   _three = @{@"type" : @"first_meeting_hope", @"index" : @"3", @"question" : NSLocalizedString(@"我比较开放，你首次见面希望做什么呢？", nil), @"img" : type == 0 ? @"boy_three@2x" : @"re_questionThree@2x", @"answers" : @[NSLocalizedString(@"拥抱", nil), NSLocalizedString(@"接吻", nil), NSLocalizedString(@"爱爱", nil), NSLocalizedString(@"其他", nil)]};
   _four = @{@"type":@"love_place",@"index":@"4",@"question":NSLocalizedString(@"你喜欢的爱爱地点是哪里？", nil),@"img" : type == 0 ? @"boy_four@2x" : @"re_questionFour@2x", @"answers" : @[NSLocalizedString(@"家里", nil), NSLocalizedString(@"野外", nil), NSLocalizedString(@"宾馆", nil), NSLocalizedString(@"都可以", nil)]};
    _count = 1;


    [self xw_addNotificationForName:@"QuestionTableViewNotification" block:^(NSNotification *notification) {
        NSDictionary *dic = [notification object];
        NSString *index = [[dic allKeys] firstObject];
        NSDictionary *value = [[dic allValues] firstObject];
      weakSelf.count = [index integerValue] + 1;
        if ([index integerValue] == 4) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QuestionViewControllerSetInfo" object:value];
        } else {
            [weakSelf reloadData];
        }
    }];
}


#pragma mark - Public Methods
//公有方法

#pragma mark - Event Responses
//事件响应方法
#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify_QuestionCell = @"QuestionTableViewCell";
    QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify_QuestionCell];
    if (cell == nil) {
        cell = [[QuestionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify_QuestionCell];
    }
    
    switch (_count) {
        case 1:
            cell.questionDic = _one;
            break;
        case 2:
            cell.questionDic = _two;
            break;
        case 3:
            cell.questionDic = _three;
            break;
        case 4:
            cell.questionDic = _four;
            break;
        case 5:
            cell.questionDic = _five;
            break;
            
        default:
            break;
    }    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *answers;
    switch (_count) {
        case 1:
            answers = [_one objectForKey:@"answers"];
            break;
        case 2:
            answers = [_two objectForKey:@"answers"];
            break;
        case 3:
            answers = [_three objectForKey:@"answers"];
            break;
        case 4:
            answers = [_four objectForKey:@"answers"];
            break;
        case 5:
            answers = [_five objectForKey:@"answers"];
            break;
            
        default:
            break;
    }

    return 19 + 20 + 55 + 132 + 76 + 16 + 43 + 70 * answers.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
}


@end
