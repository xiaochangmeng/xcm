//
//  QuestionViewParser.m
//  Appointment
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "QuestionViewParser.h"

@implementation QuestionViewParser

/**
 *  解析QuestionViewEntity需要的字段
 *
 *  @param dictionary 待解析的字典
 *
 *  @return 解析之后的实体类
 */
#pragma mark - parse
+ (QuestionViewEntity *)parse:(NSDictionary *)dictionary{
        QuestionViewEntity* entity = [QuestionViewEntity new];
//    if (nil != dictionary && [dictionary allKeys].count != 0) {
//        
//        //mid
//        if ((nil != [dictionary objectForKey:@"user_id"]) && (![[dictionary objectForKey:@"user_id"] isEqual:[NSNull null]])) {
//            entity.mid = [dictionary objectForKey:@"user_id"];
//        }
//        
//        //昵称
//        if ((nil != [dictionary objectForKey:@"name"]) && (![[dictionary objectForKey:@"name"] isEqual:[NSNull null]])) {
//            entity.nickName = [dictionary objectForKey:@"name"];
//        }
//        
//        //头像路径
//        if ((nil != [dictionary objectForKey:@"avatar"]) && (![[dictionary objectForKey:@"avatar"] isEqual:[NSNull null]])) {
//            entity.imgPath = [dictionary objectForKey:@"avatar"];
//        }
//        
//        //问题
//        if ((nil != [dictionary objectForKey:@"question"]) && (![[dictionary objectForKey:@"question"] isEqual:[NSNull null]])) {
//            NSDictionary* questions = [dictionary objectForKey:@"question"];
//            
//            //问题Id
//            if ((nil != [questions objectForKey:@"qid"]) && (![[questions objectForKey:@"qid"] isEqual:[NSNull null]])) {
//                entity.questionEntity.qId = [questions objectForKey:@"qid"];
//            }
//            
//            //问题内容
//            if ((nil != [questions objectForKey:@"title"]) && (![[questions objectForKey:@"title"] isEqual:[NSNull null]])) {
//                entity.questionEntity.questionContent = [questions objectForKey:@"title"];
//            }
//        }
//        
//        
//        
//        //答案
//        if ((nil != [dictionary objectForKey:@"select"]) && (![[dictionary objectForKey:@"select"] isEqual:[NSNull null]])) {
//            NSArray* selects = [dictionary objectForKey:@"select"];
//            
//            if (nil != selects && selects.count != 0) {
//                
//                for (NSDictionary* item in selects) {
//                    QuestionSelectEntity* selectEntity = [QuestionSelectEntity new];
//                    
//                    //答案Id
//                    if ((nil != [item objectForKey:@"sid"]) && (![[item objectForKey:@"sid"] isEqual:[NSNull null]])) {
//                        selectEntity.sId = [[item objectForKey:@"sid"] longValue];
//                    }
//                    
//                    //答案内容
//                    if ((nil != [item objectForKey:@"content"]) && (![[item objectForKey:@"content"] isEqual:[NSNull null]])) {
//                        selectEntity.anserContent = [item objectForKey:@"content"];
//                    }
//                    
//                    [entity.questionSelectionEntitys addObject:selectEntity];
//                }
//            }
//        }
//        
//        
//    }
    
    
    return entity;
}
@end
