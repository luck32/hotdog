//
//  GooglePlusConnectionManager.m
//  SignUpWithGooglePlus
//
//  Created by Tblr-Mac-09 on 4/14/15.
//  Copyright (c) 2015 Toobler. All rights reserved.
//
#import "GooglePlusConnectionManager.h"
@implementation GooglePlusConnectionManager
/*
 * 4/14/15
 * Create  Singleton Instance.
 */
+ (id)sharedInstance{
    // SHARING A SINGLE INSTANCE
    static GooglePlusConnectionManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[GooglePlusConnectionManager alloc] init];
    });
    return _sharedInstance;
}
/*
 * 4/14/15
 * Authenicate user.
 *
 */
- (void)startAutenticationWithCompletionHandler:(void (^)(NSMutableDictionary * allUserInformation ,BOOL status))handler
{
    _completionHandler=[handler copy];
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.clientID=@"306429995741-2daq5ir4q8ru78mn0bo9prpflhip7s3v.apps.googleusercontent.com";  // here add your ID
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.scopes = @[ @"profile" ];
    
    signIn.delegate = self;
    
    if (![signIn trySilentAuthentication])    // if it is not authenticate it re authenticate once
        [signIn authenticate];
}
#pragma mark - GPPSignInDelegate

/*
 * 4/14/15
 * Delegate method for invoke autenicatication is true.
 *
 */

-(void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                  error: (NSError *) error {
    
    
    
    if (error) {
        
        NSLog(@"%@",error);
        
        
        // Do some error handling here.
    } else {
        // NSLog(@"Received error %@", auth.userEmail);
        // NSLog(@"Received error %@", auth.accessToken);
        
        if ( auth.userEmail)
        {
            if ([GPPSignIn sharedInstance].authentication) {
                NSMutableDictionary * responseDictionary=[[NSMutableDictionary alloc] init];
                [responseDictionary setObject:[GPPSignIn sharedInstance].userEmail forKey:@"userEmail"];
                GTLPlusPerson *person = [GPPSignIn sharedInstance].googlePlusUser;
                if (![self checkNullString:person.displayName])
                    [responseDictionary setObject:person.displayName forKey:@"userName"];
                else[responseDictionary setObject:@"" forKey:@"userName"];
                if (![self checkNullString:person.aboutMe])
                    [responseDictionary setObject:person.aboutMe forKey:@"aboutMe"];
                else[responseDictionary setObject:@"" forKey:@"aboutMe"];
                if (![self checkNullString:person.braggingRights])
                    [responseDictionary setObject:person.braggingRights forKey:@"braggingRights"];
                else[responseDictionary setObject:@"" forKey:@"braggingRights"];
                if (![self checkNullString:person.domain])
                    [responseDictionary setObject:person.domain forKey:@"domain"];
                else[responseDictionary setObject:@"" forKey:@"domain"];
                if (![self checkNullString:person.gender])
                    [responseDictionary setObject:person.gender forKey:@"gender"];
                else[responseDictionary setObject:@"" forKey:@"gender"];
                if (![self checkNullString:person.identifier])
                    [responseDictionary setObject:person.identifier forKey:@"identifier"];
                else[responseDictionary setObject:@"" forKey:@"identifier"];
                if (![self checkNullString:person.language])
                    [responseDictionary setObject:person.language forKey:@"language"];
                else[responseDictionary setObject:@"" forKey:@"language"];
                if (![self checkNullString:person.gender])
                    [responseDictionary setObject:person.gender forKey:@"nickname"];
                else[responseDictionary setObject:@"" forKey:@"nickname"];
                if (![self checkNullString: person.image.url])
                    [responseDictionary setObject: person.image.url forKey:@"imageUrl"];
                else[responseDictionary setObject:@"" forKey:@"imageUrl"];
                _completionHandler(responseDictionary,TRUE);
            }                 }
        
        }
        
    }

/*
 * 4/14/15
 * Delegate method for invoke after signout.
 *
 */
- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
    [NSString stringWithFormat:@"Status: Failed to disconnect: %@", error];
    } else{
    [NSString stringWithFormat:@"Status: Disconnected"];
}
}

 /*
 * 4/14/15
 * signOut
 */
- (void)googlePlusSignOut{
    [[GPPSignIn sharedInstance] signOut];
}
 /*
 * 4/14/15
 * disconnect
 */
- (void)googlePlusDisconnect {
    [[GPPSignIn sharedInstance] disconnect];
}
 /*
 * 4/14/15
 * Check null value in a string
 */
-(BOOL)checkNullString:(NSString*)string
{
    if (string == (id)[NSNull null]||[string isEqualToString:@"<null>"]||string.length==0) {
        return TRUE;
    }else
    {
        return FALSE;
    }

}


@end
