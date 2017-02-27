//
//  FacebookConnectionManager.m
//  HOTDOG
//
//  Created by toobler on 10/13/15.
//  Copyright © 2015 Liming. All rights reserved.
//

#import "FacebookConnectionManager.h"
#import "AppDelegate.h"

@implementation FacebookConnectionManager
/*
 * 4/14/15
 * Create  Singleton Instance.
 */
+ (id)sharedInstance{
    // SHARING A SINGLE INSTANCE
    static FacebookConnectionManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[FacebookConnectionManager alloc] init];
    });
    return _sharedInstance;
}

/*
 * function for get facbook details
 * parmeters : set permission in read permission section
 * return    :return name and emai
 * method    :post
 */

- (void)getfacebookUserInfoWithCompletionHandler:(void (^)(NSMutableDictionary * allUserInformation ,BOOL status))handler
{
    _completionHandler=[handler copy];
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location ,friends ,hometown , friendlists"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 NSLog(@"resultis:%@",result);
                 _completionHandler(result,true);
             }
             else
             {
                 NSLog(@"Error %@",error);
             }
         }];
        
    }else
    {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:@[@"public_profile", @"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            
            if (error) {
                // Process error
            } else if (result.isCancelled) {
                // Handle cancellations
                 _completionHandler(nil,false);
            } else {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                
                if ([FBSDKAccessToken currentAccessToken])
                {
                    NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
                    
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location ,friends ,hometown , friendlists"}]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         if (!error)
                         {
                             NSLog(@"resultis:%@",result);
                             _completionHandler(result,true);
                             
                             
                         }
                         else
                         {
                             NSLog(@"Error %@",error);
                         }
                     }];
                    
                }
            }
        }];
        
    }
}


@end
