//
//  TwitterConnectionManager.h
//  HOTDOG
//
//  Created by toobler on 10/13/15.
//  Copyright © 2015 Liming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwitterKit/TwitterKit.h>
@interface TwitterConnectionManager : NSObject
{
    void (^_completionHandler)(NSDictionary * allUserInformation ,BOOL status);
    NSError *_error;
}
+ (id)sharedInstance;
- (void)getTwitterUserInfoWithCompletionHandler:(void (^)(NSMutableDictionary * allUserInformation ,BOOL status))handler;
@end
