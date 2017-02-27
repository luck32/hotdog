//
//  CloudinaryConnectionManager.h
//  HOTDOG
//
//  Created by toobler on 10/14/15.
//  Copyright © 2015 Liming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cloudinary/Cloudinary.h"
@interface CloudinaryConnectionManager : NSObject<CLUploaderDelegate>
{
void (^_completionHandler)(NSDictionary * allUserInformation ,BOOL status);
NSError *_error;
}
+ (id)sharedInstance;
- (void)UploadImageTocloudinaryApi:(void (^)(NSMutableDictionary * allUserInformation ,BOOL status))handler;

@end
