//
//  FWImageUtils.m
//  chat
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 yuhy. All rights reserved.
//

#import "FWImageUtils.h"
@interface FWImageUtils()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end
@implementation FWImageUtils

+ (instancetype)sharedInstance{
    static FWImageUtils *_sharedInstance;
    
    static dispatch_once_t token;
    
    dispatch_once(&token,^{
        _sharedInstance = [[FWImageUtils alloc] init];
    });
    return _sharedInstance;
    
}

#pragma mark - 选择照片
- (void)chooseImageForLibiary:(UIViewController*)controller{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [controller presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - 拍照
- (void)chooseImageForCamera:(UIViewController*)controller{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [controller presentViewController:imagePickerController animated:YES completion:nil];
}


#pragma mark - 选择照片  或者 拍照后 进入该方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    //对照片进行编辑
    [picker dismissViewControllerAnimated:YES completion:^{
        [self editImage:image];
    }];
}


/**
 *  编辑 存储图片
 *
 *  @param image 图片
 */
- (void)editImage:(UIImage*)image{
    NSData *pngData = UIImageJPEGRepresentation(image, 0.3);
    
    //图片名字
    NSString *imageName = @"uploadheaderimage.JPG";
    //图片存储路径 不带图片名字
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //图片真实路径
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
    //存储图片
    [pngData writeToFile:filePath atomically:YES];
    //协议
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate chooseImageEnd:filePath];
    });
    
}


#pragma mark - 拍照 或则 照片选择界面取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}




@end
