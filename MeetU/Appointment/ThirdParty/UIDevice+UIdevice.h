//
//  UIDevice+UIdevice.h
//  noble metal
//
//  Created by Apple on 16/8/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(char, iPhoneModel){//0~3
         iPhone4,//320*480
         iPhone5,//320*568
         iPhone6,//375*667
         iPhone6Plus,//414*736
         UnKnown
     };
@interface UIDevice (UIdevice)
+ (iPhoneModel)iPhonesModel;
@end
