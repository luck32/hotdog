//
//  HOTDOGBaseVC.h
//  HOTDOG
//
//  Created by User on 7/21/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <Foundation/Foundation.h>
#import "HotdogMediaMeta.h"

@interface HOTDOGBaseVC : NSObject

@property UIImage *captureImage;
@property UIImage *avatarImage;
@property NSString *imageName;
@property BOOL     isNewCapture;
@property BOOL     isNewProfile;

@property NSDictionary *profileCacheMeta;

@property NSDictionary *getRequestFilter;

@property NSMutableArray  *myMediaMetaArray;
@property NSMutableArray  *anotherMediaMetaArray;

@property NSMutableArray  *allMediaMetaArray;

@property NSMutableArray  *followUserArray;


@property HotdogMediaMeta *metaData;

+ (id)sharedManager;
- (UIAlertView *)showAlert:(NSString *)title description:(NSString *)description;
- (BOOL)validateTxt:(NSString*)str;
- (BOOL)validateEmail:(NSString *)str;

- (NSString *)md5WithString:(NSString *)string;
- (NSString *)createdOnString:(NSString *)string;
- (void) getImageNameByMd5;

- (UIImage *)blurWithCoreImage:(UIImage *)sourceImage view:(UIView *) view;

- (void) loadingFromServer;

@end



