//
//  FWImageUtils.h
//  chat
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 yuhy. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol FWImageUtilsDelegate
/**拍照或者相册选择照片后调用 */
- (void)chooseImageEnd:(NSString*)imagePath;

@end
@interface FWImageUtils : NSObject

+ (instancetype)sharedInstance;

@property (weak, nonatomic) id<FWImageUtilsDelegate> delegate;
/**打开相册 */
- (void)chooseImageForLibiary:(UIViewController*)controller;
/**拍照 */
- (void)chooseImageForCamera:(UIViewController*)controller;
@end
