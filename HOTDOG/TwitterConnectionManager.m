//
//  TwitterConnectionManager.m
//  HOTDOG
//
//  Created by toobler on 10/13/15.
//  Copyright © 2015 Liming. All rights reserved.
//

#import "TwitterConnectionManager.h"

@implementation TwitterConnectionManager
/*
 * 4/14/15
 * Create  Singleton Instance.
 */
+ (id)sharedInstance{
    // SHARING A SINGLE INSTANCE
    static TwitterConnectionManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[TwitterConnectionManager alloc] init];
    });
    return _sharedInstance;
}
- (void)getTwitterUserInfoWithCompletionHandler:(void (^)(NSMutableDictionary * allUserInformation ,BOOL status))handler
{
_completionHandler=[handler copy];
NSMutableDictionary * twiterInfo=[[NSMutableDictionary alloc]init];
[[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
    if (session) {
    
        NSString *statusesShowEndpoint = @"https://api.twitter.com/1.1/users/show.json";
        NSDictionary *params = @{@"user_id": [session userID]};
        
        NSError *clientError;
        NSURLRequest *request = [[[Twitter sharedInstance] APIClient]
                                 URLRequestWithMethod:@"GET"
                                 URL:statusesShowEndpoint
                                 parameters:params
                                 error:&clientError];
        
        if (request) {
            [[[Twitter sharedInstance] APIClient]
             sendTwitterRequest:request
             completion:^(NSURLResponse *response,
                          NSData *data,
                          NSError *connectionError) {
                 if (data) {
                     // handle the response data e.g.
                     NSError *jsonError;
                     NSDictionary *json = [NSJSONSerialization
                                           JSONObjectWithData:data
                                           options:0
                                           error:&jsonError];
                     NSLog(@"%@",json);
                     
                    [twiterInfo setObject:[NSString stringWithFormat:@"%@",[json valueForKey:@"name"]] forKey:@"name"];
                    [twiterInfo setObject:[NSString stringWithFormat:@"%@",[json valueForKey:@"screen_name"]] forKey:@"link"];
                    [twiterInfo setObject:[NSString stringWithFormat:@"%@",[session userID]] forKey:@"id"];
                    _completionHandler(twiterInfo,true);
                 }
                 else {
                     NSLog(@"Error code: %ld | Error description: %@", (long)[connectionError code], [connectionError localizedDescription]);
                 }
             }];
        }
        else {
            NSLog(@"Error: %@", clientError);
        }
        NSLog(@"signed in as %@", [session userName]);
    } else {
        NSLog(@"error: %@", [error localizedDescription]);
    }
}];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
