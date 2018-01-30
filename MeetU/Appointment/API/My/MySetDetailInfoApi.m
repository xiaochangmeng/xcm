//
//  MyGetInfoApi.m
//  Appointment
//
//  Created by feiwu on 16/7/19.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MySetDetailInfoApi.h"

@implementation MySetDetailInfoApi
{
    NSString *_nickname;
    NSString *_year;
    NSString *_month;
    NSString *_day;
    NSString *_province;
    NSString *_height;
    NSString *_weight;
    NSString *_blood;
    
    NSString *_education;
    NSString *_job;
    NSString *_income;
    NSString *_premarital_sex;
    NSString *_live_and_parent;
    NSString *_love_at_distance;
    NSString *_child;
    NSString *_data_place;
    NSString *_ft_expection;
    NSString *_love_sense;
    NSString *_fd_purpose;
    
    NSString *_hobby;
    NSString *_character;
    
}
- (id)initWithYear:(NSString *)year Month:(NSString *)month Day:(NSString *)day Province:(NSString *)province Height:(NSString *)height Weight:(NSString *)weight Blood:(NSString *)blood NickName:(NSString *)nickname Education:(NSString *)education Job:(NSString *)job Income:(NSString *)income FdPurpose:(NSString *)fd_purpose LoveSense:(NSString *)love_sense FtExpection:(NSString *)ft_expection DataPlace:(NSString *)data_place hobby:(NSString *)hobby Character:(NSString *)character{
    self = [super init];
    if (self) {
        _year = year;
        _month = month;
        _day = day;
        _province = province;
        _height = height;
        _weight = weight;
        _blood = blood;
        _nickname = nickname;
        _education = education;
        _job = job;
        _income = income;
        _fd_purpose = fd_purpose;
        _love_sense = love_sense;
        _ft_expection = ft_expection;
        _data_place = data_place;
        _hobby = hobby;
        _character = character;
    }
    return self;
}

- (NSString *)requestUrl {
    
    NSString *url = @"/iOS/Mine/setInfo";
    
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    return @{
             @"name" : _nickname ? _nickname : @"",
             @"birth_year" : _year ? _year : @"",
             @"birth_moth" : _month ? _month : @"",
             @"birth_day" : _day ? _day : @"",
             @"city" : _province ? _province : @"",
             @"height" : _height ? _height : @"",
             @"weight" : _weight ? _weight : @"",
             @"blood_type" : _blood ? _blood : @"",
             
             @"education" : _education ? _education  : @"",
             @"occupation" : _job ? _job : @"",
             @"monthly_income" : _income ? _income : @"",
             
             @"making_friends" : _fd_purpose ? _fd_purpose : @"",
             @"love_concept" : _love_sense ? _love_sense : @"",
             @"first_meeting_hope" : _ft_expection ? _ft_expection : @"",
             @"love_place" : _data_place ? _data_place : @"",
             
             @"hobby" : _hobby ? _hobby : @"",
             @"features" : _character ? _character : @""
             
             };
}

//- (id)jsonValidator {
//    return @{
//             @"state_code": [NSString class]
//            };
//}

//- (NSMutableArray *)matchList {
//    return [[[self responseJSONObject] objectForKey:@"userId"] stringValue];
//}


//- (NSInteger)cacheTimeInSeconds {
//    return 60 * 3;
//}

@end
