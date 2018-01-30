//
//  AuthenticationEntity.h
//  Appointment
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthenticationEntity : NSObject
/**图片名字 */
@property (strong, nonatomic) NSString* authenticationImageViewName;
/**认证类型 */
@property (strong, nonatomic) NSString* authenticationTypeTitle;
/**可以获得的星星数量 该属性是NSAttributedString 使用时候注意*/
@property (strong, nonatomic) NSAttributedString* authenticationStarCount;
/**按钮标题 */
@property (strong, nonatomic) NSString* authenticationButtonTitle;

- (instancetype)initWithImageViewName:(NSString*)imageName typeTitle:(NSString*)typeTitle starCount:(NSString*)starCount buttonTitle:(NSString*)buttonTitle;
@end
