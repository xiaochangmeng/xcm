//
//  LetterDetailTableView.m
//  Appointment
//
//  Created by feiwu on 16/7/20.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "LetterDetailTableView.h"
#import "LetterDetailLeftTableViewCell.h"
#import "LetterDetailRightTableViewCell.h"
#import "LetterDetailVoiceTableViewCell.h"
#import "LetterRecordModel.h"
#import "NSString+MZYExtension.h"
@implementation LetterDetailTableView

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

#pragma mark - Private Methods
//私有方法
- (void) initView
{
    self.separatorStyle = UITableViewCellSelectionStyleNone;//隐藏cell分割线
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
    self.dataSource =self;
    
}


#pragma mark - Public Methods
//公有方法

#pragma mark - Event Responses
//事件响应方法

#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _recordDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LetterRecordModel *model = _recordDataArray[indexPath.row];
    if ([model.tag isEqualToString:@"2"] ) {
        //我发的文本
        static NSString *identify_LetterDetailRightTableViewCell = @"LetterDetailRightTableViewCell";
        
        LetterDetailRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify_LetterDetailRightTableViewCell];
        if (cell == nil) {
            cell = [[LetterDetailRightTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify_LetterDetailRightTableViewCell];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        return cell;
    } else if([model.tag isEqualToString:@"1"]){
        //发给我的文本
        static NSString *identify_LetterDetailLeftTableViewCell = @"LetterDetailLeftTableViewCell";
        
        LetterDetailLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify_LetterDetailLeftTableViewCell];
        if (cell == nil) {
            cell = [[LetterDetailLeftTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify_LetterDetailLeftTableViewCell];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        return cell;
    } else {
        //音频图片
        static NSString *identify_LetterDetailVoiceTableViewCell = @"LetterDetailVoiceTableViewCell";
        
        LetterDetailVoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify_LetterDetailVoiceTableViewCell];
        if (cell == nil) {
            cell = [[LetterDetailVoiceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify_LetterDetailVoiceTableViewCell];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        return cell;

    }
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_recordDataArray.count > 0) {
        LetterRecordModel *model = _recordDataArray[indexPath.row];
        if ([model.tag isEqualToString:@"2"])  {
            //我发的文本
            LetterDetailRightTableViewCell *rigthCell = (LetterDetailRightTableViewCell *)cell;
            rigthCell.timeLabel.text = model.showtime;
            rigthCell.detailLabel.text = model.content;
            [rigthCell.logoImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:LOADIMAGE(NSLocalizedString(@"letter_headPlaceholder", nil), @"png")];
            
            CGSize size = [model.content textSizeWithContentSize: CGSizeMake(ScreenWidth - kPercentIP6(24/2) - 80 - kPercentIP6(12/2) -kPercentIP6(104/2), CGFLOAT_MAX) font:kFont16];
            float textWidth = 0.f;
            if (size.height > 40) {
                textWidth = ScreenWidth - kPercentIP6(24/2) - 80 - kPercentIP6(12/2) -kPercentIP6(104/2);
            }else{
                textWidth = size.width;
            }
            rigthCell.textWidth = textWidth;
            
        } else if([model.tag isEqualToString:@"1"]){
            //他人发的文本
            LetterDetailLeftTableViewCell *leftCell = (LetterDetailLeftTableViewCell *)cell;
            leftCell.timeLabel.text = model.showtime;
            
            leftCell.detailLabel.text = model.content;
            [leftCell.logoImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:LOADIMAGE(NSLocalizedString(@"letter_headPlaceholder", nil), @"png")];
            CGSize size = [model.content textSizeWithContentSize: CGSizeMake(ScreenWidth - kPercentIP6(24/2) - 80 - kPercentIP6(12/2) -kPercentIP6(104/2), CGFLOAT_MAX) font:kFont16];
            float textWidth = 0.f;
            if (size.height > 40) {
                textWidth = ScreenWidth - kPercentIP6(24/2) - 80 - kPercentIP6(12/2) -kPercentIP6(104/2);
            }else{
                textWidth = size.width;
            }
            leftCell.textWidth = textWidth;
            
        } else {
            //音频 图片
            LetterDetailVoiceTableViewCell *voiceCell = (LetterDetailVoiceTableViewCell *)cell;
            voiceCell.timeLabel.text = model.showtime;
            [voiceCell.logoImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:LOADIMAGE(NSLocalizedString(@"letter_headPlaceholder", nil), @"png")];
            voiceCell.model = model;

        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LetterRecordModel *model = _recordDataArray[indexPath.row];
    if ([model.tag isEqualToString:@"3"] || [model.tag isEqualToString:@"4"]) {
        //音频
        return 90;
    } else  if ([model.tag isEqualToString:@"1"] || [model.tag isEqualToString:@"2"]){
        CGSize size = [model.content textSizeWithContentSize: CGSizeMake(ScreenWidth - kPercentIP6(24/2) - 80 - kPercentIP6(12/2) -kPercentIP6(104/2), CGFLOAT_MAX) font:kFont16];
        //文本
        return 90/2 + size.height + 2 + 30;
    } else if ([model.tag isEqualToString:@"7"]){
        //图片
        return 330;
    } else {
        return 0;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    
}


#pragma mark - Getters And Setters


@end
