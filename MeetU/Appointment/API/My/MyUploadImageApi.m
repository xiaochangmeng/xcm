//
//  MySetUserImageApi.m
//  Appointment
//
//  Created by feiwu on 16/7/18.
//  Copyright © 2016年 广州飞屋网络. All rights reserved.
//

#import "MyUploadImageApi.h"

@implementation MyUploadImageApi
{
    UIImage *_image;
    NSString *_type;
}

- (id)initWithImage:(UIImage *)image Type:(NSString *)type {
    self = [super init];
    if (self) {
        _image = image;
        _type = type;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl {
   
    return @"/iOS/Img/upload";
}

- (id)requestArgument {
    return @{
             @"type" : _type ? _type : @"",
             @"img" :  @""
             };
}

- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        NSData *data = UIImageJPEGRepresentation(_image, 0.9);
        NSString *name = @"img";
        NSString *formKey = @"img";
        NSString *type = @"image/png";
        [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
    };
}


@end
