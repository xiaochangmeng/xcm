//
//  TimeLineTableViewCell.m
//  TimeLine
//
//  Created by oujinlong on 16/6/12.
//  Copyright © 2016年 oujinlong. All rights reserved.
//

#import "TimeLineTableViewCell.h"
#import "Masonry.h"
#import "TimeImageContentView.h"
#import "UIImageView+WebCache.h"
#define color(r,g,b)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
CGFloat max_content_height;
@interface TimeLineTableViewCell ()
@property (nonatomic, weak) UIImageView* iconImageView;
@property (nonatomic, weak) UIImageView* sexImageView;
@property (nonatomic, weak) UILabel* nameLB;
@property (nonatomic, weak) UILabel* contentLB;
@property (nonatomic, weak) UIButton* showAllButton;
@property (nonatomic, weak) TimeImageContentView* imageContentView;
@property (nonatomic, weak) UILabel* distanceLB;
@property (nonatomic, weak) UILabel* timeLB;
@property (nonatomic, weak) UIButton* likeButton;
@property (nonatomic, weak) UIButton* commentButton;
@property (nonatomic, weak) UIView* lineview;

@property(nonatomic,strong)UIButton * BtnView;
@end
@implementation TimeLineTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString* const identifier = @"timeLine";
    TimeLineTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TimeLineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupMain];
    }
    
    return self;
}

-(void)setupMain{
    UIImageView* iconImageView = [[UIImageView alloc] init];
    self.iconImageView = iconImageView;
    [self.contentView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    iconImageView.layer.cornerRadius = 20.0f;
    iconImageView.layer.masksToBounds = YES;
    
    
    UILabel* nameLB = [[UILabel alloc] init];
    self.nameLB = nameLB;
    nameLB.font = [UIFont systemFontOfSize:16];
    nameLB.textColor = UIColorFromRGB(0x212121);
    [self.contentView addSubview:nameLB];
    [nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconImageView.mas_right).offset(4);
        make.centerY.mas_equalTo(iconImageView);
    }];
    
    
    UIImageView* sexImageView = [[UIImageView alloc] init];
    self.sexImageView = sexImageView;
    [self.contentView addSubview:sexImageView];
    [sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLB.mas_right).offset(10);
        make.centerY.mas_equalTo(iconImageView);
        make.width.equalTo(@15);
         make.height.equalTo(@15);
    }];
    sexImageView.image = [UIImage imageNamed:@"sex_girl-1"];
    
    
    
    UILabel* timeLB = [[UILabel alloc] init];
    self.timeLB = timeLB;
    [self.contentView addSubview:timeLB];
    timeLB.font = [UIFont systemFontOfSize:12];
    timeLB.textColor = UIColorFromRGB(0x999999);
    [timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.centerY.mas_equalTo(iconImageView);
    }];
    
    
    UILabel* contentLB = [[UILabel alloc] init];
    self.contentLB = contentLB;
    contentLB.font = [UIFont systemFontOfSize:14];
    contentLB.textColor = UIColorFromRGB(0x444444);
    contentLB.numberOfLines = 5;
    [self.contentView addSubview:contentLB];
    [contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconImageView);
        make.top.mas_equalTo(iconImageView.mas_bottom).offset(10);
        make.right.mas_equalTo(-10);
    }];
    max_content_height = contentLB.font.lineHeight * 5;
    
    
//    UIButton* showAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.showAllButton = showAllButton;
//    [showAllButton addTarget:self action:@selector(showAll:) forControlEvents:UIControlEventTouchUpInside];
//    [showAllButton setTitleColor:color(71, 95, 143) forState:UIControlStateNormal];
//    [self.contentView addSubview:showAllButton];
//    showAllButton.titleLabel.font = [UIFont systemFontOfSize:13];
//    [showAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-20);
//        make.top.mas_equalTo(contentLB.mas_bottom).offset(1);
//    }];
    
    TimeImageContentView* imageConetntView = [[TimeImageContentView alloc] init];
    self.imageContentView = imageConetntView;
    [self.contentView addSubview:imageConetntView];
    imageConetntView.sd_layout
    .leftEqualToView(iconImageView)
    .topSpaceToView(contentLB,10)
    .rightSpaceToView(self.contentView,10)
    .autoHeightRatio(0);
    
    
    UILabel* distanceLB = [[UILabel alloc] init];
    self.distanceLB = distanceLB;
    distanceLB.font = [UIFont systemFontOfSize:14];
    distanceLB.textColor= UIColorFromRGB(0x999999);
    distanceLB.textColor = contentLB.textColor;
    [self.contentView addSubview:distanceLB];
   distanceLB.sd_layout
    .leftEqualToView(imageConetntView)
    .topSpaceToView(imageConetntView,1)
    .widthIs(180)
    .heightIs(20);
    
    
    
    
    
    UIButton* commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commentButton  =commentButton;
    commentButton.titleLabel.font = [UIFont systemFontOfSize:12];
    commentButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    [commentButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [commentButton setTitleColor:contentLB.textColor forState:UIControlStateNormal];
    [commentButton setImage:[UIImage imageNamed:@"icon_circle_comment"] forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:commentButton];
    commentButton.sd_layout
    .rightSpaceToView(self.contentView,10)
    .centerYEqualToView(distanceLB)
    .widthIs(45)
    .heightIs(15);
    [self.commentButton setTitle:@"评论" forState:UIControlStateNormal];
    
    UIButton* likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.likeButton  =likeButton;
    likeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    likeButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    [likeButton setTitleColor:contentLB.textColor forState:UIControlStateNormal];
    [likeButton setImage:[UIImage imageNamed:@"icon_circle_laud_n"] forState:UIControlStateNormal];
    [self.contentView addSubview:likeButton];
    [likeButton addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
    [likeButton setImage:[UIImage imageNamed:@"icon_circle_laud_s"] forState:UIControlStateSelected];
    likeButton.sd_layout
  
    .rightSpaceToView(commentButton,10)
    .centerYEqualToView(distanceLB)
    .widthIs(45)
    .heightIs(15);

    
    
    
    UIView* lineview = [[UIView alloc] init];
    self.lineview = lineview;
    [self.contentView addSubview:lineview];
    lineview.backgroundColor = UIColorFromRGB(0xeeeeee);
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(distanceLB.mas_bottom).offset(30);
        make.height.equalTo(@10);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
    }];
    
//    lineview.sd_layout
//    .topSpaceToView(distanceLB.mas_bottom,30)
//    .leftEqualToView(self.contentView)
//    .rightEqualToView(self.contentView)
//    .heightIs(10);
    
    [self setupAutoHeightWithBottomView:distanceLB bottomMargin:46];

}
-(void)setModel:(TimeModel *)model{
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"fate_mask"]];
    
    self.nameLB.text = model.nickname;
    
    self.contentLB.text = model.content;
    
    
    self.showAllButton.hidden = model.shouldShowAllButton;
    
    self.contentLB.numberOfLines = model.isShowAll ? 0: 4;
    
    [self.showAllButton setTitle:self.model.isShowAll ? @"收起":@"全文" forState:UIControlStateNormal];
    
    
    self.imageContentView.imageArray = model.imageArray;
    
    self.distanceLB.text = [NSString stringWithFormat:@"浏览%@次",model.hits_count];
    [self.distanceLB sizeToFit];
    
    self.timeLB.text = model.send_time;
    [self.timeLB sizeToFit];
    
    
    [self.likeButton setTitle:[NSString stringWithFormat:@"%zd",model.like_count] forState:UIControlStateNormal];
    
 
    
    self.likeButton.selected = model.isLiked;
    
    [self.lineview sizeToFit];
}
#pragma mark action
-(void)showAll:(UIButton*)button{
    NSLog(@"%s",__func__);
    self.model.isShowAll = !self.model.isShowAll;
    
    [self.showAllButton setTitle:self.model.isShowAll ? @"收起":@"全文" forState:UIControlStateNormal];
    
    self.showallClickBlock(self.sd_indexPath);
    


}

-(void)commentClick{
    NSLog(@"%s",__func__);
    
    if (self.BtnView == nil) {
        
        self.BtnView = [UIButton buttonWithType:UIButtonTypeCustom];
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        self.BtnView.frame = CGRectMake(0, 0, window.size.width, window.size.height);
        [window addSubview: self.BtnView];
        
        self.BtnView.backgroundColor =[UIColor colorWithWhite:0.2 alpha:0.6];
        [self.BtnView addTarget:self action:@selector(GoOnBtnClcik) forControlEvents:UIControlEventTouchUpInside];
        
        UIView * telView = [[UIView alloc] initWithFrame:CGRectMake((screenW-250)/2, window.size.height/2-170, 250, 223)];
        telView.backgroundColor = [UIColor whiteColor];
        [ self.BtnView addSubview:telView];
        telView.layer.cornerRadius = 10.f;
        telView.layer.masksToBounds = YES;
        
        UILabel * titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, telView.frame.size.width, 50)];
        titlelabel.text = @"开通会员";
        titlelabel.textColor = UIColorFromRGB(0xff596e);
        titlelabel.font = [UIFont systemFontOfSize:16];
        titlelabel.textAlignment = NSTextAlignmentCenter;
        [telView addSubview:titlelabel];
        
        UIView * lineview = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titlelabel.frame), telView.frame.size.width, 1)];
        lineview.backgroundColor = UIColorFromRGB(0xe0e0e0);
        [telView addSubview:lineview];
        
        UILabel * contentLabel  = [[UILabel alloc] initWithFrame:CGRectMake(21, CGRectGetMaxY(lineview.frame)+5, telView.frame.size.width-42, telView.frame.size.height - 50-10-40)];
        contentLabel.text = @"您暂未开通vip，暂无权限使用评论，升级VIP就可以去撩她了！";
        contentLabel.font = [UIFont systemFontOfSize:16];
        contentLabel.numberOfLines = 5;
        contentLabel.textColor = UIColorFromRGB(0x212121);
        [telView addSubview:contentLabel];
        
        
        UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, telView.frame.size.height-40, telView.size.width/2, 44);
        [telView addSubview:cancelBtn];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn setBackgroundColor:UIColorFromRGB(0xff7a8b)];
        [cancelBtn addTarget:self action:@selector(GoOnBtnClcik) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        
        
        UIButton * makesureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        makesureBtn.frame = CGRectMake(telView.size.width/2, telView.frame.size.height-40, telView.size.width/2, 44);
        [telView addSubview:makesureBtn];
        [makesureBtn setTitle:@"升级VIP会员" forState:UIControlStateNormal];
        [makesureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [makesureBtn setBackgroundColor:UIColorFromRGB(0xff6478)];
        [makesureBtn addTarget:self action:@selector(makesureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        makesureBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    
}

-(void)GoOnBtnClcik{
    
    [self.BtnView removeFromSuperview];
    self.BtnView = nil;
}


-(void)makesureBtnClick{
    
    [[NSNotificationCenter defaultCenter ] postNotificationName:@"quanzimakesureBtnClick" object:nil];
    [self.BtnView removeFromSuperview];
    self.BtnView = nil;
    
    
}


-(void)likeClick{
    NSLog(@"%s",__func__);
    
    self.likeButton.selected = !self.likeButton.selected;
    if (self.likeButton.selected) {
        self.model.like_count ++;
        [self likeAnimation];
        self.model.isLiked = YES;
    }else{
        self.model.like_count --;
        self.model.isLiked = NO;
    }
    [self.likeButton setTitle:[NSString stringWithFormat:@"%zd",self.model.like_count] forState:UIControlStateNormal];
}
-(void)likeAnimation{
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_circle_laud_s"]];
    [self.contentView addSubview:imageView];
    imageView.frame = CGRectMake(self.likeButton.frame.origin.x, self.likeButton.frame.origin.y, 15, 15);
    [UIView animateWithDuration:0.5 animations:^{
        imageView.transform = CGAffineTransformScale(imageView.transform, 8, 8);
        imageView.alpha = 0;
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
    }];
}
@end
