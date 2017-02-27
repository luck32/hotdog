//
//  HOTDOGSettings.h
//  HOTDOG
//
//  Created by User on 7/17/15.
//  Copyright (c) 2015 Liming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HOTDOGSettings : NSObject
{
    NSUserDefaults *m_pSetting;
}

@property NSString *userId;
@property NSString *authToken;
@property NSInteger personId;
@property NSString *facebookEmail;
@property NSString *facebookAccessToken;

@property BOOL     isLogined;
@property BOOL     facebookSetting;
@property BOOL     twitterSetting;
@property BOOL     instagramSetting;


+ (id)sharedManager;

@end
