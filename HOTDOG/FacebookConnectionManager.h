//
//  FacebookConnectionManager.h
//  HOTDOG
//
//  Created by toobler on 10/13/15.
//  Copyright © 2015 Liming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@interface FacebookConnectionManager : NSObject
{
    void (^_completionHandler)(NSDictionary * allUserInformation ,BOOL status);
    NSError *_error;
}
+ (id)sharedInstance;
- (void)getfacebookUserInfoWithCompletionHandler:(void (^)(NSMutableDictionary * allUserInformation ,BOOL status))handler;
@end
