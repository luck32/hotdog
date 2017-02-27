//
//  CloudinaryConnectionManager.m
//  HOTDOG
//
//  Created by toobler on 10/14/15.
//  Copyright © 2015 Liming. All rights reserved.
//

#import "CloudinaryConnectionManager.h"
#import "AppDelegate.h"


@implementation CloudinaryConnectionManager


/*
 * 4/14/15
 * Create  Singleton Instance.
 */
+ (id)sharedInstance{
    // SHARING A SINGLE INSTANCE
    static CloudinaryConnectionManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[CloudinaryConnectionManager alloc] init];
    });
    return _sharedInstance;
}
/*
 * function for upload image to cloudinary API
 * parmeters : pass the cloudinary url
 * return    :return allUserInformation
 * method    :post
 */
- (void)UploadImageTocloudinaryApi:(void (^)(NSMutableDictionary * allUserInformation ,BOOL status))handler
{
     [g_Base getImageNameByMd5];
     _completionHandler=[handler copy];
    
    CLCloudinary *cloudinary = [[CLCloudinary alloc] initWithUrl: @"cloudinary://787383562237555:we7d-OUoS2knt9BSIQJXxllNx3w@emprint"];
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    
    NSLog(@"%@",g_Base.imageName);
     NSData *imageData = UIImageJPEGRepresentation(g_Base.captureImage, 0.7);
    [uploader upload:imageData options:@{@"public_id":g_Base.imageName}];
    
}

/*
 * 10/14/15
 *Delegate method for handle upload image.
 */
- (void) uploaderSuccess:(NSDictionary*)result context:(id)context {
    NSString* publicId = [result valueForKey:@"public_id"];
    NSLog(@"Upload success. Public ID=%@, Full result=%@", publicId, result);
    _completionHandler(result,true);
}

- (void) uploaderError:(NSString*)result code:(int) code context:(id)context {
    NSLog(@"Upload error: %@, %d", result, code);
    _completionHandler(nil,false);
}

- (void) uploaderProgress:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite context:(id)context {
    NSLog(@"Upload progress: %d/%d (+%d)", totalBytesWritten, totalBytesExpectedToWrite, bytesWritten);
    
}

@end
