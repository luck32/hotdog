//
//  GooglePlusConnectionManager.h
//  SignUpWithGooglePlus
//
//  Created by Tblr-Mac-09 on 4/14/15.
//  Copyright (c) 2015 Toobler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import <QuartzCore/QuartzCore.h>

@interface GooglePlusConnectionManager : NSObject<GPPSignInDelegate>
{
    void (^_completionHandler)(NSDictionary * allUserInformation ,BOOL status);
    NSError *_error;
}
+ (id)sharedInstance;
- (void)startAutenticationWithCompletionHandler:(void (^)(NSMutableDictionary * allUserInformation ,BOOL status))handler;
- (BOOL)checkNullString:(NSString*)string;
- (void)googlePlusSignOut;
- (void)googlePlusDisconnect;
@end
